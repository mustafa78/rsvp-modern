package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record UnauthPasswordChangeRequest(
    @NotBlank String itsNumber,
    @NotBlank String currentPassword,
    @NotBlank String newPassword
) {}
