package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.dto.WebinarDtos.ZoomImportRequest;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.zoom.ZoomClient;
import com.acme.rsvp.zoom.ZoomMeeting;

class WebinarZoomSyncServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarZoomSyncService sync;
  @Autowired WebinarService webinarService;
  @MockitoBean ZoomClient zoom;

  private final OffsetDateTime start = OffsetDateTime.parse("2031-03-01T23:00:00Z");

  @Test
  void previewFlagsImportedRowsAndImportUpsertsWithoutDuplicates() {
    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of(
        new ZoomMeeting("555", "Majlis", start, start.plusMinutes(90), "https://zoom.us/j/555?pwd=first")));

    assertThat(sync.preview("meetings")).singleElement()
        .satisfies(r -> assertThat(r.alreadyImported()).isFalse());

    WebinarSummary created = sync.importOne(new ZoomImportRequest("meetings", "555", start, "OPEN"));
    assertThat(created.title()).isEqualTo("Majlis");
    assertThat(created.managedByZoom()).isTrue();
    assertThat(created.accessMode()).isEqualTo("OPEN");
    assertThat(created.status()).isEqualTo("DRAFT");
    assertThat(webinarService.require(created.id()).getJoinUrl()).isEqualTo("https://zoom.us/j/555?pwd=first");

    assertThat(sync.preview("meetings")).singleElement().satisfies(r -> assertThat(r.alreadyImported()).isTrue());

    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of(
        new ZoomMeeting("555", "Majlis (renamed)", start, start.plusMinutes(90), "https://zoom.us/j/555?pwd=second")));
    WebinarSummary updated = sync.importOne(new ZoomImportRequest("meetings", "555", start, null));
    assertThat(updated.id()).isEqualTo(created.id());
    assertThat(updated.title()).isEqualTo("Majlis (renamed)");
    assertThat(updated.accessMode()).isEqualTo("OPEN"); // unchanged when the request omits it
    assertThat(webinarService.require(created.id()).getJoinUrl()).endsWith("pwd=second");
  }

  @Test
  void importFailsCleanlyWhenTheSessionIsNoLongerOnZoom() {
    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of());
    assertThatThrownBy(() -> sync.importOne(new ZoomImportRequest("meetings", "555", start, "OPEN")))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not found");
  }
}
