package com.acme.rsvp.service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.AdminUserDtos.CreateUserRequest;
import com.acme.rsvp.dto.AdminUserDtos.ExtendExpirationRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateRolesRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateStatusRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateUserInfoRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateUserTypeRequest;
import com.acme.rsvp.dto.AdminUserDtos.UserListDto;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.UserType;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.PickupZoneRepository;

@Service
@Transactional(readOnly = true)
public class AdminUserService {

    private final PersonRepository personRepository;
    private final PickupZoneRepository pickupZoneRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminUserService(PersonRepository personRepository, PickupZoneRepository pickupZoneRepository,
            PasswordEncoder passwordEncoder) {
        this.personRepository = personRepository;
        this.pickupZoneRepository = pickupZoneRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public List<UserListDto> listAllUsers() {
        return personRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional
    public UserListDto createUser(CreateUserRequest request) {
        // Check for duplicate ITS number
        if (personRepository.existsByItsNumber(request.itsNumber())) {
            throw new IllegalArgumentException("ITS number already exists: " + request.itsNumber());
        }
        // Check for duplicate email
        if (personRepository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Email already exists: " + request.email());
        }

        Person person = new Person();
        person.setItsNumber(request.itsNumber());
        person.setFirstName(request.firstName());
        person.setLastName(request.lastName());
        person.setEmail(request.email());
        person.setPhone(request.phone());
        person.setPasswordHash(passwordEncoder.encode(request.password()));
        person.setAccountStatus(AccountStatus.ACTIVE);

        // Set roles (default to USER if none provided)
        if (request.roles() != null && !request.roles().isEmpty()) {
            person.setRoles(new HashSet<>(request.roles()));
        } else {
            Set<String> defaultRoles = new HashSet<>();
            defaultRoles.add("USER");
            person.setRoles(defaultRoles);
        }

        // Set pickup zone if provided
        if (request.pickupZoneId() != null) {
            pickupZoneRepository.findById(request.pickupZoneId())
                    .ifPresent(person::setPickupZone);
        }

        // Set user type and expiration
        UserType userType = request.userType() != null ? request.userType() : UserType.REGISTERED;
        person.setUserType(userType);

        if (request.accountExpiresAt() != null) {
            person.setAccountExpiresAt(request.accountExpiresAt());
        } else {
            person.setAccountExpiresAt(calculateDefaultExpiration(userType));
        }

        return toDto(personRepository.save(person));
    }

    public UserListDto getUser(Long id) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        return toDto(person);
    }

    @Transactional
    public UserListDto updateRoles(Long id, UpdateRolesRequest request) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        person.setRoles(new HashSet<>(request.roles()));
        return toDto(personRepository.save(person));
    }

    @Transactional
    public UserListDto updateStatus(Long id, UpdateStatusRequest request) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        person.setAccountStatus(request.status());
        // Reset failed login count if activating
        if (request.status() == AccountStatus.ACTIVE) {
            person.setFailedLoginCount(0);
        }
        return toDto(personRepository.save(person));
    }

    @Transactional
    public UserListDto updateUserInfo(Long id, UpdateUserInfoRequest request) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));

        // Check for duplicate email if changing
        if (!person.getEmail().equals(request.email()) && personRepository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Email already exists: " + request.email());
        }

        person.setFirstName(request.firstName());
        person.setLastName(request.lastName());
        person.setEmail(request.email());
        person.setPhone(request.phone());

        // Update pickup zone
        if (request.pickupZoneId() != null) {
            pickupZoneRepository.findById(request.pickupZoneId())
                    .ifPresent(person::setPickupZone);
        } else {
            person.setPickupZone(null);
        }

        return toDto(personRepository.save(person));
    }

    @Transactional
    public UserListDto updateUserType(Long id, UpdateUserTypeRequest request) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        person.setUserType(request.userType());

        if (request.accountExpiresAt() != null) {
            person.setAccountExpiresAt(request.accountExpiresAt());
        } else {
            person.setAccountExpiresAt(calculateDefaultExpiration(request.userType()));
        }

        return toDto(personRepository.save(person));
    }

    @Transactional
    public UserListDto extendExpiration(Long id, ExtendExpirationRequest request) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        person.setAccountExpiresAt(request.newExpiresAt());
        return toDto(personRepository.save(person));
    }

    @Transactional
    public UserListDto convertToRegistered(Long id) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        person.setUserType(UserType.REGISTERED);
        person.setAccountExpiresAt(null);
        return toDto(personRepository.save(person));
    }

    private Instant calculateDefaultExpiration(UserType userType) {
        return switch (userType) {
            case STUDENT -> Instant.now().plus(60, ChronoUnit.DAYS);
            case MEHMAAN -> Instant.now().plus(30, ChronoUnit.DAYS);
            case REGISTERED -> null;
        };
    }

    private UserListDto toDto(Person p) {
        return new UserListDto(
                p.getId(),
                p.getItsNumber(),
                p.getFirstName(),
                p.getLastName(),
                p.getEmail(),
                p.getPhone(),
                p.getRoles(),
                p.getAccountStatus(),
                p.getUserType(),
                p.getAccountExpiresAt(),
                p.isExpired(),
                p.getPickupZone() != null ? p.getPickupZone().getId() : null,
                p.getPickupZone() != null ? p.getPickupZone().getName() : null,
                p.getLastLoginAt());
    }
}
