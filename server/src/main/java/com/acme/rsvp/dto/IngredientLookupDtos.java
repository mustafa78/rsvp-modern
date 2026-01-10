package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class IngredientLookupDtos {

    public record LookupItemDto(
        Long id,
        String name,
        Integer displayOrder,
        boolean active
    ) {}

    public record CreateLookupRequest(
        @NotBlank(message = "Name is required")
        @Size(max = 100, message = "Name must be less than 100 characters")
        String name,
        Integer displayOrder
    ) {}

    public record UpdateLookupRequest(
        @NotBlank(message = "Name is required")
        @Size(max = 100, message = "Name must be less than 100 characters")
        String name,
        Integer displayOrder,
        Boolean active
    ) {}
}
