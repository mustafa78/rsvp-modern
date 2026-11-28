package com.acme.rsvp.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;

import jakarta.persistence.LockModeType;

import com.acme.rsvp.model.WebinarActiveLock;

public interface WebinarActiveLockRepository extends JpaRepository<WebinarActiveLock, Long> {
  // Row lock serialises concurrent launches by the same attendee.
  @Lock(LockModeType.PESSIMISTIC_WRITE)
  Optional<WebinarActiveLock> findByPersonIdAndFamilyMemberIsNull(Long personId);
  @Lock(LockModeType.PESSIMISTIC_WRITE)
  Optional<WebinarActiveLock> findByFamilyMemberId(Long familyMemberId);
}
