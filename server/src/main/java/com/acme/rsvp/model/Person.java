package com.acme.rsvp.model;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "persons", indexes = { @Index(name = "ix_person_its", columnList = "its_number", unique = true),
		@Index(name = "ix_person_email", columnList = "email", unique = true) })
public class Person extends Auditable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "its_number", nullable = false, unique = true, length = 32)
	private String itsNumber; // login id

	@Column(name = "first_name", nullable = false, length = 100)
	private String firstName;

	@Column(name = "last_name", nullable = false, length = 100)
	private String lastName;

	@Column(name = "phone", length = 32)
	private String phone;

	@Column(name = "email", nullable = false, unique = true, length = 255)
	private String email;

	@ElementCollection(fetch = FetchType.EAGER)
	@CollectionTable(name = "person_roles", joinColumns = @JoinColumn(name = "person_id"))
	@Enumerated(EnumType.STRING)
	@Column(name = "role", nullable = false, length = 32)
	private Set<RoleName> roles = new HashSet<>();

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "pickup_zone_id")
	private PickupZone pickupZone;

	// Auth fields
	@Column(name = "password_hash", nullable = false, length = 100)
	private String passwordHash; // store BCrypt hash

	@Enumerated(EnumType.STRING)
	@Column(name = "account_status", nullable = false, length = 16)
	private AccountStatus accountStatus = AccountStatus.ACTIVE;

	@Column(name = "reset_token", length = 100)
	private String resetToken;

	@Column(name = "reset_expires_at")
	private java.time.Instant resetExpiresAt;

	@Column(name = "failed_login_count", nullable = false)
	private int failedLoginCount = 0;

	@Column(name = "last_login_at")
	private java.time.Instant lastLoginAt;

	// getters/setters ...
	public Long getId() {
		return id;
	}

	public String getItsNumber() {
		return itsNumber;
	}

	public void setItsNumber(String itsNumber) {
		this.itsNumber = itsNumber;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Set<RoleName> getRoles() {
		return roles;
	}

	public void setRoles(Set<RoleName> roles) {
		this.roles = roles;
	}

	public PickupZone getPickupZone() {
		return pickupZone;
	}

	public void setPickupZone(PickupZone pickupZone) {
		this.pickupZone = pickupZone;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public AccountStatus getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(AccountStatus accountStatus) {
		this.accountStatus = accountStatus;
	}

	public String getResetToken() {
		return resetToken;
	}

	public void setResetToken(String resetToken) {
		this.resetToken = resetToken;
	}

	public java.time.Instant getResetExpiresAt() {
		return resetExpiresAt;
	}

	public void setResetExpiresAt(java.time.Instant resetExpiresAt) {
		this.resetExpiresAt = resetExpiresAt;
	}

	public int getFailedLoginCount() {
		return failedLoginCount;
	}

	public void setFailedLoginCount(int failedLoginCount) {
		this.failedLoginCount = failedLoginCount;
	}

	public java.time.Instant getLastLoginAt() {
		return lastLoginAt;
	}

	public void setLastLoginAt(java.time.Instant lastLoginAt) {
		this.lastLoginAt = lastLoginAt;
	}
}