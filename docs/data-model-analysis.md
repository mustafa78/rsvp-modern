# RSVP Modern - Data Model Analysis

**Date:** December 20, 2025

## Overview

The application supports two types of events:
1. **Niyaz** - RSVP-based event where people indicate how many adults and kids are attending
2. **Thaali** - Community kitchen cooking where a menu is published and people register for thaali with size selection and pickup location

## Current Design Analysis

### Niyaz Event - Well Designed

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| RSVP for attendance | `NiyazRsvp` entity | ✅ |
| Adults count | `NiyazRsvp.adults` (int) | ✅ |
| Kids count | `NiyazRsvp.kids` (int) | ✅ |
| One RSVP per person | Unique constraint (event_id, person_id) | ✅ |
| Miqaat details | `miqaatName`, `miqaatDate`, `miqaatTime` | ✅ |

### Thaali Event - Well Designed

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| Menu is published | `ThaaliEvent.menu` → `MenuItem` → `Dish` | ✅ |
| Register for thaali | `ThaaliOrder` entity | ✅ |
| Select size | `largeCount`, `smallCount`, `barakatiCount` | ✅ |
| Pickup location | `ThaaliOrder.pickupZone` (required) | ✅ |
| One order per person | Unique constraint (event_id, person_id) | ✅ |

### Size System (MealSize enum)

| Size | Quarts | Ounces |
|------|--------|--------|
| LARGE | 1.0 | 32 oz |
| SMALL | 0.5 | 16 oz |
| BARAKATI | 0.25 | 8 oz |

## Entity Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              EVENT (Abstract)                                │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │ id, title, description, eventDate, startTime                        │    │
│  │ registrationOpenAt, registrationCloseAt, status                     │    │
│  │ event_type (discriminator: NIYAZ | THAALI)                          │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                    │                              │                          │
│          ┌────────┴────────┐            ┌───────┴────────┐                  │
│          ▼                 ▼            ▼                ▼                  │
│   ┌─────────────┐   ┌─────────────┐                                         │
│   │ NiyazEvent  │   │ ThaaliEvent │                                         │
│   │─────────────│   │─────────────│                                         │
│   │ miqaatName  │   │ menu ───────┼──► MenuItem ──► Dish ──► DishIngredient │
│   │ miqaatDate  │   │             │                              │          │
│   │ miqaatTime  │   │             │                              ▼          │
│   └──────┬──────┘   └──────┬──────┘                         Ingredient      │
│          │                 │                                                 │
└──────────┼─────────────────┼─────────────────────────────────────────────────┘
           │                 │
           ▼                 ▼
    ┌─────────────┐   ┌─────────────┐
    │ NiyazRsvp   │   │ ThaaliOrder │
    │─────────────│   │─────────────│
    │ person ─────┼──►│ person ─────┼──► Person
    │ adults      │   │ largeCount  │       │
    │ kids        │   │ smallCount  │       └──► pickupZone (default)
    └─────────────┘   │ barakatiCount│
                      │ pickupZone ──┼──► PickupZone
                      │ notes        │
                      └─────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                            CHEF MANAGEMENT                                   │
│                                                                              │
│   Event ◄──────── EventChef ────────► Chef                                  │
│                   (role)              │                                      │
│                                       └── type: PERSON | GROUP | EXTERNAL   │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Key Entities

### Event (Abstract Base)
- **Location:** `server/src/main/java/com/acme/rsvp/model/Event.java`
- Uses Single Table Inheritance with `event_type` discriminator
- Common fields: title, description, eventDate, startTime, registrationOpenAt/CloseAt, status
- Has ManyToMany relationship with Chef via EventChef

### NiyazEvent
- **Discriminator:** `NIYAZ`
- Additional fields: `miqaatName`, `miqaatDate`, `miqaatTime`
- RSVPs stored in `NiyazRsvp`

### ThaaliEvent
- **Discriminator:** `THAALI`
- Has `menu` (OneToMany → MenuItem)
- Orders stored in `ThaaliOrder`

### NiyazRsvp
- **Location:** `server/src/main/java/com/acme/rsvp/model/NiyazRsvp.java`
- Fields: event, person, adults, kids
- Unique constraint: (event_id, person_id)

### ThaaliOrder
- **Location:** `server/src/main/java/com/acme/rsvp/model/ThaaliOrder.java`
- Fields: event, person, largeCount, smallCount, barakatiCount, pickupZone, notes
- Computed: `getTotalQuarts()` = (large × 1.0) + (small × 0.5) + (barakati × 0.25)
- Unique constraint: (event_id, person_id)

### PickupZone
- **Location:** `server/src/main/java/com/acme/rsvp/model/PickupZone.java`
- Fields: id, name, active
- Predefined zones:
  1. SELF_PICKUP_NAJMI_MASJID
  2. NORTH_POTOMAC_ROCKVILLE
  3. GERMANTOWN
  4. WASHINGTON_DC
  5. FREDERICK
  6. ELLICOTT_CITY_COLUMBIA
  7. CLARKSVILLE

### Menu System

```
Dish (catalog)
├── name (unique)
├── description
├── defaultQuartsPerThaaliUnit
├── active
└── ingredients → DishIngredient → Ingredient

MenuItem (event-specific)
├── event
├── dish (optional reference to catalog)
├── quartsPerThaaliUnit (override)
└── position (display order)
```

### Chef System

```
Chef
├── name (unique)
├── type: PERSON | GROUP | EXTERNAL
├── email, phone, notes
└── active

EventChef (join table)
├── event
├── chef
└── role (optional description)
```

## Person Entity

- **Location:** `server/src/main/java/com/acme/rsvp/model/Person.java`
- Key fields:
  - `itsNumber` (unique login identifier)
  - `firstName`, `lastName`, `email`, `phone`
  - `roles` (Set<RoleName>: USER, SUPER_USER, ADMIN)
  - `pickupZone` (optional default for ThaaliOrders)
  - Authentication: passwordHash, accountStatus, failedLoginCount, etc.

## Event Status Flow

```
DRAFT → PUBLISHED → CANCELLED
         │
         └── Registration window: registrationOpenAt to registrationCloseAt
```

## DTOs

### Event DTOs (`EventDtos.java`)
- `CreateUpdateNiyazEventRequest` - Create/update Niyaz events
- `CreateUpdateThaaliEventRequest` - Create/update Thaali events with menu
- `EventSummaryDto` - List view
- `NiyazEventDto` / `ThaaliEventDto` - Detail views

### RSVP DTOs (`RsvpDtos.java`)
- `NiyazRsvpDto` - RSVP submission
- `ThaaliOrderDto` - Order submission
- `ThaaliCountReportDto` - Aggregated counts
- `ShoppingListItemDto` - Ingredient requirements

## Design Notes

1. **Person's default pickupZone**: Users have a default `pickupZone` on their profile, but `ThaaliOrder` has its own `pickupZone` - allows overriding per order.

2. **Shopping list support**: `DishIngredient.qtyPerQuart` enables calculating total ingredient requirements based on orders - useful for kitchen planning.

3. **Chef assignment**: Both event types can have chefs assigned via the `EventChef` join table with roles.

4. **Flexible menu**: MenuItem can reference a Dish from catalog or be standalone, with optional quart override.

## Verdict

**The design correctly implements both event types.** ✅
