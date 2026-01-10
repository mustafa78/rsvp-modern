package com.acme.rsvp.web;

import com.acme.rsvp.dto.IngredientLookupDtos.*;
import com.acme.rsvp.service.IngredientLookupService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ingredient-lookups")
public class IngredientLookupController {

    private final IngredientLookupService service;

    public IngredientLookupController(IngredientLookupService service) {
        this.service = service;
    }

    // ========== Categories ==========
    @GetMapping("/categories")
    public List<LookupItemDto> listCategories(@RequestParam(defaultValue = "true") boolean activeOnly) {
        return service.listCategories(activeOnly);
    }

    @PostMapping("/categories")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto createCategory(@Valid @RequestBody CreateLookupRequest req) {
        return service.createCategory(req);
    }

    @PutMapping("/categories/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto updateCategory(@PathVariable Long id, @Valid @RequestBody UpdateLookupRequest req) {
        return service.updateCategory(id, req);
    }

    @DeleteMapping("/categories/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteCategory(@PathVariable Long id) {
        service.deleteCategory(id);
        return ResponseEntity.noContent().build();
    }

    // ========== Stores ==========
    @GetMapping("/stores")
    public List<LookupItemDto> listStores(@RequestParam(defaultValue = "true") boolean activeOnly) {
        return service.listStores(activeOnly);
    }

    @PostMapping("/stores")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto createStore(@Valid @RequestBody CreateLookupRequest req) {
        return service.createStore(req);
    }

    @PutMapping("/stores/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto updateStore(@PathVariable Long id, @Valid @RequestBody UpdateLookupRequest req) {
        return service.updateStore(id, req);
    }

    @DeleteMapping("/stores/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteStore(@PathVariable Long id) {
        service.deleteStore(id);
        return ResponseEntity.noContent().build();
    }

    // ========== Storage Locations ==========
    @GetMapping("/storage-locations")
    public List<LookupItemDto> listStorageLocations(@RequestParam(defaultValue = "true") boolean activeOnly) {
        return service.listStorageLocations(activeOnly);
    }

    @PostMapping("/storage-locations")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto createStorageLocation(@Valid @RequestBody CreateLookupRequest req) {
        return service.createStorageLocation(req);
    }

    @PutMapping("/storage-locations/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto updateStorageLocation(@PathVariable Long id, @Valid @RequestBody UpdateLookupRequest req) {
        return service.updateStorageLocation(id, req);
    }

    @DeleteMapping("/storage-locations/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteStorageLocation(@PathVariable Long id) {
        service.deleteStorageLocation(id);
        return ResponseEntity.noContent().build();
    }

    // ========== Units ==========
    @GetMapping("/units")
    public List<LookupItemDto> listUnits(@RequestParam(defaultValue = "true") boolean activeOnly) {
        return service.listUnits(activeOnly);
    }

    @PostMapping("/units")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto createUnit(@Valid @RequestBody CreateLookupRequest req) {
        return service.createUnit(req);
    }

    @PutMapping("/units/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public LookupItemDto updateUnit(@PathVariable Long id, @Valid @RequestBody UpdateLookupRequest req) {
        return service.updateUnit(id, req);
    }

    @DeleteMapping("/units/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteUnit(@PathVariable Long id) {
        service.deleteUnit(id);
        return ResponseEntity.noContent().build();
    }
}
