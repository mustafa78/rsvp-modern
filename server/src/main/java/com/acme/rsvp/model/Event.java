package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

@Entity
@Table(name="events",
       indexes = @Index(name="ix_event_date", columnList="event_date"))
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="event_type", discriminatorType=DiscriminatorType.STRING, length=16)
public abstract class Event extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name="title", length=200)
  private String title;

  @Column(name="description", length=2000)
  private String description;

  @Column(name="event_date", nullable=false)
  private LocalDate eventDate;

  @Column(name="start_time")
  private LocalTime startTime;

  @Column(name="registration_open_at", nullable=false)
  private OffsetDateTime registrationOpenAt;

  @Column(name="registration_close_at", nullable=false)
  private OffsetDateTime registrationCloseAt;

  @Enumerated(EnumType.STRING)
  @Column(name="status", nullable=false, length=16)
  private EventStatus status = EventStatus.DRAFT;

  @Column(name="last_significant_update_at")
  private OffsetDateTime lastSignificantUpdateAt;

  // Chef assignments
  @ManyToMany
  @JoinTable(name="event_chefs",
    joinColumns=@JoinColumn(name="event_id"),
    inverseJoinColumns=@JoinColumn(name="chef_id"))
  private Set<Chef> chefs = new HashSet<>();

  // getters/setters ...
  public Long getId() { return id; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public LocalDate getEventDate() { return eventDate; }
  public void setEventDate(LocalDate eventDate) { this.eventDate = eventDate; }
  public LocalTime getStartTime() { return startTime; }
  public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
  public OffsetDateTime getRegistrationOpenAt() { return registrationOpenAt; }
  public void setRegistrationOpenAt(OffsetDateTime registrationOpenAt) { this.registrationOpenAt = registrationOpenAt; }
  public OffsetDateTime getRegistrationCloseAt() { return registrationCloseAt; }
  public void setRegistrationCloseAt(OffsetDateTime registrationCloseAt) { this.registrationCloseAt = registrationCloseAt; }
  public EventStatus getStatus() { return status; }
  public void setStatus(EventStatus status) { this.status = status; }
  public OffsetDateTime getLastSignificantUpdateAt() { return lastSignificantUpdateAt; }
  public void setLastSignificantUpdateAt(OffsetDateTime lastSignificantUpdateAt) { this.lastSignificantUpdateAt = lastSignificantUpdateAt; }
  public Set<Chef> getChefs() { return chefs; }
  public void setChefs(Set<Chef> chefs) { this.chefs = chefs; }

  @Transient
  public boolean isRegistrationOpen(OffsetDateTime now) {
    return status == EventStatus.PUBLISHED && !now.isBefore(registrationOpenAt) && now.isBefore(registrationCloseAt);
  }
}