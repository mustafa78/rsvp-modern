package com.acme.rsvp.dto;

import com.acme.rsvp.model.EventStatus;
import jakarta.validation.constraints.*;
import java.time.*;
import java.util.*;
import java.math.BigDecimal;

public class EventDtos {

  public static abstract class BaseEventReq {
    @NotBlank public String title;
    public String description;
    @NotNull public LocalDate eventDate;
    public LocalTime startTime;
    @NotNull public OffsetDateTime registrationOpenAt;
    @NotNull public OffsetDateTime registrationCloseAt;
    public EventStatus status = EventStatus.DRAFT;
    public Set<Long> chefIds = new HashSet<>();
  }

  public static class CreateUpdateNiyazEventRequest extends BaseEventReq {
    @NotBlank public String miqaatName;
    @NotNull public LocalDate miqaatDate;
    public LocalTime miqaatTime;
  }

  public static class CreateUpdateThaaliEventRequest extends BaseEventReq {
    public List<MenuItemDto> menu = new ArrayList<>();
  }

  public record EventSummaryDto(Long id, String type, String title, String description, LocalDate eventDate, LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt, EventStatus status) {}
  public record NiyazEventDto(Long id, String title, String description, LocalDate eventDate, LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt, EventStatus status, String miqaatName, LocalDate miqaatDate, LocalTime miqaatTime, Set<Long> chefIds) {}
  public record ThaaliEventDto(Long id, String title, String description, LocalDate eventDate, LocalTime startTime, OffsetDateTime registrationOpenAt, OffsetDateTime registrationCloseAt, EventStatus status, List<MenuItemDto> menu, Set<Long> chefIds) {}

  public record MenuItemDto(Long id, String name, String description, BigDecimal quartsPerThaaliUnit, List<MenuItemIngredientDto> ingredients) {}
  public record MenuItemIngredientDto(Long ingredientId, String ingredientName, String unit, BigDecimal qtyPerQuart) {}
}
