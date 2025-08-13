package com.acme.rsvp.service;

import com.acme.rsvp.model.Event;
import com.acme.rsvp.repository.EventRepository;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class EventService {
  private final EventRepository repo;
  public EventService(EventRepository repo){this.repo = repo;}
  public List<Event> list(){ return repo.findAll(); }
  public Optional<Event> get(Long id){ return repo.findById(id); }
}
