package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class IngredientDtos {
  public record IngredientDto(
      Long id,
      String name,
      Long unitId,
      String unit,  // unit name for display
      String category,
      String defaultStore,
      String storageLocation,
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}

  public record IngredientUpsertRequest(
      @NotBlank String name,
      @NotNull Long unitId,  // foreign key to ingredient_units
      String category,
      String defaultStore,
      String storageLocation,
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}
}
