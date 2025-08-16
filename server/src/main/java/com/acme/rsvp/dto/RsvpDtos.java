package com.acme.rsvp.dto;

import com.acme.rsvp.model.PickupZone;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

public class RsvpDtos {
  public record NiyazRsvpDto(Long eventId, Long personId, @Min(0) int adults, @Min(0) int kids) {}
  public record ThaaliOrderDto(Long eventId, Long personId, @Min(0) int largeCount, @Min(0) int smallCount, @Min(0) int barakatiCount, PickupZone pickupZone, String notes) {}
  public record ThaaliCountReportDto(long large, long small, long barakati, BigDecimal totalQuarts) {}
  public record ShoppingListItemDto(Long ingredientId, String ingredientName, String unit, BigDecimal requiredQty) {}
  public record RegistrationWindowStatus(boolean open) {}
  public record MessageDto(String message) {}
}
