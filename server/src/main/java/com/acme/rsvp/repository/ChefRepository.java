package com.acme.rsvp.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.Chef;

public interface ChefRepository extends JpaRepository<Chef, Long> {
	Optional<Chef> findByNameIgnoreCase(String name);
}
