package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name="menu_items")
public class MenuItem extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional=false) @JoinColumn(name="event_id")
  private ThaaliEvent event;

  @Column(name="name", nullable=false, length=200)
  private String name;

  @Column(name="description", length=1000)
  private String description;

  /**
   * Multiplier applied to total \"thaali quarts\" to get quarts for this dish.
   * Default 1.0 => each dish needs the same quarts as the total thaali quarts.
   * Adjust if one dish is made in a different proportion.
   */
  @Column(name="quarts_per_thaali_unit", nullable=false)
  private java.math.BigDecimal quartsPerThaaliUnit = java.math.BigDecimal.ONE;

  @OneToMany(mappedBy="menuItem", cascade=CascadeType.ALL, orphanRemoval=true)
  private Set<MenuItemIngredient> ingredients = new HashSet<>();

  // getters/setters...
  public Long getId() { return id; }
  public ThaaliEvent getEvent() { return event; }
  public void setEvent(ThaaliEvent event) { this.event = event; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public java.math.BigDecimal getQuartsPerThaaliUnit() { return quartsPerThaaliUnit; }
  public void setQuartsPerThaaliUnit(java.math.BigDecimal v) { this.quartsPerThaaliUnit = v; }
  public Set<MenuItemIngredient> getIngredients() { return ingredients; }
  public void setIngredients(Set<MenuItemIngredient> ingredients) { this.ingredients = ingredients; }
}