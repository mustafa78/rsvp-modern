package com.acme.rsvp.web;

import com.acme.rsvp.dto.IngredientDtos.*;
import com.acme.rsvp.service.IngredientService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ingredients")
public class IngredientController {

    private final IngredientService svc;

    public IngredientController(IngredientService svc) {
        this.svc = svc;
    }

    @GetMapping
    public ResponseEntity<List<IngredientDto>> list() {
        return ResponseEntity.ok(svc.list());
    }

    @GetMapping("/{id}")
    public ResponseEntity<IngredientDto> get(@PathVariable Long id) {
        return ResponseEntity.ok(svc.get(id));
    }

    @PostMapping
    public ResponseEntity<IngredientDto> create(@Valid @RequestBody IngredientUpsertRequest req) {
        return ResponseEntity.ok(svc.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<IngredientDto> update(@PathVariable Long id, @Valid @RequestBody IngredientUpsertRequest req) {
        return ResponseEntity.ok(svc.update(id, req));
    }
}
