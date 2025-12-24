export type EventType = 'NIYAZ' | 'THAALI';
export type EventStatus = 'DRAFT' | 'PUBLISHED' | 'CANCELLED';

export type Event = {
  id: number;
  type: EventType;
  title: string;
  description?: string;
  eventDate: string;
  startTime?: string;
  registrationOpenAt?: string;
  registrationCloseAt?: string;
  status: EventStatus;
  // Niyaz-specific field
  miqaatName?: string;
};

// Menu item for Thaali events
export type MenuItem = {
  id: number;
  name: string;
  description?: string;
  quartsPerThaaliUnit: number;
  dishId?: number;
  position?: number;
};

// Thaali event with menu
export type ThaaliEvent = Event & {
  type: 'THAALI';
  menu: MenuItem[];
};

// Niyaz event with hosts
export type Host = {
  id: number;
  firstName: string;
  lastName: string;
  fullName: string;
};

export type NiyazEvent = Event & {
  type: 'NIYAZ';
  miqaatName: string;
  hostIds?: number[];
  hosts?: Host[];
};

// RSVP types
export type RsvpStatus = 'YES' | 'NO' | 'MAYBE';
export type RsvpRole = 'COOK' | 'FILL' | 'OTHER';

export type Rsvp = {
  name: string;
  email: string;
  phone?: string;
  status: RsvpStatus;
  role?: RsvpRole;
  headcount: number;
};

// Niyaz RSVP (adults/kids count)
export type NiyazRsvp = {
  eventId: number;
  personId: number;
  adults: number;
  kids: number;
};

// Meal sizes for Thaali orders
export type MealSize = 'LARGE' | 'SMALL' | 'BARAKATI';

// Thaali order item (one menu item with a size)
export type ThaaliOrderItem = {
  menuItemId: number;
  dishName?: string;
  size: MealSize;
};

// Thaali order (header with items)
export type ThaaliOrder = {
  id?: number;
  eventId: number;
  personId: number;
  pickupZoneId: number;
  pickupZoneName?: string;
  notes?: string;
  items: ThaaliOrderItem[];
};

// Request type for creating/updating Thaali order
export type ThaaliOrderRequest = {
  pickupZoneId: number;
  notes?: string;
  items: { menuItemId: number; size: MealSize }[];
};

// Pickup zone
export type PickupZone = {
  id: number;
  name: string;
  active: boolean;
};
