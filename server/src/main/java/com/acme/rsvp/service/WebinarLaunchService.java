package com.acme.rsvp.service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarActiveLock;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarActiveLockRepository;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.security.TokenHasher;

/**
 * The only code that reads Webinar.joinUrl for an attendee. Every path to Zoom goes through
 * launchSeat, which re-checks the account, the window and the one-webinar-at-a-time rule.
 */
@Service
public class WebinarLaunchService {

  private static final String INVALID_LINK = "This link is invalid or has expired";

  private final WebinarRepository webinars;
  private final PersonRepository persons;
  private final WebinarSeatService seatService;
  private final WebinarJoinTokenRepository tokens;
  private final WebinarJoinLogRepository logs;
  private final WebinarActiveLockRepository locks;

  public WebinarLaunchService(WebinarRepository webinars, PersonRepository persons,
      WebinarSeatService seatService, WebinarJoinTokenRepository tokens,
      WebinarJoinLogRepository logs, WebinarActiveLockRepository locks) {
    this.webinars = webinars;
    this.persons = persons;
    this.seatService = seatService;
    this.tokens = tokens;
    this.logs = logs;
    this.locks = locks;
  }

  @Transactional
  public String launchForMember(Long webinarId, Long personId, OffsetDateTime now) {
    Webinar w = webinars.findById(webinarId).orElseThrow(() -> new NotFoundException("Meeting not found"));
    Person p = persons.findById(personId).orElseThrow(() -> new NotFoundException("Person not found"));
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("This meeting is not available.");
    }
    WebinarSeat seat = seatService.ensureOwnSeat(w, p);
    if (seat == null) {
      throw new IllegalStateException("You do not have access to this meeting.");
    }
    return launchSeat(seat, JoinSource.PORTAL, now);
  }

  @Transactional
  public String launchForToken(String rawToken, OffsetDateTime now) {
    WebinarJoinToken token = resolveToken(rawToken, now);
    String url = launchSeat(token.getSeat(), JoinSource.MAGIC_LINK, now);
    token.setUseCount(token.getUseCount() + 1);
    token.setLastUsedAt(now);
    return url;
  }

  @Transactional(readOnly = true)
  public WebinarJoinToken resolveToken(String rawToken, OffsetDateTime now) {
    if (rawToken == null || rawToken.isBlank()) throw new NotFoundException(INVALID_LINK);
    WebinarJoinToken token = tokens.findByTokenHash(TokenHasher.sha256Hex(rawToken))
        .orElseThrow(() -> new NotFoundException(INVALID_LINK));
    if (token.getRevokedAt() != null || now.isAfter(token.getSeat().getWebinar().joinWindowEnd())) {
      throw new NotFoundException(INVALID_LINK);
    }
    return token;
  }

  private String launchSeat(WebinarSeat seat, JoinSource source, OffsetDateTime now) {
    Webinar w = seat.getWebinar();
    Person p = seat.getPerson();
    FamilyMember fm = seat.getFamilyMember();

    if (p.getAccountStatus() != AccountStatus.ACTIVE || p.isExpired()) {
      throw new IllegalStateException("This account is not active. Please contact an administrator.");
    }
    if (fm != null && !fm.isActive()) {
      throw new IllegalStateException("This seat is no longer active.");
    }
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("This meeting is not available.");
    }
    if (!w.isJoinOpen(now)) {
      throw new IllegalStateException(now.isBefore(w.joinWindowStart())
          ? "This meeting is not open for joining yet."
          : "This meeting has ended.");
    }
    if (w.getJoinUrl() == null || w.getJoinUrl().isBlank()) {
      throw new IllegalStateException("This meeting has no link yet. Please contact the coordinator.");
    }

    // Validate the final redirect target before anything is written, so a stored link that cannot
    // form a valid URI never leaves a join log or an active lock behind.
    String url = appendDisplayName(w.getJoinUrl(), seat.displayName());
    try {
      java.net.URI.create(url);
    } catch (IllegalArgumentException e) {
      throw new IllegalStateException("This meeting's link is invalid. Please contact the coordinator.");
    }

    WebinarActiveLock lock = (fm == null
        ? locks.findByPersonIdAndFamilyMemberIsNull(p.getId())
        : locks.findByFamilyMemberId(fm.getId())).orElse(null);
    // One webinar at a time: the attendee is blocked only while the session they last joined is
    // still running, judged from that webinar as it is now (status and scheduled end), not from the
    // value stored when they joined. Cancelling, unpublishing or rescheduling it takes effect at once.
    if (lock != null && !lock.getWebinar().getId().equals(w.getId())) {
      Webinar held = lock.getWebinar();
      if (held.getStatus() == WebinarStatus.PUBLISHED && !now.isAfter(held.getScheduledEnd())) {
        throw new IllegalStateException("You are already joined to another meeting.");
      }
    }
    if (lock == null) lock = new WebinarActiveLock(p, fm);
    lock.setWebinar(w);
    lock.setLockedUntil(w.getScheduledEnd());
    try {
      locks.saveAndFlush(lock);
    } catch (DataIntegrityViolationException e) {
      throw new IllegalStateException("Another join is already in progress. Please try again.");
    }

    logs.save(new WebinarJoinLog(seat, now, source));
    return url;
  }

  /**
   * Sets the uname query parameter, replacing any existing one and leaving every other parameter
   * byte-for-byte as stored (the Zoom pwd value must not be re-encoded).
   */
  public static String appendDisplayName(String joinUrl, String displayName) {
    String fragment = "";
    String base = joinUrl;
    int hash = base.indexOf('#');
    if (hash >= 0) {
      fragment = base.substring(hash);
      base = base.substring(0, hash);
    }
    String path = base;
    String query = "";
    int q = base.indexOf('?');
    if (q >= 0) {
      path = base.substring(0, q);
      query = base.substring(q + 1);
    }
    List<String> kept = new ArrayList<>();
    for (String part : query.split("&")) {
      if (part.isEmpty() || part.equals("uname") || part.startsWith("uname=")) continue;
      kept.add(part);
    }
    kept.add("uname=" + URLEncoder.encode(displayName, StandardCharsets.UTF_8).replace("+", "%20"));
    return path + "?" + String.join("&", kept) + fragment;
  }
}
