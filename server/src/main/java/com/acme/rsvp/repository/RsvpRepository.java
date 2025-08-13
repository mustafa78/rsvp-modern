package com.acme.rsvp.repository;

import com.acme.rsvp.model.Rsvp;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface RsvpRepository extends JpaRepository<Rsvp, Long> {
  List<Rsvp> findByEventId(Long eventId);
  Optional<Rsvp> findByEventIdAndPersonId(Long eventId, Long personId);
}
