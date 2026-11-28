package com.acme.rsvp.web;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.MagicJoinInfo;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.service.WebinarLaunchService;

/** Anonymous. The token in the path is the only credential. */
@RestController
@RequestMapping("/api/webinars/public")
public class WebinarPublicController {

  private static final String INVALID_LINK = "This meeting's link is invalid. Please contact the coordinator.";
  private static final String JOIN_IN_PROGRESS = "Another join is already in progress. Please try again.";

  private final WebinarLaunchService launchService;
  private final String frontendUrl;

  public WebinarPublicController(WebinarLaunchService launchService,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
    this.launchService = launchService;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @GetMapping("/{token}")
  @Transactional(readOnly = true)
  public MagicJoinInfo info(@PathVariable String token) {
    OffsetDateTime now = OffsetDateTime.now();
    WebinarSeat seat = launchService.resolveToken(token, now).getSeat();
    Webinar w = seat.getWebinar();
    return new MagicJoinInfo(w.getTitle(), w.getHostName(), w.getScheduledStart(), w.getScheduledEnd(),
        w.isJoinOpen(now), seat.attendeeName(), seat.attendeeIts());
  }

  @GetMapping("/{token}/launch")
  public ResponseEntity<Void> launch(@PathVariable String token) {
    String target;
    try {
      target = launchService.launchForToken(token, OffsetDateTime.now());
    } catch (IllegalStateException | NotFoundException e) {
      target = frontendUrl + "/j/" + URLEncoder.encode(token, StandardCharsets.UTF_8)
          + "?joinError=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
    } catch (DataAccessException e) {
      // Concurrent launches for the same attendee. Never echo the database message.
      target = frontendUrl + "/j/" + URLEncoder.encode(token, StandardCharsets.UTF_8)
          + "?joinError=" + URLEncoder.encode(JOIN_IN_PROGRESS, StandardCharsets.UTF_8);
    }
    return redirect(target, token);
  }

  private ResponseEntity<Void> redirect(String target, String token) {
    URI location;
    try {
      location = URI.create(target);
    } catch (IllegalArgumentException e) {
      // Never echo the parser's message: it contains the Zoom URL.
      location = URI.create(frontendUrl + "/j/" + URLEncoder.encode(token, StandardCharsets.UTF_8)
          + "?joinError=" + URLEncoder.encode(INVALID_LINK, StandardCharsets.UTF_8));
    }
    return ResponseEntity.status(HttpStatus.FOUND)
        .cacheControl(CacheControl.noStore())
        .location(location)
        .build();
  }
}
