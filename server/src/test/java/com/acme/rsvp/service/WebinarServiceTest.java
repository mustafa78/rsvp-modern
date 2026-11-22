package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.Arrays;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarService service;
  @Autowired WebinarSeatRepository seats;
  @Autowired TestData data;

  private SaveWebinarRequest req(String joinUrl) {
    OffsetDateTime start = OffsetDateTime.now().plusDays(2);
    return new SaveWebinarRequest("Majlis", "desc", "Host", start, start.plusHours(1),
        null, null, joinUrl, null, null);
  }

  @Test
  void rejectsJoinUrlThatIsNotAParseableUrlWithoutEchoingIt() {
    assertThatThrownBy(() -> service.create(req("https://zoom.us/j/1 2?pwd=x")))
        .isInstanceOf(IllegalArgumentException.class)
        .hasMessageNotContaining("zoom.us");
  }

  @Test
  void createAppliesDefaultsAndNeverExposesJoinUrl() {
    WebinarSummary s = service.create(req("https://zoom.us/j/1"));
    assertThat(s.status()).isEqualTo("DRAFT");
    assertThat(s.accessMode()).isEqualTo("ASSIGNED");
    assertThat(s.joinWindowBeforeMin()).isEqualTo(10);
    assertThat(s.joinWindowAfterMin()).isEqualTo(15);
    assertThat(s.hasJoinUrl()).isTrue();
    assertThat(Arrays.stream(WebinarSummary.class.getRecordComponents()).map(c -> c.getName()))
        .doesNotContain("joinUrl");
  }

  @Test
  void blankJoinUrlOnUpdateKeepsStoredValue() {
    WebinarSummary s = service.create(req("https://zoom.us/j/1"));
    service.update(s.id(), req("  "));
    assertThat(service.require(s.id()).getJoinUrl()).isEqualTo("https://zoom.us/j/1");
  }

  @Test
  void rejectsBadInput() {
    OffsetDateTime start = OffsetDateTime.now().plusDays(2);
    assertThatThrownBy(() -> service.create(new SaveWebinarRequest(" ", null, null, start, start.plusHours(1),
        null, null, null, null, null))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.create(new SaveWebinarRequest("T", null, null, start, start,
        null, null, null, null, null))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.create(req("http://not-https"))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.require(-1L)).isInstanceOf(NotFoundException.class);
  }

  @Test
  void memberSeesOpenWebinarsAndOnesTheyHoldASeatFor() {
    Person p = data.person(false);
    OffsetDateTime soon = OffsetDateTime.now().plusDays(1);
    Webinar open = data.webinar(WebinarAccessMode.OPEN, soon);
    Webinar assignedWithSeat = data.webinar(WebinarAccessMode.ASSIGNED, soon);
    Webinar assignedNoSeat = data.webinar(WebinarAccessMode.ASSIGNED, soon);
    Webinar past = data.webinar(WebinarAccessMode.OPEN, OffsetDateTime.now().minusDays(3));
    seats.saveAndFlush(new WebinarSeat(assignedWithSeat, p, null, SeatSource.ASSIGNED));

    assertThat(service.listForMember(p.getId(), OffsetDateTime.now()).stream().map(MemberWebinar::id))
        .contains(open.getId(), assignedWithSeat.getId())
        .doesNotContain(assignedNoSeat.getId(), past.getId());
  }
}
