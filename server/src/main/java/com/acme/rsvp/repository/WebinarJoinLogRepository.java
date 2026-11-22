package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarJoinLog;

public interface WebinarJoinLogRepository extends JpaRepository<WebinarJoinLog, Long> {

  @Query("SELECT l FROM WebinarJoinLog l WHERE l.seat.webinar.id = :webinarId ORDER BY l.joinedAt ASC")
  List<WebinarJoinLog> findByWebinarId(@Param("webinarId") Long webinarId);

  boolean existsBySeatId(Long seatId);
}
