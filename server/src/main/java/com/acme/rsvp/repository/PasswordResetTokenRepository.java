package com.acme.rsvp.repository;

import com.acme.rsvp.model.PasswordResetToken;
import com.acme.rsvp.model.Person;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, UUID> {
  Optional<PasswordResetToken> findByIdAndUsedAtIsNullAndExpiresAtAfter(UUID id, OffsetDateTime now);
  List<PasswordResetToken> findByPersonAndUsedAtIsNull(Person person);
}
