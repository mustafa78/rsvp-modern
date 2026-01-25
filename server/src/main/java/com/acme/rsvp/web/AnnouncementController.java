package com.acme.rsvp.web;

import com.acme.rsvp.dto.AnnouncementDtos.*;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.service.AnnouncementService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/announcements")
public class AnnouncementController {

    private final AnnouncementService announcementService;

    public AnnouncementController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }

    // Get all announcements for the current user (with read status)
    @GetMapping
    public ResponseEntity<List<AnnouncementDto>> getAnnouncements(@AuthenticationPrincipal Person me) {
        if (me == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(announcementService.getAnnouncementsForUser(me.getId()));
    }

    // Get unread count for badge display
    @GetMapping("/unread-count")
    public ResponseEntity<UnreadCountDto> getUnreadCount(@AuthenticationPrincipal Person me) {
        if (me == null) {
            return ResponseEntity.status(401).build();
        }
        long count = announcementService.getUnreadCount(me.getId());
        return ResponseEntity.ok(new UnreadCountDto(count));
    }

    // Mark a single announcement as read
    @PostMapping("/{id}/read")
    public ResponseEntity<?> markAsRead(@PathVariable Long id, @AuthenticationPrincipal Person me) {
        if (me == null) {
            return ResponseEntity.status(401).build();
        }
        announcementService.markAsRead(id, me.getId());
        return ResponseEntity.ok(Map.of("ok", true));
    }

    // Mark all announcements as read
    @PostMapping("/read-all")
    public ResponseEntity<?> markAllAsRead(@AuthenticationPrincipal Person me) {
        if (me == null) {
            return ResponseEntity.status(401).build();
        }
        announcementService.markAllAsRead(me.getId());
        return ResponseEntity.ok(Map.of("ok", true));
    }

    // Admin/Coordinators: Create a manual announcement
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR')")
    public AnnouncementDto createAnnouncement(
            @RequestBody CreateAnnouncementRequest request,
            @AuthenticationPrincipal Person me) {
        return announcementService.createManualAnnouncement(request, me.getId());
    }

    // Admin/Coordinators: Get all announcements with stats
    @GetMapping("/admin")
    @PreAuthorize("hasAnyRole('ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR')")
    public List<AdminAnnouncementDto> getAdminAnnouncements() {
        return announcementService.getAllAnnouncementsForAdmin();
    }

    // Admin/Coordinators: Update an announcement
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR')")
    public AdminAnnouncementDto updateAnnouncement(
            @PathVariable Long id,
            @RequestBody UpdateAnnouncementRequest request) {
        return announcementService.updateAnnouncement(id, request);
    }

    // Admin/Coordinators: Delete an announcement
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR')")
    public ResponseEntity<?> deleteAnnouncement(@PathVariable Long id) {
        announcementService.deleteAnnouncement(id);
        return ResponseEntity.ok(Map.of("ok", true));
    }

    // Admin/Coordinators: Toggle active status
    @PostMapping("/{id}/toggle-active")
    @PreAuthorize("hasAnyRole('ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR')")
    public AdminAnnouncementDto toggleActive(@PathVariable Long id) {
        return announcementService.toggleActive(id);
    }
}
