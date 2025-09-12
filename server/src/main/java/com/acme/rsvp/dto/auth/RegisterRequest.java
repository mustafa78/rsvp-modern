package com.acme.rsvp.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
    @NotBlank String itsNumber,
    @NotBlank String firstName,
    @NotBlank String lastName,
    @Pattern(
    	    regexp = "^[0-9\\-+()\\s]{7,}$",
    	    message = "Invalid phone"
    )
    String phone,
    @Email @NotBlank String email,
    Long pickupZoneId,   // << accept an ID
    @Size(min = 8) @NotBlank String password
) {}
