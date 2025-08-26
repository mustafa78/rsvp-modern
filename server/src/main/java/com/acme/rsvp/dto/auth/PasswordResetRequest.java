package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record PasswordResetRequest(@NotBlank String itsNumberOrEmail) {}
