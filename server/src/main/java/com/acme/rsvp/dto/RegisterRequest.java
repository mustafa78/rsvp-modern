package com.acme.rsvp.dto;

import com.acme.rsvp.model.PickupZone;
import jakarta.validation.constraints.*;

public record RegisterRequest(
  @NotBlank String itsNumber,
  @NotBlank String firstName,
  @NotBlank String lastName,
  @Email @NotBlank String email,
  @Size(min=7, max=100) String password,
  @Pattern(regexp = "^[\\d\\s()+-]{7,}$", message = "Invalid phone") String phone,
  @NotNull PickupZone pickupZone
) {}
