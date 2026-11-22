package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.acme.rsvp.dto.WebinarDtos.InviteLink;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.security.TokenHasher;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarInviteServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarInviteService invites;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarLaunchService launch;
  @Autowired WebinarJoinTokenRepository tokens;
  @Autowired TestData data;
  @MockitoBean EmailService email;

  private final OffsetDateTime now = OffsetDateTime.now();

  private Webinar webinar() {
    return data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
  }

  @Test
  void issueLinkStoresOnlyTheHashAndReissueRevokesTheOldLink() {
    Person p = data.person(false);
    Webinar w = webinar();
    WebinarSeat seat = seatService.giveSeat(w.getId(), p.getId(), null);

    String first = invites.issueLink(w.getId(), seat.getId(), now);
    assertThat(first).startsWith("http://localhost:5173/j/");
    String rawFirst = first.substring(first.lastIndexOf('/') + 1);
    assertThat(tokens.findByTokenHash(TokenHasher.sha256Hex(rawFirst))).isPresent();
    assertThat(tokens.findByTokenHash(rawFirst)).isEmpty();

    String second = invites.issueLink(w.getId(), seat.getId(), now);
    String rawSecond = second.substring(second.lastIndexOf('/') + 1);
    assertThatThrownBy(() -> launch.resolveToken(rawFirst, now)).isInstanceOf(NotFoundException.class);
    assertThat(launch.resolveToken(rawSecond, now).getSeat().getId()).isEqualTo(seat.getId());
  }

  @Test
  void issueLinkRejectsASeatFromAnotherWebinar() {
    Person p = data.person(false);
    WebinarSeat seat = seatService.giveSeat(webinar().getId(), p.getId(), null);
    assertThatThrownBy(() -> invites.issueLink(webinar().getId(), seat.getId(), now))
        .isInstanceOf(NotFoundException.class);
  }

  @Test
  @SuppressWarnings("unchecked")
  void sendsOneEmailPerFamilyAndHofWithoutASeatGetsOnlyFamilyLinks() {
    Person hof = data.person(true);
    FamilyMember fm1 = data.familyMember(hof);
    FamilyMember fm2 = data.familyMember(hof);
    Person member = data.person(false);
    Webinar w = webinar();
    seatService.giveSeat(w.getId(), hof.getId(), fm1.getId());
    seatService.giveSeat(w.getId(), hof.getId(), fm2.getId());
    seatService.giveSeat(w.getId(), member.getId(), null);

    when(email.sendWebinarInvite(any(), any(), any(), any(), any())).thenReturn(true);
    InviteResult result = invites.sendInvites(w.getId(), now);

    assertThat(result.sent()).isEqualTo(2);
    assertThat(result.skipped()).isEmpty();

    ArgumentCaptor<List<InviteLink>> hofLinks = ArgumentCaptor.forClass(List.class);
    verify(email).sendWebinarInvite(eq(hof.getEmail()), eq(w.getTitle()), any(), any(), hofLinks.capture());
    assertThat(hofLinks.getValue()).hasSize(2);
    assertThat(hofLinks.getValue()).extracting(InviteLink::label)
        .noneMatch(l -> l.equals("Your link"))
        .allMatch(l -> l.startsWith("Family Member ("));
    assertThat(hofLinks.getValue()).extracting(InviteLink::url).allMatch(u -> u.contains("/j/"));

    ArgumentCaptor<List<InviteLink>> memberLinks = ArgumentCaptor.forClass(List.class);
    verify(email).sendWebinarInvite(eq(member.getEmail()), any(), any(), any(), memberLinks.capture());
    assertThat(memberLinks.getValue()).singleElement()
        .satisfies(l -> assertThat(l.label()).isEqualTo("Your link"));
  }

  @Test
  void refusesToSendForAnUnpublishedWebinar() {
    Webinar w = webinar();
    w.setStatus(WebinarStatus.DRAFT);
    assertThatThrownBy(() -> invites.sendInvites(w.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("Publish");
  }

  @Test
  void falseFromEmailIsReportedAsSkipped() {
    Person a = data.person(false);
    Person b = data.person(false);
    Webinar w = webinar();
    seatService.giveSeat(w.getId(), a.getId(), null);
    seatService.giveSeat(w.getId(), b.getId(), null);
    when(email.sendWebinarInvite(eq(a.getEmail()), any(), any(), any(), any())).thenReturn(false);
    when(email.sendWebinarInvite(eq(b.getEmail()), any(), any(), any(), any())).thenReturn(true);

    InviteResult result = invites.sendInvites(w.getId(), now);

    assertThat(result.sent()).isEqualTo(1);
    assertThat(result.skipped()).singleElement().satisfies(m -> {
      assertThat(m).contains(a.getFirstName()).contains("email failed");
    });
  }

  @Test
  void exceptionFromEmailSkipsThatFamilyAndContinues() {
    Person a = data.person(false);
    Person b = data.person(false);
    Webinar w = webinar();
    seatService.giveSeat(w.getId(), a.getId(), null);
    seatService.giveSeat(w.getId(), b.getId(), null);
    when(email.sendWebinarInvite(eq(a.getEmail()), any(), any(), any(), any()))
        .thenThrow(new RuntimeException("boom"));
    when(email.sendWebinarInvite(eq(b.getEmail()), any(), any(), any(), any())).thenReturn(true);

    InviteResult result = invites.sendInvites(w.getId(), now);

    assertThat(result.sent()).isEqualTo(1);
    assertThat(result.skipped()).hasSize(1);
  }

  @Test
  @SuppressWarnings("unchecked")
  void sendingTwiceRevokesTheFirstRoundOfLinks() {
    Person p = data.person(false);
    Webinar w = webinar();
    seatService.giveSeat(w.getId(), p.getId(), null);
    when(email.sendWebinarInvite(any(), any(), any(), any(), any())).thenReturn(true);
    ArgumentCaptor<List<InviteLink>> links = ArgumentCaptor.forClass(List.class);

    invites.sendInvites(w.getId(), now);
    invites.sendInvites(w.getId(), now);

    verify(email, org.mockito.Mockito.times(2))
        .sendWebinarInvite(any(), any(), any(), any(), links.capture());
    String first = links.getAllValues().get(0).get(0).url();
    String second = links.getAllValues().get(1).get(0).url();
    String rawFirst = first.substring(first.lastIndexOf('/') + 1);
    String rawSecond = second.substring(second.lastIndexOf('/') + 1);
    assertThatThrownBy(() -> launch.resolveToken(rawFirst, now)).isInstanceOf(NotFoundException.class);
    assertThat(launch.resolveToken(rawSecond, now)).isNotNull();
  }
}
