package com.acme.rsvp.dto;
import jakarta.validation.constraints.*;
public record PasswordChangeRequest(@NotBlank String itsNumber, @NotBlank String oldPassword, @Size(min=7, max=100) String newPassword) {}
