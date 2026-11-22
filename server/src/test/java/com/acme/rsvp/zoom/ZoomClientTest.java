package com.acme.rsvp.zoom;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.ExpectedCount.once;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

class ZoomClientTest {

  private static final ZoomProperties PROPS = new ZoomProperties(true, "acct", "cid", "secret",
      "me", "", "https://zoom.us/oauth/token", "https://api.zoom.us", "FMB");

  private final OffsetDateTime now = OffsetDateTime.parse("2030-01-01T00:00:00Z");

  @Test
  void tokenIsFetchedOnceAndReusedUntilItNearsExpiry() {
    RestClient.Builder builder = RestClient.builder();
    MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
    server.expect(once(), requestTo("https://zoom.us/oauth/token?grant_type=account_credentials&account_id=acct"))
        .andExpect(method(HttpMethod.POST))
        .andExpect(header("Authorization", "Basic Y2lkOnNlY3JldA=="))
        .andRespond(withSuccess("{\"access_token\":\"tok1\",\"expires_in\":3600}", MediaType.APPLICATION_JSON));
    ZoomClient client = new ZoomClient(PROPS, builder);

    assertThat(client.accessToken(now)).isEqualTo("tok1");
    assertThat(client.accessToken(now.plusMinutes(30))).isEqualTo("tok1");
    server.verify();
  }

  @Test
  void listsScheduledMeetingsAndSkipsItemsWithoutAStartOrJoinUrl() {
    RestClient.Builder builder = RestClient.builder();
    MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
    server.expect(requestTo("https://zoom.us/oauth/token?grant_type=account_credentials&account_id=acct"))
        .andRespond(withSuccess("{\"access_token\":\"tok1\",\"expires_in\":3600}", MediaType.APPLICATION_JSON));
    server.expect(requestTo("https://api.zoom.us/v2/users/me/meetings?type=scheduled&page_size=300"))
        .andExpect(header("Authorization", "Bearer tok1"))
        .andRespond(withSuccess("""
            {"meetings":[
              {"id":8123456789,"topic":"Majlis","start_time":"2030-02-01T23:00:00Z","duration":90,
               "join_url":"https://zoom.us/j/8123456789?pwd=x","extra":"ignored"},
              {"id":1,"topic":"No fixed time","duration":60,"join_url":"https://zoom.us/j/1"},
              {"id":2,"topic":"No link","start_time":"2030-02-02T23:00:00Z","duration":60}
            ]}
            """, MediaType.APPLICATION_JSON));
    ZoomClient client = new ZoomClient(PROPS, builder);

    List<ZoomMeeting> meetings = client.listScheduled("meetings", now);

    assertThat(meetings).singleElement().satisfies(m -> {
      assertThat(m.id()).isEqualTo("8123456789");
      assertThat(m.topic()).isEqualTo("Majlis");
      assertThat(m.start().isEqual(OffsetDateTime.parse("2030-02-01T23:00:00Z"))).isTrue();
      assertThat(m.end().isEqual(OffsetDateTime.parse("2030-02-02T00:30:00Z"))).isTrue();
      assertThat(m.joinUrl()).isEqualTo("https://zoom.us/j/8123456789?pwd=x");
    });
    server.verify();
  }

  @Test
  void refusesWhenTheIntegrationIsNotConfigured() {
    ZoomProperties off = new ZoomProperties(false, "", "", "", "", "",
        "https://zoom.us/oauth/token", "https://api.zoom.us", "FMB");
    ZoomClient client = new ZoomClient(off, RestClient.builder());
    assertThatThrownBy(() -> client.listScheduled("meetings", now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not configured");
  }
}
