package com.acme.rsvp.repository;
import com.acme.rsvp.model.DishIngredient;
import com.acme.rsvp.model.DishIngredientId;
import org.springframework.data.jpa.repository.JpaRepository;
public interface DishIngredientRepository extends JpaRepository<DishIngredient, DishIngredientId> {}
