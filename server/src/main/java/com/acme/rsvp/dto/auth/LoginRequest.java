package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record LoginRequest(
    @NotBlank String itsNumber,
    @NotBlank String password
) {}
