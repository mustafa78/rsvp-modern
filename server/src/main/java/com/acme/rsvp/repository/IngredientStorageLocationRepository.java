package com.acme.rsvp.repository;

import com.acme.rsvp.model.IngredientStorageLocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IngredientStorageLocationRepository extends JpaRepository<IngredientStorageLocation, Long> {
    List<IngredientStorageLocation> findAllByActiveTrueOrderByDisplayOrderAscNameAsc();
    List<IngredientStorageLocation> findAllByOrderByDisplayOrderAscNameAsc();
    boolean existsByNameIgnoreCase(String name);
}
