package com.acme.rsvp.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.EventDtos.BaseEventReq;
import com.acme.rsvp.dto.EventDtos.ChefSummaryDto;
import com.acme.rsvp.dto.EventDtos.CreateUpdateNiyazEventRequest;
import com.acme.rsvp.dto.EventDtos.CreateUpdateThaaliEventRequest;
import com.acme.rsvp.dto.EventDtos.EventSummaryDto;
import com.acme.rsvp.dto.EventDtos.HostDto;
import com.acme.rsvp.dto.EventDtos.MenuAssignmentDto;
import com.acme.rsvp.dto.EventDtos.MenuItemDto;
import com.acme.rsvp.dto.EventDtos.MenuItemIngredientDto;
import com.acme.rsvp.dto.EventDtos.NiyazEventDto;
import com.acme.rsvp.dto.EventDtos.ThaaliEventDto;
import com.acme.rsvp.model.Chef;
import com.acme.rsvp.model.Dish;
import com.acme.rsvp.model.Event;
import com.acme.rsvp.model.EventStatus;
import com.acme.rsvp.model.MenuItem;
import com.acme.rsvp.model.NiyazEvent;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.ThaaliEvent;
import com.acme.rsvp.repository.ChefRepository;
import com.acme.rsvp.repository.DishRepository;
import com.acme.rsvp.repository.EventRepository;
import com.acme.rsvp.repository.MenuItemRepository;
import com.acme.rsvp.repository.NiyazEventRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.ThaaliEventRepository;

@Service
public class EventService {

    private final EventRepository eventRepo;
    private final NiyazEventRepository niyazRepo;
    private final ThaaliEventRepository thaaliRepo;
    private final ChefRepository chefRepo;
    private final MenuItemRepository menuRepo;
    private final DishRepository dishRepo;
    private final PersonRepository personRepo;
    private final AnnouncementService announcementService;

    public EventService(EventRepository eventRepo,
            NiyazEventRepository niyazRepo,
            ThaaliEventRepository thaaliRepo,
            ChefRepository chefRepo,
            MenuItemRepository menuRepo,
            DishRepository dishRepo,
            PersonRepository personRepo,
            AnnouncementService announcementService) {
        this.eventRepo = eventRepo;
        this.niyazRepo = niyazRepo;
        this.thaaliRepo = thaaliRepo;
        this.chefRepo = chefRepo;
        this.menuRepo = menuRepo;
        this.dishRepo = dishRepo;
        this.personRepo = personRepo;
        this.announcementService = announcementService;
    }

    /* ======================= Queries ======================= */

    @Transactional(readOnly = true)
    public List<EventSummaryDto> listAll() {
        return eventRepo.findAll().stream().map(EventService::toSummary).toList();
    }

    @Transactional(readOnly = true)
    public List<EventSummaryDto> listPublished() {
        return eventRepo.findByStatus(EventStatus.PUBLISHED).stream()
                .map(EventService::toSummary)
                .toList();
    }

    @Transactional(readOnly = true)
    public EventSummaryDto getSummary(Long id) {
        return eventRepo.findById(id).map(EventService::toSummary).orElseThrow();
    }

    @Transactional(readOnly = true)
    public NiyazEventDto getNiyazEvent(Long id) {
        return niyazRepo.findById(id).map(this::toDto).orElseThrow();
    }

    @Transactional(readOnly = true)
    public ThaaliEventDto getThaaliEvent(Long id) {
        return thaaliRepo.findByIdWithChefs(id).map(this::toDto).orElseThrow();
    }

    /* ======================= Commands ======================= */

    @Transactional
    public NiyazEventDto createNiyaz(CreateUpdateNiyazEventRequest req) {
        NiyazEvent e = new NiyazEvent();
        applyBase(e, req);
        e.setMiqaatName(req.miqaatName);
        // Auto-populate title from miqaatName for Niyaz events
        e.setTitle(req.miqaatName);
        e.setShowRsvpSummary(req.showRsvpSummary != null && req.showRsvpSummary);
        attachHosts(e, req.hostIds);
        niyazRepo.save(e);
        return toDto(e);
    }

    @Transactional
    public NiyazEventDto updateNiyaz(Long id, CreateUpdateNiyazEventRequest req) {
        NiyazEvent e = niyazRepo.findById(id).orElseThrow();

        // Capture old values for change detection (only if published)
        boolean wasPublished = e.getStatus() == EventStatus.PUBLISHED;
        LocalDate oldDate = e.getEventDate();
        LocalTime oldTime = e.getStartTime();
        OffsetDateTime oldRegClose = e.getRegistrationCloseAt();

        applyBase(e, req);
        e.setMiqaatName(req.miqaatName);
        // Auto-populate title from miqaatName for Niyaz events
        e.setTitle(req.miqaatName);
        e.setShowRsvpSummary(req.showRsvpSummary != null && req.showRsvpSummary);
        attachHosts(e, req.hostIds);

        // Create announcements for significant changes on published events
        if (wasPublished && e.getStatus() == EventStatus.PUBLISHED) {
            createChangeAnnouncements(e, oldDate, oldTime, oldRegClose, req.eventDate, req.startTime, req.registrationCloseAt);
        }

        return toDto(e);
    }

    @Transactional
    public ThaaliEventDto createThaali(CreateUpdateThaaliEventRequest req) {
        ThaaliEvent e = new ThaaliEvent();
        applyBase(e, req);
        attachChefs(e, req.chefIds);
        thaaliRepo.save(e);
        upsertMenu(e.getId(), req.menu);
        return toDto(e);
    }

    @Transactional
    public ThaaliEventDto updateThaali(Long id, CreateUpdateThaaliEventRequest req) {
        ThaaliEvent e = thaaliRepo.findById(id).orElseThrow();

        // Capture old values for change detection (only if published)
        boolean wasPublished = e.getStatus() == EventStatus.PUBLISHED;
        LocalDate oldDate = e.getEventDate();
        LocalTime oldTime = e.getStartTime();
        OffsetDateTime oldRegClose = e.getRegistrationCloseAt();

        // Capture old menu for comparison
        Set<Long> oldDishIds = wasPublished
                ? menuRepo.findByEvent_IdOrderByPositionAsc(id).stream()
                        .map(mi -> mi.getDish().getId())
                        .collect(Collectors.toSet())
                : Set.of();

        applyBase(e, req);
        attachChefs(e, req.chefIds);
        upsertMenu(e.getId(), req.menu);

        // Create announcements for significant changes on published events
        if (wasPublished && e.getStatus() == EventStatus.PUBLISHED) {
            createChangeAnnouncements(e, oldDate, oldTime, oldRegClose, req.eventDate, req.startTime, req.registrationCloseAt);

            // Check for menu changes
            Set<Long> newDishIds = req.menu != null
                    ? req.menu.stream().map(MenuAssignmentDto::dishId).collect(Collectors.toSet())
                    : Set.of();

            if (!oldDishIds.equals(newDishIds)) {
                announcementService.createEventUpdateAnnouncement(
                        e.getId(),
                        "Menu Updated",
                        "The menu for " + e.getTitle() + " has been updated.",
                        null);
            }
        }

        return toDto(e);
    }

    @Transactional
    public void setStatus(Long eventId, EventStatus status) {
        Event e = eventRepo.findById(eventId).orElseThrow();
        EventStatus oldStatus = e.getStatus();
        e.setStatus(status);

        // Create announcement when a published event is cancelled
        if (oldStatus == EventStatus.PUBLISHED && status == EventStatus.CANCELLED) {
            announcementService.createEventUpdateAnnouncement(
                    eventId,
                    "Event Cancelled",
                    e.getTitle() + " has been cancelled.",
                    null);
        }
    }

    /* ======================= Internals ======================= */

    /**
     * Create announcements for significant changes to published events.
     */
    private void createChangeAnnouncements(Event e, LocalDate oldDate, LocalTime oldTime,
            OffsetDateTime oldRegClose, LocalDate newDate, LocalTime newTime, OffsetDateTime newRegClose) {

        // Date changed
        if (!Objects.equals(oldDate, newDate)) {
            String oldDateStr = oldDate != null ? oldDate.toString() : "TBD";
            String newDateStr = newDate != null ? newDate.toString() : "TBD";
            announcementService.createEventUpdateAnnouncement(
                    e.getId(),
                    "Date Changed",
                    e.getTitle() + " has been moved from " + oldDateStr + " to " + newDateStr + ".",
                    null);
        }

        // Time changed
        if (!Objects.equals(oldTime, newTime)) {
            String oldTimeStr = oldTime != null ? oldTime.toString() : "TBD";
            String newTimeStr = newTime != null ? newTime.toString() : "TBD";
            announcementService.createEventUpdateAnnouncement(
                    e.getId(),
                    "Time Changed",
                    "The time for " + e.getTitle() + " has been changed from " + oldTimeStr + " to " + newTimeStr + ".",
                    null);
        }

        // Registration deadline changed
        if (!Objects.equals(oldRegClose, newRegClose)) {
            announcementService.createEventUpdateAnnouncement(
                    e.getId(),
                    "Registration Deadline Updated",
                    "The registration deadline for " + e.getTitle() + " has been updated.",
                    null);
        }
    }

    private static void applyBase(Event e, BaseEventReq req) {
        e.setTitle(req.title);
        e.setDescription(req.description);
        e.setEventDate(req.eventDate);
        e.setStartTime(req.startTime);
        e.setRegistrationOpenAt(req.registrationOpenAt);
        e.setRegistrationCloseAt(req.registrationCloseAt);
        e.setStatus(req.status);
    }

    private void attachChefs(Event e, Set<Long> chefIds) {
        if (chefIds == null)
            chefIds = Set.of();
        Set<Chef> chefs = chefIds.stream()
                .map(id -> chefRepo.findById(id).orElseThrow())
                .collect(Collectors.toSet());
        e.setChefs(chefs);
    }

    private void attachHosts(NiyazEvent e, Set<Long> hostIds) {
        if (hostIds == null || hostIds.isEmpty()) {
            e.setHosts(new HashSet<>());
            return;
        }
        Set<Person> hosts = hostIds.stream()
                .map(id -> personRepo.findById(id)
                        .orElseThrow(() -> new IllegalArgumentException("Host not found: " + id)))
                .collect(Collectors.toSet());
        e.setHosts(hosts);
    }

    private void upsertMenu(Long eventId, List<MenuAssignmentDto> items) {
        var existing = menuRepo.findByEvent_IdOrderByPositionAsc(eventId);
        if (!existing.isEmpty()) {
            menuRepo.deleteAll(existing);
            menuRepo.flush();  // Ensure deletes are executed before inserts (unique constraint)
        }
        if (items == null || items.isEmpty())
            return;

        Event e = eventRepo.findById(eventId).orElseThrow();

        for (MenuAssignmentDto dto : items) {
            if (dto.dishId() == null) {
                throw new IllegalArgumentException("dishId is required for menu assignment");
            }
            Dish d = dishRepo.findById(dto.dishId()).orElseThrow();
            MenuItem mi = new MenuItem();
            mi.setEvent(e);
            mi.setDish(d);
            mi.setPosition(dto.position());
            // Use DTO value if provided, otherwise fall back to dish's default
            BigDecimal quartsValue = dto.quartsPerThaaliUnit() != null
                    ? dto.quartsPerThaaliUnit()
                    : d.getDefaultQuartsPerThaaliUnit();
            mi.setQuartsPerThaaliUnit(quartsValue);
            menuRepo.save(mi);
        }
    }

    private static EventSummaryDto toSummary(Event e) {
        String type = (e instanceof NiyazEvent) ? "NIYAZ" : (e instanceof ThaaliEvent) ? "THAALI" : "EVENT";

        // Include Niyaz-specific fields if applicable
        String miqaatName = null;
        Boolean showRsvpSummary = null;
        if (e instanceof NiyazEvent niyaz) {
            miqaatName = niyaz.getMiqaatName();
            showRsvpSummary = niyaz.isShowRsvpSummary();
        }

        return new EventSummaryDto(
                e.getId(), type, e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
                e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(),
                miqaatName, showRsvpSummary);
    }

    private ThaaliEventDto toDto(ThaaliEvent e) {
        // Always fetch menu from repository for consistency
        var items = menuRepo.findByEvent_IdOrderByPositionAsc(e.getId());
        var menu = items.stream().map(mi -> {
            Dish d = mi.getDish();
            BigDecimal q = (mi.getQuartsPerThaaliUnit() != null)
                    ? mi.getQuartsPerThaaliUnit()
                    : (d != null ? d.getDefaultQuartsPerThaaliUnit() : BigDecimal.ONE);

            var lines = (d == null || d.getIngredients() == null) ? java.util.List.<MenuItemIngredientDto>of()
                    : d.getIngredients().stream().map(di -> new MenuItemIngredientDto(
                            di.getIngredient().getId(),
                            di.getIngredient().getName(),
                            di.getIngredient().getUnit().getName(),
                            di.getQtyPerQuart())).toList();

            Long dishId = (d != null ? d.getId() : null);
            String name = (d != null ? d.getName() : null);
            String desc = (d != null ? d.getDescription() : null);

            return new MenuItemDto(mi.getId(), name, desc, q, lines, dishId, mi.getPosition());
        }).toList();

        var chefIds = e.getChefs().stream().map(Chef::getId).collect(Collectors.toSet());

        List<ChefSummaryDto> chefs = e.getChefs().stream()
                .map(c -> new ChefSummaryDto(c.getId(), c.getName(), c.getType().name()))
                .toList();

        return new ThaaliEventDto(
                e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
                e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(), menu, chefIds, chefs);
    }

    private NiyazEventDto toDto(NiyazEvent e) {
        Set<Long> chefIds = e.getChefs().stream().map(Chef::getId).collect(Collectors.toSet());
        Set<Long> hostIds = e.getHosts().stream().map(Person::getId).collect(Collectors.toSet());

        List<HostDto> hosts = e.getHosts().stream()
                .map(p -> new HostDto(
                        p.getId(),
                        p.getFirstName(),
                        p.getLastName(),
                        p.getFirstName() + " " + p.getLastName()))
                .toList();

        return new NiyazEventDto(
                e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
                e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(),
                e.getMiqaatName(), e.isShowRsvpSummary(), chefIds, hostIds, hosts);
    }

}
