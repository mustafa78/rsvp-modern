package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record PasswordConfirmRequest(@NotBlank String token, @NotBlank String newPassword) {}
