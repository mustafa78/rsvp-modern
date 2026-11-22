package com.acme.rsvp.web;

import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.service.WebinarInviteService;
import com.acme.rsvp.service.WebinarSeatService;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarApiTest extends PostgresIntegrationTest {

  @Autowired MockMvc mvc;
  @Autowired TestData data;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarInviteService invites;

  private final OffsetDateTime now = OffsetDateTime.now();

  private String rawTokenFor(Webinar w, WebinarSeat seat) {
    String link = invites.issueLink(w.getId(), seat.getId(), now);
    return link.substring(link.lastIndexOf('/') + 1);
  }

  @Test
  void adminEndpointsRejectPlainUsersAndAnonymous() throws Exception {
    Person user = data.person(true, "USER");
    mvc.perform(get("/api/webinars/admin").cookie(data.session(user))).andExpect(status().isForbidden());
    mvc.perform(get("/api/admin/family-members/hofs").param("search", "ab").cookie(data.session(user)))
        .andExpect(status().isForbidden());
    mvc.perform(get("/api/webinars/admin")).andExpect(status().isForbidden());
    mvc.perform(get("/api/webinars")).andExpect(status().isForbidden());
  }

  @Test
  void coordinatorCanCreateAndTheResponseNeverContainsTheJoinUrl() throws Exception {
    Person coord = data.person(false, "USER", "WEBINAR_COORDINATOR");
    String body = """
        {"title":"Majlis","hostName":"Host","scheduledStart":"2031-01-01T18:00:00Z",
         "scheduledEnd":"2031-01-01T19:00:00Z","status":"PUBLISHED","accessMode":"ASSIGNED",
         "joinUrl":"https://zoom.us/j/999?pwd=secretpwd"}
        """;
    mvc.perform(post("/api/webinars/admin").cookie(data.session(coord))
            .contentType(MediaType.APPLICATION_JSON).content(body))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.hasJoinUrl").value(true))
        .andExpect(jsonPath("$.joinUrl").doesNotExist())
        .andExpect(content().string(not(containsString("secretpwd"))));
    mvc.perform(get("/api/webinars/admin").cookie(data.session(coord)))
        .andExpect(status().isOk())
        .andExpect(content().string(not(containsString("secretpwd"))));
  }

  @Test
  void coordinatorManagesFamilyMembersSeatsLinksAndReport() throws Exception {
    Person coord = data.person(false, "USER", "WEBINAR_COORDINATOR");
    Person hof = data.person(true);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
    var session = data.session(coord);

    String fmBody = """
        {"hofPersonId":%d,"firstName":"Fatema","lastName":"Kanchwala","itsNumber":"%s","webinarId":%d}
        """.formatted(hof.getId(), TestData.nextIts(), w.getId());
    mvc.perform(post("/api/admin/family-members").cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content(fmBody))
        .andExpect(status().isOk()).andExpect(jsonPath("$.active").value(true));

    mvc.perform(get("/api/webinars/admin/{id}/seats", w.getId()).cookie(session))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$[0].personId").value(hof.getId()))
        .andExpect(jsonPath("$[0].ownSeatId").doesNotExist())
        .andExpect(jsonPath("$[0].family[0].seatId").isNumber());

    mvc.perform(post("/api/webinars/admin/{id}/seats", w.getId()).cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content("{\"personId\":" + hof.getId() + "}"))
        .andExpect(status().isOk());
    mvc.perform(post("/api/webinars/admin/{id}/seats", w.getId()).cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content("{\"personId\":" + hof.getId() + "}"))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.error").value(containsString("already has a seat")));

    mvc.perform(get("/api/webinars/admin/{id}/report", w.getId()).cookie(session))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.seatCount").value(2))
        .andExpect(jsonPath("$.joinedCount").value(0));

    mvc.perform(post("/api/webinars/admin/{id}/send-invites", w.getId()).cookie(session))
        .andExpect(status().isOk()).andExpect(jsonPath("$.sent").value(1));

    mvc.perform(delete("/api/webinars/admin/{id}", 999999L).cookie(session))
        .andExpect(status().isNotFound());
  }

  @Test
  void memberListAndLaunchRedirectToZoomOrBackWithAnError() throws Exception {
    Person member = data.person(false);
    Webinar live = data.webinar(WebinarAccessMode.OPEN, now.plusMinutes(5));
    Webinar noAccess = data.webinar(WebinarAccessMode.ASSIGNED, now.plusMinutes(5));
    var session = data.session(member);

    mvc.perform(get("/api/webinars").cookie(session))
        .andExpect(status().isOk())
        .andExpect(content().string(not(containsString("zoom.us"))));

    mvc.perform(get("/api/webinars/{id}/launch", live.getId()).cookie(session))
        .andExpect(status().isFound())
        .andExpect(header().string("Location",
            allOf(startsWith("https://zoom.us/j/123"), containsString("uname=" + member.getItsNumber()))));

    mvc.perform(get("/api/webinars/{id}/launch", noAccess.getId()).cookie(session))
        .andExpect(status().isFound())
        .andExpect(header().string("Location",
            allOf(startsWith("http://localhost:5173/webinars?joinError="), not(containsString("zoom.us")))));
  }

  @Test
  void magicLinkWorksWithoutLoginAndShowsWhoseSeatItIs() throws Exception {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar live = data.webinar(WebinarAccessMode.ASSIGNED, now.plusMinutes(5));
    String raw = rawTokenFor(live, seatService.giveSeat(live.getId(), hof.getId(), fm.getId()));

    mvc.perform(get("/api/webinars/public/{token}", raw))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.attendeeIts").value(fm.getItsNumber()))
        .andExpect(jsonPath("$.joinOpen").value(true))
        .andExpect(content().string(not(containsString("zoom.us"))));

    mvc.perform(get("/api/webinars/public/{token}/launch", raw))
        .andExpect(status().isFound())
        .andExpect(header().string("Location", containsString("uname=" + fm.getItsNumber())));

    mvc.perform(get("/api/webinars/public/{token}", "garbage")).andExpect(status().isNotFound());

    Webinar later = data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
    String early = rawTokenFor(later, seatService.giveSeat(later.getId(), hof.getId(), fm.getId()));
    mvc.perform(get("/api/webinars/public/{token}/launch", early))
        .andExpect(status().isFound())
        .andExpect(header().string("Location", startsWith("http://localhost:5173/j/" + early + "?joinError=")));
  }
}
