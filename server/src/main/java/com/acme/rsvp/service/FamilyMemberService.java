package com.acme.rsvp.service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.regex.Pattern;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.repository.FamilyMemberRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;

@Service
public class FamilyMemberService {

  private static final Pattern ITS = Pattern.compile("\\d{8}");

  private final FamilyMemberRepository familyMembers;
  private final PersonRepository persons;
  private final WebinarJoinTokenRepository tokens;

  public FamilyMemberService(FamilyMemberRepository familyMembers, PersonRepository persons,
      WebinarJoinTokenRepository tokens) {
    this.familyMembers = familyMembers;
    this.persons = persons;
    this.tokens = tokens;
  }

  @Transactional
  public FamilyMember createEntity(Long hofPersonId, String firstName, String lastName, String itsNumber) {
    if (hofPersonId == null) throw new IllegalArgumentException("Head of family is required");
    Person hof = persons.findById(hofPersonId)
        .orElseThrow(() -> new IllegalArgumentException("Head of family not found"));
    if (!hof.isHof()) {
      throw new IllegalArgumentException("Family members can only be added under a head of family");
    }
    FamilyMember fm = new FamilyMember();
    fm.setHof(hof);
    fm.setFirstName(requireName(firstName, "First name"));
    fm.setLastName(requireName(lastName, "Last name"));
    fm.setItsNumber(validateIts(itsNumber, null));
    return familyMembers.save(fm);
  }

  @Transactional
  public FamilyMemberDto create(SaveFamilyMemberRequest req) {
    return toDto(createEntity(req.hofPersonId(), req.firstName(), req.lastName(), req.itsNumber()));
  }

  @Transactional
  public FamilyMemberDto update(Long id, SaveFamilyMemberRequest req) {
    FamilyMember fm = require(id);
    fm.setFirstName(requireName(req.firstName(), "First name"));
    fm.setLastName(requireName(req.lastName(), "Last name"));
    fm.setItsNumber(validateIts(req.itsNumber(), id));
    return toDto(fm);
  }

  /** Deactivating never deletes: past attendance reports keep the name. Live links stop working. */
  @Transactional
  public FamilyMemberDto setActive(Long id, boolean active) {
    FamilyMember fm = require(id);
    fm.setActive(active);
    if (!active) {
      tokens.revokeForFamilyMember(id, OffsetDateTime.now());
    }
    return toDto(fm);
  }

  @Transactional(readOnly = true)
  public List<FamilyMemberDto> listByHof(Long hofPersonId) {
    return familyMembers.findByHofIdOrderByFirstNameAscLastNameAsc(hofPersonId).stream()
        .map(this::toDto).toList();
  }

  /** Active heads of family matching a name or ITS prefix. Returns nothing for fewer than 2 characters. */
  @Transactional(readOnly = true)
  public List<HofDto> searchHofs(String search) {
    String s = search == null ? "" : search.trim();
    if (s.length() < 2) return List.of();
    return persons.searchActive(s, Instant.now(), PageRequest.of(0, 50)).stream()
        .filter(Person::isHof)
        .limit(20)
        .map(p -> new HofDto(p.getId(), p.getFirstName(), p.getLastName(), p.getItsNumber(),
            familyMembers.countByHofIdAndActiveTrue(p.getId())))
        .toList();
  }

  public FamilyMemberDto toDto(FamilyMember fm) {
    return new FamilyMemberDto(fm.getId(), fm.getHof().getId(), fm.getFirstName(), fm.getLastName(),
        fm.getItsNumber(), fm.isActive());
  }

  private FamilyMember require(Long id) {
    return familyMembers.findById(id).orElseThrow(() -> new NotFoundException("Family member not found"));
  }

  private static String requireName(String value, String label) {
    if (value == null || value.isBlank()) throw new IllegalArgumentException(label + " is required");
    return value.trim();
  }

  private String validateIts(String raw, Long selfId) {
    String its = raw == null ? "" : raw.trim();
    if (!ITS.matcher(its).matches()) {
      throw new IllegalArgumentException("ITS number must be exactly 8 digits");
    }
    if (persons.existsByItsNumber(its)) {
      throw new IllegalArgumentException(
          "ITS " + its + " belongs to an existing user. Give that user a seat directly instead.");
    }
    boolean taken = selfId == null
        ? familyMembers.existsByItsNumber(its)
        : familyMembers.existsByItsNumberAndIdNot(its, selfId);
    if (taken) {
      throw new IllegalArgumentException("ITS " + its + " is already saved as a family member");
    }
    return its;
  }
}
