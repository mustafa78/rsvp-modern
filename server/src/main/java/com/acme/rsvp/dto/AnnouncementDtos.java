package com.acme.rsvp.dto;

import com.acme.rsvp.model.AnnouncementType;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;

public class AnnouncementDtos {

    // Response DTO for displaying announcements
    public record AnnouncementDto(
        Long id,
        String title,
        String content,
        AnnouncementType type,
        Long eventId,
        String eventTitle,
        String createdByName,
        OffsetDateTime createdAt,
        OffsetDateTime expiresAt,
        boolean active,
        boolean isRead
    ) {}

    // Request DTO for creating manual announcements
    public record CreateAnnouncementRequest(
        String title,
        String content,
        LocalDateTime expiresAt
    ) {}

    // Request DTO for updating announcements
    public record UpdateAnnouncementRequest(
        String title,
        String content,
        LocalDateTime expiresAt
    ) {}

    // Response DTO for unread count
    public record UnreadCountDto(
        long count
    ) {}

    // Admin view with additional stats
    public record AdminAnnouncementDto(
        Long id,
        String title,
        String content,
        AnnouncementType type,
        Long eventId,
        String eventTitle,
        String createdByName,
        OffsetDateTime createdAt,
        OffsetDateTime expiresAt,
        boolean active,
        long readCount
    ) {}
}
