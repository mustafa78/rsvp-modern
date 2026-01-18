package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name="ingredients", uniqueConstraints = @UniqueConstraint(name="uc_ingredient_name", columnNames = "name"))
public class Ingredient extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name="name", nullable=false, length=200)
  private String name;

  @ManyToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "unit_id", nullable = false)
  private IngredientUnit unit;

  @ManyToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "category_id")
  private IngredientCategory category;

  @ManyToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "store_id")
  private IngredientStore store;

  @ManyToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "storage_location_id")
  private IngredientStorageLocation storageLocation;

  @Column(name="notes", length=500)
  private String notes;

  @Column(name="cost_per_unit", precision=10, scale=2)
  private BigDecimal costPerUnit; // Cost in dollars per unit

  @Column(name="calories_per_unit")
  private Integer caloriesPerUnit; // Calories per unit

  // getters/setters
  public Long getId() { return id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public IngredientUnit getUnit() { return unit; }
  public void setUnit(IngredientUnit unit) { this.unit = unit; }
  public IngredientCategory getCategory() { return category; }
  public void setCategory(IngredientCategory category) { this.category = category; }
  public IngredientStore getStore() { return store; }
  public void setStore(IngredientStore store) { this.store = store; }
  public IngredientStorageLocation getStorageLocation() { return storageLocation; }
  public void setStorageLocation(IngredientStorageLocation storageLocation) { this.storageLocation = storageLocation; }
  public String getNotes() { return notes; }
  public void setNotes(String notes) { this.notes = notes; }
  public BigDecimal getCostPerUnit() { return costPerUnit; }
  public void setCostPerUnit(BigDecimal costPerUnit) { this.costPerUnit = costPerUnit; }
  public Integer getCaloriesPerUnit() { return caloriesPerUnit; }
  public void setCaloriesPerUnit(Integer caloriesPerUnit) { this.caloriesPerUnit = caloriesPerUnit; }
}