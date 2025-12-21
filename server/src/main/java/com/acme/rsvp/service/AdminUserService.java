package com.acme.rsvp.service;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.AdminUserDtos.UpdateRolesRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateStatusRequest;
import com.acme.rsvp.dto.AdminUserDtos.UserListDto;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.RoleName;
import com.acme.rsvp.repository.PersonRepository;

@Service
@Transactional(readOnly = true)
public class AdminUserService {

    private final PersonRepository personRepository;

    public AdminUserService(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    public List<UserListDto> listAllUsers() {
        return personRepository.findAll().stream()
                .map(this::toDto)
                .toList();
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
        person.setRoles(request.roles());
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
                p.getPickupZone() != null ? p.getPickupZone().getName() : null,
                p.getLastLoginAt());
    }
}
