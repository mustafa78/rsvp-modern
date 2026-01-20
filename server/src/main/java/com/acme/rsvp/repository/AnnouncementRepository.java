package com.acme.rsvp.repository;

import com.acme.rsvp.model.Announcement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.OffsetDateTime;
import java.util.List;

public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {

    // Find all active announcements that haven't expired, ordered by newest first
    @Query("""
        SELECT a FROM Announcement a
        WHERE a.active = true
        AND (a.expiresAt IS NULL OR a.expiresAt > :now)
        ORDER BY a.createdAt DESC
        """)
    List<Announcement> findActiveAnnouncements(@Param("now") OffsetDateTime now);

    // Find all announcements for admin view, ordered by newest first
    @Query("SELECT a FROM Announcement a ORDER BY a.createdAt DESC")
    List<Announcement> findAllOrderByCreatedAtDesc();

    // Find announcements related to a specific event
    @Query("SELECT a FROM Announcement a WHERE a.event.id = :eventId ORDER BY a.createdAt DESC")
    List<Announcement> findByEventId(@Param("eventId") Long eventId);

    // Count active announcements (for admin stats)
    @Query("""
        SELECT COUNT(a) FROM Announcement a
        WHERE a.active = true
        AND (a.expiresAt IS NULL OR a.expiresAt > :now)
        """)
    long countActiveAnnouncements(@Param("now") OffsetDateTime now);
}
