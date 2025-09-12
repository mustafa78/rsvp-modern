package com.acme.rsvp.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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

	@Column(name = "large_count", nullable = false)
	private int largeCount = 0;
	@Column(name = "small_count", nullable = false)
	private int smallCount = 0;
	@Column(name = "barakati_count", nullable = false)
	private int barakatiCount = 0;

	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "pickup_zone_id", nullable = false)
	private PickupZone pickupZone;

	@Column(name = "notes", length = 500)
	private String notes;

	// Computed helper (not persisted): total quarts for this order
	@Transient
	public BigDecimal getTotalQuarts() {
		return MealSize.LARGE.quarts().multiply(BigDecimal.valueOf(largeCount))
				.add(MealSize.SMALL.quarts().multiply(BigDecimal.valueOf(smallCount)))
				.add(MealSize.BARAKATI.quarts().multiply(BigDecimal.valueOf(barakatiCount)));
	}

	// getters/setters...
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

	public int getLargeCount() {
		return largeCount;
	}

	public void setLargeCount(int largeCount) {
		this.largeCount = largeCount;
	}

	public int getSmallCount() {
		return smallCount;
	}

	public void setSmallCount(int smallCount) {
		this.smallCount = smallCount;
	}

	public int getBarakatiCount() {
		return barakatiCount;
	}

	public void setBarakatiCount(int barakatiCount) {
		this.barakatiCount = barakatiCount;
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