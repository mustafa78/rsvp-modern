package com.acme.rsvp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "thaali_order_items", uniqueConstraints = @UniqueConstraint(name = "uc_order_menu_item", columnNames = {
        "order_id", "menu_item_id" }))
public class ThaaliOrderItem extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private ThaaliOrder order;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;

    @Enumerated(EnumType.STRING)
    @Column(name = "size", nullable = false, length = 16)
    private MealSize size;

    // Getters and setters
    public Long getId() {
        return id;
    }

    public ThaaliOrder getOrder() {
        return order;
    }

    public void setOrder(ThaaliOrder order) {
        this.order = order;
    }

    public MenuItem getMenuItem() {
        return menuItem;
    }

    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
    }

    public MealSize getSize() {
        return size;
    }

    public void setSize(MealSize size) {
        this.size = size;
    }
}
