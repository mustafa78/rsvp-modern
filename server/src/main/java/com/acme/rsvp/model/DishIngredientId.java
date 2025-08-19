package com.acme.rsvp.model;

import java.io.Serializable;
import java.util.Objects;

public class DishIngredientId implements Serializable {
  private Long dish;
  private Long ingredient;

  public DishIngredientId() {}
  public DishIngredientId(Long dish, Long ingredient){ this.dish = dish; this.ingredient = ingredient; }

  @Override public boolean equals(Object o){
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    DishIngredientId that = (DishIngredientId) o;
    return java.util.Objects.equals(dish, that.dish) && java.util.Objects.equals(ingredient, that.ingredient);
  }
  @Override public int hashCode(){ return java.util.Objects.hash(dish, ingredient); }
}
