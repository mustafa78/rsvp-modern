package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.MenuItem;

public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
	void deleteByEvent_Id(Long eventId);
	
	List<MenuItem> findByEvent_IdOrderByPositionAsc(Long eventId);
}
