package com.acme.rsvp.web;

import com.acme.rsvp.repository.EventRepository;
import com.acme.rsvp.repository.RsvpRepository;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/stats")
public class StatsController {
  private final EventRepository events; private final RsvpRepository rsvps;
  public StatsController(EventRepository e, RsvpRepository r){ this.events=e; this.rsvps=r; }

  @GetMapping("/summary")
  public Map<String,Object> summary(){
    Map<String,Object> m = new LinkedHashMap<>();
    m.put("upcomingEventsCount", events.count());
    Map<String, Long> byRole = rsvps.findAll().stream()
      .filter(r -> r.getRole()!=null)
      .collect(java.util.stream.Collectors.groupingBy(r -> r.getRole().name(), java.util.stream.Collectors.counting()));
    m.put("rsvpCountsByRole", byRole);
    return m;
  }
}
