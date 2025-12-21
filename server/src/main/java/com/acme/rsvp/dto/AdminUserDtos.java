package com.acme.rsvp.dto;

import java.time.Instant;
import java.util.Set;

import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.RoleName;

import jakarta.validation.constraints.NotNull;

public class AdminUserDtos {

    public record UserListDto(
            Long id,
            String itsNumber,
            String firstName,
            String lastName,
            String email,
            String phone,
            Set<RoleName> roles,
            AccountStatus accountStatus,
            String pickupZoneName,
            Instant lastLoginAt) {
    }

    public record UpdateRolesRequest(@NotNull Set<RoleName> roles) {
    }

    public record UpdateStatusRequest(@NotNull AccountStatus status) {
    }
}
