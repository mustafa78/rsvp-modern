package com.acme.rsvp.service;

import com.acme.rsvp.dto.IngredientDtos.*;
import com.acme.rsvp.model.Ingredient;
import com.acme.rsvp.model.IngredientUnit;
import com.acme.rsvp.repository.IngredientRepository;
import com.acme.rsvp.repository.IngredientUnitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class IngredientService {

    private final IngredientRepository repo;
    private final IngredientUnitRepository unitRepo;

    public IngredientService(IngredientRepository repo, IngredientUnitRepository unitRepo) {
        this.repo = repo;
        this.unitRepo = unitRepo;
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

        Ingredient i = new Ingredient();
        i.setName(req.name());
        i.setUnit(unit);
        i.setCategory(req.category());
        i.setDefaultStore(req.defaultStore());
        i.setStorageLocation(req.storageLocation());
        i.setNotes(req.notes());
        i.setCostPerUnit(req.costPerUnit());
        i.setCaloriesPerUnit(req.caloriesPerUnit());
        repo.save(i);
        return toDto(i);
    }

    public IngredientDto update(Long id, IngredientUpsertRequest req) {
        IngredientUnit unit = unitRepo.findById(req.unitId())
                .orElseThrow(() -> new IllegalArgumentException("Unit not found: " + req.unitId()));

        Ingredient i = repo.findById(id).orElseThrow();
        i.setName(req.name());
        i.setUnit(unit);
        i.setCategory(req.category());
        i.setDefaultStore(req.defaultStore());
        i.setStorageLocation(req.storageLocation());
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
            i.getCategory(),
            i.getDefaultStore(),
            i.getStorageLocation(),
            i.getNotes(),
            i.getCostPerUnit(),
            i.getCaloriesPerUnit()
        );
    }
}
