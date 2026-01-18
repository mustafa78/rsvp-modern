package com.acme.rsvp.service;

import com.acme.rsvp.dto.IngredientDtos.*;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class IngredientService {

    private final IngredientRepository repo;
    private final IngredientUnitRepository unitRepo;
    private final IngredientCategoryRepository categoryRepo;
    private final IngredientStoreRepository storeRepo;
    private final IngredientStorageLocationRepository storageLocationRepo;

    public IngredientService(IngredientRepository repo,
                             IngredientUnitRepository unitRepo,
                             IngredientCategoryRepository categoryRepo,
                             IngredientStoreRepository storeRepo,
                             IngredientStorageLocationRepository storageLocationRepo) {
        this.repo = repo;
        this.unitRepo = unitRepo;
        this.categoryRepo = categoryRepo;
        this.storeRepo = storeRepo;
        this.storageLocationRepo = storageLocationRepo;
    }

    /* ======================= Queries ======================= */

    @Transactional(readOnly = true)
    public List<IngredientDto> list() {
        return repo.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public IngredientDto get(Long id) {
        return toDto(repo.findById(id).orElseThrow());
    }

    /* ======================= Commands ======================= */

    public IngredientDto create(IngredientUpsertRequest req) {
        IngredientUnit unit = unitRepo.findById(req.unitId())
                .orElseThrow(() -> new IllegalArgumentException("Unit not found: " + req.unitId()));

        IngredientCategory category = req.categoryId() != null
                ? categoryRepo.findById(req.categoryId()).orElse(null)
                : null;
        IngredientStore store = req.storeId() != null
                ? storeRepo.findById(req.storeId()).orElse(null)
                : null;
        IngredientStorageLocation storageLocation = req.storageLocationId() != null
                ? storageLocationRepo.findById(req.storageLocationId()).orElse(null)
                : null;

        Ingredient i = new Ingredient();
        i.setName(req.name());
        i.setUnit(unit);
        i.setCategory(category);
        i.setStore(store);
        i.setStorageLocation(storageLocation);
        i.setNotes(req.notes());
        i.setCostPerUnit(req.costPerUnit());
        i.setCaloriesPerUnit(req.caloriesPerUnit());
        repo.save(i);
        return toDto(i);
    }

    public IngredientDto update(Long id, IngredientUpsertRequest req) {
        IngredientUnit unit = unitRepo.findById(req.unitId())
                .orElseThrow(() -> new IllegalArgumentException("Unit not found: " + req.unitId()));

        IngredientCategory category = req.categoryId() != null
                ? categoryRepo.findById(req.categoryId()).orElse(null)
                : null;
        IngredientStore store = req.storeId() != null
                ? storeRepo.findById(req.storeId()).orElse(null)
                : null;
        IngredientStorageLocation storageLocation = req.storageLocationId() != null
                ? storageLocationRepo.findById(req.storageLocationId()).orElse(null)
                : null;

        Ingredient i = repo.findById(id).orElseThrow();
        i.setName(req.name());
        i.setUnit(unit);
        i.setCategory(category);
        i.setStore(store);
        i.setStorageLocation(storageLocation);
        i.setNotes(req.notes());
        i.setCostPerUnit(req.costPerUnit());
        i.setCaloriesPerUnit(req.caloriesPerUnit());
        repo.save(i);
        return toDto(i);
    }

    /* ======================= Helpers ======================= */

    private IngredientDto toDto(Ingredient i) {
        return new IngredientDto(
            i.getId(),
            i.getName(),
            i.getUnit().getId(),
            i.getUnit().getName(),
            i.getCategory() != null ? i.getCategory().getId() : null,
            i.getCategory() != null ? i.getCategory().getName() : null,
            i.getStore() != null ? i.getStore().getId() : null,
            i.getStore() != null ? i.getStore().getName() : null,
            i.getStorageLocation() != null ? i.getStorageLocation().getId() : null,
            i.getStorageLocation() != null ? i.getStorageLocation().getName() : null,
            i.getNotes(),
            i.getCostPerUnit(),
            i.getCaloriesPerUnit()
        );
    }
}
