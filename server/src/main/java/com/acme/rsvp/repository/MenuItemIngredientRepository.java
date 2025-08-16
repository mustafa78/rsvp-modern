package com.acme.rsvp.repository;

import com.acme.rsvp.model.MenuItemIngredient;
import com.acme.rsvp.model.MenuItemIngredientId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemIngredientRepository extends JpaRepository<MenuItemIngredient, MenuItemIngredientId> {
  List<MenuItemIngredient> findByMenuItemEventId(Long eventId);
}