package com.acme.rsvp.repository;

import com.acme.rsvp.model.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface PersonRepository extends JpaRepository<Person, Long> {
  Optional<Person> findByItsNumber(String itsNumber);
  Optional<Person> findByEmail(String email);
  boolean existsByItsNumber(String itsNumber);
  boolean existsByEmail(String email);

  @Query("SELECT p FROM Person p WHERE p.id NOT IN (SELECT o.person.id FROM ThaaliOrder o WHERE o.event.id = :eventId) ORDER BY p.firstName, p.lastName")
  List<Person> findWithoutOrderForEvent(@Param("eventId") Long eventId);

  @Query("SELECT p FROM Person p WHERE p.id NOT IN (SELECT r.person.id FROM NiyazRsvp r WHERE r.event.id = :eventId) ORDER BY p.firstName, p.lastName")
  List<Person> findWithoutRsvpForEvent(@Param("eventId") Long eventId);
}
