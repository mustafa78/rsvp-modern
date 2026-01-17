package com.acme.rsvp.repository;

import com.acme.rsvp.model.SessionToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.OffsetDateTime;
import java.util.Optional;
import java.util.UUID;

public interface SessionTokenRepository extends JpaRepository<SessionToken, UUID> {

  @Query("select t from SessionToken t join fetch t.person p left join fetch p.roles where t.id = :id and t.revoked = false and t.expiresAt > :now")
  Optional<SessionToken> findActive(@Param("id") UUID id, @Param("now") OffsetDateTime now);
}
