package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "dishes")
public class Dish {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false, unique = true)
  private String name;

  @Column(columnDefinition = "text")
  private String description;

  @Column(name="default_quarts_per_thaali_unit", precision=6, scale=2, nullable=false)
  private BigDecimal defaultQuartsPerThaaliUnit = new BigDecimal("1.00");

  @Column(nullable = false)
  private boolean active = true;

  @Column(name="created_at", nullable=false)
  private OffsetDateTime createdAt = OffsetDateTime.now();

  @OneToMany(mappedBy = "dish", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<DishIngredient> ingredients = new ArrayList<>();

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public BigDecimal getDefaultQuartsPerThaaliUnit() { return defaultQuartsPerThaaliUnit; }
  public void setDefaultQuartsPerThaaliUnit(BigDecimal v) { this.defaultQuartsPerThaaliUnit = v; }
  public boolean isActive() { return active; }
  public void setActive(boolean active) { this.active = active; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
  public List<DishIngredient> getIngredients() { return ingredients; }
  public void setIngredients(List<DishIngredient> ingredients) { this.ingredients = ingredients; }
}
