package com.acme.rsvp.repository;

import com.acme.rsvp.model.ThaaliEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface ThaaliEventRepository extends JpaRepository<ThaaliEvent, Long> {

    @Query("SELECT t FROM ThaaliEvent t LEFT JOIN FETCH t.chefs WHERE t.id = :id")
    Optional<ThaaliEvent> findByIdWithChefs(Long id);
}