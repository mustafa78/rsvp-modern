package com.acme.rsvp.repository;

import com.acme.rsvp.model.Event;
import com.acme.rsvp.model.EventStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long> {
  List<Event> findByEventDateOrderByStartTimeAsc(LocalDate date);
  List<Event> findByStatusOrderByEventDateAscStartTimeAsc(EventStatus status);
}