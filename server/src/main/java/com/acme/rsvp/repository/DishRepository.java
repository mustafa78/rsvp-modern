package com.acme.rsvp.repository;
import com.acme.rsvp.model.Dish;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface DishRepository extends JpaRepository<Dish, Long> {
  Optional<Dish> findByNameIgnoreCase(String name);
}
