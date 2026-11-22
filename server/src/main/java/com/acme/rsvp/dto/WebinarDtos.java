package com.acme.rsvp.dto;

import java.time.OffsetDateTime;
import java.util.List;

/** All request/response shapes for the webinar module. None of them carries the Zoom join URL. */
public final class WebinarDtos {
  private WebinarDtos() {}

  // ---- webinars ----
  public record SaveWebinarRequest(String title, String description, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String status, String accessMode,
      String joinUrl, Integer joinWindowBeforeMin, Integer joinWindowAfterMin) {}

  public record WebinarSummary(Long id, String title, String description, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String status, String accessMode,
      boolean managedByZoom, int joinWindowBeforeMin, int joinWindowAfterMin,
      boolean hasJoinUrl, long seatCount) {}

  public record MemberWebinar(Long id, String title, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, boolean joinOpen) {}

  // ---- family members ----
  public record SaveFamilyMemberRequest(Long hofPersonId, String firstName, String lastName,
      String itsNumber, Long webinarId) {}

  public record FamilyMemberDto(Long id, Long hofPersonId, String firstName, String lastName,
      String itsNumber, boolean active) {}

  public record SetActiveRequest(boolean active) {}

  public record HofDto(Long id, String firstName, String lastName, String itsNumber,
      long familyMemberCount) {}

  // ---- seats ----
  public record GiveSeatRequest(Long personId, Long familyMemberId) {}

  public record FamilySeatRow(Long familyMemberId, String itsNumber, String name, Long seatId) {}

  /** One head of family or member, their own seat (null if none), and their active family members. */
  public record FamilySeats(Long personId, String itsNumber, String name, boolean hof,
      Long ownSeatId, List<FamilySeatRow> family) {}

  /** A search hit: a person (familyMemberId null) or a saved family member. */
  public record AssignableRow(Long personId, Long familyMemberId, String itsNumber, String name,
      String hofName, boolean hof, boolean hasSeat) {}

  public record CopySeatsResult(int added, int skipped) {}

  // ---- links and invites ----
  public record LinkResponse(String link) {}

  public record InviteLink(String label, String url) {}

  public record InviteResult(int sent, List<String> skipped) {}

  public record MagicJoinInfo(String title, String hostName, OffsetDateTime scheduledStart,
      OffsetDateTime scheduledEnd, boolean joinOpen, String attendeeName, String attendeeIts) {}

  // ---- report ----
  public record AttendeeRow(String itsNumber, String name, String type, String hofName, String hofIts,
      boolean joined, OffsetDateTime firstJoinedAt, int launchCount) {}

  public record AttendanceReport(WebinarSummary webinar, int seatCount, int joinedCount,
      List<AttendeeRow> rows) {}

  // ---- zoom sync ----
  public record ZoomSyncRow(String zoomMeetingId, String topic, OffsetDateTime start,
      OffsetDateTime end, boolean alreadyImported) {}

  public record ZoomImportRequest(String kind, String zoomMeetingId, OffsetDateTime start,
      String accessMode) {}
}
