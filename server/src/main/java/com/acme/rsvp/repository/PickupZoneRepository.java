package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.PickupZone;

public interface PickupZoneRepository extends JpaRepository<PickupZone, Long> {
	List<PickupZone> findAllByActiveTrueOrderByNameAsc();
}