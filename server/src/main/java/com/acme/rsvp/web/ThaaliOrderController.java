package com.acme.rsvp.web;

import com.acme.rsvp.dto.RsvpDtos.*;
import com.acme.rsvp.dto.RsvpDtos.PerDishShoppingListDto;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.service.ThaaliService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/thaali/{eventId}/orders")
public class ThaaliOrderController {

    private final ThaaliService service;

    public ThaaliOrderController(ThaaliService service) {
        this.service = service;
    }

    // Create or update order for the current user
    @PostMapping
    public ThaaliOrderDto upsertMyOrder(
            @PathVariable Long eventId,
            @Valid @RequestBody ThaaliOrderRequest request,
            @AuthenticationPrincipal Person user) {
        if (!user.isHof()) {
            throw new IllegalStateException("Only Head of Family (HOF) users can register for thaalis");
        }
        return service.upsert(eventId, user.getId(), request);
    }

    // Get the current user's order for this event
    @GetMapping("/my")
    public ResponseEntity<ThaaliOrderDto> getMyOrder(
            @PathVariable Long eventId,
            @AuthenticationPrincipal Person user) {
        ThaaliOrderDto order = service.getOrder(eventId, user.getId());
        return order != null ? ResponseEntity.ok(order) : ResponseEntity.noContent().build();
    }

    // Delete the current user's order
    @DeleteMapping("/my")
    public ResponseEntity<Void> deleteMyOrder(
            @PathVariable Long eventId,
            @AuthenticationPrincipal Person user) {
        if (!user.isHof()) {
            throw new IllegalStateException("Only Head of Family (HOF) users can manage thaali registrations");
        }
        service.deleteOrder(eventId, user.getId());
        return ResponseEntity.noContent().build();
    }

    // Admin: Get all orders for this event
    @GetMapping
    public List<ThaaliOrderDto> getAllOrders(@PathVariable Long eventId) {
        return service.getOrdersByEvent(eventId);
    }

    // Admin: Get counts summary
    @GetMapping("/counts")
    public ThaaliCountReportDto counts(@PathVariable Long eventId) {
        return service.counts(eventId);
    }

    // Admin: Get detailed report with counts per menu item
    @GetMapping("/detailed-report")
    public ThaaliDetailedReportDto detailedReport(@PathVariable Long eventId) {
        return service.detailedReport(eventId);
    }

    // Admin: Get shopping list (cumulative by store)
    @GetMapping("/shopping-list")
    public List<ShoppingListItemDto> shoppingList(@PathVariable Long eventId) {
        return service.shoppingList(eventId);
    }

    // Admin: Get shopping list per dish
    @GetMapping("/shopping-list-per-dish")
    public PerDishShoppingListDto shoppingListPerDish(@PathVariable Long eventId) {
        return service.shoppingListPerDish(eventId);
    }

    // Admin: Get individual orders report (who ordered what)
    @GetMapping("/individual-orders")
    public IndividualOrdersReportDto individualOrders(@PathVariable Long eventId) {
        return service.individualOrdersReport(eventId);
    }

    // Admin: Get users without orders (for adding new orders)
    @GetMapping("/users-without-orders")
    public List<PersonBasicDto> getUsersWithoutOrders(@PathVariable Long eventId) {
        return service.getUsersWithoutOrders(eventId);
    }

    // Admin: Create order for any user (bypasses registration window)
    @PostMapping("/admin")
    public ThaaliOrderDto createOrderAdmin(
            @PathVariable Long eventId,
            @Valid @RequestBody AdminOrderRequest request) {
        return service.createOrderAdmin(eventId, request);
    }

    // Admin: Update any order (bypasses registration window)
    @PutMapping("/admin/{orderId}")
    public ThaaliOrderDto updateOrderAdmin(
            @PathVariable Long eventId,
            @PathVariable Long orderId,
            @Valid @RequestBody AdminOrderRequest request) {
        return service.updateOrderAdmin(eventId, orderId, request);
    }

    // Admin: Delete any order (bypasses registration window)
    @DeleteMapping("/admin/{orderId}")
    public ResponseEntity<Void> deleteOrderAdmin(
            @PathVariable Long eventId,
            @PathVariable Long orderId) {
        service.deleteOrderAdmin(eventId, orderId);
        return ResponseEntity.noContent().build();
    }
}
