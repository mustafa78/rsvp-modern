package com.acme.rsvp.web;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.ProfileDtos.*;
import com.acme.rsvp.dto.auth.PasswordChangeRequest;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.repository.PickupZoneRepository;
import com.acme.rsvp.service.AuthService;
import com.acme.rsvp.service.ProfileService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    private final ProfileService profileService;
    private final AuthService authService;
    private final PickupZoneRepository pickupZoneRepo;

    public ProfileController(ProfileService profileService, AuthService authService,
            PickupZoneRepository pickupZoneRepo) {
        this.profileService = profileService;
        this.authService = authService;
        this.pickupZoneRepo = pickupZoneRepo;
    }

    public record PickupZoneDto(Long id, String name) {}

    // Get current user's profile
    @GetMapping
    public ResponseEntity<ProfileResponse> getProfile(@AuthenticationPrincipal Person user) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(profileService.getProfile(user));
    }

    // Update current user's profile
    @PutMapping
    public ResponseEntity<ProfileResponse> updateProfile(
            @AuthenticationPrincipal Person user,
            @Valid @RequestBody UpdateProfileRequest request) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(profileService.updateProfile(user, request));
    }

    // Change password (authenticated)
    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(
            @AuthenticationPrincipal Person user,
            @Valid @RequestBody PasswordChangeRequest request) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        try {
            authService.changePassword(user, request);
            return ResponseEntity.ok(Map.of("ok", true));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // Get RSVP history
    @GetMapping("/rsvp-history")
    public ResponseEntity<RsvpHistoryResponse> getRsvpHistory(@AuthenticationPrincipal Person user) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(profileService.getRsvpHistory(user));
    }

    // Get available pickup zones (for the dropdown)
    @GetMapping("/pickup-zones")
    public List<PickupZoneDto> getPickupZones() {
        return pickupZoneRepo.findAllByActiveTrueOrderByNameAsc().stream()
                .map(z -> new PickupZoneDto(z.getId(), z.getName()))
                .toList();
    }
}
