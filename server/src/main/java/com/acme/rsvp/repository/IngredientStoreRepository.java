package com.acme.rsvp.repository;

import com.acme.rsvp.model.IngredientStore;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IngredientStoreRepository extends JpaRepository<IngredientStore, Long> {
    List<IngredientStore> findAllByActiveTrueOrderByDisplayOrderAscNameAsc();
    List<IngredientStore> findAllByOrderByDisplayOrderAscNameAsc();
    boolean existsByNameIgnoreCase(String name);
}
