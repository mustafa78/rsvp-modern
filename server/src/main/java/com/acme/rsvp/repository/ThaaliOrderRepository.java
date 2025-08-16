package com.acme.rsvp.repository;

import com.acme.rsvp.model.ThaaliOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;

public interface ThaaliOrderRepository extends JpaRepository<ThaaliOrder, Long> {

  boolean existsByEventIdAndPersonId(Long eventId, Long personId);

  List<ThaaliOrder> findByEventId(Long eventId);

  // Size counts for reports
  @Query("""
    select coalesce(sum(o.largeCount),0) from ThaaliOrder o
    where o.event.id = :eventId
  """)
  long totalLarge(Long eventId);

  @Query("""
    select coalesce(sum(o.smallCount),0) from ThaaliOrder o
    where o.event.id = :eventId
  """)
  long totalSmall(Long eventId);

  @Query("""
    select coalesce(sum(o.barakatiCount),0) from ThaaliOrder o
    where o.event.id = :eventId
  """)
  long totalBarakati(Long eventId);

  // Total quarts for a Thaali event
  @Query("""
    select
      ( coalesce(sum(o.largeCount),0) * 1.0
      + coalesce(sum(o.smallCount),0) * 0.5
      + coalesce(sum(o.barakatiCount),0) * 0.25 )
    from ThaaliOrder o
    where o.event.id = :eventId
  """)
  Double totalThaaliQuartsAsDouble(Long eventId);

  default BigDecimal totalThaaliQuarts(Long eventId) {
    Double d = totalThaaliQuartsAsDouble(eventId);
    return d == null ? BigDecimal.ZERO : new BigDecimal(String.valueOf(d));
  }

  // Shopping list: sum per ingredient across the event menu
  @Query("""
    select mi.ingredient.id as ingredientId,
           mi.ingredient.name as ingredientName,
           mi.ingredient.unit as unit,
           sum(mi.quantityPerQuart * (m.quartsPerThaaliUnit)) as qtyPerThaaliQuartUnit
    from MenuItemIngredient mi
    join mi.menuItem m
    where m.event.id = :eventId
    group by mi.ingredient.id, mi.ingredient.name, mi.ingredient.unit
  """)
  List<Object[]> ingredientPerThaaliUnit(Long eventId);
}