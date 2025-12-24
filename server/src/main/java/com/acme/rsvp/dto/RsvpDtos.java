package com.acme.rsvp.dto;

import com.acme.rsvp.model.MealSize;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

public class RsvpDtos {

    // Niyaz RSVP DTOs
    public record NiyazRsvpDto(
            Long eventId,
            Long personId,
            @Min(0) int adults,
            @Min(0) int kids) {
    }

    // Thaali Order DTOs - new structure with order items
    public record ThaaliOrderItemDto(
            Long menuItemId,
            String dishName, // For display purposes in responses
            @NotNull MealSize size) {
    }

    public record ThaaliOrderDto(
            Long id,
            Long eventId,
            Long personId,
            @NotNull Long pickupZoneId,
            String pickupZoneName, // For display purposes in responses
            String notes,
            @NotEmpty List<ThaaliOrderItemDto> items) {
    }

    // Request DTO for creating/updating orders
    public record ThaaliOrderRequest(
            @NotNull Long pickupZoneId,
            String notes,
            @NotEmpty List<ThaaliOrderItemRequest> items) {
    }

    public record ThaaliOrderItemRequest(
            @NotNull Long menuItemId,
            @NotNull MealSize size) {
    }

    // Report DTOs
    public record ThaaliCountReportDto(
            long large,
            long small,
            long barakati,
            BigDecimal totalQuarts) {
    }

    public record MenuItemCountDto(
            Long menuItemId,
            String dishName,
            long largeCount,
            long smallCount,
            long barakatiCount) {
    }

    public record ThaaliDetailedReportDto(
            ThaaliCountReportDto totals,
            List<MenuItemCountDto> byMenuItem) {
    }

    public record ShoppingListItemDto(
            Long ingredientId,
            String ingredientName,
            String unit,
            BigDecimal requiredQty,
            String defaultStore,
            String category) {
    }

    public record RegistrationWindowStatus(boolean open) {
    }

    public record MessageDto(String message) {
    }
}
