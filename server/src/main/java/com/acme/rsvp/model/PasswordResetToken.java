package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "password_reset_tokens", indexes = {
    @Index(name="ix_prt_person_expires", columnList = "person_id, expires_at")
})
public class PasswordResetToken {

  @Id
  @Column(name = "id", columnDefinition = "uuid")
  private UUID id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "person_id", nullable = false)
  private Person person;

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  @Column(name = "expires_at", nullable = false)
  private OffsetDateTime expiresAt;

  @Column(name = "used_at")
  private OffsetDateTime usedAt;

  public PasswordResetToken(){}

  public PasswordResetToken(UUID id, Person person, OffsetDateTime createdAt, OffsetDateTime expiresAt) {
    this.id = id;
    this.person = person;
    this.createdAt = createdAt;
    this.expiresAt = expiresAt;
  }

  public UUID getId() { return id; }
  public void setId(UUID id) { this.id = id; }
  public Person getPerson() { return person; }
  public void setPerson(Person person) { this.person = person; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
  public OffsetDateTime getExpiresAt() { return expiresAt; }
  public void setExpiresAt(OffsetDateTime expiresAt) { this.expiresAt = expiresAt; }
  public OffsetDateTime getUsedAt() { return usedAt; }
  public void setUsedAt(OffsetDateTime usedAt) { this.usedAt = usedAt; }
}
