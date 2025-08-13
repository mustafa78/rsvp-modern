package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.*;

@Entity
@Table(name = "rsvps",
  uniqueConstraints = @UniqueConstraint(name="uc_event_person", columnNames={"event_id","person_id"}))
public class Rsvp {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional=false) @JoinColumn(name="event_id")
  private Event event;
  @ManyToOne(optional=false) @JoinColumn(name="person_id")
  private Person person;

  @Enumerated(EnumType.STRING)
  @Column(nullable=false)
  private Status status; // YES/NO/MAYBE
  @Enumerated(EnumType.STRING)
  private Role role;     // COOK/FILL/OTHER

  private Integer headcount;
  @Column(nullable=false)
  private Instant createdAt = Instant.now();

  public enum Status { YES, NO, MAYBE }
  public enum Role { COOK, FILL, OTHER }

  public Long getId(){return id;} public void setId(Long id){this.id=id;}
  public Event getEvent(){return event;} public void setEvent(Event e){this.event=e;}
  public Person getPerson(){return person;} public void setPerson(Person p){this.person=p;}
  public Status getStatus(){return status;} public void setStatus(Status s){this.status=s;}
  public Role getRole(){return role;} public void setRole(Role r){this.role=r;}
  public Integer getHeadcount(){return headcount;} public void setHeadcount(Integer h){this.headcount=h;}
  public Instant getCreatedAt(){return createdAt;} public void setCreatedAt(Instant i){this.createdAt=i;}
}
