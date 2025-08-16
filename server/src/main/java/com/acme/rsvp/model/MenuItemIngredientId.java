package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MenuItemIngredientId implements Serializable {
  private static final long serialVersionUID = 1L;
  
  @Column(name="menu_item_id") private Long menuItemId;
  @Column(name="ingredient_id") private Long ingredientId;

  public MenuItemIngredientId() {}
  public MenuItemIngredientId(Long menuItemId, Long ingredientId) {
    this.menuItemId = menuItemId; this.ingredientId = ingredientId;
  }
  public Long getMenuItemId() { return menuItemId; }
  public Long getIngredientId() { return ingredientId; }

  @Override public boolean equals(Object o){
    if(this==o) return true; if(!(o instanceof MenuItemIngredientId m)) return false;
    return Objects.equals(menuItemId, m.menuItemId) && Objects.equals(ingredientId, m.ingredientId);
  }
  @Override public int hashCode(){ return Objects.hash(menuItemId, ingredientId); }
}