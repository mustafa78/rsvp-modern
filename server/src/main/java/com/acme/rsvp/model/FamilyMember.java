package com.acme.rsvp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/** A family member saved under a head of family. Not a user: no login, password or role. */
@Entity
@Table(name = "family_members")
public class FamilyMember extends Auditable {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "hof_person_id", nullable = false)
  private Person hof;

  @Column(name = "first_name", nullable = false, length = 100)
  private String firstName;

  @Column(name = "last_name", nullable = false, length = 100)
  private String lastName;

  @Column(name = "its_number", nullable = false, unique = true, length = 32)
  private String itsNumber;

  @Column(name = "active", nullable = false)
  private boolean active = true;

  public String fullName() { return firstName + " " + lastName; }

  public Long getId() { return id; }
  public Person getHof() { return hof; }
  public void setHof(Person hof) { this.hof = hof; }
  public String getFirstName() { return firstName; }
  public void setFirstName(String firstName) { this.firstName = firstName; }
  public String getLastName() { return lastName; }
  public void setLastName(String lastName) { this.lastName = lastName; }
  public String getItsNumber() { return itsNumber; }
  public void setItsNumber(String itsNumber) { this.itsNumber = itsNumber; }
  public boolean isActive() { return active; }
  public void setActive(boolean active) { this.active = active; }
}
