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
      Long categoryId,
      String category,  // category name for display
      Long storeId,
      String store,  // store name for display
      Long storageLocationId,
      String storageLocation,  // storage location name for display
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}

  public record IngredientUpsertRequest(
      @NotBlank String name,
      @NotNull Long unitId,  // foreign key to ingredient_units
      Long categoryId,  // foreign key to ingredient_categories
      Long storeId,  // foreign key to ingredient_stores
      Long storageLocationId,  // foreign key to ingredient_storage_locations
      String notes,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}
}
