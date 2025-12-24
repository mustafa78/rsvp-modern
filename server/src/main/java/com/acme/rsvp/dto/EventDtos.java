package com.acme.rsvp.dto;

import com.acme.rsvp.model.EventStatus;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Set;

/**
 * Aggregated DTOs for Events to simplify imports and keep shapes consistent with EventService.
 *
 * - Requests are simple classes with public fields (so EventService can use req.field style).
 * - Responses use records for immutability.
 */
public final class EventDtos {

    private EventDtos() {}

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
        public Set<Long> chefIds;
        public Set<Long> hostIds; // Person IDs who are hosting this Niyaz
    }

    /* ============== THAALI ============== */
    public static class CreateUpdateThaaliEventRequest extends BaseEventReq {
        public Set<Long> chefIds;
        /** Menu assignment is catalog-backed: pick a dish and optional override + position. */
        public List<MenuAssignmentDto> menu;
    }

    /** Assign a Dish to a Thaali event. */
    public static record MenuAssignmentDto(
            Long dishId,
            BigDecimal quartsPerThaaliUnit, // null => use Dish.defaultQuartsPerThaaliUnit
            Integer position
    ) {}

    /* ============== READ MODELS ============== */

    public static record EventSummaryDto(
            Long id,
            String type,
            String title,
            String description,
            LocalDate eventDate,
            LocalTime startTime,
            OffsetDateTime registrationOpenAt,
            OffsetDateTime registrationCloseAt,
            EventStatus status,
            // Niyaz-specific field (null for Thaali)
            String miqaatName
    ) {}

    // Host info for Niyaz events
    public static record HostDto(
            Long id,
            String firstName,
            String lastName,
            String fullName
    ) {}

    public static record NiyazEventDto(
            Long id,
            String title,
            String description,
            LocalDate eventDate,
            LocalTime startTime,
            OffsetDateTime registrationOpenAt,
            OffsetDateTime registrationCloseAt,
            EventStatus status,
            String miqaatName,
            Set<Long> chefIds,
            Set<Long> hostIds,
            List<HostDto> hosts // Full host info for display
    ) {}

    public static record MenuItemIngredientDto(
            Long ingredientId,
            String ingredientName,
            String unit,
            BigDecimal qtyPerQuart
    ) {}

    public static record MenuItemDto(
            Long id,
            String name,
            String description,
            BigDecimal quartsPerThaaliUnit,
            List<MenuItemIngredientDto> ingredients,
            Long dishId,
            Integer position
    ) {}

    public static record ThaaliEventDto(
            Long id,
            String title,
            String description,
            LocalDate eventDate,
            LocalTime startTime,
            OffsetDateTime registrationOpenAt,
            OffsetDateTime registrationCloseAt,
            EventStatus status,
            List<MenuItemDto> menu,
            Set<Long> chefIds
    ) {}
}
