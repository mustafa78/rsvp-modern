package com.acme.rsvp.model;

import jakarta.persistence.*;

@Entity
@Table(name="event_chefs")
@IdClass(EventChefId.class)
public class EventChef {
  @Id @ManyToOne(optional=false) @JoinColumn(name="event_id")
  private Event event;
  @Id @ManyToOne(optional=false) @JoinColumn(name="chef_id")
  private Chef chef;
  private String role;

  public Event getEvent(){ return event; }
  public void setEvent(Event event){ this.event = event; }
  public Chef getChef(){ return chef; }
  public void setChef(Chef chef){ this.chef = chef; }
  public String getRole(){ return role; }
  public void setRole(String role){ this.role = role; }
}
