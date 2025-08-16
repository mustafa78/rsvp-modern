package com.acme.rsvp.service;

import java.time.Instant;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.AuthResponse;
import com.acme.rsvp.dto.LoginRequest;
import com.acme.rsvp.dto.PasswordChangeRequest;
import com.acme.rsvp.dto.PasswordResetConfirmRequest;
import com.acme.rsvp.dto.PasswordResetRequest;
import com.acme.rsvp.dto.PersonDtos.PersonDto;
import com.acme.rsvp.dto.RegisterRequest;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.PickupZone;
import com.acme.rsvp.model.RoleName;
import com.acme.rsvp.repository.PersonRepository;

@Service
public class AuthService {
  private final PersonRepository people;
  private final PasswordEncoder encoder;

  public AuthService(PersonRepository people, PasswordEncoder encoder) { this.people = people; this.encoder = encoder; }

  @Transactional
  public PersonDto register(RegisterRequest req) {
    if (people.existsByItsNumber(req.itsNumber())) throw new IllegalArgumentException("ITS already registered");
    if (people.existsByEmail(req.email())) throw new IllegalArgumentException("Email already registered");
    Person p = new Person();
    p.setItsNumber(req.itsNumber());
    p.setFirstName(req.firstName());
    p.setLastName(req.lastName());
    p.setEmail(req.email());
    p.setPhone(req.phone());
    p.setPickupZone(req.pickupZone() == null ? PickupZone.SELF_PICKUP_NAJMI_MASJID : req.pickupZone());
    p.setPasswordHash(encoder.encode(req.password()));
    p.getRoles().add(RoleName.USER);
    people.save(p);
    return toDto(p);
  }

  public AuthResponse login(LoginRequest req) {
    Person p = people.findByItsNumber(req.itsNumber()).orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
    if (p.getAccountStatus() != AccountStatus.ACTIVE) throw new IllegalStateException("Account not active");
    if (!encoder.matches(req.password(), p.getPasswordHash())) throw new IllegalArgumentException("Invalid credentials");
    p.setLastLoginAt(Instant.now());
    people.save(p);
    String token = UUID.randomUUID().toString(); // stub token
    return new AuthResponse(token, p.getId(), p.getItsNumber(), p.getFirstName(), p.getLastName(), p.getEmail(),
        p.getRoles().stream().map(Enum::name).collect(Collectors.toSet()));
  }

  @Transactional
  public void changePassword(PasswordChangeRequest req) {
    Person p = people.findByItsNumber(req.itsNumber()).orElseThrow(() -> new IllegalArgumentException("User not found"));
    if (!encoder.matches(req.oldPassword(), p.getPasswordHash())) throw new IllegalArgumentException("Old password mismatch");
    p.setPasswordHash(encoder.encode(req.newPassword()));
    people.save(p);
  }

  @Transactional
  public String requestPasswordReset(PasswordResetRequest req) {
    Person p = people.findByItsNumber(req.itsOrEmail()).orElse(
        people.findByEmail(req.itsOrEmail()).orElseThrow(() -> new IllegalArgumentException("User not found")));
    String token = UUID.randomUUID().toString();
    p.setResetToken(token);
    p.setResetExpiresAt(Instant.now().plusSeconds(3600));
    people.save(p);
    return token; // email in real impl
  }

  @Transactional
  public void confirmPasswordReset(PasswordResetConfirmRequest req) {
    Person p = people.findByItsNumber(req.itsNumber()).orElseThrow(() -> new IllegalArgumentException("User not found"));
    if (p.getResetToken() == null || p.getResetExpiresAt() == null) throw new IllegalStateException("Reset not requested");
    if (!p.getResetToken().equals(req.token())) throw new IllegalArgumentException("Invalid token");
    if (Instant.now().isAfter(p.getResetExpiresAt())) throw new IllegalStateException("Token expired");
    p.setPasswordHash(encoder.encode(req.newPassword()));
    p.setResetToken(null); p.setResetExpiresAt(null);
    people.save(p);
  }

  private static PersonDto toDto(Person p) {
    Set<String> roles = p.getRoles().stream().map(Enum::name).collect(Collectors.toSet());
    return new PersonDto(p.getId(), p.getItsNumber(), p.getFirstName(), p.getLastName(), p.getEmail(), p.getPhone(), roles, p.getPickupZone());
  }
}
