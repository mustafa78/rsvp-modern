package com.acme.rsvp.web;

import com.acme.rsvp.dto.RoleDtos.*;
import com.acme.rsvp.service.RoleService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    private final RoleService roleService;

    public RoleController(RoleService roleService) {
        this.roleService = roleService;
    }

    @GetMapping
    public ResponseEntity<List<RoleDto>> listAll() {
        return ResponseEntity.ok(roleService.listAll());
    }

    @GetMapping("/active")
    public ResponseEntity<List<RoleDto>> listActive() {
        return ResponseEntity.ok(roleService.listActive());
    }

    @GetMapping("/{id}")
    public ResponseEntity<RoleDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(roleService.getById(id));
    }

    @PostMapping
    public ResponseEntity<RoleDto> create(@Valid @RequestBody CreateRoleRequest request) {
        return ResponseEntity.ok(roleService.create(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RoleDto> update(@PathVariable Long id, @Valid @RequestBody UpdateRoleRequest request) {
        return ResponseEntity.ok(roleService.update(id, request));
    }

    @PutMapping("/{id}/activate")
    public ResponseEntity<RoleDto> activate(@PathVariable Long id) {
        return ResponseEntity.ok(roleService.activate(id));
    }

    @PutMapping("/{id}/deactivate")
    public ResponseEntity<RoleDto> deactivate(@PathVariable Long id) {
        return ResponseEntity.ok(roleService.deactivate(id));
    }
}
