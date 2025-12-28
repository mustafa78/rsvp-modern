package com.acme.rsvp.web;

import java.util.List;

import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDetailDto;
import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDto;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.service.NiyazService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/niyaz/{eventId}/rsvp")
public class NiyazRsvpController {

    private final NiyazService service;

    public NiyazRsvpController(NiyazService service) {
        this.service = service;
    }

    // Request body for upsert
    public record NiyazRsvpRequest(int adults, int kids) {}

    // Create or update RSVP for the current user
    @PostMapping
    public NiyazRsvpDto upsertMyRsvp(
            @PathVariable Long eventId,
            @Valid @RequestBody NiyazRsvpRequest request,
            @AuthenticationPrincipal Person user) {
        return service.upsert(eventId, user.getId(), request.adults(), request.kids());
    }

    // Get the current user's RSVP for this event
    @GetMapping("/my")
    public ResponseEntity<NiyazRsvpDto> getMyRsvp(
            @PathVariable Long eventId,
            @AuthenticationPrincipal Person user) {
        NiyazRsvpDto rsvp = service.getMyRsvp(eventId, user.getId());
        return rsvp != null ? ResponseEntity.ok(rsvp) : ResponseEntity.noContent().build();
    }

    // Admin: Get totals
    @GetMapping("/totals/adults")
    public long adults(@PathVariable Long eventId) {
        return service.totalAdults(eventId);
    }

    @GetMapping("/totals/kids")
    public long kids(@PathVariable Long eventId) {
        return service.totalKids(eventId);
    }

    // Admin: Get all RSVPs with person details
    @GetMapping("/all")
    public List<NiyazRsvpDetailDto> getAllRsvps(@PathVariable Long eventId) {
        return service.getRsvpsByEvent(eventId);
    }
}
