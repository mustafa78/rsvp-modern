package com.acme.rsvp.web;

import com.acme.rsvp.dto.EventMenuAssignmentDtos.MenuAssignment;
import com.acme.rsvp.model.Chef;
import com.acme.rsvp.model.MenuItem;
import com.acme.rsvp.service.EventAdminService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events/{eventId}")
public class EventAdminController {

  private final EventAdminService svc;
  public EventAdminController(EventAdminService svc){ this.svc = svc; }

  @PostMapping("/chefs")
  public ResponseEntity<Void> setChefs(@PathVariable Long eventId, @RequestBody List<Long> chefIds){
    svc.setEventChefs(eventId, chefIds);
    return ResponseEntity.ok().build();
  }

  @GetMapping("/chefs")
  public ResponseEntity<List<Chef>> listChefs(@PathVariable Long eventId){
    return ResponseEntity.ok(svc.listEventChefs(eventId));
  }

  @PostMapping("/menu")
  public ResponseEntity<Void> setMenu(@PathVariable Long eventId, @Valid @RequestBody List<MenuAssignment> items){
    svc.setEventMenu(eventId, items);
    return ResponseEntity.ok().build();
  }

  @GetMapping("/menu")
  public ResponseEntity<List<MenuItem>> listMenu(@PathVariable Long eventId){
    return ResponseEntity.ok(svc.listEventMenu(eventId));
  }
}
