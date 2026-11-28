package com.acme.rsvp.repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarJoinToken;

public interface WebinarJoinTokenRepository extends JpaRepository<WebinarJoinToken, UUID> {

  Optional<WebinarJoinToken> findByTokenHash(String tokenHash);

  List<WebinarJoinToken> findBySeatIdAndRevokedAtIsNull(Long seatId);

  @Query("SELECT t FROM WebinarJoinToken t WHERE t.revokedAt IS NULL AND t.seat.familyMember.id = :familyMemberId")
  List<WebinarJoinToken> findLiveByFamilyMemberId(@Param("familyMemberId") Long familyMemberId);

  /** Call inside a transaction. */
  default int revokeForSeat(Long seatId, OffsetDateTime now) {
    List<WebinarJoinToken> live = findBySeatIdAndRevokedAtIsNull(seatId);
    live.forEach(t -> t.setRevokedAt(now));
    return live.size();
  }

  /** Call inside a transaction. */
  default int revokeForFamilyMember(Long familyMemberId, OffsetDateTime now) {
    List<WebinarJoinToken> live = findLiveByFamilyMemberId(familyMemberId);
    live.forEach(t -> t.setRevokedAt(now));
    return live.size();
  }
}
