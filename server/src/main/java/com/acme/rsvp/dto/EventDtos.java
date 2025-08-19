package com.acme.rsvp.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Set;

import com.acme.rsvp.model.EventStatus;

/**
 * Aggregated DTOs for Events to simplify imports and keep shapes consistent
 * with EventService.
 *
 * - Requests are simple classes with public fields (so EventService can use
 * req.field style). - Responses use records for immutability.
 */
public final class EventDtos {

	private EventDtos() {
	}

	/* ============== Base Request ============== */
	public static class BaseEventReq {
		public String title;
		public String description;
		public LocalDate eventDate;
		public LocalTime startTime;
		public OffsetDateTime registrationOpenAt;
		public OffsetDateTime registrationCloseAt;
		public EventStatus status;
	}

	/* ============== NIYAZ ============== */
	public static class CreateUpdateNiyazEventRequest extends BaseEventReq {
		public String miqaatName;
		public LocalDate miqaatDate;
		public LocalTime miqaatTime;
		public Set<Long> chefIds;
	}

	/* ============== THAALI ============== */
	public static class CreateUpdateThaaliEventRequest extends BaseEventReq {
		public Set<Long> chefIds;
		/**
		 * Menu assignment is catalog-backed: pick a dish and optional override +
		 * position.
		 */
		public List<MenuAssignmentDto> menu;
	}

	/** Assign a Dish to a Thaali event. */
	public static record MenuAssignmentDto(Long dishId, BigDecimal quartsPerThaaliUnit, // null => use
																						// Dish.defaultQuartsPerThaaliUnit
			Integer position) {
	}

	/* ============== READ MODELS ============== */

	public static record EventSummaryDto(Long id, String type, String title, String description, LocalDate eventDate,
			LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt,
			EventStatus status) {
	}

	public static record NiyazEventDto(Long id, String title, String description, LocalDate eventDate,
			LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt,
			EventStatus status, String miqaatName, LocalDate miqaatDate, LocalTime miqaatTime, Set<Long> chefIds) {
	}

	public static record MenuItemIngredientDto(Long ingredientId, String ingredientName, String unit,
			BigDecimal qtyPerQuart) {
	}

	public static record MenuItemDto(Long id, String name, String description, BigDecimal quartsPerThaaliUnit,
			List<MenuItemIngredientDto> ingredients, Long dishId, Integer position) {
	}

	public static record ThaaliEventDto(Long id, String title, String description, LocalDate eventDate,
			LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt,
			EventStatus status, List<MenuItemDto> menu, Set<Long> chefIds) {
	}
}
