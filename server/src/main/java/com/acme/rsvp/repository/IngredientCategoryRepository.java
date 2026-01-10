package com.acme.rsvp.repository;

import com.acme.rsvp.model.IngredientCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IngredientCategoryRepository extends JpaRepository<IngredientCategory, Long> {
    List<IngredientCategory> findAllByActiveTrueOrderByDisplayOrderAscNameAsc();
    List<IngredientCategory> findAllByOrderByDisplayOrderAscNameAsc();
    boolean existsByNameIgnoreCase(String name);
}
