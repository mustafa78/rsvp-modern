import { useState, useMemo } from 'react';
import { Link, Outlet, useLocation } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { api } from '../../api/client';

type NavItem = {
  label: string;
  path?: string;
  children?: { label: string; path: string; disabled?: boolean }[];
};

type User = {
  personId: number;
  roles: string[];
};

// Helper to check if user has a specific role
const hasRole = (roles: string[], role: string) => roles?.includes(role) ?? false;
const isAdmin = (roles: string[]) => hasRole(roles, 'ADMIN');
const isNiyazCoordinator = (roles: string[]) => hasRole(roles, 'NIYAZ_COORDINATOR');
const isThaaliCoordinator = (roles: string[]) => hasRole(roles, 'THAALI_COORDINATOR');
const isMenuCoordinator = (roles: string[]) => hasRole(roles, 'MENU_COORDINATOR');
const isShoppingCoordinator = (roles: string[]) => hasRole(roles, 'SHOPPING_COORDINATOR');
const isDanaCoordinator = (roles: string[]) => hasRole(roles, 'DANA_COORDINATOR');

// Build navigation items based on user roles
const getNavItems = (roles: string[]): NavItem[] => {
  const items: NavItem[] = [];
  const admin = isAdmin(roles);
  const niyazCoord = isNiyazCoordinator(roles);
  const thaaliCoord = isThaaliCoordinator(roles);
  const danaCoord = isDanaCoordinator(roles);

  // Dashboard - visible to all admin panel users
  items.push({ label: 'Dashboard', path: '/admin' });

  // Events section
  const eventChildren: { label: string; path: string }[] = [];
  const shoppingCoord = isShoppingCoordinator(roles);
  if (admin || niyazCoord || thaaliCoord || danaCoord || shoppingCoord) {
    eventChildren.push({ label: 'All Events', path: '/admin/events' });
  }
  if (admin || thaaliCoord) {
    eventChildren.push({ label: 'Create Thaali', path: '/admin/events/new/thaali' });
  }
  if (admin || niyazCoord) {
    eventChildren.push({ label: 'Create Niyaz', path: '/admin/events/new/niyaz' });
  }
  if (eventChildren.length > 0) {
    items.push({ label: 'Events', children: eventChildren });
  }

  // Catalog - based on role
  const menuCoord = isMenuCoordinator(roles);

  if (admin || menuCoord || shoppingCoord) {
    const catalogChildren: { label: string; path: string }[] = [];

    // Dishes - Admin, Menu Coordinator, Shopping Coordinator (view only for Shopping)
    if (admin || menuCoord || shoppingCoord) {
      catalogChildren.push({ label: 'Dishes', path: '/admin/catalog/dishes' });
    }
    // Ingredients - Admin, Menu Coordinator, Shopping Coordinator
    if (admin || menuCoord || shoppingCoord) {
      catalogChildren.push({ label: 'Ingredients', path: '/admin/catalog/ingredients' });
    }
    // Chefs - Admin, Menu Coordinator
    if (admin || menuCoord) {
      catalogChildren.push({ label: 'Chefs', path: '/admin/catalog/chefs' });
    }
    // Categories - Admin, Menu Coordinator, Shopping Coordinator
    if (admin || menuCoord || shoppingCoord) {
      catalogChildren.push({ label: 'Categories', path: '/admin/catalog/categories' });
    }
    // Stores - Admin, Shopping Coordinator
    if (admin || shoppingCoord) {
      catalogChildren.push({ label: 'Stores', path: '/admin/catalog/stores' });
    }
    // Storage Locations - Admin, Shopping Coordinator
    if (admin || shoppingCoord) {
      catalogChildren.push({ label: 'Storage Locations', path: '/admin/catalog/storage-locations' });
    }
    // Units - Admin, Menu Coordinator, Shopping Coordinator
    if (admin || menuCoord || shoppingCoord) {
      catalogChildren.push({ label: 'Units', path: '/admin/catalog/units' });
    }

    if (catalogChildren.length > 0) {
      items.push({ label: 'Catalog', children: catalogChildren });
    }
  }

  // Reports - Admin, Shopping Coordinator, and Dana Coordinator
  if (admin || shoppingCoord || danaCoord) {
    items.push({
      label: 'Reports',
      children: [
        { label: 'Shopping List Generator', path: '/admin/reports/shopping-list' },
      ],
    });
  }

  // Announcements - admin and coordinators
  if (admin || niyazCoord || thaaliCoord) {
    items.push({ label: 'Announcements', path: '/admin/announcements' });
  }

  // Settings - admin only
  if (admin) {
    items.push({
      label: 'Settings',
      children: [
        { label: 'Users', path: '/admin/settings/users' },
        { label: 'Roles', path: '/admin/settings/roles' },
        { label: 'Pickup Zones', path: '/admin/settings/zones' },
      ],
    });
  }

  return items;
};

function ChevronDown({ open }: { open: boolean }) {
  return (
    <svg
      className={`w-4 h-4 transition-transform ${open ? 'rotate-180' : ''}`}
      fill="none"
      stroke="currentColor"
      viewBox="0 0 24 24"
    >
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
    </svg>
  );
}

function NavSection({ item }: { item: NavItem }) {
  const location = useLocation();
  const [open, setOpen] = useState(() => {
    if (!item.children) return false;
    return item.children.some((c) => location.pathname === c.path);
  });

  const isActive = (path: string) => location.pathname === path;

  if (item.path && !item.children) {
    return (
      <Link
        to={item.path}
        className={`block px-4 py-2 rounded-lg mx-2 transition-colors ${
          isActive(item.path)
            ? 'bg-purple-600/30 text-white border-l-2 border-purple-400'
            : 'text-gray-300 hover:bg-white/5 hover:text-white'
        }`}
      >
        {item.label}
      </Link>
    );
  }

  return (
    <div>
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between px-4 py-2 mx-2 text-gray-300 hover:bg-white/5 hover:text-white rounded-lg transition-colors"
        style={{ width: 'calc(100% - 1rem)' }}
      >
        <span>{item.label}</span>
        <ChevronDown open={open} />
      </button>
      {open && item.children && (
        <div className="ml-4 mt-1 space-y-1">
          {item.children.map((child) => (
            <Link
              key={child.path}
              to={child.path}
              className={`block px-4 py-1.5 rounded-lg mx-2 text-sm transition-colors ${
                child.disabled
                  ? 'text-gray-500 cursor-not-allowed'
                  : isActive(child.path)
                  ? 'bg-purple-600/30 text-white border-l-2 border-purple-400'
                  : 'text-gray-400 hover:bg-white/5 hover:text-white'
              }`}
              onClick={(e) => child.disabled && e.preventDefault()}
            >
              {child.label}
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}

export default function AdminLayout() {
  const { data: user } = useQuery<User>({
    queryKey: ['me'],
    queryFn: () => api.me() as Promise<User>,
    staleTime: 1000 * 60 * 5,
  });

  const navItems = useMemo(() => {
    return getNavItems(user?.roles || []);
  }, [user?.roles]);

  return (
    <div className="flex min-h-[calc(100vh-7rem)]">
      {/* Sidebar */}
      <aside className="w-56 lg:w-64 bg-gradient-to-b from-gray-900 via-gray-900 to-purple-900 text-white flex-shrink-0">
        <div className="p-4 border-b border-white/10">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
              <svg className="w-5 h-5 text-purple-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <h2 className="text-lg font-semibold">Admin Panel</h2>
          </div>
        </div>
        <nav className="py-4 space-y-1">
          {navItems.map((item) => (
            <NavSection key={item.label} item={item} />
          ))}
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 bg-gray-50 p-4 lg:p-8 overflow-x-auto">
        <div className="max-w-[1600px]">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
