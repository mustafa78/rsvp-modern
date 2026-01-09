package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.UUID;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.auth.AuthResponse;
import com.acme.rsvp.dto.auth.LoginRequest;
import com.acme.rsvp.dto.auth.PasswordChangeRequest;
import com.acme.rsvp.dto.auth.PasswordConfirmRequest;
import com.acme.rsvp.dto.auth.RegisterRequest;
import com.acme.rsvp.dto.auth.UnauthPasswordChangeRequest;
import com.acme.rsvp.exception.AccountExpiredException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.PasswordResetToken;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.UserType;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.PasswordResetTokenRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.PickupZoneRepository;
import com.acme.rsvp.repository.SessionTokenRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

@Service
public class AuthService {

	private final PersonRepository personRepo;
	private final SessionTokenRepository tokenRepo;
	private final PasswordResetTokenRepository prtRepo;
	private final PickupZoneRepository zoneRepo;
	private final PasswordEncoder encoder;
	private final EntityManager em;
	private final EmailService emailService;

	public AuthService(PersonRepository personRepo, SessionTokenRepository tokenRepo,
			PasswordResetTokenRepository prtRepo, PickupZoneRepository zoneRepo, PasswordEncoder encoder,
			EntityManager em, EmailService emailService) {
		this.personRepo = personRepo;
		this.tokenRepo = tokenRepo;
		this.prtRepo = prtRepo;
		this.zoneRepo = zoneRepo;
		this.encoder = encoder;
		this.em = em;
		this.emailService = emailService;
	}

	@Transactional
	public AuthResponse register(RegisterRequest req) {
		var zone = zoneRepo.findById(req.pickupZoneId())
				.orElseThrow(() -> new IllegalArgumentException("Invalid pickup zone"));

		Person p = findByItsNumber(req.itsNumber()).orElse(null);
		if (p != null)
			throw new IllegalArgumentException("User already exists");
		
		p = new Person();
		p.setItsNumber(req.itsNumber());
		p.setFirstName(req.firstName());
		p.setLastName(req.lastName());
		p.setPhone(req.phone());
		p.setEmail(req.email());
		p.setPickupZone(zone);
		p.setPasswordHash(encoder.encode(req.password()));
		// Self-registration always creates REGISTERED users with no expiration
		p.setUserType(UserType.REGISTERED);
		p.setAccountExpiresAt(null);
		personRepo.save(p);
		return toAuthResponse(p);
	}

	@Transactional
	public SessionToken login(LoginRequest req) {
		Person p = findByItsNumber(req.itsNumber())
				.orElseThrow(() -> new BadCredentialsException("bad credentials"));

		// Check if account has expired (Student/Mehmaan past expiration date)
		if (p.isExpired()) {
			throw new AccountExpiredException(
					"Your account has expired. Please contact an administrator to extend your access.");
		}

		// Check if account is active (not LOCKED or DISABLED)
		if (p.getAccountStatus() != AccountStatus.ACTIVE) {
			throw new BadCredentialsException("Account is " + p.getAccountStatus().name().toLowerCase());
		}

		if (p.getPasswordHash() == null || !encoder.matches(req.password(), p.getPasswordHash())) {
			throw new BadCredentialsException("bad credentials");
		}
		var now = OffsetDateTime.now(ZoneOffset.UTC);
		SessionToken t = new SessionToken(UUID.randomUUID(), p, now, now.plusDays(7));
		tokenRepo.save(t);
		return t;
	}

	@Transactional
	public void logout(UUID tokenId) {
		tokenRepo.findById(tokenId).ifPresent(t -> {
			t.setRevoked(true);
			tokenRepo.save(t);
		});
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
	public void changePasswordUnauthenticated(UnauthPasswordChangeRequest req) {
		Person p = findByItsNumber(req.itsNumber())
				.orElseThrow(() -> new BadCredentialsException("Invalid ITS number or password"));
		if (p.getPasswordHash() == null || !encoder.matches(req.currentPassword(), p.getPasswordHash())) {
			throw new BadCredentialsException("Invalid ITS number or password");
		}
		p.setPasswordHash(encoder.encode(req.newPassword()));
		personRepo.save(p);
	}

	@Transactional
	public void sendReset(String itsNum, String baseUrl) {
		Person p = findByItsNumber(itsNum)
				.orElseThrow(() -> new IllegalArgumentException("Account not found"));
		for (var t : prtRepo.findByPersonAndUsedAtIsNull(p)) {
			t.setUsedAt(OffsetDateTime.now());
			prtRepo.save(t);
		}
		var now = OffsetDateTime.now(ZoneOffset.UTC);
		var token = new PasswordResetToken(UUID.randomUUID(), p, now, now.plusHours(2));
		prtRepo.save(token);
		String link = baseUrl + "/reset-password?token=" + token.getId();
		emailService.sendPasswordResetLink(p.getEmail() != null ? p.getEmail() : p.getItsNumber() + "@example.invalid",
				link);
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

	private Optional<Person> findByItsNumber(String its) {
		try {
			TypedQuery<Person> q = em.createQuery("select p from Person p where p.itsNumber = :its",
					Person.class);
			q.setParameter("its", its);
			return Optional.of(q.getSingleResult());
		} catch (NoResultException e) {
			return Optional.empty();
		}
	}

	private static AuthResponse toAuthResponse(Person p) {
		Long pickupZoneId = p.getPickupZone() != null ? p.getPickupZone().getId() : null;
		return new AuthResponse(p.getId(), p.getItsNumber(), p.getFirstName(), p.getLastName(), p.getEmail(), p.getPhone(), p.getRoles(), pickupZoneId);
	}
}
