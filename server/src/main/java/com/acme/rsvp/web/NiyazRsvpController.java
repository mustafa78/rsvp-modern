package com.acme.rsvp.web;

import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDto;
import com.acme.rsvp.service.NiyazService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/niyaz/{eventId}/rsvp")
public class NiyazRsvpController {
  private final NiyazService svc;
  public NiyazRsvpController(NiyazService svc){ this.svc = svc; }

  @PostMapping public NiyazRsvpDto upsert(@PathVariable Long eventId, @Valid @RequestBody NiyazRsvpDto dto){ return svc.upsert(eventId, dto); }
  @GetMapping("/totals/adults") public long adults(@PathVariable Long eventId){ return svc.totalAdults(eventId); }
  @GetMapping("/totals/kids") public long kids(@PathVariable Long eventId){ return svc.totalKids(eventId); }
}
