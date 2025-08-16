package com.acme.rsvp.dto;
import jakarta.validation.constraints.*;
public record PasswordResetConfirmRequest(@NotBlank String itsNumber, @NotBlank String token, @Size(min=7, max=100) String newPassword) {}
