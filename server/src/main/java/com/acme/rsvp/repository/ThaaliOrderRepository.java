package com.acme.rsvp.repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.ThaaliOrder;

public interface ThaaliOrderRepository extends JpaRepository<ThaaliOrder, Long> {

    @Query("SELECT o FROM ThaaliOrder o WHERE o.event.id = :eventId AND o.person.id = :personId")
    Optional<ThaaliOrder> findByEventIdAndPersonId(@Param("eventId") Long eventId, @Param("personId") Long personId);

    @Query("SELECT o FROM ThaaliOrder o WHERE o.event.id = :eventId")
    List<ThaaliOrder> findByEventId(@Param("eventId") Long eventId);

    // Count orders by size using the new order items structure
    @Query(value = """
            SELECT COUNT(*) FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            WHERE o.event_id = :eventId AND oi.size = 'LARGE'
            """, nativeQuery = true)
    long totalLarge(@Param("eventId") Long eventId);

    @Query(value = """
            SELECT COUNT(*) FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            WHERE o.event_id = :eventId AND oi.size = 'SMALL'
            """, nativeQuery = true)
    long totalSmall(@Param("eventId") Long eventId);

    @Query(value = """
            SELECT COUNT(*) FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            WHERE o.event_id = :eventId AND oi.size = 'BARAKATI'
            """, nativeQuery = true)
    long totalBarakati(@Param("eventId") Long eventId);

    // Total quarts calculation based on order items
    @Query(value = """
            SELECT COALESCE(SUM(
                CASE oi.size
                    WHEN 'LARGE' THEN 1.0
                    WHEN 'SMALL' THEN 0.5
                    WHEN 'BARAKATI' THEN 0.25
                    ELSE 0
                END
            ), 0)
            FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            WHERE o.event_id = :eventId
            """, nativeQuery = true)
    BigDecimal totalQuarts(@Param("eventId") Long eventId);

    @Query(value = """
            SELECT COALESCE(SUM(COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit)),0)
            FROM menu_items mi
            JOIN dishes d ON d.id = mi.dish_id
            WHERE mi.event_id = :eventId
            """, nativeQuery = true)
    BigDecimal sumQuartsPerThaaliUnit(@Param("eventId") Long eventId);

    // Shopping list calculation: ingredient quantities per menu item and size
    @Query(value = """
            SELECT i.id AS ingredient_id,
                   i.name AS ingredient_name,
                   i.unit AS unit,
                   SUM(
                       di.qty_per_quart
                       * COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit)
                       * CASE oi.size
                           WHEN 'LARGE' THEN 1.0
                           WHEN 'SMALL' THEN 0.5
                           WHEN 'BARAKATI' THEN 0.25
                           ELSE 0
                         END
                   ) AS required_qty,
                   i.default_store AS default_store,
                   i.category AS category
            FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            JOIN menu_items mi ON mi.id = oi.menu_item_id
            JOIN dishes d ON d.id = mi.dish_id
            JOIN dish_ingredients di ON di.dish_id = d.id
            JOIN ingredients i ON i.id = di.ingredient_id
            WHERE o.event_id = :eventId
            GROUP BY i.id, i.name, i.unit, i.default_store, i.category
            ORDER BY COALESCE(i.default_store, 'ZZZ'), i.name
            """, nativeQuery = true)
    List<Object[]> shoppingList(@Param("eventId") Long eventId);

    // Count by menu item and size for detailed reporting
    @Query(value = """
            SELECT mi.id AS menu_item_id,
                   d.name AS dish_name,
                   oi.size AS size,
                   COUNT(*) AS count
            FROM thaali_order_items oi
            JOIN thaali_orders o ON o.id = oi.order_id
            JOIN menu_items mi ON mi.id = oi.menu_item_id
            JOIN dishes d ON d.id = mi.dish_id
            WHERE o.event_id = :eventId
            GROUP BY mi.id, d.name, oi.size
            ORDER BY mi.position, oi.size
            """, nativeQuery = true)
    List<Object[]> countsByMenuItemAndSize(@Param("eventId") Long eventId);
}
