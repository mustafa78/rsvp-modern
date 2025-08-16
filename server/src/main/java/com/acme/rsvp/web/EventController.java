package com.acme.rsvp.web;

import com.acme.rsvp.dto.EventDtos.*;
import com.acme.rsvp.model.EventStatus;
import com.acme.rsvp.service.EventService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/events")
public class EventController {
  private final EventService svc;
  public EventController(EventService svc){ this.svc = svc; }

  @GetMapping public List<EventSummaryDto> list(){ return svc.listAll(); }
  @GetMapping("/{id}") public EventSummaryDto get(@PathVariable Long id){ return svc.getSummary(id); }

  @PostMapping("/niyaz") public NiyazEventDto createNiyaz(@Valid @RequestBody CreateUpdateNiyazEventRequest req){ return svc.createNiyaz(req); }
  @PutMapping("/niyaz/{id}") public NiyazEventDto updateNiyaz(@PathVariable Long id, @Valid @RequestBody CreateUpdateNiyazEventRequest req){ return svc.updateNiyaz(id, req); }

  @PostMapping("/thaali") public ThaaliEventDto createThaali(@Valid @RequestBody CreateUpdateThaaliEventRequest req){ return svc.createThaali(req); }
  @PutMapping("/thaali/{id}") public ThaaliEventDto updateThaali(@PathVariable Long id, @Valid @RequestBody CreateUpdateThaaliEventRequest req){ return svc.updateThaali(id, req); }

  @PostMapping("/{id}/publish") public ResponseEntity<Void> publish(@PathVariable Long id){ svc.setStatus(id, EventStatus.PUBLISHED); return ResponseEntity.ok().build(); }
  @PostMapping("/{id}/cancel") public ResponseEntity<Void> cancel(@PathVariable Long id){ svc.setStatus(id, EventStatus.CANCELLED); return ResponseEntity.ok().build(); }
}
