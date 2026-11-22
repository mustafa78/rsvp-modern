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

@Entity
@Table(name = "webinar_join_logs")
public class WebinarJoinLog {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "seat_id", nullable = false)
  private WebinarSeat seat;

  @Column(name = "joined_at", nullable = false)
  private OffsetDateTime joinedAt;

  @Enumerated(EnumType.STRING)
  @Column(name = "source", nullable = false, length = 16)
  private JoinSource source;

  protected WebinarJoinLog() {}

  public WebinarJoinLog(WebinarSeat seat, OffsetDateTime joinedAt, JoinSource source) {
    this.seat = seat;
    this.joinedAt = joinedAt;
    this.source = source;
  }

  public Long getId() { return id; }
  public WebinarSeat getSeat() { return seat; }
  public OffsetDateTime getJoinedAt() { return joinedAt; }
  public JoinSource getSource() { return source; }
}
