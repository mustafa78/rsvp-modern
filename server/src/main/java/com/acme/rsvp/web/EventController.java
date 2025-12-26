package com.acme.rsvp.web;

import com.acme.rsvp.dto.EventDtos.*;
import com.acme.rsvp.model.EventStatus;
import com.acme.rsvp.service.EventService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class EventController {

    private final EventService service;

    public EventController(EventService service) {
        this.service = service;
    }

    // List all events (summary) - for admin use
    @GetMapping("/events")
    public List<EventSummaryDto> list() {
        return service.listAll();
    }

    // List only published events - for public/user use
    @GetMapping("/events/public")
    public List<EventSummaryDto> listPublished() {
        return service.listPublished();
    }

    // Get event summary by ID
    @GetMapping("/events/{id}")
    public EventSummaryDto get(@PathVariable Long id) {
        return service.getSummary(id);
    }

    // Get full Thaali event details (with menu)
    @GetMapping("/thaali/{id}")
    public ThaaliEventDto getThaali(@PathVariable Long id) {
        return service.getThaaliEvent(id);
    }

    // Get full Niyaz event details (with hosts)
    @GetMapping("/niyaz/{id}")
    public NiyazEventDto getNiyaz(@PathVariable Long id) {
        return service.getNiyazEvent(id);
    }

    // Create Niyaz event
    @PostMapping("/events/niyaz")
    public NiyazEventDto createNiyaz(@Valid @RequestBody CreateUpdateNiyazEventRequest req) {
        return service.createNiyaz(req);
    }

    // Update Niyaz event
    @PutMapping("/events/niyaz/{id}")
    public NiyazEventDto updateNiyaz(@PathVariable Long id, @Valid @RequestBody CreateUpdateNiyazEventRequest req) {
        return service.updateNiyaz(id, req);
    }

    // Create Thaali event
    @PostMapping("/events/thaali")
    public ThaaliEventDto createThaali(@Valid @RequestBody CreateUpdateThaaliEventRequest req) {
        return service.createThaali(req);
    }

    // Update Thaali event
    @PutMapping("/events/thaali/{id}")
    public ThaaliEventDto updateThaali(@PathVariable Long id, @Valid @RequestBody CreateUpdateThaaliEventRequest req) {
        return service.updateThaali(id, req);
    }

    // Publish event
    @PostMapping("/events/{id}/publish")
    public ResponseEntity<Void> publish(@PathVariable Long id) {
        service.setStatus(id, EventStatus.PUBLISHED);
        return ResponseEntity.ok().build();
    }

    // Cancel event
    @PostMapping("/events/{id}/cancel")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        service.setStatus(id, EventStatus.CANCELLED);
        return ResponseEntity.ok().build();
    }
}
