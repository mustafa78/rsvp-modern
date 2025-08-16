package com.acme.rsvp.repository;

import com.acme.rsvp.model.ThaaliEvent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ThaaliEventRepository extends JpaRepository<ThaaliEvent, Long> {}