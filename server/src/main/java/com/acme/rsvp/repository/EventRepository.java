package com.acme.rsvp.repository;
import com.acme.rsvp.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
public interface EventRepository extends JpaRepository<Event, Long> {}
