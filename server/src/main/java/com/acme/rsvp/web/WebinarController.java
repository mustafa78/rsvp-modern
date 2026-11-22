package com.acme.rsvp.web;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.service.WebinarLaunchService;
import com.acme.rsvp.service.WebinarService;

/** Any logged-in member. Not limited to heads of family. */
@RestController
@RequestMapping("/api/webinars")
public class WebinarController {

  private final WebinarService webinars;
  private final WebinarLaunchService launchService;
  private final String frontendUrl;

  public WebinarController(WebinarService webinars, WebinarLaunchService launchService,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
    this.webinars = webinars;
    this.launchService = launchService;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @GetMapping
  public List<MemberWebinar> mine(@AuthenticationPrincipal Person me) {
    return webinars.listForMember(me.getId(), OffsetDateTime.now());
  }

  /** The browser navigates here directly, so every outcome is a redirect: to Zoom, or back with a message. */
  @GetMapping("/{id}/launch")
  public ResponseEntity<Void> launch(@PathVariable Long id, @AuthenticationPrincipal Person me) {
    String target;
    try {
      target = launchService.launchForMember(id, me.getId(), OffsetDateTime.now());
    } catch (IllegalStateException | NotFoundException e) {
      target = frontendUrl + "/webinars?joinError=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
    }
    return ResponseEntity.status(HttpStatus.FOUND)
        .cacheControl(CacheControl.noStore())
        .location(URI.create(target))
        .build();
  }
}
