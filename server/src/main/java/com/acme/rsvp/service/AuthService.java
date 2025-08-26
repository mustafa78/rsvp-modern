package com.acme.rsvp.service;

import com.acme.rsvp.dto.auth.*;
import com.acme.rsvp.model.PasswordResetToken;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.PasswordResetTokenRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.SessionTokenRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {

  private final PersonRepository personRepo;
  private final SessionTokenRepository tokenRepo;
  private final PasswordResetTokenRepository prtRepo;
  private final PasswordEncoder encoder;
  private final EntityManager em;
  private final EmailService emailService;

  public AuthService(PersonRepository personRepo, SessionTokenRepository tokenRepo,
                     PasswordResetTokenRepository prtRepo, PasswordEncoder encoder,
                     EntityManager em, EmailService emailService) {
    this.personRepo = personRepo;
    this.tokenRepo = tokenRepo;
    this.prtRepo = prtRepo;
    this.encoder = encoder;
    this.em = em;
    this.emailService = emailService;
  }

  @Transactional
  public AuthResponse register(RegisterRequest req) {
    Person p = findByItsOrEmail(req.itsNumber(), req.email()).orElse(null);
    if (p != null) throw new IllegalArgumentException("User already exists");
    p = new Person();
    p.setItsNumber(req.itsNumber());
    p.setFirstName(req.firstName());
    p.setLastName(req.lastName());
    p.setPhone(req.phone());
    p.setEmail(req.email());
    try { p.setPickupZone(req.pickupZone()); } catch (Exception ignored) {}
    p.setPasswordHash(encoder.encode(req.password()));
    personRepo.save(p);
    return toAuthResponse(p);
  }

  @Transactional
  public SessionToken login(LoginRequest req) {
    Person p = findByItsOrEmail(req.itsNumber(), req.itsNumber())
        .orElseThrow(() -> new IllegalArgumentException("User not found"));
    if (p.getPasswordHash() == null || !encoder.matches(req.password(), p.getPasswordHash())) {
      throw new IllegalArgumentException("Invalid credentials");
    }
    var now = OffsetDateTime.now(ZoneOffset.UTC);
    SessionToken t = new SessionToken(UUID.randomUUID(), p, now, now.plusDays(7));
    tokenRepo.save(t);
    return t;
  }

  @Transactional
  public void logout(UUID tokenId) {
    tokenRepo.findById(tokenId).ifPresent(t -> { t.setRevoked(true); tokenRepo.save(t); });
  }

  @Transactional
  public void changePassword(Person current, PasswordChangeRequest req) {
    if (current.getPasswordHash() == null || !encoder.matches(req.currentPassword(), current.getPasswordHash())) {
      throw new IllegalArgumentException("Current password incorrect");
    }
    current.setPasswordHash(encoder.encode(req.newPassword()));
    personRepo.save(current);
  }

  @Transactional
  public void sendReset(String itsOrEmail, String baseUrl) {
    Person p = findByItsOrEmail(itsOrEmail, itsOrEmail)
        .orElseThrow(() -> new IllegalArgumentException("Account not found"));
    for (var t : prtRepo.findByPersonAndUsedAtIsNull(p)) {
      t.setUsedAt(OffsetDateTime.now());
      prtRepo.save(t);
    }
    var now = OffsetDateTime.now(ZoneOffset.UTC);
    var token = new PasswordResetToken(UUID.randomUUID(), p, now, now.plusHours(2));
    prtRepo.save(token);
    String link = baseUrl + "/reset-password?token=" + token.getId();
    emailService.sendPasswordResetLink(p.getEmail() != null ? p.getEmail() : p.getItsNumber() + "@example.invalid", link);
  }

  @Transactional
  public void confirmReset(PasswordConfirmRequest req) {
    UUID id = UUID.fromString(req.token());
    var t = prtRepo.findByIdAndUsedAtIsNullAndExpiresAtAfter(id, OffsetDateTime.now(ZoneOffset.UTC))
        .orElseThrow(() -> new IllegalArgumentException("Invalid/expired token"));
    Person p = t.getPerson();
    p.setPasswordHash(encoder.encode(req.newPassword()));
    personRepo.save(p);
    t.setUsedAt(OffsetDateTime.now(ZoneOffset.UTC));
    prtRepo.save(t);
  }

  private Optional<Person> findByItsOrEmail(String its, String email) {
    try {
      TypedQuery<Person> q = em.createQuery(
          "select p from Person p where p.itsNumber = :its or p.email = :email", Person.class);
      q.setParameter("its", its);
      q.setParameter("email", email);
      return Optional.of(q.getSingleResult());
    } catch (NoResultException e) {
      return Optional.empty();
    }
  }

  private static AuthResponse toAuthResponse(Person p) {
    return new AuthResponse(p.getId(), p.getItsNumber(), p.getFirstName(), p.getLastName(), p.getEmail());
  }
}
