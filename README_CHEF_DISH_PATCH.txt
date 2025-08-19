WHAT'S IN THIS PATCH
--------------------
- Flyway V3 migration: introduces `chefs`, `event_chefs`, `dishes`, `dish_ingredients`; updates `menu_items` to reference `dish_id`.
- Java model: Chef, ChefType, Dish, DishIngredient(+Id), EventChef(+Id), updated MenuItem (now references Dish).
- Repositories: ChefRepository, DishRepository, DishIngredientRepository, EventChefRepository, MenuItemRepository,
  IngredientRepository (minimal), EventRepository (minimal), and updated ThaaliOrderRepository to compute shopping lists via the dish catalog.
- DTOs: ChefDtos, DishDtos, EventMenuAssignmentDtos.
- Services: ChefService, DishService, EventAdminService.
- Controllers: ChefController, DishController, EventAdminController.

HOW TO APPLY
------------
1) Copy `server/src/main/resources/db/migration/V3__chefs_and_dish_catalog.sql` into your server project (same path).
2) Copy the Java files under `server/src/main/java/com/acme/rsvp/...` into your codebase (merge/replace same-named files).
3) Rebuild: `cd server && ./gradlew clean build -x test`
4) Run migrations (dev example): `docker compose --env-file .env.dev -f docker-compose.dev.yml exec server ./gradlew flywayMigrate`
5) Seed data:
   - Create ingredients (if you haven't already).
   - POST /api/dishes with per-quart recipe.
   - POST /api/chefs to add chefs.
   - POST /api/events/{eventId}/menu to assign dishes to an event.
   - POST /api/events/{eventId}/chefs to assign chefs to an event.

NOTES
-----
- If you previously used `event_chefs(event_id, person_id)`, it will be renamed to `event_person_chefs` for safekeeping.
- New `event_chefs` is reserved for Chef assignments.
- Legacy `menu_item_ingredients` is left intact (not used by the new computations).
