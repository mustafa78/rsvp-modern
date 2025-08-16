package com.acme.rsvp.web;

import com.acme.rsvp.dto.RsvpDtos.*;
import com.acme.rsvp.service.ThaaliService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/thaali/{eventId}/orders")
public class ThaaliOrderController {
  private final ThaaliService svc;
  public ThaaliOrderController(ThaaliService svc){ this.svc = svc; }

  @PostMapping public ThaaliOrderDto upsert(@PathVariable Long eventId, @Valid @RequestBody ThaaliOrderDto dto){ return svc.upsert(eventId, dto); }
  @GetMapping("/counts") public ThaaliCountReportDto counts(@PathVariable Long eventId){ return svc.counts(eventId); }
  @GetMapping("/shopping-list") public List<ShoppingListItemDto> shopping(@PathVariable Long eventId){ return svc.shoppingList(eventId); }
}
