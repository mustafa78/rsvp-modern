package com.acme.rsvp.web;

import com.acme.rsvp.dto.RsvpDto;
import com.acme.rsvp.model.Rsvp;
import com.acme.rsvp.service.RsvpService;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.*;

@RestController
@RequestMapping("/api/events/{eventId}/rsvps")
public class RsvpController {
  private final RsvpService svc;
  public RsvpController(RsvpService svc){ this.svc = svc; }

  @GetMapping
  public List<RsvpDto> list(@PathVariable Long eventId){
    return svc.list(eventId).stream().map(RsvpDto::from).toList();
  }

  @PostMapping
  public RsvpDto upsert(@PathVariable Long eventId, @Valid @RequestBody RsvpDto dto){
    Rsvp r = svc.upsert(eventId, dto);
    return RsvpDto.from(r);
  }
}
