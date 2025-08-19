package com.acme.rsvp.service;

import com.acme.rsvp.dto.EventDtos.*;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class EventService {

  private final EventRepository eventRepo;
  private final NiyazEventRepository niyazRepo;
  private final ThaaliEventRepository thaaliRepo;
  private final PersonRepository personRepo;
  private final MenuItemRepository menuRepo;
  private final DishRepository dishRepo;

  public EventService(EventRepository eventRepo,
                      NiyazEventRepository niyazRepo,
                      ThaaliEventRepository thaaliRepo,
                      PersonRepository personRepo,
                      MenuItemRepository menuRepo,
                      DishRepository dishRepo) {
    this.eventRepo = eventRepo;
    this.niyazRepo = niyazRepo;
    this.thaaliRepo = thaaliRepo;
    this.personRepo = personRepo;
    this.menuRepo = menuRepo;
    this.dishRepo = dishRepo;
  }

  /* ======================= Queries ======================= */

  @Transactional(readOnly = true)
  public List<EventSummaryDto> listAll() {
    return eventRepo.findAll().stream().map(EventService::toSummary).toList();
  }

  @Transactional(readOnly = true)
  public EventSummaryDto getSummary(Long id) {
    return eventRepo.findById(id).map(EventService::toSummary).orElseThrow();
  }

  /* ======================= Commands ======================= */

  @Transactional
  public NiyazEventDto createNiyaz(CreateUpdateNiyazEventRequest req) {
    NiyazEvent e = new NiyazEvent();
    applyBase(e, req);
    e.setMiqaatName(req.miqaatName);
    e.setMiqaatDate(req.miqaatDate);
    e.setMiqaatTime(req.miqaatTime);
    attachChefs(e, req.chefIds);
    niyazRepo.save(e);
    return toDto(e);
  }

  @Transactional
  public NiyazEventDto updateNiyaz(Long id, CreateUpdateNiyazEventRequest req) {
    NiyazEvent e = niyazRepo.findById(id).orElseThrow();
    applyBase(e, req);
    e.setMiqaatName(req.miqaatName);
    e.setMiqaatDate(req.miqaatDate);
    e.setMiqaatTime(req.miqaatTime);
    attachChefs(e, req.chefIds);
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
    applyBase(e, req);
    attachChefs(e, req.chefIds);
    upsertMenu(e.getId(), req.menu);
    return toDto(e);
  }

  @Transactional
  public void setStatus(Long eventId, EventStatus status) {
    Event e = eventRepo.findById(eventId).orElseThrow();
    e.setStatus(status);
  }

  /* ======================= Internals ======================= */

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
    Set<Person> newChefs = new HashSet<>();
    if (chefIds != null) {
      for (Long pid : chefIds) {
        Person p = personRepo.findById(pid).orElseThrow();
        newChefs.add(p);
      }
    }
    e.setChefs(newChefs);
  }

  private void upsertMenu(Long eventId, List<MenuAssignmentDto> items) {
    var existing = menuRepo.findByEvent_IdOrderByPositionAsc(eventId);
    if (!existing.isEmpty()) {
      menuRepo.deleteAll(existing);
    }
    if (items == null || items.isEmpty()) return;

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
      // If null, callers/readers should fall back to dish.defaultQuartsPerThaaliUnit
      mi.setQuartsPerThaaliUnit(dto.quartsPerThaaliUnit());
      menuRepo.save(mi);
    }
  }

  private static EventSummaryDto toSummary(Event e) {
    String type = (e instanceof NiyazEvent) ? "NIYAZ" : (e instanceof ThaaliEvent) ? "THAALI" : "EVENT";
    return new EventSummaryDto(
        e.getId(), type, e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus()
    );
  }

  private ThaaliEventDto toDto(ThaaliEvent e) {
    // Always fetch menu from repository for consistency
    var items = menuRepo.findByEvent_IdOrderByPositionAsc(e.getId());
    var menu = items.stream().map(mi -> {
      Dish d = mi.getDish();
      BigDecimal q = (mi.getQuartsPerThaaliUnit() != null)
          ? mi.getQuartsPerThaaliUnit()
          : (d != null ? d.getDefaultQuartsPerThaaliUnit() : BigDecimal.ONE);

      var lines =
          (d == null || d.getIngredients() == null) ? java.util.List.<MenuItemIngredientDto>of() :
              d.getIngredients().stream().map(di ->
                  new MenuItemIngredientDto(
                      di.getIngredient().getId(),
                      di.getIngredient().getName(),
                      di.getIngredient().getUnit(),
                      di.getQtyPerQuart()
                  )
              ).toList();

      Long dishId = (d != null ? d.getId() : null);
      String name = (d != null ? d.getName() : null);
      String desc = (d != null ? d.getDescription() : null);

      return new MenuItemDto(mi.getId(), name, desc, q, lines, dishId, mi.getPosition());
    }).toList();

    var chefIds = e.getChefs().stream().map(Person::getId).collect(Collectors.toSet());

    return new ThaaliEventDto(
        e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(), menu, chefIds
    );
  }

  private static NiyazEventDto toDto(NiyazEvent e) {
    var chefIds = e.getChefs().stream().map(Person::getId).collect(Collectors.toSet());
    return new NiyazEventDto(
        e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(),
        e.getMiqaatName(), e.getMiqaatDate(), e.getMiqaatTime(), chefIds
    );
  }
}
