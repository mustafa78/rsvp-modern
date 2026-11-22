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
import org.springframework.transaction.annotation.Transactional;

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

  public WebinarInviteService(WebinarService webinarService, WebinarSeatRepository seats,
      WebinarJoinTokenRepository tokens, EmailService email, WebinarProperties props,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
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

  @Transactional
  public InviteResult sendInvites(Long webinarId, OffsetDateTime now) {
    Webinar w = webinarService.require(webinarId);
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("Publish the webinar before sending invites");
    }
    String whenText = WHEN.format(w.getScheduledStart().atZoneSameInstant(ZoneId.of(props.displayZone())));

    Map<Long, List<WebinarSeat>> byPerson = new LinkedHashMap<>();
    for (WebinarSeat s : seats.findByWebinarIdWithAttendees(webinarId)) {
      byPerson.computeIfAbsent(s.getPerson().getId(), k -> new ArrayList<>()).add(s);
    }

    int sent = 0;
    List<String> skipped = new ArrayList<>();
    for (List<WebinarSeat> family : byPerson.values()) {
      Person contact = family.get(0).getPerson();
      String contactName = contact.getFirstName() + " " + contact.getLastName();
      if (contact.getEmail() == null || contact.getEmail().isBlank()) {
        skipped.add(contactName + " (no email address)");
        continue;
      }
      // Own seat first, then family members by name.
      family.sort(Comparator.comparing(WebinarSeat::isFamilySeat).thenComparing(WebinarSeat::attendeeName));
      List<InviteLink> links = new ArrayList<>();
      for (WebinarSeat s : family) {
        String label = s.isFamilySeat() ? s.attendeeName() + " (" + s.attendeeIts() + ")" : "Your link";
        links.add(new InviteLink(label, issue(s, now)));
      }
      try {
        email.sendWebinarInvite(contact.getEmail(), w.getTitle(), w.getHostName(), whenText, links);
        sent++;
      } catch (RuntimeException e) {
        log.error("Failed to send webinar invite for webinar {} to person {}", webinarId, contact.getId(), e);
        skipped.add(contactName + " (email failed)");
      }
    }
    return new InviteResult(sent, skipped);
  }

  /** One live link per seat: issuing a new one revokes the rest. The raw token is returned once and never stored. */
  private String issue(WebinarSeat seat, OffsetDateTime now) {
    tokens.revokeForSeat(seat.getId(), now);
    String raw = TokenHasher.randomToken();
    tokens.save(new WebinarJoinToken(UUID.randomUUID(), seat, TokenHasher.sha256Hex(raw), now,
        seat.getWebinar().joinWindowEnd()));
    return frontendUrl + "/j/" + raw;
  }
}
