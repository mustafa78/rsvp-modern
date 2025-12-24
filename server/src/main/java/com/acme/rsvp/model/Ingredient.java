package com.acme.rsvp.model;

import jakarta.persistence.*;

@Entity
@Table(name="ingredients", uniqueConstraints = @UniqueConstraint(name="uc_ingredient_name", columnNames = "name"))
public class Ingredient extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name="name", nullable=false, length=200)
  private String name;

  @Column(name="unit", nullable=false, length=32) // e.g., lb, bunch, can, box
  private String unit;

  @Column(name="category", length=32) // produce, meat, non-perishable, frozen, pantry, bread
  private String category;

  @Column(name="default_store", length=64) // Costco, Indian, Indus, Grocery
  private String defaultStore;

  @Column(name="storage_location", length=100) // refrigerator, freezer, spice rack, etc.
  private String storageLocation;

  @Column(name="notes", length=500)
  private String notes;

  // getters/setters
  public Long getId() { return id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getUnit() { return unit; }
  public void setUnit(String unit) { this.unit = unit; }
  public String getCategory() { return category; }
  public void setCategory(String category) { this.category = category; }
  public String getDefaultStore() { return defaultStore; }
  public void setDefaultStore(String defaultStore) { this.defaultStore = defaultStore; }
  public String getStorageLocation() { return storageLocation; }
  public void setStorageLocation(String storageLocation) { this.storageLocation = storageLocation; }
  public String getNotes() { return notes; }
  public void setNotes(String notes) { this.notes = notes; }
}