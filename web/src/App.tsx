// web/src/App.tsx
import { Link, Outlet } from 'react-router-dom';

export default function App() {
  return (
    <div className="min-h-screen bg-neutral-50 text-black">
      <header className="border-b">
        <div className="max-w-6xl mx-auto px-4 h-12 flex items-center justify-between">
          <nav className="space-x-6">
            <Link to="/">Events</Link>
            <Link to="/admin">Admin</Link>
          </nav>
          <nav>
            <Link to="/login">Login</Link>
          </nav>
        </div>
      </header>
      <main className="max-w-6xl mx-auto px-4 py-6">
        <Outlet />
      </main>
    </div>
  );
}