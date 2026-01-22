package com.acme.rsvp.dto;

import java.time.LocalDate;
import java.time.Instant;
import java.util.List;
import java.util.Set;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class ProfileDtos {

    // Full profile response
    public record ProfileResponse(
        Long id,
        String itsNumber,
        String firstName,
        String lastName,
        String email,
        String phone,
        Set<String> roles,
        Long pickupZoneId,
        String pickupZoneName,
        String userType,
        boolean isHof,
        Instant lastLoginAt,
        Instant createdAt
    ) {}

    // Update profile request (only editable fields)
    public record UpdateProfileRequest(
        @NotBlank @Email String email,
        String phone,
        Long pickupZoneId
    ) {}

    // RSVP History
    public record RsvpHistoryResponse(
        List<NiyazRsvpHistoryItem> niyazRsvps,
        List<ThaaliOrderHistoryItem> thaaliOrders
    ) {}

    public record NiyazRsvpHistoryItem(
        Long rsvpId,
        Long eventId,
        String eventTitle,
        LocalDate eventDate,
        String eventStatus,
        int adults,
        int kids,
        String notes
    ) {}

    public record ThaaliOrderHistoryItem(
        Long orderId,
        Long eventId,
        String eventTitle,
        LocalDate eventDate,
        String eventStatus,
        String pickupZoneName,
        List<ThaaliOrderItemHistory> items,
        String notes
    ) {}

    public record ThaaliOrderItemHistory(
        String dishName,
        String size
    ) {}
}
