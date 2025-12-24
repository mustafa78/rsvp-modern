package com.acme.rsvp.service;

import com.acme.rsvp.dto.RsvpDtos.NiyazRsvpDto;
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
}
