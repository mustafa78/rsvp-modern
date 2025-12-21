package com.acme.rsvp.web;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.PickupZoneDtos.PickupZoneDto;
import com.acme.rsvp.dto.PickupZoneDtos.PickupZoneUpsertRequest;
import com.acme.rsvp.service.PickupZoneService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/pickup-zones")
public class PickupZoneController {

    private final PickupZoneService pickupZoneService;

    public PickupZoneController(PickupZoneService pickupZoneService) {
        this.pickupZoneService = pickupZoneService;
    }

    @GetMapping
    public ResponseEntity<List<PickupZoneDto>> list() {
        return ResponseEntity.ok(pickupZoneService.listAll());
    }

    @GetMapping("/active")
    public ResponseEntity<List<PickupZoneDto>> listActive() {
        return ResponseEntity.ok(pickupZoneService.listActive());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PickupZoneDto> get(@PathVariable Long id) {
        return ResponseEntity.ok(pickupZoneService.get(id));
    }

    @PostMapping
    public ResponseEntity<PickupZoneDto> create(@Valid @RequestBody PickupZoneUpsertRequest request) {
        return ResponseEntity.ok(pickupZoneService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PickupZoneDto> update(@PathVariable Long id,
            @Valid @RequestBody PickupZoneUpsertRequest request) {
        return ResponseEntity.ok(pickupZoneService.update(id, request));
    }
}
