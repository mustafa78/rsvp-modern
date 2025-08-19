package com.acme.rsvp.service;

import com.acme.rsvp.dto.EventMenuAssignmentDtos.MenuAssignment;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class EventAdminService {

  private final EventRepository events;
  private final ChefRepository chefs;
  private final EventChefRepository eventChefs;
  private final DishRepository dishes;
  private final MenuItemRepository menuItems;

  public EventAdminService(EventRepository events, ChefRepository chefs, EventChefRepository eventChefs,
                           DishRepository dishes, MenuItemRepository menuItems) {
    this.events = events; this.chefs = chefs; this.eventChefs = eventChefs; this.dishes = dishes; this.menuItems = menuItems;
  }

  public void setEventChefs(Long eventId, List<Long> chefIds){
    Event event = events.findById(eventId).orElseThrow();
    eventChefs.deleteByEvent_Id(eventId);
    if (chefIds == null) return;
    for (Long cid : chefIds){
      Chef c = chefs.findById(cid).orElseThrow();
      EventChef ec = new EventChef();
      ec.setEvent(event);
      ec.setChef(c);
      eventChefs.save(ec);
    }
  }

  public void setEventMenu(Long eventId, List<MenuAssignment> assignments){
    Event event = events.findById(eventId).orElseThrow();
    // replace menu
    List<MenuItem> existing = menuItems.findByEvent_IdOrderByPositionAsc(eventId);
    for (MenuItem mi : existing) { menuItems.delete(mi); }
    if (assignments == null) return;
    int positionCounter = 1;
    for (MenuAssignment a : assignments){
      Dish d = dishes.findById(a.dishId()).orElseThrow();
      MenuItem mi = new MenuItem();
      mi.setEvent(event);
      mi.setDish(d);
      if (a.quartsPerThaaliUnitOverride() != null){
        mi.setQuartsPerThaaliUnit(a.quartsPerThaaliUnitOverride());
      }
      mi.setPosition(a.position()!=null ? a.position() : positionCounter++);
      menuItems.save(mi);
    }
  }

  public List<Chef> listEventChefs(Long eventId){
    List<EventChef> ecs = eventChefs.findByEvent_Id(eventId);
    List<Chef> out = new ArrayList<>();
    for (EventChef ec : ecs){ out.add(ec.getChef()); }
    return out;
  }

  public List<MenuItem> listEventMenu(Long eventId){
    return menuItems.findByEvent_IdOrderByPositionAsc(eventId);
  }
}
