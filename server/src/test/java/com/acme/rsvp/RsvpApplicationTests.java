package com.acme.rsvp;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class RsvpApplicationTests extends PostgresIntegrationTest {

  @Autowired TestData data;

  @Test
  void contextLoadsAndAllMigrationsApply() {
    Person p = data.person(true);
    assertThat(p.getId()).isNotNull();
    assertThat(data.session(p).getValue()).isNotBlank();
  }
}
