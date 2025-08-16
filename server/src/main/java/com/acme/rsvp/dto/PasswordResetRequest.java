package com.acme.rsvp.dto;
import jakarta.validation.constraints.*;
public record PasswordResetRequest(@NotBlank String itsOrEmail) {}
