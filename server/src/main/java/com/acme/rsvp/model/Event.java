package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.*;

@Entity
@Table(name = "events")
public class Event {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(nullable=false)
  private LocalDate date;
  private LocalTime startTime;
  private Integer capacity;
  private String notes;

  public Long getId(){return id;} public void setId(Long id){this.id=id;}
  public LocalDate getDate(){return date;} public void setDate(LocalDate d){this.date=d;}
  public LocalTime getStartTime(){return startTime;} public void setStartTime(LocalTime t){this.startTime=t;}
  public Integer getCapacity(){return capacity;} public void setCapacity(Integer c){this.capacity=c;}
  public String getNotes(){return notes;} public void setNotes(String n){this.notes=n;}
}
