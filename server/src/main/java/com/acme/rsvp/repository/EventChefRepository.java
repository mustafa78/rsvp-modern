package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.EventChef;
import com.acme.rsvp.model.EventChefId;

public interface EventChefRepository extends JpaRepository<EventChef, EventChefId> {
	List<EventChef> findByEvent_Id(Long eventId);

	void deleteByEvent_Id(Long eventId);
}
