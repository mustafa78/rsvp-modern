package com.acme.rsvp.repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarStatus;

public interface WebinarRepository extends JpaRepository<Webinar, Long> {
  List<Webinar> findAllByOrderByScheduledStartDesc();
  List<Webinar> findByStatusOrderByScheduledStartAsc(WebinarStatus status);
  Optional<Webinar> findByZoomMeetingIdAndScheduledStart(String zoomMeetingId, OffsetDateTime scheduledStart);
}
