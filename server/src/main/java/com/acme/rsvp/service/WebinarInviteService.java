package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.InviteLink;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.security.TokenHasher;

@Service
public class WebinarInviteService {
  private static final Logger log = LoggerFactory.getLogger(WebinarInviteService.class);
  private static final DateTimeFormatter WHEN =
      DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy 'at' h:mm a z", Locale.US);

  private final WebinarService webinarService;
  private final WebinarSeatRepository seats;
  private final WebinarJoinTokenRepository tokens;
  private final EmailService email;
  private final WebinarProperties props;
  private final String frontendUrl;
  private final TransactionTemplate readTx;
  private final TransactionTemplate writeTx;

  public WebinarInviteService(WebinarService webinarService, WebinarSeatRepository seats,
      WebinarJoinTokenRepository tokens, EmailService email, WebinarProperties props,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl,
      PlatformTransactionManager txManager) {
    this.readTx = new TransactionTemplate(txManager);
    this.readTx.setReadOnly(true);
    this.writeTx = new TransactionTemplate(txManager);
    this.webinarService = webinarService;
    this.seats = seats;
    this.tokens = tokens;
    this.email = email;
    this.props = props;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @Transactional
  public String issueLink(Long webinarId, Long seatId, OffsetDateTime now) {
    WebinarSeat seat = seats.findById(seatId)
        .filter(s -> s.getWebinar().getId().equals(webinarId))
        .orElseThrow(() -> new NotFoundException("Seat not found"));
    return issue(seat, now);
  }

  /**
   * Emails each family its links. Deliberately not transactional: each family's links are reissued in
   * a short transaction that commits before that family's email is sent, so no database transaction
   * (and no row lock on a token) is held across a call to the mail provider.
   */
  public InviteResult sendInvites(Long webinarId, OffsetDateTime now) {
    InvitePlan plan = readTx.execute(status -> planInvites(webinarId));
    if (!email.isEnabled()) {
      throw new IllegalStateException("Email sending is not configured on this server. "
          + "Copy each person's link from the Attendees screen instead.");
    }

    int sent = 0;
    List<String> skipped = new ArrayList<>();
    for (FamilyInvite family : plan.families()) {
      if (family.email() == null || family.email().isBlank()) {
        skipped.add(family.contactName() + " (no email address)");
        continue;
      }
      // Links are reissued (old ones revoked) and committed before sending. If the email then fails, the
      // recipient is listed in `skipped` so the coordinator can resend or copy a link; old links are not restored.
      List<InviteLink> links = writeTx.execute(status -> {
        List<InviteLink> issued = new ArrayList<>();
        for (SeatInvite si : family.seats()) {
          WebinarSeat seat = seats.findById(si.seatId()).orElse(null);
          if (seat == null) continue; // removed since the plan was read
          issued.add(new InviteLink(si.label(), issue(seat, now)));
        }
        return issued;
      });
      if (links == null || links.isEmpty()) continue;
      try {
        if (email.sendWebinarInvite(family.email(), plan.title(), plan.hostName(), plan.whenText(), links)) {
          sent++;
        } else {
          skipped.add(family.contactName() + " (email failed)");
        }
      } catch (RuntimeException e) {
        log.error("Failed to send webinar invite for webinar {} to person {}", webinarId, family.personId(), e);
        skipped.add(family.contactName() + " (email failed)");
      }
    }
    return new InviteResult(sent, skipped);
  }

  /** Reads everything the invite emails need as plain values, inside a read transaction. */
  private InvitePlan planInvites(Long webinarId) {
    Webinar w = webinarService.require(webinarId);
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("Publish the webinar before sending invites");
    }
    String whenText = WHEN.format(w.getScheduledStart().atZoneSameInstant(ZoneId.of(props.displayZone())));

    Map<Long, List<WebinarSeat>> byPerson = new LinkedHashMap<>();
    for (WebinarSeat s : seats.findByWebinarIdWithAttendees(webinarId)) {
      byPerson.computeIfAbsent(s.getPerson().getId(), k -> new ArrayList<>()).add(s);
    }
    List<FamilyInvite> families = new ArrayList<>();
    for (List<WebinarSeat> family : byPerson.values()) {
      Person contact = family.get(0).getPerson();
      // Own seat first, then family members by name.
      family.sort(Comparator.comparing(WebinarSeat::isFamilySeat).thenComparing(WebinarSeat::attendeeName));
      List<SeatInvite> seatInvites = new ArrayList<>();
      for (WebinarSeat s : family) {
        String label = s.isFamilySeat() ? s.attendeeName() + " (" + s.attendeeIts() + ")" : "Your link";
        seatInvites.add(new SeatInvite(s.getId(), label));
      }
      families.add(new FamilyInvite(contact.getId(), contact.getFirstName() + " " + contact.getLastName(),
          contact.getEmail(), seatInvites));
    }
    return new InvitePlan(w.getTitle(), w.getHostName(), whenText, families);
  }

  private record SeatInvite(Long seatId, String label) {}

  private record FamilyInvite(Long personId, String contactName, String email, List<SeatInvite> seats) {}

  private record InvitePlan(String title, String hostName, String whenText, List<FamilyInvite> families) {}

  /** One live link per seat: issuing a new one revokes the rest. The raw token is returned once and never stored. */
  private String issue(WebinarSeat seat, OffsetDateTime now) {
    tokens.revokeForSeat(seat.getId(), now);
    String raw = TokenHasher.randomToken();
    tokens.save(new WebinarJoinToken(UUID.randomUUID(), seat, TokenHasher.sha256Hex(raw), now,
        seat.getWebinar().joinWindowEnd()));
    return frontendUrl + "/j/" + raw;
  }
}
