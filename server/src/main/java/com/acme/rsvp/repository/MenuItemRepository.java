package com.acme.rsvp.repository;

import com.acme.rsvp.model.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
  List<MenuItem> findByEventIdOrderByIdAsc(Long eventId);
}