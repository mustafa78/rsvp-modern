package com.acme.rsvp.dto.auth;

import com.acme.rsvp.model.PickupZone;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record RegisterRequest(
    @NotBlank String itsNumber,
    @NotBlank String firstName,
    @NotBlank String lastName,
    @Pattern(
    	    regexp = "^[0-9\\-+()\\s]{7,}$",
    	    message = "Invalid phone"
    )
    String phone,
    @Email String email,
    @NotNull PickupZone pickupZone,
    @NotBlank String password
) {}
