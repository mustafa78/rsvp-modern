package com.acme.rsvp.model;

import jakarta.persistence.*;

@Entity
@Table(name="niyaz_rsvps",
  uniqueConstraints = @UniqueConstraint(name="uc_niyaz_event_person", columnNames={"event_id","person_id"}))
public class NiyazRsvp extends Auditable {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional=false) @JoinColumn(name="event_id")
  private NiyazEvent event;

  @ManyToOne(optional=false) @JoinColumn(name="person_id")
  private Person person;

  @Column(name="adults", nullable=false)
  private int adults;

  @Column(name="kids", nullable=false)
  private int kids;

  // getters/setters...
  public Long getId() { return id; }
  public NiyazEvent getEvent() { return event; }
  public void setEvent(NiyazEvent event) { this.event = event; }
  public Person getPerson() { return person; }
  public void setPerson(Person person) { this.person = person; }
  public int getAdults() { return adults; }
  public void setAdults(int adults) { this.adults = adults; }
  public int getKids() { return kids; }
  public void setKids(int kids) { this.kids = kids; }
}