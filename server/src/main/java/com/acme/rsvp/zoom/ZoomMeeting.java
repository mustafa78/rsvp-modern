package com.acme.rsvp.zoom;

import java.time.OffsetDateTime;

/** A scheduled Zoom meeting or webinar occurrence. joinUrl stays on the server. */
public record ZoomMeeting(String id, String topic, OffsetDateTime start, OffsetDateTime end, String joinUrl) {}
