package com.acme.rsvp.dto;

import com.acme.rsvp.model.Rsvp;
import jakarta.validation.constraints.*;

public record RsvpDto(
  @NotBlank String name,
  @Email @NotBlank String email,
  String phone,
  @NotNull Rsvp.Status status,
  Rsvp.Role role,
  @Min(1) int headcount
){
  public static RsvpDto from(Rsvp r){
    return new RsvpDto(r.getPerson().getName(), r.getPerson().getEmail(), r.getPerson().getPhone(), r.getStatus(), r.getRole(), r.getHeadcount());
  }
}
