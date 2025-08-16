package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name="menu_item_ingredients")
public class MenuItemIngredient extends Auditable {
  @EmbeddedId
  private MenuItemIngredientId id;

  @ManyToOne(optional=false) @MapsId("menuItemId")
  @JoinColumn(name="menu_item_id")
  private MenuItem menuItem;

  @ManyToOne(optional=false) @MapsId("ingredientId")
  @JoinColumn(name="ingredient_id")
  private Ingredient ingredient;

  /**
   * Quantity of this ingredient required to prepare *1 quart* of this menu item.
   * Units are in ingredient.unit (e.g., grams/quart).
   */
  @Column(name="qty_per_quart", nullable=false, precision=19, scale=6)
  private BigDecimal quantityPerQuart;

  // getters/setters...
  public MenuItemIngredientId getId() { return id; }
  public void setId(MenuItemIngredientId id) { this.id = id; }
  public MenuItem getMenuItem() { return menuItem; }
  public void setMenuItem(MenuItem menuItem) { this.menuItem = menuItem; }
  public Ingredient getIngredient() { return ingredient; }
  public void setIngredient(Ingredient ingredient) { this.ingredient = ingredient; }
  public BigDecimal getQuantityPerQuart() { return quantityPerQuart; }
  public void setQuantityPerQuart(BigDecimal quantityPerQuart) { this.quantityPerQuart = quantityPerQuart; }
}