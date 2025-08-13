package com.acme.rsvp.repository;

import com.acme.rsvp.model.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PersonRepository extends JpaRepository<Person, Long> {
  Optional<Person> findByEmail(String email);
}
