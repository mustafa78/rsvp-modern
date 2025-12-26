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
};

// Public routes that don't require authentication
const PUBLIC_ROUTES = ['/login', '/forgot-password', '/reset-password'];

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

  const isPublicRoute = PUBLIC_ROUTES.some(route => location.pathname.startsWith(route));

  // Redirect to login if not authenticated and not on a public route
  useEffect(() => {
    if (!isLoading && !user && !isPublicRoute) {
      navigate('/login', { replace: true });
    }
  }, [isLoading, user, isPublicRoute, navigate]);

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

  // Show minimal layout for public routes (login, forgot password, etc.)
  if (isPublicRoute) {
    return (
      <div className="min-h-screen bg-neutral-50 text-black">
        <header className="border-b">
          <div className="max-w-6xl mx-auto px-4 h-12 flex items-center">
            <span className="font-semibold">RSVP System</span>
          </div>
        </header>
        <main className="max-w-6xl mx-auto px-4 py-6">
          <Outlet />
        </main>
      </div>
    );
  }

  // Show loading state while checking auth
  if (isLoading) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center">
        <div className="text-gray-500">Loading...</div>
      </div>
    );
  }

  // If not authenticated and not public route, don't render (redirect will happen)
  if (!user) {
    return null;
  }

  // Authenticated layout
  return (
    <div className="min-h-screen bg-neutral-50 text-black">
      <header className="border-b">
        <div className="max-w-6xl mx-auto px-4 h-12 flex items-center justify-between">
          <nav className="space-x-6">
            <Link to="/" className="font-semibold">Events</Link>
            {(user.roles?.includes('ADMIN') ||
              user.roles?.includes('NIYAZ_COORDINATOR') ||
              user.roles?.includes('THAALI_COORDINATOR')) && (
              <Link to="/admin">Admin</Link>
            )}
          </nav>
          <nav className="flex items-center space-x-4">
            <span className="text-sm text-gray-600">
              {user.firstName} {user.lastName}
            </span>
            <button
              onClick={handleLogout}
              className="text-sm underline hover:no-underline"
            >
              Logout
            </button>
          </nav>
        </div>
      </header>
      <main className="max-w-6xl mx-auto px-4 py-6">
        <Outlet />
      </main>
    </div>
  );
}