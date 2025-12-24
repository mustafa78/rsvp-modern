package com.acme.rsvp.repository;

import java.util.Optional;

import com.acme.rsvp.model.NiyazRsvp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NiyazRsvpRepository extends JpaRepository<NiyazRsvp, Long> {

  boolean existsByEventIdAndPersonId(Long eventId, Long personId);

  @Query("SELECT r FROM NiyazRsvp r WHERE r.event.id = :eventId AND r.person.id = :personId")
  Optional<NiyazRsvp> findByEventIdAndPersonId(@Param("eventId") Long eventId, @Param("personId") Long personId);

  @Query("""
    select coalesce(sum(n.adults),0) from NiyazRsvp n
    where n.event.id = :eventId
  """)
  long totalAdults(Long eventId);

  @Query("""
    select coalesce(sum(n.kids),0) from NiyazRsvp n
    where n.event.id = :eventId
  """)
  long totalKids(Long eventId);
}