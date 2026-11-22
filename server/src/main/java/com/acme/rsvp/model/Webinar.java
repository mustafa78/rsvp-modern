package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "webinars")
public class Webinar extends Auditable {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name = "title", nullable = false, length = 200)
  private String title;

  @Column(name = "description", length = 2000)
  private String description;

  @Column(name = "host_name", length = 200)
  private String hostName;

  @Column(name = "scheduled_start", nullable = false)
  private OffsetDateTime scheduledStart;

  @Column(name = "scheduled_end", nullable = false)
  private OffsetDateTime scheduledEnd;

  @Enumerated(EnumType.STRING)
  @Column(name = "status", nullable = false, length = 16)
  private WebinarStatus status = WebinarStatus.DRAFT;

  @Enumerated(EnumType.STRING)
  @Column(name = "access_mode", nullable = false, length = 16)
  private WebinarAccessMode accessMode = WebinarAccessMode.ASSIGNED;

  /** Secret. Never copy this into a DTO, log line or email. */
  @Column(name = "join_url", length = 2000)
  private String joinUrl;

  @Column(name = "zoom_meeting_id", length = 64)
  private String zoomMeetingId;

  @Column(name = "managed_by_zoom", nullable = false)
  private boolean managedByZoom = false;

  @Column(name = "join_window_before_min", nullable = false)
  private int joinWindowBeforeMin = 10;

  @Column(name = "join_window_after_min", nullable = false)
  private int joinWindowAfterMin = 15;

  @Column(name = "event_id")
  private Long eventId;

  public OffsetDateTime joinWindowStart() { return scheduledStart.minusMinutes(joinWindowBeforeMin); }

  public OffsetDateTime joinWindowEnd() { return scheduledEnd.plusMinutes(joinWindowAfterMin); }

  public boolean isJoinOpen(OffsetDateTime now) {
    return status == WebinarStatus.PUBLISHED
        && !now.isBefore(joinWindowStart())
        && !now.isAfter(joinWindowEnd());
  }

  public Long getId() { return id; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public String getHostName() { return hostName; }
  public void setHostName(String hostName) { this.hostName = hostName; }
  public OffsetDateTime getScheduledStart() { return scheduledStart; }
  public void setScheduledStart(OffsetDateTime scheduledStart) { this.scheduledStart = scheduledStart; }
  public OffsetDateTime getScheduledEnd() { return scheduledEnd; }
  public void setScheduledEnd(OffsetDateTime scheduledEnd) { this.scheduledEnd = scheduledEnd; }
  public WebinarStatus getStatus() { return status; }
  public void setStatus(WebinarStatus status) { this.status = status; }
  public WebinarAccessMode getAccessMode() { return accessMode; }
  public void setAccessMode(WebinarAccessMode accessMode) { this.accessMode = accessMode; }
  public String getJoinUrl() { return joinUrl; }
  public void setJoinUrl(String joinUrl) { this.joinUrl = joinUrl; }
  public String getZoomMeetingId() { return zoomMeetingId; }
  public void setZoomMeetingId(String zoomMeetingId) { this.zoomMeetingId = zoomMeetingId; }
  public boolean isManagedByZoom() { return managedByZoom; }
  public void setManagedByZoom(boolean managedByZoom) { this.managedByZoom = managedByZoom; }
  public int getJoinWindowBeforeMin() { return joinWindowBeforeMin; }
  public void setJoinWindowBeforeMin(int v) { this.joinWindowBeforeMin = v; }
  public int getJoinWindowAfterMin() { return joinWindowAfterMin; }
  public void setJoinWindowAfterMin(int v) { this.joinWindowAfterMin = v; }
  public Long getEventId() { return eventId; }
  public void setEventId(Long eventId) { this.eventId = eventId; }
}
