package com.acme.rsvp.service;

import com.acme.rsvp.dto.DishDtos.*;
import com.acme.rsvp.model.Dish;
import com.acme.rsvp.model.DishIngredient;
import com.acme.rsvp.model.Ingredient;
import com.acme.rsvp.repository.DishRepository;
import com.acme.rsvp.repository.DishIngredientRepository;
import com.acme.rsvp.repository.IngredientRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class DishService {
  private final DishRepository dishes;
  private final DishIngredientRepository dishIngs;
  private final IngredientRepository ingredients;
  private final EntityManager em;

  public DishService(DishRepository dishes, DishIngredientRepository dishIngs, IngredientRepository ingredients, EntityManager em){
    this.dishes = dishes; this.dishIngs = dishIngs; this.ingredients = ingredients; this.em = em;
  }

  public DishDto create(DishUpsertRequest req){
    Dish d = new Dish();
    d.setName(req.name());
    d.setDescription(req.description());
    d.setDefaultQuartsPerThaaliUnit(req.defaultQuartsPerThaaliUnit());
    if(req.active()!=null) d.setActive(req.active());
    dishes.save(d);
    upsertIngredients(d, req.ingredients());
    return toDto(d);
  }

  public DishDto update(Long id, DishUpsertRequest req){
    Dish d = dishes.findById(id).orElseThrow();
    d.setName(req.name());
    d.setDescription(req.description());
    d.setDefaultQuartsPerThaaliUnit(req.defaultQuartsPerThaaliUnit());
    if(req.active()!=null) d.setActive(req.active());
    upsertIngredients(d, req.ingredients());
    return toDto(d);
  }

  public List<DishDto> list(){
    return dishes.findAll().stream().map(this::toDto).collect(java.util.stream.Collectors.toList());
  }

  private void upsertIngredients(Dish d, List<DishIngredientUpsert> ins){
    if(ins==null) return;
    // Clear existing ingredients and flush to avoid NonUniqueObjectException
    // when re-adding the same ingredient with different quantities
    d.getIngredients().clear();
    em.flush();

    for (DishIngredientUpsert i : ins){
      Ingredient ing = ingredients.findById(i.ingredientId()).orElseThrow();
      DishIngredient di = new DishIngredient();
      di.setDish(d);
      di.setIngredient(ing);
      di.setQtyPerQuart(i.qtyPerQuart());
      d.getIngredients().add(di);
    }
  }

  private DishDto toDto(Dish d){
    List<DishIngredientDto> ingDtos = d.getIngredients()==null? new ArrayList<>()
      : d.getIngredients().stream().map(di -> new DishIngredientDto(
        di.getIngredient().getId(),
        di.getIngredient().getName(),
        di.getIngredient().getUnit(),
        di.getQtyPerQuart(),
        di.getIngredient().getCostPerUnit(),
        di.getIngredient().getCaloriesPerUnit()
      )).collect(java.util.stream.Collectors.toList());

    // Calculate estimated cost per quart
    // Cost = sum of (qtyPerQuart * costPerUnit) for each ingredient
    BigDecimal estimatedCostPerQuart = null;
    if (d.getIngredients() != null && !d.getIngredients().isEmpty()) {
      BigDecimal totalCost = BigDecimal.ZERO;
      boolean hasCostData = false;
      for (DishIngredient di : d.getIngredients()) {
        if (di.getIngredient().getCostPerUnit() != null) {
          BigDecimal ingredientCost = di.getQtyPerQuart().multiply(di.getIngredient().getCostPerUnit());
          totalCost = totalCost.add(ingredientCost);
          hasCostData = true;
        }
      }
      if (hasCostData) {
        estimatedCostPerQuart = totalCost.setScale(2, RoundingMode.HALF_UP);
      }
    }

    // Calculate estimated calories per quart
    // Calories = sum of (qtyPerQuart * caloriesPerUnit) for each ingredient
    Integer estimatedCaloriesPerQuart = null;
    if (d.getIngredients() != null && !d.getIngredients().isEmpty()) {
      double totalCalories = 0;
      boolean hasCalorieData = false;
      for (DishIngredient di : d.getIngredients()) {
        if (di.getIngredient().getCaloriesPerUnit() != null) {
          double ingredientCalories = di.getQtyPerQuart().doubleValue() * di.getIngredient().getCaloriesPerUnit();
          totalCalories += ingredientCalories;
          hasCalorieData = true;
        }
      }
      if (hasCalorieData) {
        estimatedCaloriesPerQuart = (int) Math.round(totalCalories);
      }
    }

    return new DishDto(
        d.getId(),
        d.getName(),
        d.getDescription(),
        d.getDefaultQuartsPerThaaliUnit(),
        d.isActive(),
        ingDtos,
        estimatedCostPerQuart,
        estimatedCaloriesPerQuart
    );
  }
}
