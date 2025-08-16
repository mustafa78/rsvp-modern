package com.acme.rsvp.dto;
import jakarta.validation.constraints.*;
/** Alias of PasswordResetConfirmRequest for compatibility */
public record PasswordConfirmRequest(@NotBlank String itsNumber, @NotBlank String token, @Size(min=7, max=100) String newPassword) {}
