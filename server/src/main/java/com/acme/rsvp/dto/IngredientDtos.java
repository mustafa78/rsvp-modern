package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;

public class IngredientDtos {
  public record IngredientDto(Long id, String name, String unit, String notes) {}

  public record IngredientUpsertRequest(
      @NotBlank String name,
      @NotBlank String unit,
      String notes
  ) {}
}
