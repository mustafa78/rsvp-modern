package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.FamilyMember;

public interface FamilyMemberRepository extends JpaRepository<FamilyMember, Long> {
  List<FamilyMember> findByHofIdOrderByFirstNameAscLastNameAsc(Long hofPersonId);
  boolean existsByItsNumber(String itsNumber);
  boolean existsByItsNumberAndIdNot(String itsNumber, Long id);
  long countByHofIdAndActiveTrue(Long hofPersonId);

  @Query("""
      SELECT f FROM FamilyMember f JOIN FETCH f.hof h
      WHERE f.active = true
        AND (LOWER(CONCAT(f.firstName, ' ', f.lastName)) LIKE LOWER(CONCAT('%', :search, '%'))
             OR f.itsNumber LIKE CONCAT(:search, '%'))
      ORDER BY f.firstName, f.lastName
      """)
  List<FamilyMember> searchActive(@Param("search") String search, Pageable pageable);
}
