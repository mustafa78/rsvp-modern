package com.acme.rsvp.model;

import jakarta.persistence.*;

@Entity
@Table(name="ingredients", uniqueConstraints = @UniqueConstraint(name="uc_ingredient_name", columnNames = "name"))
public class Ingredient extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name="name", nullable=false, length=200)
  private String name;

  @Column(name="unit", nullable=false, length=32) // e.g., g, kg, lb, tsp, tbsp, ml, l
  private String unit;

  @Column(name="notes", length=500)
  private String notes;

  // getters/setters...
  public Long getId() { return id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getUnit() { return unit; }
  public void setUnit(String unit) { this.unit = unit; }
  public String getNotes() { return notes; }
  public void setNotes(String notes) { this.notes = notes; }
}