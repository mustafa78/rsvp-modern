package com.acme.rsvp.service;

import com.acme.rsvp.dto.IngredientDtos.*;
import com.acme.rsvp.model.Ingredient;
import com.acme.rsvp.repository.IngredientRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class IngredientService {

    private final IngredientRepository repo;

    public IngredientService(IngredientRepository repo) {
        this.repo = repo;
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
        Ingredient i = new Ingredient();
        i.setName(req.name());
        i.setUnit(req.unit());
        i.setNotes(req.notes());
        repo.save(i);
        return toDto(i);
    }

    public IngredientDto update(Long id, IngredientUpsertRequest req) {
        Ingredient i = repo.findById(id).orElseThrow();
        i.setName(req.name());
        i.setUnit(req.unit());
        i.setNotes(req.notes());
        repo.save(i);
        return toDto(i);
    }

    /* ======================= Helpers ======================= */

    private IngredientDto toDto(Ingredient i) {
        return new IngredientDto(i.getId(), i.getName(), i.getUnit(), i.getNotes());
    }
}
