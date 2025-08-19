package com.acme.rsvp.repository;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.ThaaliOrder;

public interface ThaaliOrderRepository extends JpaRepository<ThaaliOrder, Long> {

	@Query(value = "SELECT COALESCE(SUM(large_count),0) FROM thaali_orders WHERE event_id = :eventId", nativeQuery = true)
	long totalLarge(@Param("eventId") Long eventId);

	@Query(value = "SELECT COALESCE(SUM(small_count),0) FROM thaali_orders WHERE event_id = :eventId", nativeQuery = true)
	long totalSmall(@Param("eventId") Long eventId);

	@Query(value = "SELECT COALESCE(SUM(barakati_count),0) FROM thaali_orders WHERE event_id = :eventId", nativeQuery = true)
	long totalBarakati(@Param("eventId") Long eventId);

	@Query(value = """
			SELECT COALESCE(SUM(COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit)),0)
			FROM menu_items mi
			JOIN dishes d ON d.id = mi.dish_id
			WHERE mi.event_id = :eventId
	""", nativeQuery = true)
	BigDecimal sumQuartsPerThaaliUnit(@Param("eventId") Long eventId);

	@Query(value = """   
			SELECT i.id AS ingredient_id,
				i.name AS ingredient_name,
				i.unit AS unit,
				SUM(di.qty_per_quart * COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit)) AS qty_per_thaali_unit    
			FROM menu_items mi    
			JOIN dishes d ON d.id = mi.dish_id    
			JOIN dish_ingredients di ON di.dish_id = d.id    
			JOIN ingredients i ON i.id = di.ingredient_id    
			WHERE mi.event_id = :eventId    
			GROUP BY i.id, i.name, i.unit  
	""", nativeQuery = true)
	List<Object[]> ingredientPerThaaliUnit(@Param("eventId") Long eventId);

	@Query(value = """    
			WITH units AS (      
				SELECT (COALESCE(SUM(large_count),0) + 0.5*COALESCE(SUM(small_count),0) + 0.25*COALESCE(SUM(barakati_count),0)) AS u      
				FROM thaali_orders 
				WHERE event_id = :eventId    
			),    
			qptu AS (      
				SELECT COALESCE(SUM(COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit)),0) AS q      
				FROM menu_items mi JOIN dishes d ON d.id = mi.dish_id WHERE mi.event_id = :eventId    
			)    
			SELECT (SELECT u FROM units) * (SELECT q FROM qptu)  
	""")
	BigDecimal totalThaaliQuarts(@Param("eventId") Long eventId);
}
