package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.*;

@Entity
@DiscriminatorValue("NIYAZ")
public class NiyazEvent extends Event {
  @Column(name="miqaat_name", nullable=false, length=200)
  private String miqaatName;

  @Column(name="miqaat_date", nullable=false)
  private LocalDate miqaatDate;

  @Column(name="miqaat_time")
  private LocalTime miqaatTime;

  // getters/setters
  public String getMiqaatName() { return miqaatName; }
  public void setMiqaatName(String miqaatName) { this.miqaatName = miqaatName; }
  public LocalDate getMiqaatDate() { return miqaatDate; }
  public void setMiqaatDate(LocalDate miqaatDate) { this.miqaatDate = miqaatDate; }
  public LocalTime getMiqaatTime() { return miqaatTime; }
  public void setMiqaatTime(LocalTime miqaatTime) { this.miqaatTime = miqaatTime; }
}