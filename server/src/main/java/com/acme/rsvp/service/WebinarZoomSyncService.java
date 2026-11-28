package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.dto.WebinarDtos.ZoomImportRequest;
import com.acme.rsvp.dto.WebinarDtos.ZoomSyncRow;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.zoom.ZoomClient;
import com.acme.rsvp.zoom.ZoomMeeting;
import com.acme.rsvp.zoom.ZoomProperties;

@Service
public class WebinarZoomSyncService {

  private final ZoomClient zoom;
  private final ZoomProperties zoomProps;
  private final WebinarProperties webinarProps;
  private final WebinarRepository webinars;
  private final WebinarService webinarService;

  public WebinarZoomSyncService(ZoomClient zoom, ZoomProperties zoomProps, WebinarProperties webinarProps,
      WebinarRepository webinars, WebinarService webinarService) {
    this.zoom = zoom;
    this.zoomProps = zoomProps;
    this.webinarProps = webinarProps;
    this.webinars = webinars;
    this.webinarService = webinarService;
  }

  /** What is scheduled on Zoom, without join URLs, flagged if already imported. */
  @Transactional(readOnly = true)
  public List<ZoomSyncRow> preview(String kind) {
    requireKnownKind(kind);
    return zoom.listScheduled(kind, OffsetDateTime.now()).stream()
        .map(m -> new ZoomSyncRow(m.id(), m.topic(), m.start(), m.end(),
            webinars.findByZoomMeetingIdAndScheduledStart(m.id(), m.start()).isPresent()))
        .toList();
  }

  /**
   * Imports one previewed session. The join URL is re-read from Zoom here, so it never passes
   * through the browser. Importing the same session again updates the existing webinar.
   */
  @Transactional
  public WebinarSummary importOne(ZoomImportRequest req) {
    if (req.zoomMeetingId() == null || req.start() == null) {
      throw new IllegalArgumentException("Zoom session id and start time are required");
    }
    requireKnownKind(req.kind());
    WebinarAccessMode accessMode = req.accessMode() != null && !req.accessMode().isBlank()
        ? WebinarAccessMode.parse(req.accessMode()) : null;
    ZoomMeeting m = zoom.listScheduled(req.kind(), OffsetDateTime.now()).stream()
        .filter(x -> x.id().equals(req.zoomMeetingId()) && x.start().isEqual(req.start()))
        .findFirst()
        .orElseThrow(() -> new IllegalStateException(
            "That Zoom session was not found. Refresh the list and try again."));

    Webinar w = webinars.findByZoomMeetingIdAndScheduledStart(m.id(), m.start()).orElseGet(() -> {
      Webinar created = new Webinar();
      created.setZoomMeetingId(m.id());
      created.setHostName(zoomProps.defaultHostName());
      created.setJoinWindowBeforeMin(webinarProps.joinWindowBeforeMinutes());
      created.setJoinWindowAfterMin(webinarProps.joinWindowAfterMinutes());
      return created;
    });
    String topic = m.topic() == null || m.topic().isBlank() ? "Zoom session" : m.topic().trim();
    w.setTitle(topic.length() > 200 ? topic.substring(0, 200) : topic);
    w.setScheduledStart(m.start());
    w.setScheduledEnd(m.end());
    w.setJoinUrl(m.joinUrl());
    w.setManagedByZoom(true);
    if (accessMode != null) w.setAccessMode(accessMode);
    return webinarService.toSummary(webinars.save(w));
  }

  /** Only the two Zoom list types are accepted, so no other value reaches the Zoom client or its log. */
  private static void requireKnownKind(String kind) {
    if (!"meetings".equals(kind) && !"webinars".equals(kind)) {
      throw new IllegalArgumentException("Unknown Zoom list type");
    }
  }
}
