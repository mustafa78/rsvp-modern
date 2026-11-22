package com.acme.rsvp.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.WebinarActiveLock;

public interface WebinarActiveLockRepository extends JpaRepository<WebinarActiveLock, Long> {
  Optional<WebinarActiveLock> findByPersonIdAndFamilyMemberIsNull(Long personId);
  Optional<WebinarActiveLock> findByFamilyMemberId(Long familyMemberId);
}
