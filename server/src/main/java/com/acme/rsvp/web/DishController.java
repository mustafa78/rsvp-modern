package com.acme.rsvp.web;

import com.acme.rsvp.dto.DishDtos.*;
import com.acme.rsvp.service.DishService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/dishes")
public class DishController {
  private final DishService svc;
  public DishController(DishService svc){ this.svc = svc; }

  @GetMapping
  public ResponseEntity<List<DishDto>> list(){ return ResponseEntity.ok(svc.list()); }

  @PostMapping
  public ResponseEntity<DishDto> create(@Valid @RequestBody DishUpsertRequest req){ return ResponseEntity.ok(svc.create(req)); }

  @PutMapping("/{id}")
  public ResponseEntity<DishDto> update(@PathVariable Long id, @Valid @RequestBody DishUpsertRequest req){ return ResponseEntity.ok(svc.update(id, req)); }
}
