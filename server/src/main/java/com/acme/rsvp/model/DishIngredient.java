package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "dish_ingredients")
@IdClass(DishIngredientId.class)
public class DishIngredient {
  @Id
  @ManyToOne(optional=false) @JoinColumn(name="dish_id")
  private Dish dish;

  @Id
  @ManyToOne(optional=false) @JoinColumn(name="ingredient_id")
  private Ingredient ingredient;

  @Column(name="qty_per_quart", precision=10, scale=3, nullable=false)
  private BigDecimal qtyPerQuart;

  public Dish getDish(){ return dish; }
  public void setDish(Dish dish){ this.dish = dish; }
  public Ingredient getIngredient(){ return ingredient; }
  public void setIngredient(Ingredient ingredient){ this.ingredient = ingredient; }
  public BigDecimal getQtyPerQuart(){ return qtyPerQuart; }
  public void setQtyPerQuart(BigDecimal qtyPerQuart){ this.qtyPerQuart = qtyPerQuart; }
}
