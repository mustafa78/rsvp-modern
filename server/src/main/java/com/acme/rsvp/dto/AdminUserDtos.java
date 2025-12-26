package com.acme.rsvp.dto;

import java.time.Instant;
import java.util.Set;

import com.acme.rsvp.model.AccountStatus;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class AdminUserDtos {

    public record UserListDto(
            Long id,
            String itsNumber,
            String firstName,
            String lastName,
            String email,
            String phone,
            Set<String> roles,
            AccountStatus accountStatus,
            String pickupZoneName,
            Instant lastLoginAt) {
    }

    public record CreateUserRequest(
            @NotBlank String itsNumber,
            @NotBlank String firstName,
            @NotBlank String lastName,
            @NotBlank @Email String email,
            String phone,
            @NotBlank String password,
            Long pickupZoneId,
            Set<String> roles) {
    }

    public record UpdateRolesRequest(@NotNull Set<String> roles) {
    }

    public record UpdateStatusRequest(@NotNull AccountStatus status) {
    }
}
