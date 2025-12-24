import { useState } from 'react';
import { Link, Outlet, useLocation } from 'react-router-dom';

type NavItem = {
  label: string;
  path?: string;
  children?: { label: string; path: string; disabled?: boolean }[];
};

const navItems: NavItem[] = [
  { label: 'Dashboard', path: '/admin' },
  {
    label: 'Events',
    children: [
      { label: 'All Events', path: '/admin/events' },
      { label: 'Create Thaali', path: '/admin/events/new/thaali' },
      { label: 'Create Niyaz', path: '/admin/events/new/niyaz' },
    ],
  },
  {
    label: 'Catalog',
    children: [
      { label: 'Dishes', path: '/admin/catalog/dishes' },
      { label: 'Ingredients', path: '/admin/catalog/ingredients' },
      { label: 'Chefs', path: '/admin/catalog/chefs' },
    ],
  },
  {
    label: 'Reports',
    children: [
      { label: 'Shopping List Generator', path: '/admin/reports/shopping-list' },
    ],
  },
  {
    label: 'Settings',
    children: [
      { label: 'Users', path: '/admin/settings/users' },
      { label: 'Pickup Zones', path: '/admin/settings/zones' },
    ],
  },
];

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
        className={`block px-4 py-2 rounded-lg mx-2 ${
          isActive(item.path)
            ? 'bg-gray-700 text-white'
            : 'text-gray-300 hover:bg-gray-800 hover:text-white'
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
        className="w-full flex items-center justify-between px-4 py-2 mx-2 text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg"
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
              className={`block px-4 py-1.5 rounded-lg mx-2 text-sm ${
                child.disabled
                  ? 'text-gray-500 cursor-not-allowed'
                  : isActive(child.path)
                  ? 'bg-gray-700 text-white'
                  : 'text-gray-400 hover:bg-gray-800 hover:text-white'
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
  return (
    <div className="flex min-h-[calc(100vh-3rem)]">
      {/* Sidebar */}
      <aside className="w-60 bg-gray-900 text-white flex-shrink-0">
        <div className="p-4 border-b border-gray-700">
          <h2 className="text-lg font-semibold">Admin Panel</h2>
        </div>
        <nav className="py-4 space-y-1">
          {navItems.map((item) => (
            <NavSection key={item.label} item={item} />
          ))}
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 bg-gray-50 p-6">
        <Outlet />
      </main>
    </div>
  );
}
