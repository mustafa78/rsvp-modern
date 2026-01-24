// web/src/App.tsx
import { useEffect, useState, useRef } from 'react';
import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api/client';

type UnreadCountResponse = {
  count: number;
};

type User = {
  personId: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  roles: string[];
  isHof: boolean;
};

// Public routes that don't require authentication
const PUBLIC_ROUTES = ['/', '/login', '/forgot-password', '/reset-password'];

export default function App() {
  const navigate = useNavigate();
  const location = useLocation();
  const queryClient = useQueryClient();
  const { data: user, isLoading, isError } = useQuery<User>({
    queryKey: ['me'],
    queryFn: () => api.me() as Promise<User>,
    retry: false,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });

  // Fetch unread announcement count
  const { data: unreadCountData } = useQuery<UnreadCountResponse>({
    queryKey: ['announcements-unread-count'],
    queryFn: async () => (await api.get('/announcements/unread-count')).data,
    enabled: !!user,
    staleTime: 1000 * 30, // 30 seconds
    refetchInterval: 1000 * 60, // Refetch every minute
  });

  const unreadCount = unreadCountData?.count || 0;

  const isPublicRoute = PUBLIC_ROUTES.some(route =>
    route === '/' ? location.pathname === '/' : location.pathname.startsWith(route)
  );

  // Check if user has any admin role
  const hasAdminRole = user?.roles?.some(role =>
    ['ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR', 'SHOPPING_COORDINATOR', 'DANA_COORDINATOR'].includes(role)
  );

  // User dropdown state - must be declared before any conditional returns (Rules of Hooks)
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const userMenuRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (userMenuRef.current && !userMenuRef.current.contains(event.target as Node)) {
        setUserMenuOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Redirect to login if not authenticated and not on a public route
  // Redirect logged-in users from landing page to events
  // Redirect non-HOF users away from events pages to admin
  useEffect(() => {
    if (!isLoading && !user && !isPublicRoute) {
      navigate('/login', { replace: true });
    }
    // Redirect logged-in users from landing page to events
    if (!isLoading && user && location.pathname === '/') {
      if (user.isHof) {
        navigate('/events', { replace: true });
      } else if (hasAdminRole) {
        navigate('/admin', { replace: true });
      }
    }
    // Non-HOF users should be redirected to admin if they try to access events
    if (!isLoading && user && !user.isHof && !isPublicRoute) {
      const isEventsRoute = location.pathname.startsWith('/events') ||
        location.pathname.startsWith('/rsvp');
      if (isEventsRoute && hasAdminRole) {
        navigate('/admin', { replace: true });
      }
    }
  }, [isLoading, user, isPublicRoute, navigate, location.pathname, hasAdminRole]);

  const handleLogout = async () => {
    try {
      await api.logout();
      queryClient.clear();
      navigate('/login');
    } catch (e) {
      // ignore errors, just redirect
      queryClient.clear();
      navigate('/login');
    }
  };

  // Landing page has its own layout, render it directly for non-logged-in users
  // Logged-in users will be redirected by useEffect, show nothing while that happens
  if (location.pathname === '/') {
    if (isLoading) {
      return (
        <div className="min-h-screen bg-neutral-50 flex items-center justify-center">
          <div className="text-gray-500">Loading...</div>
        </div>
      );
    }
    if (user) {
      // User is logged in, redirect will happen via useEffect
      return null;
    }
    return <Outlet />;
  }

  // Login page has its own full-screen layout
  if (location.pathname === '/login') {
    return <Outlet />;
  }

  // Show minimal layout for other public routes (forgot password, etc.)
  if (isPublicRoute) {
    return (
      <div className="min-h-screen bg-neutral-50 text-black flex flex-col">
        <header className="bg-white shadow-sm">
          <div className="max-w-6xl mx-auto px-4 h-16 flex items-center">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-purple-600 to-blue-600 flex items-center justify-center">
                <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <span className="font-bold text-gray-900">RSVP</span>
            </div>
          </div>
        </header>
        <main className="flex-1 px-4 py-6">
          <div className="max-w-lg mx-auto">
            <Outlet />
          </div>
        </main>
        <footer className="border-t bg-white">
          <div className="max-w-6xl mx-auto px-4 py-4 text-center text-sm text-gray-500">
            Copyright © Anjuman-e-Ezzi, Washington DC. All Rights Reserved
          </div>
        </footer>
      </div>
    );
  }

  // Show loading state while checking auth
  if (isLoading) {
    return (
      <div className="min-h-screen bg-neutral-50 flex flex-col">
        <div className="flex-1 flex items-center justify-center">
          <div className="text-gray-500">Loading...</div>
        </div>
        <footer className="border-t">
          <div className="max-w-6xl mx-auto px-4 py-4 text-center text-sm text-gray-500">
            Copyright © Anjuman-e-Ezzi, Washington DC. All Rights Reserved
          </div>
        </footer>
      </div>
    );
  }

  // If not authenticated and not public route, don't render (redirect will happen)
  if (!user) {
    return null;
  }

  // Check if current route is active
  const isEventsActive = location.pathname.startsWith('/events') && !location.pathname.startsWith('/admin');
  const isCalendarActive = location.pathname === '/calendar';
  const isAdminActive = location.pathname.startsWith('/admin');

  // Authenticated layout
  return (
    <div className="min-h-screen bg-neutral-50 text-black flex flex-col">
      <header className="bg-gradient-to-r from-purple-600 to-blue-600 sticky top-0 z-50 shadow-lg">
        <div className="px-4 lg:px-6 h-16 flex items-center justify-between">
          {/* Left: Logo & Navigation */}
          <div className="flex items-center gap-8">
            {/* Logo/Brand */}
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg bg-white/20 flex items-center justify-center">
                <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <span className="font-bold text-white hidden sm:block">RSVP</span>
            </div>

            {/* Navigation */}
            <nav className="flex items-center gap-1">
              {user.isHof && (
                <>
                  <Link
                    to="/events"
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                      isEventsActive
                        ? 'bg-white/20 text-white'
                        : 'text-white/80 hover:bg-white/10 hover:text-white'
                    }`}
                  >
                    Events
                  </Link>
                  <Link
                    to="/calendar"
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                      isCalendarActive
                        ? 'bg-white/20 text-white'
                        : 'text-white/80 hover:bg-white/10 hover:text-white'
                    }`}
                  >
                    Calendar
                  </Link>
                </>
              )}
              {hasAdminRole && (
                <Link
                  to="/admin"
                  className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                    isAdminActive
                      ? 'bg-white/20 text-white'
                      : 'text-white/80 hover:bg-white/10 hover:text-white'
                  }`}
                >
                  Admin
                </Link>
              )}
            </nav>
          </div>

          {/* Right: User Menu */}
          <div className="flex items-center gap-3">
            {/* Notification Bell */}
            <Link
              to="/announcements"
              className="relative p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-colors"
              title="Announcements"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
              </svg>
              {unreadCount > 0 && (
                <span className="absolute -top-0.5 -right-0.5 inline-flex items-center justify-center w-4 h-4 text-[10px] font-bold text-white bg-red-500 rounded-full">
                  {unreadCount > 9 ? '9+' : unreadCount}
                </span>
              )}
            </Link>

            {/* User Menu Dropdown */}
            <div className="relative pl-3 border-l border-white/20" ref={userMenuRef}>
              <button
                onClick={() => setUserMenuOpen(!userMenuOpen)}
                className="flex items-center gap-3 p-1 rounded-lg hover:bg-white/10 transition-colors"
              >
                <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center">
                  <span className="text-xs font-semibold text-white">
                    {user.firstName.charAt(0)}{user.lastName.charAt(0)}
                  </span>
                </div>
                <div className="hidden sm:block text-left">
                  <p className="text-sm font-medium text-white leading-tight">
                    {user.firstName} {user.lastName}
                  </p>
                  <p className="text-xs text-white/70 leading-tight">
                    {user.itsNumber}
                  </p>
                </div>
                <svg
                  className={`w-4 h-4 text-white/70 transition-transform ${userMenuOpen ? 'rotate-180' : ''}`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {/* Dropdown Menu */}
              {userMenuOpen && (
                <div className="absolute right-0 mt-2 w-56 bg-white rounded-xl shadow-lg border border-gray-100 py-2 z-50">
                  {/* User Info Header */}
                  <div className="px-4 py-3 border-b border-gray-100">
                    <p className="text-sm font-semibold text-gray-900">
                      {user.firstName} {user.lastName}
                    </p>
                    <p className="text-xs text-gray-500">{user.email}</p>
                    <p className="text-xs text-gray-400 mt-1">ITS: {user.itsNumber}</p>
                  </div>

                  {/* Menu Items */}
                  <div className="py-1">
                    <Link
                      to="/profile"
                      onClick={() => setUserMenuOpen(false)}
                      className="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                    >
                      <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                      My Profile
                    </Link>
                    <Link
                      to="/profile?tab=security"
                      onClick={() => setUserMenuOpen(false)}
                      className="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                    >
                      <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                      </svg>
                      Change Password
                    </Link>
                  </div>

                  {/* Logout */}
                  <div className="border-t border-gray-100 pt-1">
                    <button
                      onClick={() => {
                        setUserMenuOpen(false);
                        handleLogout();
                      }}
                      className="flex items-center gap-3 w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                      </svg>
                      Logout
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>
      <main className="flex-1">
        <Outlet />
      </main>
      <footer className="border-t bg-white">
        <div className="px-4 py-4 text-center text-sm text-gray-500">
          Copyright © Anjuman-e-Ezzi, Washington DC. All Rights Reserved
        </div>
      </footer>
    </div>
  );
}