package com.acme.rsvp.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.RsvpDtos.AdminOrderRequest;
import com.acme.rsvp.dto.RsvpDtos.DishShoppingListDto;
import com.acme.rsvp.dto.RsvpDtos.IndividualOrderDto;
import com.acme.rsvp.dto.RsvpDtos.IndividualOrderItemDto;
import com.acme.rsvp.dto.RsvpDtos.IndividualOrdersReportDto;
import com.acme.rsvp.dto.RsvpDtos.MenuItemCountDto;
import com.acme.rsvp.dto.RsvpDtos.MenuItemInfo;
import com.acme.rsvp.dto.RsvpDtos.PerDishShoppingListDto;
import com.acme.rsvp.dto.RsvpDtos.PersonBasicDto;
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

    @Transactional(readOnly = true)
    public PerDishShoppingListDto shoppingListPerDish(Long eventId) {
        List<Object[]> rows = orderRepo.shoppingListPerDish(eventId);

        // Group by dish
        Map<Long, DishShoppingListDto> dishMap = new java.util.LinkedHashMap<>();

        for (Object[] row : rows) {
            Long dishId = ((Number) row[0]).longValue();
            String dishName = (String) row[1];
            BigDecimal totalQuarts = (BigDecimal) row[2];
            Long ingredientId = ((Number) row[3]).longValue();
            String ingredientName = (String) row[4];
            String unit = (String) row[5];
            BigDecimal requiredQty = (BigDecimal) row[6];
            String defaultStore = (String) row[7];
            String category = (String) row[8];

            ShoppingListItemDto ingredient = new ShoppingListItemDto(
                    ingredientId, ingredientName, unit, requiredQty, defaultStore, category);

            if (!dishMap.containsKey(dishId)) {
                dishMap.put(dishId, new DishShoppingListDto(dishId, dishName, totalQuarts, new ArrayList<>()));
            }

            // Add ingredient to the dish's list (need to create new list since record is immutable)
            DishShoppingListDto existing = dishMap.get(dishId);
            List<ShoppingListItemDto> ingredients = new ArrayList<>(existing.ingredients());
            ingredients.add(ingredient);
            dishMap.put(dishId, new DishShoppingListDto(dishId, dishName, totalQuarts, ingredients));
        }

        return new PerDishShoppingListDto(new ArrayList<>(dishMap.values()));
    }

    @Transactional
    public void deleteOrder(Long eventId, Long personId) {
        orderRepo.findByEventIdAndPersonId(eventId, personId)
                .ifPresent(orderRepo::delete);
    }

    // Admin methods - bypass registration window check

    @Transactional
    public ThaaliOrderDto createOrderAdmin(Long eventId, AdminOrderRequest request) {
        ThaaliEvent event = eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        Person person = personRepo.findById(request.personId())
                .orElseThrow(() -> new IllegalArgumentException("Person not found: " + request.personId()));

        // Check if order already exists
        if (orderRepo.findByEventIdAndPersonId(eventId, request.personId()).isPresent()) {
            throw new IllegalStateException("Order already exists for this person. Use update instead.");
        }

        PickupZone pickupZone = pickupZoneRepo.findById(request.pickupZoneId())
                .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found: " + request.pickupZoneId()));

        ThaaliOrder order = new ThaaliOrder();
        order.setEvent(event);
        order.setPerson(person);
        order.setPickupZone(pickupZone);
        order.setNotes(request.notes());

        for (var itemRequest : request.items()) {
            MenuItem menuItem = menuItemRepo.findById(itemRequest.menuItemId())
                    .orElseThrow(() -> new IllegalArgumentException("Menu item not found: " + itemRequest.menuItemId()));

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

    @Transactional
    public ThaaliOrderDto updateOrderAdmin(Long eventId, Long orderId, AdminOrderRequest request) {
        ThaaliOrder order = orderRepo.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + orderId));

        // Verify order belongs to the event
        if (!order.getEvent().getId().equals(eventId)) {
            throw new IllegalArgumentException("Order " + orderId + " does not belong to event " + eventId);
        }

        PickupZone pickupZone = pickupZoneRepo.findById(request.pickupZoneId())
                .orElseThrow(() -> new IllegalArgumentException("Pickup zone not found: " + request.pickupZoneId()));

        order.setPickupZone(pickupZone);
        order.setNotes(request.notes());
        order.clearItems();

        // Flush to ensure deletes are executed before inserts (unique constraint on order_id, menu_item_id)
        orderRepo.saveAndFlush(order);

        for (var itemRequest : request.items()) {
            MenuItem menuItem = menuItemRepo.findById(itemRequest.menuItemId())
                    .orElseThrow(() -> new IllegalArgumentException("Menu item not found: " + itemRequest.menuItemId()));

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

    @Transactional
    public void deleteOrderAdmin(Long eventId, Long orderId) {
        ThaaliOrder order = orderRepo.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + orderId));

        // Verify order belongs to the event
        if (!order.getEvent().getId().equals(eventId)) {
            throw new IllegalArgumentException("Order " + orderId + " does not belong to event " + eventId);
        }

        orderRepo.delete(order);
    }

    @Transactional(readOnly = true)
    public List<PersonBasicDto> getUsersWithoutOrders(Long eventId) {
        // Verify event exists
        eventRepo.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found: " + eventId));

        return personRepo.findWithoutOrderForEvent(eventId).stream()
                .map(p -> new PersonBasicDto(
                        p.getId(),
                        p.getItsNumber(),
                        p.getFirstName(),
                        p.getLastName(),
                        p.getPhone()))
                .toList();
    }

    @Transactional(readOnly = true)
    public IndividualOrdersReportDto individualOrdersReport(Long eventId) {
        // Get all menu items for this event (for column headers)
        List<MenuItem> menuItems = menuItemRepo.findByEvent_IdOrderByPositionAsc(eventId);
        List<MenuItemInfo> menuItemInfos = menuItems.stream()
                .map(mi -> new MenuItemInfo(mi.getId(), mi.getDish() != null ? mi.getDish().getName() : "Unknown"))
                .toList();

        // Get all orders with person details
        List<ThaaliOrder> orders = orderRepo.findByEventIdWithPersonAndItems(eventId);

        List<IndividualOrderDto> orderDtos = orders.stream()
                .map(order -> {
                    Person person = order.getPerson();
                    String personName = person.getFirstName() + " " + person.getLastName();
                    String personPhone = person.getPhone();
                    Long pickupZoneId = order.getPickupZone() != null ? order.getPickupZone().getId() : null;
                    String pickupZoneName = order.getPickupZone() != null ? order.getPickupZone().getName() : null;

                    List<IndividualOrderItemDto> items = order.getItems().stream()
                            .map(item -> new IndividualOrderItemDto(
                                    item.getMenuItem().getId(),
                                    item.getMenuItem().getDish() != null ? item.getMenuItem().getDish().getName() : null,
                                    item.getSize()))
                            .toList();

                    return new IndividualOrderDto(
                            order.getId(),
                            person.getId(),
                            personName,
                            personPhone,
                            pickupZoneId,
                            pickupZoneName,
                            items);
                })
                .sorted((a, b) -> a.personName().compareToIgnoreCase(b.personName()))
                .toList();

        return new IndividualOrdersReportDto(menuItemInfos, orderDtos);
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
