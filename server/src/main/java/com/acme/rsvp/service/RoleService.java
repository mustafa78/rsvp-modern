package com.acme.rsvp.service;

import com.acme.rsvp.dto.RoleDtos.*;
import com.acme.rsvp.model.Role;
import com.acme.rsvp.repository.RoleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RoleService {

    private final RoleRepository roleRepository;

    public RoleService(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    /* ======================= Queries ======================= */

    @Transactional(readOnly = true)
    public List<RoleDto> listAll() {
        return roleRepository.findAllByOrderByNameAsc().stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<RoleDto> listActive() {
        return roleRepository.findByActiveTrue().stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public RoleDto getById(Long id) {
        return roleRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new IllegalArgumentException("Role not found: " + id));
    }

    @Transactional(readOnly = true)
    public RoleDto getByName(String name) {
        return roleRepository.findByName(name)
                .map(this::toDto)
                .orElseThrow(() -> new IllegalArgumentException("Role not found: " + name));
    }

    /* ======================= Commands ======================= */

    public RoleDto create(CreateRoleRequest req) {
        // Normalize role name to uppercase
        String normalizedName = req.name().toUpperCase().replace(" ", "_");

        if (roleRepository.existsByName(normalizedName)) {
            throw new IllegalArgumentException("Role already exists: " + normalizedName);
        }

        Role role = new Role();
        role.setName(normalizedName);
        role.setDescription(req.description());
        role.setActive(true);

        roleRepository.save(role);
        return toDto(role);
    }

    public RoleDto update(Long id, UpdateRoleRequest req) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Role not found: " + id));

        if (req.description() != null) {
            role.setDescription(req.description());
        }

        if (req.active() != null) {
            role.setActive(req.active());
        }

        roleRepository.save(role);
        return toDto(role);
    }

    public RoleDto activate(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Role not found: " + id));

        role.setActive(true);
        roleRepository.save(role);
        return toDto(role);
    }

    public RoleDto deactivate(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Role not found: " + id));

        // Prevent deactivating core roles
        if (isSystemRole(role.getName())) {
            throw new IllegalArgumentException("Cannot deactivate system role: " + role.getName());
        }

        role.setActive(false);
        roleRepository.save(role);
        return toDto(role);
    }

    /* ======================= Helpers ======================= */

    private boolean isSystemRole(String name) {
        return "USER".equals(name) || "SUPER_USER".equals(name) || "ADMIN".equals(name);
    }

    private RoleDto toDto(Role role) {
        return new RoleDto(
                role.getId(),
                role.getName(),
                role.getDescription(),
                role.isActive(),
                role.getCreatedAt(),
                role.getUpdatedAt()
        );
    }
}
