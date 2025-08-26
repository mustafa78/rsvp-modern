package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record PasswordChangeRequest(
    @NotBlank String currentPassword,
    @NotBlank String newPassword
) {}
