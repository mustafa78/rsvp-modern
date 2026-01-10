package com.acme.rsvp.service;

import com.acme.rsvp.dto.IngredientLookupDtos.*;
import com.acme.rsvp.model.*;
import com.acme.rsvp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class IngredientLookupService {

    private final IngredientCategoryRepository categoryRepo;
    private final IngredientStoreRepository storeRepo;
    private final IngredientStorageLocationRepository locationRepo;
    private final IngredientUnitRepository unitRepo;

    public IngredientLookupService(
            IngredientCategoryRepository categoryRepo,
            IngredientStoreRepository storeRepo,
            IngredientStorageLocationRepository locationRepo,
            IngredientUnitRepository unitRepo) {
        this.categoryRepo = categoryRepo;
        this.storeRepo = storeRepo;
        this.locationRepo = locationRepo;
        this.unitRepo = unitRepo;
    }

    // ========== Categories ==========
    public List<LookupItemDto> listCategories(boolean activeOnly) {
        var list = activeOnly
            ? categoryRepo.findAllByActiveTrueOrderByDisplayOrderAscNameAsc()
            : categoryRepo.findAllByOrderByDisplayOrderAscNameAsc();
        return list.stream().map(this::toCategoryDto).toList();
    }

    public LookupItemDto createCategory(CreateLookupRequest req) {
        if (categoryRepo.existsByNameIgnoreCase(req.name())) {
            throw new IllegalArgumentException("Category already exists: " + req.name());
        }
        var entity = new IngredientCategory();
        entity.setName(req.name());
        entity.setDisplayOrder(req.displayOrder() != null ? req.displayOrder() : 0);
        categoryRepo.save(entity);
        return toCategoryDto(entity);
    }

    public LookupItemDto updateCategory(Long id, UpdateLookupRequest req) {
        var entity = categoryRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Category not found"));
        entity.setName(req.name());
        if (req.displayOrder() != null) entity.setDisplayOrder(req.displayOrder());
        if (req.active() != null) entity.setActive(req.active());
        categoryRepo.save(entity);
        return toCategoryDto(entity);
    }

    public void deleteCategory(Long id) {
        categoryRepo.deleteById(id);
    }

    private LookupItemDto toCategoryDto(IngredientCategory e) {
        return new LookupItemDto(e.getId(), e.getName(), e.getDisplayOrder(), e.isActive());
    }

    // ========== Stores ==========
    public List<LookupItemDto> listStores(boolean activeOnly) {
        var list = activeOnly
            ? storeRepo.findAllByActiveTrueOrderByDisplayOrderAscNameAsc()
            : storeRepo.findAllByOrderByDisplayOrderAscNameAsc();
        return list.stream().map(this::toStoreDto).toList();
    }

    public LookupItemDto createStore(CreateLookupRequest req) {
        if (storeRepo.existsByNameIgnoreCase(req.name())) {
            throw new IllegalArgumentException("Store already exists: " + req.name());
        }
        var entity = new IngredientStore();
        entity.setName(req.name());
        entity.setDisplayOrder(req.displayOrder() != null ? req.displayOrder() : 0);
        storeRepo.save(entity);
        return toStoreDto(entity);
    }

    public LookupItemDto updateStore(Long id, UpdateLookupRequest req) {
        var entity = storeRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Store not found"));
        entity.setName(req.name());
        if (req.displayOrder() != null) entity.setDisplayOrder(req.displayOrder());
        if (req.active() != null) entity.setActive(req.active());
        storeRepo.save(entity);
        return toStoreDto(entity);
    }

    public void deleteStore(Long id) {
        storeRepo.deleteById(id);
    }

    private LookupItemDto toStoreDto(IngredientStore e) {
        return new LookupItemDto(e.getId(), e.getName(), e.getDisplayOrder(), e.isActive());
    }

    // ========== Storage Locations ==========
    public List<LookupItemDto> listStorageLocations(boolean activeOnly) {
        var list = activeOnly
            ? locationRepo.findAllByActiveTrueOrderByDisplayOrderAscNameAsc()
            : locationRepo.findAllByOrderByDisplayOrderAscNameAsc();
        return list.stream().map(this::toLocationDto).toList();
    }

    public LookupItemDto createStorageLocation(CreateLookupRequest req) {
        if (locationRepo.existsByNameIgnoreCase(req.name())) {
            throw new IllegalArgumentException("Storage location already exists: " + req.name());
        }
        var entity = new IngredientStorageLocation();
        entity.setName(req.name());
        entity.setDisplayOrder(req.displayOrder() != null ? req.displayOrder() : 0);
        locationRepo.save(entity);
        return toLocationDto(entity);
    }

    public LookupItemDto updateStorageLocation(Long id, UpdateLookupRequest req) {
        var entity = locationRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Storage location not found"));
        entity.setName(req.name());
        if (req.displayOrder() != null) entity.setDisplayOrder(req.displayOrder());
        if (req.active() != null) entity.setActive(req.active());
        locationRepo.save(entity);
        return toLocationDto(entity);
    }

    public void deleteStorageLocation(Long id) {
        locationRepo.deleteById(id);
    }

    private LookupItemDto toLocationDto(IngredientStorageLocation e) {
        return new LookupItemDto(e.getId(), e.getName(), e.getDisplayOrder(), e.isActive());
    }

    // ========== Units ==========
    public List<LookupItemDto> listUnits(boolean activeOnly) {
        var list = activeOnly
            ? unitRepo.findAllByActiveTrueOrderByDisplayOrderAscNameAsc()
            : unitRepo.findAllByOrderByDisplayOrderAscNameAsc();
        return list.stream().map(this::toUnitDto).toList();
    }

    public LookupItemDto createUnit(CreateLookupRequest req) {
        if (unitRepo.existsByNameIgnoreCase(req.name())) {
            throw new IllegalArgumentException("Unit already exists: " + req.name());
        }
        var entity = new IngredientUnit();
        entity.setName(req.name());
        entity.setDisplayOrder(req.displayOrder() != null ? req.displayOrder() : 0);
        unitRepo.save(entity);
        return toUnitDto(entity);
    }

    public LookupItemDto updateUnit(Long id, UpdateLookupRequest req) {
        var entity = unitRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Unit not found"));
        entity.setName(req.name());
        if (req.displayOrder() != null) entity.setDisplayOrder(req.displayOrder());
        if (req.active() != null) entity.setActive(req.active());
        unitRepo.save(entity);
        return toUnitDto(entity);
    }

    public void deleteUnit(Long id) {
        unitRepo.deleteById(id);
    }

    private LookupItemDto toUnitDto(IngredientUnit e) {
        return new LookupItemDto(e.getId(), e.getName(), e.getDisplayOrder(), e.isActive());
    }
}
