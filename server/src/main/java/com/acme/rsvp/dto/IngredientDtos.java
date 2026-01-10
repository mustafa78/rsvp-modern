package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;

public class IngredientDtos {
  public record IngredientDto(
      Long id,
      String name,
      String unit,
      String category,
      String defaultStore,
      String storageLocation,
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}

  public record IngredientUpsertRequest(
      @NotBlank String name,
      @NotBlank String unit,
      String category,
      String defaultStore,
      String storageLocation,
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}
}
