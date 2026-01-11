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

    // Niyaz RSVP with person details for reports
    public record NiyazRsvpDetailDto(
            Long rsvpId,
            Long personId,
            String personName,
            String personPhone,
            int adults,
            int kids) {
    }

    // Admin RSVP request DTO (includes personId)
    public record AdminNiyazRsvpRequest(
            @NotNull Long personId,
            @Min(0) int adults,
            @Min(0) int kids) {
    }

    // Guest detail for public RSVP summary
    public record GuestDetailDto(
            Long personId,
            String name,
            int adults,
            int kids) {
    }

    // Public RSVP summary for event detail page (only shown if showRsvpSummary is true)
    public record NiyazRsvpPublicSummaryDto(
            int familyCount,
            long totalAdults,
            long totalKids,
            List<GuestDetailDto> guests) {
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

    // Per-dish shopping list DTOs
    public record DishShoppingListDto(
            Long dishId,
            String dishName,
            BigDecimal totalQuarts,
            List<ShoppingListItemDto> ingredients) {
    }

    public record PerDishShoppingListDto(
            List<DishShoppingListDto> dishes) {
    }

    public record RegistrationWindowStatus(boolean open) {
    }

    public record MessageDto(String message) {
    }

    // Individual Orders Report DTOs (for admin export)
    public record IndividualOrderItemDto(
            Long menuItemId,
            String dishName,
            MealSize size) {
    }

    public record IndividualOrderDto(
            Long orderId,
            Long personId,
            String personName,
            String personPhone,
            Long pickupZoneId,
            String pickupZoneName,
            List<IndividualOrderItemDto> items) {
    }

    public record MenuItemInfo(
            Long menuItemId,
            String dishName) {
    }

    public record IndividualOrdersReportDto(
            List<MenuItemInfo> menuItems,
            List<IndividualOrderDto> orders) {
    }

    // Admin order request DTO (includes personId)
    public record AdminOrderRequest(
            @NotNull Long personId,
            @NotNull Long pickupZoneId,
            String notes,
            @NotEmpty List<ThaaliOrderItemRequest> items) {
    }

    // User without order DTO (for admin to select who to add order for)
    public record PersonBasicDto(
            Long id,
            String itsNumber,
            String firstName,
            String lastName,
            String phone) {
    }
}
