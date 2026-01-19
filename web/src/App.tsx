// web/src/App.tsx
import { useEffect } from 'react';
import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api/client';

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
const PUBLIC_ROUTES = ['/', '/login', '/forgot-password', '/reset-password', '/change-password-public'];

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

  const isPublicRoute = PUBLIC_ROUTES.some(route =>
    route === '/' ? location.pathname === '/' : location.pathname.startsWith(route)
  );

  // Check if user has any admin role
  const hasAdminRole = user?.roles?.some(role =>
    ['ADMIN', 'NIYAZ_COORDINATOR', 'THAALI_COORDINATOR', 'SHOPPING_COORDINATOR'].includes(role)
  );

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
            {/* User Info */}
            <div className="flex items-center gap-3 pl-3 border-l border-white/20">
              <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center">
                <span className="text-xs font-semibold text-white">
                  {user.firstName.charAt(0)}{user.lastName.charAt(0)}
                </span>
              </div>
              <div className="hidden sm:block">
                <p className="text-sm font-medium text-white leading-tight">
                  {user.firstName} {user.lastName}
                </p>
                <p className="text-xs text-white/70 leading-tight">
                  {user.itsNumber}
                </p>
              </div>
            </div>

            {/* Logout Button */}
            <button
              onClick={handleLogout}
              className="p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-colors"
              title="Logout"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
              </svg>
            </button>
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