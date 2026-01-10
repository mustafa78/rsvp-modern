package com.acme.rsvp.repository;

import com.acme.rsvp.model.IngredientUnit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IngredientUnitRepository extends JpaRepository<IngredientUnit, Long> {
    List<IngredientUnit> findAllByActiveTrueOrderByDisplayOrderAscNameAsc();
    List<IngredientUnit> findAllByOrderByDisplayOrderAscNameAsc();
    boolean existsByNameIgnoreCase(String name);
}
