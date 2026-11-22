package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.AttendeeRow;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarReportServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarReportService reports;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired TestData data;

  @Test
  void listsEachFamilyMemberSeparatelyWithJoinDetails() {
    Person hof = data.person(true);
    FamilyMember joinedFm = data.familyMember(hof);
    FamilyMember absentFm = data.familyMember(hof);
    Person member = data.person(false);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));

    WebinarSeat s1 = seatService.giveSeat(w.getId(), hof.getId(), joinedFm.getId());
    seatService.giveSeat(w.getId(), hof.getId(), absentFm.getId());
    seatService.giveSeat(w.getId(), member.getId(), null);

    OffsetDateTime first = OffsetDateTime.parse("2030-01-01T18:00:00Z");
    logs.saveAndFlush(new WebinarJoinLog(s1, first.plusMinutes(5), JoinSource.MAGIC_LINK));
    logs.saveAndFlush(new WebinarJoinLog(s1, first, JoinSource.MAGIC_LINK));

    AttendanceReport report = reports.report(w.getId());

    assertThat(report.seatCount()).isEqualTo(3);
    assertThat(report.joinedCount()).isEqualTo(1);
    // The HOF holds no seat, so there is no row for them.
    assertThat(report.rows()).extracting(AttendeeRow::itsNumber).doesNotContain(hof.getItsNumber());

    AttendeeRow joined = report.rows().stream()
        .filter(r -> r.itsNumber().equals(joinedFm.getItsNumber())).findFirst().orElseThrow();
    assertThat(joined.type()).isEqualTo("Family");
    assertThat(joined.hofIts()).isEqualTo(hof.getItsNumber());
    assertThat(joined.joined()).isTrue();
    assertThat(joined.launchCount()).isEqualTo(2);
    assertThat(joined.firstJoinedAt().isEqual(first)).isTrue();

    AttendeeRow absent = report.rows().stream()
        .filter(r -> r.itsNumber().equals(absentFm.getItsNumber())).findFirst().orElseThrow();
    assertThat(absent.joined()).isFalse();
    assertThat(absent.launchCount()).isZero();
    assertThat(absent.firstJoinedAt()).isNull();

    AttendeeRow own = report.rows().stream()
        .filter(r -> r.itsNumber().equals(member.getItsNumber())).findFirst().orElseThrow();
    assertThat(own.type()).isEqualTo("Member");
    assertThat(own.hofName()).isNull();
  }
}
