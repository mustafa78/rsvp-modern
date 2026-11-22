package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.security.TokenHasher;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarLaunchServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarLaunchService launch;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarJoinTokenRepository tokens;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired com.acme.rsvp.repository.WebinarRepository webinarRepo;
  @Autowired TestData data;

  private final OffsetDateTime now = OffsetDateTime.now();

  /** A webinar whose join window is open right now. */
  private Webinar live(WebinarAccessMode mode) {
    return data.webinar(mode, now.plusMinutes(5));
  }

  private String tokenFor(WebinarSeat seat) {
    String raw = TokenHasher.randomToken();
    tokens.saveAndFlush(new WebinarJoinToken(UUID.randomUUID(), seat, TokenHasher.sha256Hex(raw),
        now, seat.getWebinar().joinWindowEnd()));
    return raw;
  }

  @Test
  void appendDisplayNameReplacesExistingUnameAndKeepsOtherParams() {
    String url = WebinarLaunchService.appendDisplayName(
        "https://zoom.us/j/123?pwd=a%2Bb&uname=old#frag", "30702040 Fatema Kanchwala");
    assertThat(url).isEqualTo("https://zoom.us/j/123?pwd=a%2Bb&uname=30702040%20Fatema%20Kanchwala#frag");
    assertThat(WebinarLaunchService.appendDisplayName("https://zoom.us/j/123", "1 A B"))
        .isEqualTo("https://zoom.us/j/123?uname=1%20A%20B");
  }

  @Test
  void unparseableStoredLinkIsRefusedBeforeAnyJoinLogIsWritten() {
    Person member = data.person(false);
    Webinar w = live(WebinarAccessMode.OPEN);
    w.setJoinUrl("https://zoom.us/j/1 2?pwd=secretpwd");
    webinarRepo.saveAndFlush(w);

    assertThatThrownBy(() -> launch.launchForMember(w.getId(), member.getId(), now))
        .isInstanceOf(IllegalStateException.class)
        .hasMessageContaining("Zoom link is invalid")
        .hasMessageNotContaining("secretpwd");
    assertThat(logs.findByWebinarId(w.getId())).isEmpty();
  }

  @Test
  void tokenHasherProducesStableHashAndRandomTokens() {
    assertThat(TokenHasher.sha256Hex("abc"))
        .isEqualTo("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
    assertThat(TokenHasher.randomToken()).hasSize(43).isNotEqualTo(TokenHasher.randomToken());
  }

  @Test
  void memberOnOpenWebinarGetsASeatALogAndTheirNameInTheUrl() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.OPEN);
    String url = launch.launchForMember(w.getId(), p.getId(), now);
    assertThat(url).startsWith("https://zoom.us/j/123?pwd=abc&uname=" + p.getItsNumber() + "%20");
    assertThat(logs.findByWebinarId(w.getId())).singleElement()
        .satisfies(l -> assertThat(l.getSource()).isEqualTo(JoinSource.PORTAL));
  }

  @Test
  void memberWithoutASeatOnAssignedWebinarIsRefused() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    assertThatThrownBy(() -> launch.launchForMember(w.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("do not have access");
  }

  @Test
  void refusesOutsideTheWindowAndWhenNotPublished() {
    Person p = data.person(false);
    Webinar future = data.webinar(WebinarAccessMode.OPEN, now.plusDays(1));
    assertThatThrownBy(() -> launch.launchForMember(future.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not open for joining yet");

    Webinar draft = live(WebinarAccessMode.OPEN);
    draft.setStatus(WebinarStatus.DRAFT);
    assertThatThrownBy(() -> launch.launchForMember(draft.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not available");

    Webinar noLink = live(WebinarAccessMode.OPEN);
    noLink.setJoinUrl(null);
    assertThatThrownBy(() -> launch.launchForMember(noLink.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("no Zoom link");
  }

  @Test
  void familyLinkJoinsAsTheFamilyMemberAndCountsUse() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), hof.getId(), fm.getId());
    String raw = tokenFor(seat);

    String url = launch.launchForToken(raw, now);

    assertThat(url).contains("uname=" + fm.getItsNumber() + "%20Family%20Member");
    WebinarJoinToken t = tokens.findByTokenHash(TokenHasher.sha256Hex(raw)).orElseThrow();
    assertThat(t.getUseCount()).isEqualTo(1);
    assertThat(logs.findByWebinarId(w.getId())).singleElement()
        .satisfies(l -> assertThat(l.getSource()).isEqualTo(JoinSource.MAGIC_LINK));
  }

  @Test
  void unknownRevokedAndClosedWindowTokensAreNotFound() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), p.getId(), null);
    String raw = tokenFor(seat);

    assertThatThrownBy(() -> launch.resolveToken("garbage", now)).isInstanceOf(NotFoundException.class);
    assertThatThrownBy(() -> launch.resolveToken(raw, w.joinWindowEnd().plusSeconds(1)))
        .isInstanceOf(NotFoundException.class);

    tokens.revokeForSeat(seat.getId(), now);
    assertThatThrownBy(() -> launch.launchForToken(raw, now)).isInstanceOf(NotFoundException.class);
  }

  @Test
  void disabledHofBlocksTheFamilySeatAndDeactivatedMemberIsBlocked() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), hof.getId(), fm.getId());
    String raw = tokenFor(seat);

    fm.setActive(false);
    assertThatThrownBy(() -> launch.launchForToken(raw, now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("no longer active");

    fm.setActive(true);
    hof.setAccountStatus(AccountStatus.DISABLED);
    assertThatThrownBy(() -> launch.launchForToken(raw, now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("account is not active");
  }

  @Test
  void oneWebinarAtATimePerAttendeeButFamilyMembersAreIndependent() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar a = live(WebinarAccessMode.OPEN);
    Webinar b = live(WebinarAccessMode.OPEN);
    WebinarSeat familyOnB = seatService.giveSeat(b.getId(), hof.getId(), fm.getId());

    launch.launchForMember(a.getId(), hof.getId(), now);
    launch.launchForMember(a.getId(), hof.getId(), now.plusMinutes(1)); // rejoin same webinar is fine

    assertThatThrownBy(() -> launch.launchForMember(b.getId(), hof.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("another webinar");

    // The family member is a different attendee and is not blocked by the HOF's lock.
    assertThat(launch.launchForToken(tokenFor(familyOnB), now)).contains("uname=");
    assertThat(logs.findByWebinarId(a.getId())).hasSize(2);
  }

  @Test
  void attendeeCanJoinTheNextWebinarOnceTheFirstHasReachedItsScheduledEnd() {
    Person p = data.person(false);
    // A ran from 70 to 10 minutes ago; its late-join allowance (15 min after the end) is still open.
    Webinar a = data.webinar(WebinarAccessMode.OPEN, now.minusMinutes(70));
    Webinar b = live(WebinarAccessMode.OPEN);
    assertThat(a.isJoinOpen(now)).isTrue();

    launch.launchForMember(a.getId(), p.getId(), now.minusMinutes(30));

    assertThat(launch.launchForMember(b.getId(), p.getId(), now)).contains("uname=");
    assertThat(logs.findByWebinarId(b.getId())).hasSize(1);
  }

  @Test
  void cancellingTheJoinedWebinarReleasesTheAttendee() {
    Person p = data.person(false);
    Webinar a = live(WebinarAccessMode.OPEN);
    Webinar b = live(WebinarAccessMode.OPEN);
    launch.launchForMember(a.getId(), p.getId(), now);

    a.setStatus(WebinarStatus.CANCELLED);
    webinarRepo.saveAndFlush(a);

    assertThat(launch.launchForMember(b.getId(), p.getId(), now)).contains("uname=");
  }

  @Test
  void movingTheJoinedWebinarsEndIntoThePastReleasesTheAttendee() {
    Person p = data.person(false);
    Webinar a = live(WebinarAccessMode.OPEN);
    Webinar b = live(WebinarAccessMode.OPEN);
    launch.launchForMember(a.getId(), p.getId(), now);

    a.setScheduledStart(now.minusMinutes(60));
    a.setScheduledEnd(now.minusMinutes(1));
    webinarRepo.saveAndFlush(a);

    assertThat(launch.launchForMember(b.getId(), p.getId(), now)).contains("uname=");
  }
}
