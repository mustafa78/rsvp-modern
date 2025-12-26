package com.acme.rsvp.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.RsvpDtos.MenuItemCountDto;
import com.acme.rsvp.dto.RsvpDtos.ShoppingListItemDto;
import com.acme.rsvp.dto.RsvpDtos.ThaaliCountReportDto;
import com.acme.rsvp.dto.RsvpDtos.ThaaliDetailedReportDto;
import com.acme.rsvp.dto.RsvpDtos.ThaaliOrderDto;
import com.acme.rsvp.dto.RsvpDtos.ThaaliOrderItemDto;
import com.acme.rsvp.dto.RsvpDtos.ThaaliOrderRequest;
import com.acme.rsvp.model.MenuItem;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.PickupZone;
import com.acme.rsvp.model.ThaaliEvent;
import com.acme.rsvp.model.ThaaliOrder;
import com.acme.rsvp.model.ThaaliOrderItem;
import com.acme.rsvp.repository.MenuItemRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.PickupZoneRepository;
import com.acme.rsvp.repository.ThaaliEventRepository;
import com.acme.rsvp.repository.ThaaliOrderRepository;

@Service
public class ThaaliService {

    private final ThaaliEventRepository eventRepo;
    private final PersonRepository personRepo;
    private final ThaaliOrderRepository orderRepo;
    private final MenuItemRepository menuItemRepo;
    private final PickupZoneRepository pickupZoneRepo;

    public ThaaliService(ThaaliEventRepository eventRepo, PersonRepository personRepo,
            ThaaliOrderRepository orderRepo, MenuItemRepository menuItemRepo,
            PickupZoneRepository pickupZoneRepo) {
        this.eventRepo = eventRepo;
        this.personRepo = personRepo;
        this.orderRepo = orderRepo;
        this.menuItemRepo = menuItemRepo;
        this.pickupZoneRepo = pickupZoneRepo;
    }

    @Transactional
    public ThaaliOrderDto upsert(Long eventId, Long personId, ThaaliOrderRequest request) {
        ThaaliEvent event = eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        // Check if registration is open
        if (!event.isRegistrationOpen(java.time.OffsetDateTime.now())) {
            throw new IllegalStateException("Registration is closed for this event");
        }

        Person person = personRepo.findById(personId)
                .orElseThrow(() -> new IllegalArgumentException("Person not found: " + personId));
        PickupZone pickupZone = pickupZoneRepo.findById(request.pickupZoneId())
                .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found: " + request.pickupZoneId()));

        // Find existing order or create new one
        ThaaliOrder order = orderRepo.findByEventIdAndPersonId(eventId, personId)
                .orElseGet(ThaaliOrder::new);

        order.setEvent(event);
        order.setPerson(person);
        order.setPickupZone(pickupZone);
        order.setNotes(request.notes());

        // Clear existing items and add new ones
        order.clearItems();

        for (var itemRequest : request.items()) {
            MenuItem menuItem = menuItemRepo.findById(itemRequest.menuItemId())
                    .orElseThrow(() -> new IllegalArgumentException("Menu item not found: " + itemRequest.menuItemId()));

            // Verify menu item belongs to this event
            if (!menuItem.getEvent().getId().equals(eventId)) {
                throw new IllegalArgumentException("Menu item " + itemRequest.menuItemId() + " does not belong to event " + eventId);
            }

            ThaaliOrderItem orderItem = new ThaaliOrderItem();
            orderItem.setMenuItem(menuItem);
            orderItem.setSize(itemRequest.size());
            order.addItem(orderItem);
        }

        order = orderRepo.save(order);
        return toDto(order);
    }

    @Transactional(readOnly = true)
    public ThaaliOrderDto getOrder(Long eventId, Long personId) {
        return orderRepo.findByEventIdAndPersonId(eventId, personId)
                .map(this::toDto)
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public List<ThaaliOrderDto> getOrdersByEvent(Long eventId) {
        return orderRepo.findByEventId(eventId).stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public ThaaliCountReportDto counts(Long eventId) {
        long large = orderRepo.totalLarge(eventId);
        long small = orderRepo.totalSmall(eventId);
        long barakati = orderRepo.totalBarakati(eventId);
        BigDecimal totalQuarts = orderRepo.totalQuarts(eventId);
        return new ThaaliCountReportDto(large, small, barakati, totalQuarts);
    }

    @Transactional(readOnly = true)
    public ThaaliDetailedReportDto detailedReport(Long eventId) {
        ThaaliCountReportDto totals = counts(eventId);

        // Get counts by menu item and size
        List<Object[]> rows = orderRepo.countsByMenuItemAndSize(eventId);

        // Group by menu item
        Map<Long, MenuItemCountDto> byMenuItem = new HashMap<>();
        for (Object[] row : rows) {
            Long menuItemId = ((Number) row[0]).longValue();
            String dishName = (String) row[1];
            String size = (String) row[2];
            long count = ((Number) row[3]).longValue();

            MenuItemCountDto existing = byMenuItem.get(menuItemId);
            long largeCount = existing != null ? existing.largeCount() : 0;
            long smallCount = existing != null ? existing.smallCount() : 0;
            long barakatiCount = existing != null ? existing.barakatiCount() : 0;

            switch (size) {
                case "LARGE" -> largeCount = count;
                case "SMALL" -> smallCount = count;
                case "BARAKATI" -> barakatiCount = count;
            }

            byMenuItem.put(menuItemId, new MenuItemCountDto(menuItemId, dishName, largeCount, smallCount, barakatiCount));
        }

        return new ThaaliDetailedReportDto(totals, new ArrayList<>(byMenuItem.values()));
    }

    @Transactional(readOnly = true)
    public List<ShoppingListItemDto> shoppingList(Long eventId) {
        List<Object[]> rows = orderRepo.shoppingList(eventId);
        List<ShoppingListItemDto> result = new ArrayList<>();

        for (Object[] row : rows) {
            Long ingredientId = ((Number) row[0]).longValue();
            String name = (String) row[1];
            String unit = (String) row[2];
            BigDecimal requiredQty = (BigDecimal) row[3];
            String defaultStore = (String) row[4];
            String category = (String) row[5];

            result.add(new ShoppingListItemDto(ingredientId, name, unit, requiredQty, defaultStore, category));
        }

        return result;
    }

    @Transactional
    public void deleteOrder(Long eventId, Long personId) {
        orderRepo.findByEventIdAndPersonId(eventId, personId)
                .ifPresent(orderRepo::delete);
    }

    private ThaaliOrderDto toDto(ThaaliOrder order) {
        List<ThaaliOrderItemDto> items = order.getItems().stream()
                .map(item -> new ThaaliOrderItemDto(
                        item.getMenuItem().getId(),
                        item.getMenuItem().getDish() != null ? item.getMenuItem().getDish().getName() : null,
                        item.getSize()))
                .toList();

        return new ThaaliOrderDto(
                order.getId(),
                order.getEvent().getId(),
                order.getPerson().getId(),
                order.getPickupZone().getId(),
                order.getPickupZone().getName(),
                order.getNotes(),
                items);
    }
}
