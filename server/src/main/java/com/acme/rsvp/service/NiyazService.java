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
    this.eventRepo = eventRepo; this.personRepo = personRepo; this.rsvpRepo = rsvpRepo;
  }

  @Transactional
  public NiyazRsvpDto upsert(Long eventId, NiyazRsvpDto dto) {
    NiyazEvent e = eventRepo.findById(eventId).orElseThrow();
    Person p = personRepo.findById(dto.personId()).orElseThrow();

    NiyazRsvp r = rsvpRepo.findAll().stream()
        .filter(x -> x.getEvent().getId().equals(eventId) && x.getPerson().getId().equals(dto.personId()))
        .findFirst().orElseGet(NiyazRsvp::new);

    r.setEvent(e); r.setPerson(p); r.setAdults(dto.adults()); r.setKids(dto.kids());
    rsvpRepo.save(r);
    return dto;
  }

  @Transactional(readOnly = true) public long totalAdults(Long eventId){ return rsvpRepo.totalAdults(eventId); }
  @Transactional(readOnly = true) public long totalKids(Long eventId){ return rsvpRepo.totalKids(eventId); }
}
