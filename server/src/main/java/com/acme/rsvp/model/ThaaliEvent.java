package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.util.*;

@Entity
@DiscriminatorValue("THAALI")
public class ThaaliEvent extends Event {
  @OneToMany(mappedBy="event", cascade=CascadeType.ALL, orphanRemoval=true)
  private List<MenuItem> menu = new ArrayList<>(); // typically 2 (Sat) or 3 (Wed)

  public List<MenuItem> getMenu() { return menu; }
  public void setMenu(List<MenuItem> menu) { this.menu = menu; }
}