package com.acme.rsvp.dto;

import com.acme.rsvp.model.ChefType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class ChefDtos {
  public record ChefDto(Long id, String name, ChefType type, String email, String phone, String notes, boolean active) {}
  public record ChefUpsertRequest(@NotBlank String name, @NotNull ChefType type, String email, String phone, String notes, Boolean active) {}
}
