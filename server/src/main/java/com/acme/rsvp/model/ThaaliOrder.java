package com.acme.rsvp.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "thaali_orders", uniqueConstraints = @UniqueConstraint(name = "uc_thaali_event_person", columnNames = {
        "event_id", "person_id" }))
public class ThaaliOrder extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "event_id")
    private ThaaliEvent event;

    @ManyToOne(optional = false)
    @JoinColumn(name = "person_id")
    private Person person;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ThaaliOrderItem> items = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pickup_zone_id", nullable = false)
    private PickupZone pickupZone;

    @Column(name = "notes", length = 500)
    private String notes;

    // Computed helper (not persisted): total quarts for this order
    @Transient
    public BigDecimal getTotalQuarts() {
        return items.stream()
                .map(item -> item.getSize().quarts())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Helper method to add an item
    public void addItem(ThaaliOrderItem item) {
        items.add(item);
        item.setOrder(this);
    }

    // Helper method to remove an item
    public void removeItem(ThaaliOrderItem item) {
        items.remove(item);
        item.setOrder(null);
    }

    // Helper method to clear all items
    public void clearItems() {
        items.forEach(item -> item.setOrder(null));
        items.clear();
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public ThaaliEvent getEvent() {
        return event;
    }

    public void setEvent(ThaaliEvent event) {
        this.event = event;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public List<ThaaliOrderItem> getItems() {
        return items;
    }

    public void setItems(List<ThaaliOrderItem> items) {
        this.items = items;
    }

    public PickupZone getPickupZone() {
        return pickupZone;
    }

    public void setPickupZone(PickupZone pickupZone) {
        this.pickupZone = pickupZone;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
