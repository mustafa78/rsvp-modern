package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarSeatServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarSeatService service;
  @Autowired FamilyMemberService familyMemberService;
  @Autowired WebinarSeatRepository seats;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired TestData data;

  private Webinar assigned() {
    return data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));
  }

  @Test
  void familyMemberCanHoldASeatWhenTheHofHasNone() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();

    service.giveSeat(w.getId(), hof.getId(), fm.getId());

    List<FamilySeats> rows = service.listSeats(w.getId());
    assertThat(rows).hasSize(1);
    assertThat(rows.get(0).personId()).isEqualTo(hof.getId());
    assertThat(rows.get(0).ownSeatId()).isNull();
    assertThat(rows.get(0).family()).singleElement()
        .satisfies(r -> assertThat(r.seatId()).isNotNull());
  }

  @Test
  void listSeatsShowsUnseatedActiveFamilyMembersOfSeatedFamilies() {
    Person hof = data.person(true);
    data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);

    FamilySeats row = service.listSeats(w.getId()).get(0);
    assertThat(row.ownSeatId()).isNotNull();
    assertThat(row.family()).singleElement().satisfies(r -> assertThat(r.seatId()).isNull());
  }

  @Test
  void rejectsDuplicates() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);
    service.giveSeat(w.getId(), hof.getId(), fm.getId());

    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), null))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already has a seat");
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already has a seat");
  }

  @Test
  void rejectsFamilyMemberOfAnotherHofDeactivatedMembersAndInactiveAccounts() {
    Person hof = data.person(true);
    Person otherHof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();

    assertThatThrownBy(() -> service.giveSeat(w.getId(), otherHof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("does not belong");

    familyMemberService.setActive(fm.getId(), false);
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("deactivated");

    FamilyMember fm2 = data.familyMember(hof);
    hof.setAccountStatus(AccountStatus.DISABLED);
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm2.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not active");
  }

  @Test
  void removeSeatIsRefusedOnceTheAttendeeHasJoined() {
    Person p = data.person(false);
    Webinar w = assigned();
    WebinarSeat removable = service.giveSeat(w.getId(), p.getId(), null);
    service.removeSeat(w.getId(), removable.getId());
    assertThat(seats.countByWebinarId(w.getId())).isZero();

    WebinarSeat joined = service.giveSeat(w.getId(), p.getId(), null);
    logs.saveAndFlush(new WebinarJoinLog(joined, OffsetDateTime.now(), JoinSource.PORTAL));
    assertThatThrownBy(() -> service.removeSeat(w.getId(), joined.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already joined");
  }

  @Test
  void copyFromSeatsEligibleAttendeesAndSkipsTheRest() {
    Person hof = data.person(true);
    FamilyMember keep = data.familyMember(hof);
    FamilyMember gone = data.familyMember(hof);
    Webinar previous = assigned();
    service.giveSeat(previous.getId(), hof.getId(), null);
    service.giveSeat(previous.getId(), hof.getId(), keep.getId());
    service.giveSeat(previous.getId(), hof.getId(), gone.getId());
    familyMemberService.setActive(gone.getId(), false);

    Webinar next = assigned();
    CopySeatsResult result = service.copyFrom(next.getId(), previous.getId());

    assertThat(result.added()).isEqualTo(2);
    assertThat(result.skipped()).isEqualTo(1);
    assertThat(service.copyFrom(next.getId(), previous.getId()).added()).isZero();
  }

  @Test
  void ensureOwnSeatAutoCreatesOnlyOnOpenWebinars() {
    Person p = data.person(false);
    Webinar open = data.webinar(WebinarAccessMode.OPEN, OffsetDateTime.now().plusDays(1));
    WebinarSeat first = service.ensureOwnSeat(open, p);
    assertThat(first.getSource()).isEqualTo(SeatSource.OPEN_AUTO);
    assertThat(service.ensureOwnSeat(open, p).getId()).isEqualTo(first.getId());
    assertThat(service.ensureOwnSeat(assigned(), p)).isNull();
  }

  @Test
  void createFamilyMemberAndSeatDoesBothInOneStep() {
    Person hof = data.person(true);
    Webinar w = assigned();
    FamilyMemberDto dto = service.createFamilyMemberAndSeat(
        new SaveFamilyMemberRequest(hof.getId(), "Husain", "Kanchwala", TestData.nextIts(), w.getId()));
    assertThat(seats.findByWebinarIdAndFamilyMemberId(w.getId(), dto.id())).isPresent();
  }

  @Test
  void searchFindsPeopleAndFamilyMembers() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);

    List<AssignableRow> byPerson = service.searchAssignable(w.getId(), hof.getItsNumber());
    assertThat(byPerson).anySatisfy(r -> {
      assertThat(r.personId()).isEqualTo(hof.getId());
      assertThat(r.familyMemberId()).isNull();
      assertThat(r.hasSeat()).isTrue();
    });
    List<AssignableRow> byFamily = service.searchAssignable(w.getId(), fm.getItsNumber());
    assertThat(byFamily).anySatisfy(r -> {
      assertThat(r.familyMemberId()).isEqualTo(fm.getId());
      assertThat(r.hasSeat()).isFalse();
    });
    assertThat(service.searchAssignable(w.getId(), "9")).isEmpty();
  }
}
