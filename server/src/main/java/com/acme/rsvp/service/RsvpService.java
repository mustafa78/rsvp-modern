package com.acme.rsvp.service;

import com.acme.rsvp.dto.RsvpDto;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
public class RsvpService {
  private final PersonRepository personRepo; private final EventRepository eventRepo; private final RsvpRepository rsvpRepo;
  public RsvpService(PersonRepository p, EventRepository e, RsvpRepository r){this.personRepo=p; this.eventRepo=e; this.rsvpRepo=r;}

  public List<Rsvp> list(Long eventId){ return rsvpRepo.findByEventId(eventId); }

  @Transactional
  public Rsvp upsert(Long eventId, RsvpDto dto){
    Event event = eventRepo.findById(eventId).orElseThrow();
    Person person = personRepo.findByEmail(dto.email()).orElseGet(() -> {
      Person np = new Person();
      np.setName(dto.name()); np.setEmail(dto.email()); np.setPhone(dto.phone());
      return personRepo.save(np);
    });

    Rsvp r = rsvpRepo.findByEventIdAndPersonId(eventId, person.getId()).orElseGet(Rsvp::new);
    r.setEvent(event); r.setPerson(person);
    r.setStatus(dto.status()); r.setRole(dto.role()); r.setHeadcount(dto.headcount());
    return rsvpRepo.save(r);
  }
}
