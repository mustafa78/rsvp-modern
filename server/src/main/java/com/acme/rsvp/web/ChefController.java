package com.acme.rsvp.web;

import com.acme.rsvp.dto.ChefDtos.ChefDto;
import com.acme.rsvp.dto.ChefDtos.ChefUpsertRequest;
import com.acme.rsvp.service.ChefService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/chefs")
public class ChefController {
  private final ChefService svc;
  public ChefController(ChefService svc){ this.svc = svc; }

  @GetMapping
  public ResponseEntity<List<ChefDto>> list(){ return ResponseEntity.ok(svc.list()); }

  @PostMapping
  public ResponseEntity<ChefDto> create(@Valid @RequestBody ChefUpsertRequest req){ return ResponseEntity.ok(svc.create(req)); }

  @PutMapping("/{id}")
  public ResponseEntity<ChefDto> update(@PathVariable Long id, @Valid @RequestBody ChefUpsertRequest req){ return ResponseEntity.ok(svc.update(id, req)); }
}
