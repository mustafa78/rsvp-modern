package com.acme.rsvp.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.ProfileDtos.*;
import com.acme.rsvp.model.NiyazEvent;
import com.acme.rsvp.model.NiyazRsvp;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.PickupZone;
import com.acme.rsvp.model.ThaaliEvent;
import com.acme.rsvp.model.ThaaliOrder;
import com.acme.rsvp.repository.NiyazRsvpRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.PickupZoneRepository;
import com.acme.rsvp.repository.ThaaliOrderRepository;

@Service
public class ProfileService {

    private final PersonRepository personRepo;
    private final PickupZoneRepository pickupZoneRepo;
    private final NiyazRsvpRepository niyazRsvpRepo;
    private final ThaaliOrderRepository thaaliOrderRepo;

    public ProfileService(PersonRepository personRepo, PickupZoneRepository pickupZoneRepo,
            NiyazRsvpRepository niyazRsvpRepo, ThaaliOrderRepository thaaliOrderRepo) {
        this.personRepo = personRepo;
        this.pickupZoneRepo = pickupZoneRepo;
        this.niyazRsvpRepo = niyazRsvpRepo;
        this.thaaliOrderRepo = thaaliOrderRepo;
    }

    @Transactional(readOnly = true)
    public ProfileResponse getProfile(Person person) {
        // Reload to get fresh data including pickup zone
        Person p = personRepo.findById(person.getId())
                .orElseThrow(() -> new IllegalArgumentException("Person not found"));

        return new ProfileResponse(
                p.getId(),
                p.getItsNumber(),
                p.getFirstName(),
                p.getLastName(),
                p.getEmail(),
                p.getPhone(),
                p.getRoles(),
                p.getPickupZone() != null ? p.getPickupZone().getId() : null,
                p.getPickupZone() != null ? p.getPickupZone().getName() : null,
                p.getUserType().name(),
                p.isHof(),
                p.getLastLoginAt(),
                p.getCreatedAt()
        );
    }

    @Transactional
    public ProfileResponse updateProfile(Person person, UpdateProfileRequest request) {
        Person p = personRepo.findById(person.getId())
                .orElseThrow(() -> new IllegalArgumentException("Person not found"));

        // Check if email is already used by another person
        personRepo.findByEmail(request.email()).ifPresent(existing -> {
            if (!existing.getId().equals(p.getId())) {
                throw new IllegalArgumentException("Email is already in use");
            }
        });

        p.setEmail(request.email());
        p.setPhone(request.phone());

        if (request.pickupZoneId() != null) {
            PickupZone zone = pickupZoneRepo.findById(request.pickupZoneId())
                    .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found"));
            p.setPickupZone(zone);
        } else {
            p.setPickupZone(null);
        }

        personRepo.save(p);

        return getProfile(p);
    }

    @Transactional(readOnly = true)
    public RsvpHistoryResponse getRsvpHistory(Person person) {
        List<NiyazRsvp> niyazRsvps = niyazRsvpRepo.findByPersonIdWithEvent(person.getId());
        List<ThaaliOrder> thaaliOrders = thaaliOrderRepo.findByPersonIdWithEventAndItems(person.getId());

        List<NiyazRsvpHistoryItem> niyazItems = niyazRsvps.stream()
                .map(rsvp -> {
                    NiyazEvent event = rsvp.getEvent();
                    return new NiyazRsvpHistoryItem(
                            rsvp.getId(),
                            event.getId(),
                            event.getTitle() != null ? event.getTitle() : event.getMiqaatName(),
                            event.getEventDate(),
                            event.getStatus().name(),
                            rsvp.getAdults(),
                            rsvp.getKids(),
                            null // NiyazRsvp doesn't have notes field
                    );
                })
                .collect(Collectors.toList());

        List<ThaaliOrderHistoryItem> thaaliItems = thaaliOrders.stream()
                .map(order -> {
                    ThaaliEvent event = order.getEvent();
                    List<ThaaliOrderItemHistory> items = order.getItems().stream()
                            .map(item -> new ThaaliOrderItemHistory(
                                    item.getMenuItem().getDish() != null
                                            ? item.getMenuItem().getDish().getName()
                                            : "Unknown",
                                    item.getSize().name()
                            ))
                            .collect(Collectors.toList());

                    return new ThaaliOrderHistoryItem(
                            order.getId(),
                            event.getId(),
                            event.getTitle(),
                            event.getEventDate(),
                            event.getStatus().name(),
                            order.getPickupZone() != null ? order.getPickupZone().getName() : null,
                            items,
                            order.getNotes()
                    );
                })
                .collect(Collectors.toList());

        return new RsvpHistoryResponse(niyazItems, thaaliItems);
    }
}
