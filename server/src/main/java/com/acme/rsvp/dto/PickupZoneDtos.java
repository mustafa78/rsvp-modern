package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;

public class PickupZoneDtos {

    public record PickupZoneDto(Long id, String name, boolean active) {
    }

    public record PickupZoneUpsertRequest(@NotBlank String name, boolean active) {
    }
}
