package com.acme.rsvp.web;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.AdminUserDtos.CreateUserRequest;
import com.acme.rsvp.dto.AdminUserDtos.ExtendExpirationRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateRolesRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateStatusRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateUserInfoRequest;
import com.acme.rsvp.dto.AdminUserDtos.UpdateUserTypeRequest;
import com.acme.rsvp.dto.AdminUserDtos.UserListDto;
import com.acme.rsvp.service.AdminUserService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final AdminUserService adminUserService;

    public AdminUserController(AdminUserService adminUserService) {
        this.adminUserService = adminUserService;
    }

    @GetMapping
    public ResponseEntity<List<UserListDto>> list() {
        return ResponseEntity.ok(adminUserService.listAllUsers());
    }

    @PostMapping
    public ResponseEntity<UserListDto> create(@Valid @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(adminUserService.createUser(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserListDto> get(@PathVariable Long id) {
        return ResponseEntity.ok(adminUserService.getUser(id));
    }

    @PutMapping("/{id}/roles")
    public ResponseEntity<UserListDto> updateRoles(@PathVariable Long id,
            @Valid @RequestBody UpdateRolesRequest request) {
        return ResponseEntity.ok(adminUserService.updateRoles(id, request));
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<UserListDto> updateStatus(@PathVariable Long id,
            @Valid @RequestBody UpdateStatusRequest request) {
        return ResponseEntity.ok(adminUserService.updateStatus(id, request));
    }

    @PutMapping("/{id}/info")
    public ResponseEntity<UserListDto> updateUserInfo(@PathVariable Long id,
            @Valid @RequestBody UpdateUserInfoRequest request) {
        return ResponseEntity.ok(adminUserService.updateUserInfo(id, request));
    }

    @PutMapping("/{id}/user-type")
    public ResponseEntity<UserListDto> updateUserType(@PathVariable Long id,
            @Valid @RequestBody UpdateUserTypeRequest request) {
        return ResponseEntity.ok(adminUserService.updateUserType(id, request));
    }

    @PutMapping("/{id}/extend")
    public ResponseEntity<UserListDto> extendExpiration(@PathVariable Long id,
            @Valid @RequestBody ExtendExpirationRequest request) {
        return ResponseEntity.ok(adminUserService.extendExpiration(id, request));
    }

    @PostMapping("/{id}/convert-to-registered")
    public ResponseEntity<UserListDto> convertToRegistered(@PathVariable Long id) {
        return ResponseEntity.ok(adminUserService.convertToRegistered(id));
    }
}
