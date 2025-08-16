package com.acme.rsvp.service;

import com.acme.rsvp.dto.RsvpDtos.*;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.PickupZone;
import com.acme.rsvp.model.ThaaliEvent;
import com.acme.rsvp.model.ThaaliOrder;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.ThaaliEventRepository;
import com.acme.rsvp.repository.ThaaliOrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class ThaaliService {
  private final ThaaliEventRepository eventRepo;
  private final PersonRepository personRepo;
  private final ThaaliOrderRepository orderRepo;

  public ThaaliService(ThaaliEventRepository eventRepo, PersonRepository personRepo, ThaaliOrderRepository orderRepo) {
    this.eventRepo = eventRepo; this.personRepo = personRepo; this.orderRepo = orderRepo;
  }

  @Transactional
  public ThaaliOrderDto upsert(Long eventId, ThaaliOrderDto dto) {
    ThaaliEvent e = eventRepo.findById(eventId).orElseThrow();
    Person p = personRepo.findById(dto.personId()).orElseThrow();

    ThaaliOrder o = orderRepo.findAll().stream()
        .filter(x -> x.getEvent().getId().equals(eventId) && x.getPerson().getId().equals(dto.personId()))
        .findFirst().orElseGet(ThaaliOrder::new);
    o.setEvent(e); o.setPerson(p);
    o.setLargeCount(dto.largeCount()); o.setSmallCount(dto.smallCount()); o.setBarakatiCount(dto.barakatiCount());
    o.setPickupZone(dto.pickupZone()==null? p.getPickupZone(): dto.pickupZone()); o.setNotes(dto.notes());
    orderRepo.save(o);
    return new ThaaliOrderDto(eventId, p.getId(), o.getLargeCount(), o.getSmallCount(), o.getBarakatiCount(), o.getPickupZone(), o.getNotes());
  }

  @Transactional(readOnly = true)
  public ThaaliCountReportDto counts(Long eventId) {
    long L = orderRepo.totalLarge(eventId), S = orderRepo.totalSmall(eventId), B = orderRepo.totalBarakati(eventId);
    BigDecimal q = orderRepo.totalThaaliQuarts(eventId);
    return new ThaaliCountReportDto(L, S, B, q);
  }

  @Transactional(readOnly = true)
  public List<ShoppingListItemDto> shoppingList(Long eventId) {
    BigDecimal totalQuarts = orderRepo.totalThaaliQuarts(eventId);
    var unitRows = orderRepo.ingredientPerThaaliUnit(eventId);
    List<ShoppingListItemDto> out = new ArrayList<>();
    for (Object[] row : unitRows) {
      Long ingId = (Long) row[0]; String name = (String) row[1]; String unit = (String) row[2];
      java.math.BigDecimal perUnit = (java.math.BigDecimal) row[3];
      out.add(new ShoppingListItemDto(ingId, name, unit, perUnit.multiply(totalQuarts)));
    }
    return out;
  }
}
