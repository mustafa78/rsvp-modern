package com.acme.rsvp.migration;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class V37MigrationTest extends PostgresIntegrationTest {

  @Autowired JdbcTemplate jdbc;
  @Autowired TestData data;

  @Test
  void tablesAndRoleExist() {
    for (String t : new String[] {"webinars", "family_members", "webinar_seats",
        "webinar_join_tokens", "webinar_join_logs", "webinar_active_locks"}) {
      Integer n = jdbc.queryForObject(
          "select count(*) from information_schema.tables where table_name = ?", Integer.class, t);
      assertThat(n).as(t).isEqualTo(1);
    }
    assertThat(jdbc.queryForObject(
        "select count(*) from roles where name = 'WEBINAR_COORDINATOR'", Integer.class)).isEqualTo(1);
  }

  @Test
  void eventsTableIsUntouched() {
    Integer n = jdbc.queryForObject(
        "select count(*) from information_schema.columns where table_name = 'events' "
            + "and column_name in ('join_url','zoom_meeting_id','scheduled_start')", Integer.class);
    assertThat(n).isZero();
  }

  @Test
  void aPersonCanHoldOnlyOneOwnSeatPerWebinar() {
    Person p = data.person(true);
    Long w = jdbc.queryForObject(
        "insert into webinars (title, scheduled_start, scheduled_end) "
            + "values ('T', now(), now() + interval '1 hour') returning id", Long.class);
    jdbc.update("insert into webinar_seats (webinar_id, person_id, source) values (?,?,'ASSIGNED')", w, p.getId());
    assertThatThrownBy(() -> jdbc.update(
        "insert into webinar_seats (webinar_id, person_id, source) values (?,?,'ASSIGNED')", w, p.getId()))
        .isInstanceOf(DataIntegrityViolationException.class);
  }
}
