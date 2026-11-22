package com.acme.rsvp.zoom;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/** Zoom Server-to-Server OAuth client. Read-only: it lists scheduled sessions and nothing else. */
@Component
public class ZoomClient {

  @JsonIgnoreProperties(ignoreUnknown = true)
  record TokenResponse(@JsonProperty("access_token") String accessToken,
      @JsonProperty("expires_in") long expiresIn) {}

  @JsonIgnoreProperties(ignoreUnknown = true)
  record Item(String id, String topic, @JsonProperty("start_time") OffsetDateTime startTime,
      Integer duration, @JsonProperty("join_url") String joinUrl) {}

  @JsonIgnoreProperties(ignoreUnknown = true)
  record ListResponse(List<Item> meetings, List<Item> webinars) {}

  private final ZoomProperties props;
  private final RestClient http;
  private String cachedToken;
  private OffsetDateTime cachedUntil;

  public ZoomClient(ZoomProperties props, RestClient.Builder builder) {
    this.props = props;
    this.http = builder.build();
  }

  public synchronized String accessToken(OffsetDateTime now) {
    requireConfigured();
    if (cachedToken == null || !now.isBefore(cachedUntil)) {
      TokenResponse t;
      try {
        t = http.post()
            .uri(props.oauthUrl() + "?grant_type=account_credentials&account_id={accountId}", props.accountId())
            .headers(h -> h.setBasicAuth(props.clientId(), props.clientSecret()))
            .retrieve()
            .body(TokenResponse.class);
      } catch (RestClientException e) {
        throw new IllegalStateException("Could not sign in to Zoom. Check the Zoom credentials.");
      }
      if (t == null || t.accessToken() == null) {
        throw new IllegalStateException("Zoom did not return an access token");
      }
      cachedToken = t.accessToken();
      cachedUntil = now.plusSeconds(Math.max(0, t.expiresIn() - 60)); // refresh a minute early
    }
    return cachedToken;
  }

  public List<ZoomMeeting> listScheduled(String kind, OffsetDateTime now) {
    requireConfigured();
    boolean webinars = "webinars".equals(kind);
    String userId = webinars && !props.webinarImportUserId().isBlank()
        ? props.webinarImportUserId() : props.importUserId();
    String path = webinars
        ? "/v2/users/{userId}/webinars?page_size=300"
        : "/v2/users/{userId}/meetings?type=scheduled&page_size=300";
    String token = accessToken(now);
    ListResponse response;
    try {
      response = http.get()
          .uri(props.baseUrl() + path, userId)
          .headers(h -> h.setBearerAuth(token))
          .retrieve()
          .body(ListResponse.class);
    } catch (RestClientException e) {
      throw new IllegalStateException("Could not read the schedule from Zoom. Please try again.");
    }
    List<Item> items = response == null ? null : webinars ? response.webinars() : response.meetings();
    if (items == null) return List.of();
    return items.stream()
        .filter(i -> i.id() != null && i.startTime() != null && i.joinUrl() != null && !i.joinUrl().isBlank())
        .map(i -> new ZoomMeeting(i.id(), i.topic(), i.startTime(),
            i.startTime().plusMinutes(i.duration() == null || i.duration() <= 0 ? 60 : i.duration()),
            i.joinUrl()))
        .toList();
  }

  private void requireConfigured() {
    if (!props.enabled() || props.accountId().isBlank() || props.clientId().isBlank()
        || props.clientSecret().isBlank()) {
      throw new IllegalStateException("Zoom integration is not configured");
    }
  }
}
