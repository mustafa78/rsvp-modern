package com.acme.rsvp.support;

import java.time.OffsetDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.FamilyMemberRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.SessionTokenRepository;
import com.acme.rsvp.repository.WebinarRepository;

import jakarta.servlet.http.Cookie;

/** Builders for test fixtures. ITS numbers start with 9 so they cannot clash with seeded users. */
@Component
public class TestData {

  private static final AtomicInteger SEQ = new AtomicInteger(1000);

  @Autowired PersonRepository persons;
  @Autowired SessionTokenRepository sessions;
  @Autowired WebinarRepository webinars;
  @Autowired FamilyMemberRepository familyMembers;

  public static String nextIts() {
    return "9" + String.format("%07d", SEQ.incrementAndGet());
  }

  public Person person(boolean hof, String... roles) {
    String its = nextIts();
    Person p = new Person();
    p.setItsNumber(its);
    p.setFirstName("Test");
    p.setLastName("User" + its);
    p.setEmail("test" + its + "@example.com");
    p.setPasswordHash("x");
    p.setHof(hof);
    p.setRoles(new HashSet<>(roles.length == 0 ? List.of("USER") : List.of(roles)));
    return persons.saveAndFlush(p);
  }

  public Cookie session(Person p) {
    OffsetDateTime now = OffsetDateTime.now();
    SessionToken t = new SessionToken(UUID.randomUUID(), p, now, now.plusHours(1));
    sessions.saveAndFlush(t);
    return new Cookie("RSVP_SESSION", t.getId().toString());
  }

  /** A published, one-hour webinar with a join URL. */
  public Webinar webinar(WebinarAccessMode mode, OffsetDateTime start) {
    Webinar w = new Webinar();
    w.setTitle("Test Meeting");
    w.setHostName("Host");
    w.setScheduledStart(start);
    w.setScheduledEnd(start.plusHours(1));
    w.setStatus(WebinarStatus.PUBLISHED);
    w.setAccessMode(mode);
    w.setJoinUrl("https://zoom.us/j/123?pwd=abc");
    return webinars.saveAndFlush(w);
  }

  public FamilyMember familyMember(Person hof) {
    FamilyMember fm = new FamilyMember();
    fm.setHof(hof);
    fm.setFirstName("Family");
    fm.setLastName("Member");
    fm.setItsNumber(nextIts());
    return familyMembers.saveAndFlush(fm);
  }
}
