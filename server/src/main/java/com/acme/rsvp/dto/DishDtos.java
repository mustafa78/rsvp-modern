package com.acme.rsvp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.util.List;

public class DishDtos {
  public record DishDto(
      Long id,
      String name,
      String description,
      BigDecimal defaultQuartsPerThaaliUnit,
      boolean active,
      List<DishIngredientDto> ingredients,
      BigDecimal estimatedCostPerQuart,
      Integer estimatedCaloriesPerQuart
  ) {}

  public record DishIngredientDto(
      Long ingredientId,
      String ingredientName,
      String unit,
      @NotNull @Positive BigDecimal qtyPerQuart,
      BigDecimal costPerUnit,
      Integer caloriesPerUnit
  ) {}

  public record DishUpsertRequest(@NotBlank String name, String description,
                                  @NotNull @Positive BigDecimal defaultQuartsPerThaaliUnit,
                                  Boolean active,
                                  List<DishIngredientUpsert> ingredients) {}
  public record DishIngredientUpsert(@NotNull Long ingredientId, @NotNull @Positive BigDecimal qtyPerQuart) {}
}
