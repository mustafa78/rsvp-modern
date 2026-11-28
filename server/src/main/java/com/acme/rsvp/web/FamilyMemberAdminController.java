package com.acme.rsvp.web;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.dto.WebinarDtos.SetActiveRequest;
import com.acme.rsvp.service.FamilyMemberService;
import com.acme.rsvp.service.WebinarSeatService;

/** ADMIN / WEBINAR_COORDINATOR only, enforced by the URL rule in WebSecurityConfig. */
@RestController
@RequestMapping("/api/admin/family-members")
public class FamilyMemberAdminController {

  private final FamilyMemberService familyMembers;
  private final WebinarSeatService seats;

  public FamilyMemberAdminController(FamilyMemberService familyMembers, WebinarSeatService seats) {
    this.familyMembers = familyMembers;
    this.seats = seats;
  }

  /** Exposes only id, name, ITS and family count, so coordinators need no access to user management. */
  @GetMapping("/hofs")
  public List<HofDto> hofs(@RequestParam(defaultValue = "") String search) {
    return familyMembers.searchHofs(search);
  }

  @GetMapping
  public List<FamilyMemberDto> list(@RequestParam Long hofPersonId) {
    return familyMembers.listByHof(hofPersonId);
  }

  /** With webinarId set, the new family member is also given a seat on that webinar in one transaction. */
  @PostMapping
  public FamilyMemberDto create(@RequestBody SaveFamilyMemberRequest req) {
    return req.webinarId() != null ? seats.createFamilyMemberAndSeat(req) : familyMembers.create(req);
  }

  @PutMapping("/{id}")
  public FamilyMemberDto update(@PathVariable Long id, @RequestBody SaveFamilyMemberRequest req) {
    return familyMembers.update(id, req);
  }

  @PutMapping("/{id}/active")
  public FamilyMemberDto setActive(@PathVariable Long id, @RequestBody SetActiveRequest req) {
    return familyMembers.setActive(id, req.active());
  }
}
