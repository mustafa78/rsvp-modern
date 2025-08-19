package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name="menu_items")
public class MenuItem {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional=false) @JoinColumn(name="event_id")
  private Event event;

  // New catalog link (optional but recommended)
  @ManyToOne @JoinColumn(name="dish_id")
  private Dish dish;

  // Optional override per event; if null, use dish.defaultQuartsPerThaaliUnit
  @Column(name="quarts_per_thaali_unit", precision=6, scale=2)
  private BigDecimal quartsPerThaaliUnit;

  @Column(name="position")
  private Integer position;

  public Long getId(){ return id; }
  public void setId(Long id){ this.id = id; }
  public Event getEvent(){ return event; }
  public void setEvent(Event event){ this.event = event; }
  public Dish getDish(){ return dish; }
  public void setDish(Dish dish){ this.dish = dish; }
  public BigDecimal getQuartsPerThaaliUnit(){ return quartsPerThaaliUnit; }
  public void setQuartsPerThaaliUnit(BigDecimal q){ this.quartsPerThaaliUnit = q; }
  public Integer getPosition(){ return position; }
  public void setPosition(Integer position){ this.position = position; }
}
