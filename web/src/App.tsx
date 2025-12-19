// web/src/App.tsx
import { Link, Outlet, useNavigate } from 'react-router-dom';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api/client';

type User = {
  personId: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
};

export default function App() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { data: user, isLoading } = useQuery<User>({
    queryKey: ['me'],
    queryFn: () => api.me() as Promise<User>,
    retry: false,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });

  const handleLogout = async () => {
    try {
      await api.logout();
      queryClient.clear();
      navigate('/login');
    } catch (e) {
      // ignore errors, just redirect
      navigate('/login');
    }
  };

  return (
    <div className="min-h-screen bg-neutral-50 text-black">
      <header className="border-b">
        <div className="max-w-6xl mx-auto px-4 h-12 flex items-center justify-between">
          <nav className="space-x-6">
            <Link to="/">Events</Link>
            <Link to="/admin">Admin</Link>
          </nav>
          <nav className="flex items-center space-x-4">
            {isLoading ? null : user ? (
              <>
                <span className="text-sm text-gray-600">
                  {user.firstName} {user.lastName}
                </span>
                <button
                  onClick={handleLogout}
                  className="text-sm underline hover:no-underline"
                >
                  Logout
                </button>
              </>
            ) : (
              <Link to="/login">Login</Link>
            )}
          </nav>
        </div>
      </header>
      <main className="max-w-6xl mx-auto px-4 py-6">
        <Outlet />
      </main>
    </div>
  );
}