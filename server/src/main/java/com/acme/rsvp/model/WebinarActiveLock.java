package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/** Which webinar an attendee is currently in. One row per attendee. */
@Entity
@Table(name = "webinar_active_locks")
public class WebinarActiveLock {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "person_id", nullable = false)
  private Person person;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "family_member_id")
  private FamilyMember familyMember;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "webinar_id", nullable = false)
  private Webinar webinar;

  /**
   * Informational only: the joined webinar's scheduled end at the time of joining. The launch check
   * reads the live Webinar (status and scheduled end) instead of this value.
   */
  @Column(name = "locked_until", nullable = false)
  private OffsetDateTime lockedUntil;

  protected WebinarActiveLock() {}

  public WebinarActiveLock(Person person, FamilyMember familyMember) {
    this.person = person;
    this.familyMember = familyMember;
  }

  public Long getId() { return id; }
  public Webinar getWebinar() { return webinar; }
  public void setWebinar(Webinar webinar) { this.webinar = webinar; }
  public OffsetDateTime getLockedUntil() { return lockedUntil; }
  public void setLockedUntil(OffsetDateTime lockedUntil) { this.lockedUntil = lockedUntil; }
}
