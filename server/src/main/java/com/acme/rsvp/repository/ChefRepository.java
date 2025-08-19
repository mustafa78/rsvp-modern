package com.acme.rsvp.repository;
import com.acme.rsvp.model.Chef;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface ChefRepository extends JpaRepository<Chef, Long> {
  Optional<Chef> findByNameIgnoreCase(String name);
}
