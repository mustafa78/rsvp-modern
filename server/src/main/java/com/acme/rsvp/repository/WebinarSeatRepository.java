package com.acme.rsvp.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarSeat;

public interface WebinarSeatRepository extends JpaRepository<WebinarSeat, Long> {

  @Query("""
      SELECT s FROM WebinarSeat s
      JOIN FETCH s.person
      LEFT JOIN FETCH s.familyMember
      WHERE s.webinar.id = :webinarId
      """)
  List<WebinarSeat> findByWebinarIdWithAttendees(@Param("webinarId") Long webinarId);

  Optional<WebinarSeat> findByWebinarIdAndPersonIdAndFamilyMemberIsNull(Long webinarId, Long personId);
  Optional<WebinarSeat> findByWebinarIdAndFamilyMemberId(Long webinarId, Long familyMemberId);
  long countByWebinarId(Long webinarId);
}
