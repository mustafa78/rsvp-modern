package com.acme.rsvp.dto;
import jakarta.validation.constraints.*;
public record LoginRequest(@NotBlank String itsNumber, @NotBlank String password) {}
