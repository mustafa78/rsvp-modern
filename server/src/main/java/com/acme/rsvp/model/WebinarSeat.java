package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * One attendee on one webinar. familyMember == null means the person's own seat;
 * otherwise person is the family member's head of family.
 */
@Entity
@Table(name = "webinar_seats")
public class WebinarSeat {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "webinar_id", nullable = false)
  private Webinar webinar;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "person_id", nullable = false)
  private Person person;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "family_member_id")
  private FamilyMember familyMember;

  @Enumerated(EnumType.STRING)
  @Column(name = "source", nullable = false, length = 16)
  private SeatSource source;

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  protected WebinarSeat() {}

  public WebinarSeat(Webinar webinar, Person person, FamilyMember familyMember, SeatSource source) {
    this.webinar = webinar;
    this.person = person;
    this.familyMember = familyMember;
    this.source = source;
    this.createdAt = OffsetDateTime.now();
  }

  public boolean isFamilySeat() { return familyMember != null; }

  public String attendeeIts() {
    return familyMember != null ? familyMember.getItsNumber() : person.getItsNumber();
  }

  public String attendeeName() {
    return familyMember != null
        ? familyMember.fullName()
        : person.getFirstName() + " " + person.getLastName();
  }

  /** The locked Zoom display name: "ITS First Last". */
  public String displayName() { return attendeeIts() + " " + attendeeName(); }

  public Long getId() { return id; }
  public Webinar getWebinar() { return webinar; }
  public Person getPerson() { return person; }
  public FamilyMember getFamilyMember() { return familyMember; }
  public SeatSource getSource() { return source; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
}
