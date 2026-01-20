package com.acme.rsvp.service;

import com.acme.rsvp.dto.AnnouncementDtos.*;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Set;

@Service
@Transactional
public class AnnouncementService {

    private final AnnouncementRepository announcementRepository;
    private final AnnouncementReadRepository announcementReadRepository;
    private final PersonRepository personRepository;
    private final EventRepository eventRepository;

    public AnnouncementService(
            AnnouncementRepository announcementRepository,
            AnnouncementReadRepository announcementReadRepository,
            PersonRepository personRepository,
            EventRepository eventRepository) {
        this.announcementRepository = announcementRepository;
        this.announcementReadRepository = announcementReadRepository;
        this.personRepository = personRepository;
        this.eventRepository = eventRepository;
    }

    // Create a manual announcement (admin only)
    public AnnouncementDto createManualAnnouncement(CreateAnnouncementRequest request, Long createdById) {
        Person createdBy = personRepository.findById(createdById)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Announcement announcement = new Announcement();
        announcement.setTitle(request.title());
        announcement.setContent(request.content());
        announcement.setType(AnnouncementType.MANUAL);
        announcement.setCreatedBy(createdBy);
        // Convert LocalDateTime to OffsetDateTime using system default timezone
        if (request.expiresAt() != null) {
            announcement.setExpiresAt(request.expiresAt().atZone(ZoneId.systemDefault()).toOffsetDateTime());
        }
        announcement.setCreatedAt(OffsetDateTime.now());
        announcement.setActive(true);

        announcement = announcementRepository.save(announcement);
        return toDto(announcement, false);
    }

    // Create an event update announcement (called automatically when events change)
    public AnnouncementDto createEventUpdateAnnouncement(Long eventId, String title, String content, Long createdById) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found"));
        Person createdBy = createdById != null ? personRepository.findById(createdById).orElse(null) : null;

        Announcement announcement = new Announcement();
        announcement.setTitle(title);
        announcement.setContent(content);
        announcement.setType(AnnouncementType.EVENT_UPDATE);
        announcement.setEvent(event);
        announcement.setCreatedBy(createdBy);
        announcement.setCreatedAt(OffsetDateTime.now());
        announcement.setActive(true);

        // Update event's last significant update timestamp
        event.setLastSignificantUpdateAt(OffsetDateTime.now());
        eventRepository.save(event);

        announcement = announcementRepository.save(announcement);
        return toDto(announcement, false);
    }

    // Get all announcements for a user (with read status)
    @Transactional(readOnly = true)
    public List<AnnouncementDto> getAnnouncementsForUser(Long personId) {
        OffsetDateTime now = OffsetDateTime.now();
        List<Announcement> announcements = announcementRepository.findActiveAnnouncements(now);
        Set<Long> readIds = announcementReadRepository.findReadAnnouncementIdsByPersonId(personId);

        return announcements.stream()
                .map(a -> toDto(a, readIds.contains(a.getId())))
                .toList();
    }

    // Get unread count for a user
    @Transactional(readOnly = true)
    public long getUnreadCount(Long personId) {
        return announcementReadRepository.countUnreadByPersonId(personId, OffsetDateTime.now());
    }

    // Mark a single announcement as read
    public void markAsRead(Long announcementId, Long personId) {
        if (announcementReadRepository.existsByAnnouncementIdAndPersonId(announcementId, personId)) {
            return; // Already read
        }

        Announcement announcement = announcementRepository.findById(announcementId)
                .orElseThrow(() -> new IllegalArgumentException("Announcement not found"));
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        AnnouncementRead read = new AnnouncementRead(announcement, person);
        announcementReadRepository.save(read);
    }

    // Mark all announcements as read for a user
    public void markAllAsRead(Long personId) {
        OffsetDateTime now = OffsetDateTime.now();
        List<Announcement> announcements = announcementRepository.findActiveAnnouncements(now);
        Set<Long> readIds = announcementReadRepository.findReadAnnouncementIdsByPersonId(personId);
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        for (Announcement announcement : announcements) {
            if (!readIds.contains(announcement.getId())) {
                AnnouncementRead read = new AnnouncementRead(announcement, person);
                announcementReadRepository.save(read);
            }
        }
    }

    // Admin: Get all announcements with read stats
    @Transactional(readOnly = true)
    public List<AdminAnnouncementDto> getAllAnnouncementsForAdmin() {
        List<Announcement> announcements = announcementRepository.findAllOrderByCreatedAtDesc();
        return announcements.stream()
                .map(this::toAdminDto)
                .toList();
    }

    // Admin: Delete an announcement
    public void deleteAnnouncement(Long id) {
        announcementRepository.deleteById(id);
    }

    // Admin: Toggle active status
    public AdminAnnouncementDto toggleActive(Long id) {
        Announcement announcement = announcementRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Announcement not found"));
        announcement.setActive(!announcement.isActive());
        announcement = announcementRepository.save(announcement);
        return toAdminDto(announcement);
    }

    // Convert to user DTO
    private AnnouncementDto toDto(Announcement a, boolean isRead) {
        return new AnnouncementDto(
                a.getId(),
                a.getTitle(),
                a.getContent(),
                a.getType(),
                a.getEvent() != null ? a.getEvent().getId() : null,
                a.getEvent() != null ? a.getEvent().getTitle() : null,
                a.getCreatedBy() != null ? a.getCreatedBy().getFirstName() + " " + a.getCreatedBy().getLastName() : null,
                a.getCreatedAt(),
                a.getExpiresAt(),
                a.isActive(),
                isRead
        );
    }

    // Convert to admin DTO with read count
    private AdminAnnouncementDto toAdminDto(Announcement a) {
        long readCount = announcementReadRepository.countByAnnouncementId(a.getId());
        return new AdminAnnouncementDto(
                a.getId(),
                a.getTitle(),
                a.getContent(),
                a.getType(),
                a.getEvent() != null ? a.getEvent().getId() : null,
                a.getEvent() != null ? a.getEvent().getTitle() : null,
                a.getCreatedBy() != null ? a.getCreatedBy().getFirstName() + " " + a.getCreatedBy().getLastName() : null,
                a.getCreatedAt(),
                a.getExpiresAt(),
                a.isActive(),
                readCount
        );
    }
}
