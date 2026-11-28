package com.acme.rsvp.service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.FamilySeatRow;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.FamilyMemberRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarSeatService {

  private final WebinarSeatRepository seats;
  private final WebinarService webinarService;
  private final PersonRepository persons;
  private final FamilyMemberRepository familyMembers;
  private final FamilyMemberService familyMemberService;
  private final WebinarJoinLogRepository logs;

  public WebinarSeatService(WebinarSeatRepository seats, WebinarService webinarService,
      PersonRepository persons, FamilyMemberRepository familyMembers,
      FamilyMemberService familyMemberService, WebinarJoinLogRepository logs) {
    this.seats = seats;
    this.webinarService = webinarService;
    this.persons = persons;
    this.familyMembers = familyMembers;
    this.familyMemberService = familyMemberService;
    this.logs = logs;
  }

  @Transactional
  public WebinarSeat giveSeat(Long webinarId, Long personId, Long familyMemberId) {
    Webinar w = webinarService.require(webinarId);
    if (personId == null) throw new IllegalArgumentException("Person is required");
    Person p = persons.findById(personId).orElseThrow(() -> new IllegalArgumentException("Person not found"));
    FamilyMember fm = familyMemberId == null ? null : familyMembers.findById(familyMemberId)
        .orElseThrow(() -> new IllegalArgumentException("Family member not found"));
    String problem = problem(webinarId, p, fm);
    if (problem != null) throw new IllegalStateException(problem);
    try {
      return seats.saveAndFlush(new WebinarSeat(w, p, fm, SeatSource.ASSIGNED));
    } catch (DataIntegrityViolationException e) {
      // Two coordinators seating the same attendee at once: report it as a rule violation, not a 403/500.
      throw new IllegalStateException("This attendee already has a seat");
    }
  }

  @Transactional
  public FamilyMemberDto createFamilyMemberAndSeat(SaveFamilyMemberRequest req) {
    FamilyMember fm = familyMemberService.createEntity(
        req.hofPersonId(), req.firstName(), req.lastName(), req.itsNumber());
    giveSeat(req.webinarId(), req.hofPersonId(), fm.getId());
    return familyMemberService.toDto(fm);
  }

  @Transactional
  public void removeSeat(Long webinarId, Long seatId) {
    WebinarSeat seat = seats.findById(seatId)
        .filter(s -> s.getWebinar().getId().equals(webinarId))
        .orElseThrow(() -> new NotFoundException("Seat not found"));
    if (logs.existsBySeatId(seatId)) {
      // Deleting the seat would delete its join logs and erase the attendance record.
      throw new IllegalStateException(seat.attendeeName() + " has already joined; the seat cannot be removed");
    }
    seats.delete(seat); // join tokens go with it (ON DELETE CASCADE), so its link stops working
    seats.flush();
  }

  @Transactional(readOnly = true)
  public List<FamilySeats> listSeats(Long webinarId) {
    webinarService.require(webinarId);
    Map<Long, Person> people = new LinkedHashMap<>();
    Map<Long, Long> ownSeat = new HashMap<>();
    Map<Long, Long> familySeat = new HashMap<>();
    for (WebinarSeat s : seats.findByWebinarIdWithAttendees(webinarId)) {
      people.putIfAbsent(s.getPerson().getId(), s.getPerson());
      if (s.isFamilySeat()) {
        familySeat.put(s.getFamilyMember().getId(), s.getId());
      } else {
        ownSeat.put(s.getPerson().getId(), s.getId());
      }
    }
    return people.values().stream()
        .sorted(Comparator.comparing((Person p) -> p.getFirstName() + " " + p.getLastName(),
            String.CASE_INSENSITIVE_ORDER))
        .map(p -> new FamilySeats(p.getId(), p.getItsNumber(), p.getFirstName() + " " + p.getLastName(),
            p.isHof(), ownSeat.get(p.getId()),
            familyMembers.findByHofIdOrderByFirstNameAscLastNameAsc(p.getId()).stream()
                .filter(fm -> fm.isActive() || familySeat.containsKey(fm.getId()))
                .map(fm -> new FamilySeatRow(fm.getId(), fm.getItsNumber(), fm.fullName(),
                    familySeat.get(fm.getId())))
                .toList()))
        .toList();
  }

  /** People and saved family members matching a name or ITS prefix. Nothing for fewer than 2 characters. */
  @Transactional(readOnly = true)
  public List<AssignableRow> searchAssignable(Long webinarId, String search) {
    String s = search == null ? "" : search.trim();
    if (s.length() < 2) return List.of();
    List<AssignableRow> rows = new ArrayList<>();
    for (Person p : persons.searchActive(s, Instant.now(), PageRequest.of(0, 20))) {
      rows.add(new AssignableRow(p.getId(), null, p.getItsNumber(),
          p.getFirstName() + " " + p.getLastName(), null, p.isHof(),
          seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(webinarId, p.getId()).isPresent()));
    }
    for (FamilyMember fm : familyMembers.searchActive(s, PageRequest.of(0, 20))) {
      Person hof = fm.getHof();
      rows.add(new AssignableRow(hof.getId(), fm.getId(), fm.getItsNumber(), fm.fullName(),
          hof.getFirstName() + " " + hof.getLastName(), false,
          seats.findByWebinarIdAndFamilyMemberId(webinarId, fm.getId()).isPresent()));
    }
    return rows;
  }

  @Transactional
  public CopySeatsResult copyFrom(Long webinarId, Long otherWebinarId) {
    if (webinarId.equals(otherWebinarId)) {
      throw new IllegalArgumentException("Choose a different meeting to copy from");
    }
    Webinar w = webinarService.require(webinarId);
    webinarService.require(otherWebinarId);
    int added = 0;
    int skipped = 0;
    for (WebinarSeat other : seats.findByWebinarIdWithAttendees(otherWebinarId)) {
      if (problem(webinarId, other.getPerson(), other.getFamilyMember()) == null) {
        seats.save(new WebinarSeat(w, other.getPerson(), other.getFamilyMember(), SeatSource.ASSIGNED));
        added++;
      } else {
        skipped++;
      }
    }
    seats.flush();
    return new CopySeatsResult(added, skipped);
  }

  /** The person's own seat; created on first use for OPEN webinars; null when they have no access. */
  @Transactional
  public WebinarSeat ensureOwnSeat(Webinar w, Person p) {
    return seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), p.getId())
        .orElseGet(() -> w.getAccessMode() == WebinarAccessMode.OPEN
            ? seats.saveAndFlush(new WebinarSeat(w, p, null, SeatSource.OPEN_AUTO))
            : null);
  }

  /** Why this attendee cannot be given a seat, or null if they can. A family seat never needs an HOF seat. */
  private String problem(Long webinarId, Person p, FamilyMember fm) {
    String who = fm != null ? fm.fullName() : p.getFirstName() + " " + p.getLastName();
    if (fm != null && !fm.getHof().getId().equals(p.getId())) {
      return who + " does not belong to this head of family";
    }
    if (p.getAccountStatus() != AccountStatus.ACTIVE || p.isExpired()) {
      return (fm != null ? "The head of family's account" : who + "'s account") + " is not active";
    }
    if (fm != null) {
      if (!fm.isActive()) return who + " is deactivated";
      if (seats.findByWebinarIdAndFamilyMemberId(webinarId, fm.getId()).isPresent()) {
        return who + " already has a seat";
      }
    } else if (seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(webinarId, p.getId()).isPresent()) {
      return who + " already has a seat";
    }
    return null;
  }
}
