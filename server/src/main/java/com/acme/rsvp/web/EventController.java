package com.acme.rsvp.web;

import com.acme.rsvp.dto.EventDto;
import com.acme.rsvp.service.EventService;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/events")
public class EventController {
  private final EventService svc;
  public EventController(EventService svc){ this.svc = svc; }

  @GetMapping
  public List<EventDto> list(){ return svc.list().stream().map(EventDto::from).toList(); }

  @GetMapping("/{id}")
  public EventDto get(@PathVariable Long id){ return svc.get(id).map(EventDto::from).orElseThrow(); }
}
