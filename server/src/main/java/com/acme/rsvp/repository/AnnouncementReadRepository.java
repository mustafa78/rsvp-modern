package com.acme.rsvp.repository;

import com.acme.rsvp.model.AnnouncementRead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface AnnouncementReadRepository extends JpaRepository<AnnouncementRead, Long> {

    // Check if a person has read a specific announcement
    Optional<AnnouncementRead> findByAnnouncementIdAndPersonId(Long announcementId, Long personId);

    // Check if a person has read a specific announcement
    boolean existsByAnnouncementIdAndPersonId(Long announcementId, Long personId);

    // Get all announcement IDs that a person has read
    @Query("SELECT ar.announcement.id FROM AnnouncementRead ar WHERE ar.person.id = :personId")
    Set<Long> findReadAnnouncementIdsByPersonId(@Param("personId") Long personId);

    // Count how many people have read a specific announcement
    @Query("SELECT COUNT(ar) FROM AnnouncementRead ar WHERE ar.announcement.id = :announcementId")
    long countByAnnouncementId(@Param("announcementId") Long announcementId);

    // Count unread announcements for a user (active and not expired)
    @Query("""
        SELECT COUNT(a) FROM Announcement a
        WHERE a.active = true
        AND (a.expiresAt IS NULL OR a.expiresAt > :now)
        AND NOT EXISTS (
            SELECT ar FROM AnnouncementRead ar
            WHERE ar.announcement = a AND ar.person.id = :personId
        )
        """)
    long countUnreadByPersonId(@Param("personId") Long personId, @Param("now") OffsetDateTime now);

    // Delete all reads for a specific announcement (when deleting announcement)
    void deleteByAnnouncementId(Long announcementId);

    // Get all reads by a person
    List<AnnouncementRead> findByPersonId(Long personId);
}
