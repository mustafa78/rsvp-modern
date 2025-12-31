package com.acme.rsvp.service;

import java.util.List;

import com.acme.rsvp.dto.RsvpDtos.AdminNiyazRsvpRequest;
import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDetailDto;
import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDto;
import com.acme.rsvp.dto.RsvpDtos.PersonBasicDto;
import com.acme.rsvp.model.NiyazEvent;
import com.acme.rsvp.model.NiyazRsvp;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.repository.NiyazEventRepository;
import com.acme.rsvp.repository.NiyazRsvpRepository;
import com.acme.rsvp.repository.PersonRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NiyazService {

    private final NiyazEventRepository eventRepo;
    private final PersonRepository personRepo;
    private final NiyazRsvpRepository rsvpRepo;

    public NiyazService(NiyazEventRepository eventRepo, PersonRepository personRepo, NiyazRsvpRepository rsvpRepo) {
        this.eventRepo = eventRepo;
        this.personRepo = personRepo;
        this.rsvpRepo = rsvpRepo;
    }

    @Transactional
    public NiyazRsvpDto upsert(Long eventId, Long personId, int adults, int kids) {
        NiyazEvent e = eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        // Check if registration is open
        if (!e.isRegistrationOpen(java.time.OffsetDateTime.now())) {
            throw new IllegalStateException("Registration is closed for this event");
        }

        Person p = personRepo.findById(personId)
                .orElseThrow(() -> new IllegalArgumentException("Person not found: " + personId));

        NiyazRsvp r = rsvpRepo.findByEventIdAndPersonId(eventId, personId)
                .orElseGet(NiyazRsvp::new);

        r.setEvent(e);
        r.setPerson(p);
        r.setAdults(adults);
        r.setKids(kids);
        rsvpRepo.save(r);

        return new NiyazRsvpDto(eventId, personId, adults, kids);
    }

    @Transactional(readOnly = true)
    public NiyazRsvpDto getMyRsvp(Long eventId, Long personId) {
        return rsvpRepo.findByEventIdAndPersonId(eventId, personId)
                .map(r -> new NiyazRsvpDto(eventId, personId, r.getAdults(), r.getKids()))
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public long totalAdults(Long eventId) {
        return rsvpRepo.totalAdults(eventId);
    }

    @Transactional(readOnly = true)
    public long totalKids(Long eventId) {
        return rsvpRepo.totalKids(eventId);
    }

    @Transactional(readOnly = true)
    public List<NiyazRsvpDetailDto> getRsvpsByEvent(Long eventId) {
        return rsvpRepo.findByEventIdWithPerson(eventId).stream()
                .map(r -> new NiyazRsvpDetailDto(
                        r.getId(),
                        r.getPerson().getId(),
                        r.getPerson().getFirstName() + " " + r.getPerson().getLastName(),
                        r.getPerson().getPhone(),
                        r.getAdults(),
                        r.getKids()))
                .toList();
    }

    // Admin methods - bypass registration window check

    @Transactional
    public NiyazRsvpDto createRsvpAdmin(Long eventId, AdminNiyazRsvpRequest request) {
        NiyazEvent event = eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        Person person = personRepo.findById(request.personId())
                .orElseThrow(() -> new IllegalArgumentException("Person not found: " + request.personId()));

        // Check if RSVP already exists
        if (rsvpRepo.findByEventIdAndPersonId(eventId, request.personId()).isPresent()) {
            throw new IllegalStateException("RSVP already exists for this person. Use update instead.");
        }

        NiyazRsvp rsvp = new NiyazRsvp();
        rsvp.setEvent(event);
        rsvp.setPerson(person);
        rsvp.setAdults(request.adults());
        rsvp.setKids(request.kids());

        rsvp = rsvpRepo.save(rsvp);
        return new NiyazRsvpDto(eventId, request.personId(), request.adults(), request.kids());
    }

    @Transactional
    public NiyazRsvpDto updateRsvpAdmin(Long eventId, Long rsvpId, AdminNiyazRsvpRequest request) {
        NiyazRsvp rsvp = rsvpRepo.findById(rsvpId)
                .orElseThrow(() -> new IllegalArgumentException("RSVP not found: " + rsvpId));

        // Verify RSVP belongs to the event
        if (!rsvp.getEvent().getId().equals(eventId)) {
            throw new IllegalArgumentException("RSVP " + rsvpId + " does not belong to event " + eventId);
        }

        rsvp.setAdults(request.adults());
        rsvp.setKids(request.kids());

        rsvp = rsvpRepo.save(rsvp);
        return new NiyazRsvpDto(eventId, rsvp.getPerson().getId(), request.adults(), request.kids());
    }

    @Transactional
    public void deleteRsvpAdmin(Long eventId, Long rsvpId) {
        NiyazRsvp rsvp = rsvpRepo.findById(rsvpId)
                .orElseThrow(() -> new IllegalArgumentException("RSVP not found: " + rsvpId));

        // Verify RSVP belongs to the event
        if (!rsvp.getEvent().getId().equals(eventId)) {
            throw new IllegalArgumentException("RSVP " + rsvpId + " does not belong to event " + eventId);
        }

        rsvpRepo.delete(rsvp);
    }

    @Transactional(readOnly = true)
    public List<PersonBasicDto> getUsersWithoutRsvps(Long eventId) {
        // Verify event exists
        eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        return personRepo.findWithoutRsvpForEvent(eventId).stream()
                .map(p -> new PersonBasicDto(
                        p.getId(),
                        p.getItsNumber(),
                        p.getFirstName(),
                        p.getLastName(),
                        p.getPhone()))
                .toList();
    }
}
