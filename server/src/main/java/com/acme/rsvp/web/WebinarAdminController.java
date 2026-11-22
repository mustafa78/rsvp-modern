package com.acme.rsvp.web;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.GiveSeatRequest;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.dto.WebinarDtos.LinkResponse;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.service.WebinarInviteService;
import com.acme.rsvp.service.WebinarReportService;
import com.acme.rsvp.service.WebinarSeatService;
import com.acme.rsvp.service.WebinarService;

/** ADMIN / WEBINAR_COORDINATOR only, enforced by the URL rule in WebSecurityConfig. */
@RestController
@RequestMapping("/api/webinars/admin")
public class WebinarAdminController {

  private final WebinarService webinars;
  private final WebinarSeatService seats;
  private final WebinarInviteService invites;
  private final WebinarReportService reports;

  public WebinarAdminController(WebinarService webinars, WebinarSeatService seats,
      WebinarInviteService invites, WebinarReportService reports) {
    this.webinars = webinars;
    this.seats = seats;
    this.invites = invites;
    this.reports = reports;
  }

  @GetMapping
  public List<WebinarSummary> list() { return webinars.list(); }

  @PostMapping
  public WebinarSummary create(@RequestBody SaveWebinarRequest req) { return webinars.create(req); }

  @GetMapping("/{id}")
  public WebinarSummary get(@PathVariable Long id) { return webinars.get(id); }

  @PutMapping("/{id}")
  public WebinarSummary update(@PathVariable Long id, @RequestBody SaveWebinarRequest req) {
    return webinars.update(id, req);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    webinars.delete(id);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/{id}/seats")
  public List<FamilySeats> seats(@PathVariable Long id) { return seats.listSeats(id); }

  @GetMapping("/{id}/assignable")
  public List<AssignableRow> assignable(@PathVariable Long id, @RequestParam(defaultValue = "") String search) {
    return seats.searchAssignable(id, search);
  }

  @PostMapping("/{id}/seats")
  public Map<String, Long> giveSeat(@PathVariable Long id, @RequestBody GiveSeatRequest req) {
    return Map.of("seatId", seats.giveSeat(id, req.personId(), req.familyMemberId()).getId());
  }

  @DeleteMapping("/{id}/seats/{seatId}")
  public ResponseEntity<Void> removeSeat(@PathVariable Long id, @PathVariable Long seatId) {
    seats.removeSeat(id, seatId);
    return ResponseEntity.noContent().build();
  }

  @PostMapping("/{id}/seats/copy-from/{otherId}")
  public CopySeatsResult copyFrom(@PathVariable Long id, @PathVariable Long otherId) {
    return seats.copyFrom(id, otherId);
  }

  @PostMapping("/{id}/seats/{seatId}/link")
  public LinkResponse link(@PathVariable Long id, @PathVariable Long seatId) {
    return new LinkResponse(invites.issueLink(id, seatId, OffsetDateTime.now()));
  }

  @PostMapping("/{id}/send-invites")
  public InviteResult sendInvites(@PathVariable Long id) {
    return invites.sendInvites(id, OffsetDateTime.now());
  }

  @GetMapping("/{id}/report")
  public AttendanceReport report(@PathVariable Long id) { return reports.report(id); }
}
