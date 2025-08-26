import { Outlet, NavLink } from 'react-router-dom';

export default function App() {
  return (
    <div className="min-h-screen">
      {/* optional header/nav */}
      <header className="p-4 border-b">
        <nav className="flex gap-4">
          <NavLink to="/">Events</NavLink>
          <NavLink to="/admin">Admin</NavLink>
          <NavLink to="/login" className="ml-auto">Login</NavLink>
        </nav>
      </header>

      <main className="p-4">
        {/* child routes render here */}
        <Outlet />
      </main>
    </div>
  );
}