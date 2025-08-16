package com.acme.rsvp.service;

import com.acme.rsvp.dto.EventDtos.*;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class EventService {
  private final EventRepository eventRepo;
  private final NiyazEventRepository niyazRepo;
  private final ThaaliEventRepository thaaliRepo;
  private final PersonRepository personRepo;
  private final MenuItemRepository menuRepo;
  private final IngredientRepository ingRepo;
  private final MenuItemIngredientRepository mixRepo;

  public EventService(EventRepository eventRepo, NiyazEventRepository niyazRepo, ThaaliEventRepository thaaliRepo,
                      PersonRepository personRepo, MenuItemRepository menuRepo, IngredientRepository ingRepo,
                      MenuItemIngredientRepository mixRepo) {
    this.eventRepo = eventRepo; this.niyazRepo = niyazRepo; this.thaaliRepo = thaaliRepo;
    this.personRepo = personRepo; this.menuRepo = menuRepo; this.ingRepo = ingRepo; this.mixRepo = mixRepo;
  }

  @Transactional(readOnly = true)
  public List<EventSummaryDto> listAll() { return eventRepo.findAll().stream().map(EventService::toSummary).toList(); }

  @Transactional(readOnly = true)
  public EventSummaryDto getSummary(Long id) { return eventRepo.findById(id).map(EventService::toSummary).orElseThrow(); }

  @Transactional
  public NiyazEventDto createNiyaz(CreateUpdateNiyazEventRequest req) {
    NiyazEvent e = new NiyazEvent(); applyBase(e, req);
    e.setMiqaatName(req.miqaatName); e.setMiqaatDate(req.miqaatDate); e.setMiqaatTime(req.miqaatTime);
    niyazRepo.save(e); attachChefs(e, req.chefIds); return toDto(e);
  }

  @Transactional
  public NiyazEventDto updateNiyaz(Long id, CreateUpdateNiyazEventRequest req) {
    NiyazEvent e = niyazRepo.findById(id).orElseThrow(); applyBase(e, req);
    e.setMiqaatName(req.miqaatName); e.setMiqaatDate(req.miqaatDate); e.setMiqaatTime(req.miqaatTime);
    attachChefs(e, req.chefIds); return toDto(e);
  }

  @Transactional
  public ThaaliEventDto createThaali(CreateUpdateThaaliEventRequest req) {
    ThaaliEvent e = new ThaaliEvent(); applyBase(e, req); thaaliRepo.save(e);
    attachChefs(e, req.chefIds); upsertMenu(e, req.menu); return toDto(e);
  }

  @Transactional
  public ThaaliEventDto updateThaali(Long id, CreateUpdateThaaliEventRequest req) {
    ThaaliEvent e = thaaliRepo.findById(id).orElseThrow(); applyBase(e, req);
    attachChefs(e, req.chefIds); upsertMenu(e, req.menu); return toDto(e);
  }

  @Transactional
  public void setStatus(Long eventId, EventStatus status) {
    Event e = eventRepo.findById(eventId).orElseThrow(); e.setStatus(status);
  }

  private static void applyBase(Event e, BaseEventReq req) {
    e.setTitle(req.title); e.setDescription(req.description); e.setEventDate(req.eventDate);
    e.setStartTime(req.startTime); e.setRegistrationOpenAt(req.registrationOpenAt);
    e.setRegistrationCloseAt(req.registrationCloseAt); e.setStatus(req.status);
  }

  private void attachChefs(Event e, java.util.Set<Long> chefIds) {
    if (chefIds == null) chefIds = java.util.Set.of();
    java.util.Set<Person> chefs = chefIds.stream().map(id -> personRepo.findById(id).orElseThrow()).collect(java.util.stream.Collectors.toSet());
    e.setChefs(chefs);
  }

  private void upsertMenu(ThaaliEvent e, java.util.List<MenuItemDto> items) {
    for (var mi : new java.util.ArrayList<>(e.getMenu())) menuRepo.delete(mi);
    e.getMenu().clear();
    if (items == null) return;
    for (MenuItemDto dto : items) {
      var mi = new com.acme.rsvp.model.MenuItem();
      mi.setEvent(e); mi.setName(dto.name()); mi.setDescription(dto.description());
      mi.setQuartsPerThaaliUnit(dto.quartsPerThaaliUnit()==null? java.math.BigDecimal.ONE : dto.quartsPerThaaliUnit());
      menuRepo.save(mi);
      if (dto.ingredients()!=null) {
        for (MenuItemIngredientDto ing : dto.ingredients()) {
          var ingredient = (ing.ingredientId()!=null)
              ? ingRepo.findById(ing.ingredientId()).orElse(null)
              : ingRepo.findByNameIgnoreCase(ing.ingredientName()).orElse(null);
          if (ingredient==null) {
            ingredient = new com.acme.rsvp.model.Ingredient();
            ingredient.setName(ing.ingredientName()); ingredient.setUnit(ing.unit()==null? "g": ing.unit());
            ingredient = ingRepo.save(ingredient);
          }
          var link = new com.acme.rsvp.model.MenuItemIngredient();
          link.setId(new com.acme.rsvp.model.MenuItemIngredientId(mi.getId(), ingredient.getId()));
          link.setMenuItem(mi); link.setIngredient(ingredient); link.setQuantityPerQuart(ing.qtyPerQuart());
          mixRepo.save(link);
        }
      }
      e.getMenu().add(mi);
    }
  }

  private static EventSummaryDto toSummary(Event e) {
    String type = (e instanceof NiyazEvent) ? "NIYAZ" : (e instanceof ThaaliEvent) ? "THAALI" : "EVENT";
    return new EventSummaryDto(e.getId(), type, e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus());
  }

  private static NiyazEventDto toDto(NiyazEvent e) {
    java.util.Set<Long> chefIds = e.getChefs().stream().map(Person::getId).collect(java.util.stream.Collectors.toSet());
    return new NiyazEventDto(e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(),
        e.getMiqaatName(), e.getMiqaatDate(), e.getMiqaatTime(), chefIds);
  }

  private static ThaaliEventDto toDto(ThaaliEvent e) {
    java.util.List<MenuItemDto> menu = e.getMenu().stream().map(mi ->
        new MenuItemDto(mi.getId(), mi.getName(), mi.getDescription(), mi.getQuartsPerThaaliUnit(),
            mi.getIngredients().stream().map(link ->
                new MenuItemIngredientDto(link.getIngredient().getId(), link.getIngredient().getName(), link.getIngredient().getUnit(), link.getQuantityPerQuart())
            ).toList()
        )
    ).toList();
    java.util.Set<Long> chefIds = e.getChefs().stream().map(Person::getId).collect(java.util.stream.Collectors.toSet());
    return new ThaaliEventDto(e.getId(), e.getTitle(), e.getDescription(), e.getEventDate(), e.getStartTime(),
        e.getRegistrationOpenAt(), e.getRegistrationCloseAt(), e.getStatus(), menu, chefIds);
  }
}
