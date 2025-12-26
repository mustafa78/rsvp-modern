package com.acme.rsvp.repository;

import java.util.List;

import com.acme.rsvp.model.Event;
import com.acme.rsvp.model.EventStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EventRepository extends JpaRepository<Event, Long> {
    List<Event> findByStatus(EventStatus status);
}
