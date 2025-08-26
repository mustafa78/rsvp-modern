package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "session_tokens")
public class SessionToken {

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

  @Column(name = "revoked", nullable = false)
  private boolean revoked = false;

  public SessionToken() {}

  public SessionToken(UUID id, Person person, OffsetDateTime createdAt, OffsetDateTime expiresAt) {
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
  public boolean isRevoked() { return revoked; }
  public void setRevoked(boolean revoked) { this.revoked = revoked; }
}
