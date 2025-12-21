package com.acme.rsvp.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.PickupZoneDtos.PickupZoneDto;
import com.acme.rsvp.dto.PickupZoneDtos.PickupZoneUpsertRequest;
import com.acme.rsvp.model.PickupZone;
import com.acme.rsvp.repository.PickupZoneRepository;

@Service
@Transactional(readOnly = true)
public class PickupZoneService {

    private final PickupZoneRepository pickupZoneRepository;

    public PickupZoneService(PickupZoneRepository pickupZoneRepository) {
        this.pickupZoneRepository = pickupZoneRepository;
    }

    public List<PickupZoneDto> listAll() {
        return pickupZoneRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    public List<PickupZoneDto> listActive() {
        return pickupZoneRepository.findAllByActiveTrueOrderByNameAsc().stream()
                .map(this::toDto)
                .toList();
    }

    public PickupZoneDto get(Long id) {
        PickupZone zone = pickupZoneRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found: " + id));
        return toDto(zone);
    }

    @Transactional
    public PickupZoneDto create(PickupZoneUpsertRequest request) {
        PickupZone zone = new PickupZone();
        zone.setName(request.name());
        zone.setActive(request.active());
        return toDto(pickupZoneRepository.save(zone));
    }

    @Transactional
    public PickupZoneDto update(Long id, PickupZoneUpsertRequest request) {
        PickupZone zone = pickupZoneRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found: " + id));
        zone.setName(request.name());
        zone.setActive(request.active());
        return toDto(pickupZoneRepository.save(zone));
    }

    private PickupZoneDto toDto(PickupZone z) {
        return new PickupZoneDto(z.getId(), z.getName(), z.isActive());
    }
}
