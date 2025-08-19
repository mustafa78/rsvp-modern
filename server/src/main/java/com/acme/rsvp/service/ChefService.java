package com.acme.rsvp.service;

import com.acme.rsvp.dto.ChefDtos.ChefDto;
import com.acme.rsvp.dto.ChefDtos.ChefUpsertRequest;
import com.acme.rsvp.model.Chef;
import com.acme.rsvp.repository.ChefRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChefService {
  private final ChefRepository repo;
  public ChefService(ChefRepository repo){ this.repo = repo; }

  public ChefDto create(ChefUpsertRequest req){
    Chef c = new Chef();
    c.setName(req.name());
    c.setType(req.type());
    c.setEmail(req.email());
    c.setPhone(req.phone());
    c.setNotes(req.notes());
    if(req.active()!=null) c.setActive(req.active());
    repo.save(c);
    return toDto(c);
  }

  public ChefDto update(Long id, ChefUpsertRequest req){
    Chef c = repo.findById(id).orElseThrow();
    c.setName(req.name());
    c.setType(req.type());
    c.setEmail(req.email());
    c.setPhone(req.phone());
    c.setNotes(req.notes());
    if(req.active()!=null) c.setActive(req.active());
    return toDto(c);
  }

  public List<ChefDto> list(){
    return repo.findAll().stream().map(this::toDto).collect(java.util.stream.Collectors.toList());
  }

  private ChefDto toDto(Chef c){
    return new ChefDto(c.getId(), c.getName(), c.getType(), c.getEmail(), c.getPhone(), c.getNotes(), c.isActive());
  }
}
