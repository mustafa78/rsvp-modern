package com.acme.rsvp.model;

import java.time.OffsetDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import org.hibernate.annotations.DynamicUpdate;

/**
 * A magic join link for one seat. Only the SHA-256 hash of the raw token is stored.
 * DynamicUpdate: a launch bumps use_count/last_used_at only, so it can never write back a stale
 * revoked_at (null) over a revoke committed while the launch was in flight.
 */
@Entity
@DynamicUpdate
@Table(name = "webinar_join_tokens")
public class WebinarJoinToken {

  @Id
  @Column(name = "id", columnDefinition = "uuid")
  private UUID id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "seat_id", nullable = false)
  private WebinarSeat seat;

  @Column(name = "token_hash", nullable = false, unique = true, length = 64)
  private String tokenHash;

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  @Column(name = "expires_at", nullable = false)
  private OffsetDateTime expiresAt;

  @Column(name = "revoked_at")
  private OffsetDateTime revokedAt;

  @Column(name = "last_used_at")
  private OffsetDateTime lastUsedAt;

  @Column(name = "use_count", nullable = false)
  private int useCount = 0;

  protected WebinarJoinToken() {}

  public WebinarJoinToken(UUID id, WebinarSeat seat, String tokenHash,
      OffsetDateTime createdAt, OffsetDateTime expiresAt) {
    this.id = id;
    this.seat = seat;
    this.tokenHash = tokenHash;
    this.createdAt = createdAt;
    this.expiresAt = expiresAt;
  }

  public UUID getId() { return id; }
  public WebinarSeat getSeat() { return seat; }
  public String getTokenHash() { return tokenHash; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
  public OffsetDateTime getExpiresAt() { return expiresAt; }
  public OffsetDateTime getRevokedAt() { return revokedAt; }
  public void setRevokedAt(OffsetDateTime revokedAt) { this.revokedAt = revokedAt; }
  public OffsetDateTime getLastUsedAt() { return lastUsedAt; }
  public void setLastUsedAt(OffsetDateTime lastUsedAt) { this.lastUsedAt = lastUsedAt; }
  public int getUseCount() { return useCount; }
  public void setUseCount(int useCount) { this.useCount = useCount; }
}
