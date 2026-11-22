package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.AttendeeRow;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarReportService {

  private final WebinarService webinarService;
  private final WebinarSeatRepository seats;
  private final WebinarJoinLogRepository logs;

  public WebinarReportService(WebinarService webinarService, WebinarSeatRepository seats,
      WebinarJoinLogRepository logs) {
    this.webinarService = webinarService;
    this.seats = seats;
    this.logs = logs;
  }

  @Transactional(readOnly = true)
  public AttendanceReport report(Long webinarId) {
    Webinar w = webinarService.require(webinarId);

    Map<Long, OffsetDateTime> firstJoin = new HashMap<>();
    Map<Long, Integer> launches = new HashMap<>();
    for (WebinarJoinLog l : logs.findByWebinarId(webinarId)) { // ordered by joinedAt ascending
      Long seatId = l.getSeat().getId();
      firstJoin.putIfAbsent(seatId, l.getJoinedAt());
      launches.merge(seatId, 1, Integer::sum);
    }

    List<WebinarSeat> all = new ArrayList<>(seats.findByWebinarIdWithAttendees(webinarId));
    all.sort(Comparator
        .comparing((WebinarSeat s) -> fullName(s.getPerson()), String.CASE_INSENSITIVE_ORDER)
        .thenComparing(WebinarSeat::isFamilySeat)
        .thenComparing(WebinarSeat::attendeeName, String.CASE_INSENSITIVE_ORDER));

    List<AttendeeRow> rows = all.stream().map(s -> {
      boolean family = s.isFamilySeat();
      return new AttendeeRow(s.attendeeIts(), s.attendeeName(), family ? "Family" : "Member",
          family ? fullName(s.getPerson()) : null,
          family ? s.getPerson().getItsNumber() : null,
          firstJoin.containsKey(s.getId()), firstJoin.get(s.getId()),
          launches.getOrDefault(s.getId(), 0));
    }).toList();

    int joined = (int) rows.stream().filter(AttendeeRow::joined).count();
    return new AttendanceReport(webinarService.toSummary(w), rows.size(), joined, rows);
  }

  private static String fullName(Person p) {
    return p.getFirstName() + " " + p.getLastName();
  }
}
