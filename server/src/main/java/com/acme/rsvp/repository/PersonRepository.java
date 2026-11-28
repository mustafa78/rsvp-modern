package com.acme.rsvp.repository;

import com.acme.rsvp.model.Person;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface PersonRepository extends JpaRepository<Person, Long> {
  Optional<Person> findByItsNumber(String itsNumber);
  Optional<Person> findByEmail(String email);
  boolean existsByItsNumber(String itsNumber);
  boolean existsByEmail(String email);

  // Eligible-for-registration filter (used by the admin "Add Thaali" / "Add RSVP" pickers):
  //   - Head of Family only (only HOF users can hold a registration)
  //   - ACTIVE account status (excludes LOCKED / DISABLED)
  //   - access not expired — mirrors Person.isExpired(): REGISTERED never expires,
  //     STUDENT / MEHMAAN are excluded once accountExpiresAt has passed.
  @Query("""
      SELECT p FROM Person p
      WHERE p.id NOT IN (SELECT o.person.id FROM ThaaliOrder o WHERE o.event.id = :eventId)
        AND p.hof = true
        AND p.accountStatus = com.acme.rsvp.model.AccountStatus.ACTIVE
        AND (p.userType = com.acme.rsvp.model.UserType.REGISTERED
             OR p.accountExpiresAt IS NULL
             OR p.accountExpiresAt > :now)
      ORDER BY p.firstName, p.lastName
      """)
  List<Person> findWithoutOrderForEvent(@Param("eventId") Long eventId, @Param("now") Instant now);

  @Query("""
      SELECT p FROM Person p
      WHERE p.id NOT IN (SELECT r.person.id FROM NiyazRsvp r WHERE r.event.id = :eventId)
        AND p.hof = true
        AND p.accountStatus = com.acme.rsvp.model.AccountStatus.ACTIVE
        AND (p.userType = com.acme.rsvp.model.UserType.REGISTERED
             OR p.accountExpiresAt IS NULL
             OR p.accountExpiresAt > :now)
      ORDER BY p.firstName, p.lastName
      """)
  List<Person> findWithoutRsvpForEvent(@Param("eventId") Long eventId, @Param("now") Instant now);

  // Active, non-expired people matching a name or ITS prefix. Not limited to HOFs.
  @Query("""
      SELECT p FROM Person p
      WHERE p.accountStatus = com.acme.rsvp.model.AccountStatus.ACTIVE
        AND (p.userType = com.acme.rsvp.model.UserType.REGISTERED
             OR p.accountExpiresAt IS NULL
             OR p.accountExpiresAt > :now)
        AND (LOWER(CONCAT(p.firstName, ' ', p.lastName)) LIKE LOWER(CONCAT('%', :search, '%'))
             OR p.itsNumber LIKE CONCAT(:search, '%'))
      ORDER BY p.firstName, p.lastName
      """)
  List<Person> searchActive(@Param("search") String search, @Param("now") Instant now, Pageable pageable);
}
