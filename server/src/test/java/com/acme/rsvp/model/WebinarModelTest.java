package com.acme.rsvp.model;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarModelTest extends PostgresIntegrationTest {

  @Autowired TestData data;
  @Autowired WebinarSeatRepository seats;

  @Test
  void joinWindowIsInclusiveAndRequiresPublished() {
    OffsetDateTime start = OffsetDateTime.parse("2030-01-01T18:00:00Z");
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, start);
    assertThat(w.isJoinOpen(start.minusMinutes(11))).isFalse();
    assertThat(w.isJoinOpen(start.minusMinutes(10))).isTrue();
    assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(15))).isTrue();
    assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(16))).isFalse();
    w.setStatus(WebinarStatus.DRAFT);
    assertThat(w.isJoinOpen(start)).isFalse();
  }

  @Test
  void seatResolvesMemberOrFamilyIdentity() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));

    WebinarSeat own = seats.saveAndFlush(new WebinarSeat(w, hof, null, SeatSource.ASSIGNED));
    WebinarSeat family = seats.saveAndFlush(new WebinarSeat(w, hof, fm, SeatSource.ASSIGNED));

    assertThat(own.isFamilySeat()).isFalse();
    assertThat(own.displayName()).isEqualTo(hof.getItsNumber() + " " + hof.getFirstName() + " " + hof.getLastName());
    assertThat(family.isFamilySeat()).isTrue();
    assertThat(family.displayName()).isEqualTo(fm.getItsNumber() + " " + fm.getFirstName() + " " + fm.getLastName());
    assertThat(seats.findByWebinarIdAndFamilyMemberId(w.getId(), fm.getId())).isPresent();
    assertThat(seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), hof.getId())).isPresent();
    assertThat(seats.findByWebinarIdWithAttendees(w.getId())).hasSize(2);
  }
}
