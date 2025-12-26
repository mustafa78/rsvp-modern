package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.Instant;

public class RoleDtos {

    public record RoleDto(
            Long id,
            String name,
            String description,
            boolean active,
            Instant createdAt,
            Instant updatedAt
    ) {}

    public record CreateRoleRequest(
            @NotBlank @Size(max = 50) String name,
            @Size(max = 255) String description
    ) {}

    public record UpdateRoleRequest(
            @Size(max = 255) String description,
            Boolean active
    ) {}
}
