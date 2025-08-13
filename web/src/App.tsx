import { Link, Outlet } from 'react-router-dom'

export default function App(){
  return (
    <div className="max-w-5xl mx-auto p-6 space-y-6">
      <header className="flex items-center justify-between">
        <Link to="/" className="text-2xl font-bold">Community Kitchen RSVP</Link>
        <nav className="space-x-4">
          <Link to="/" className="underline">Events</Link>
          <Link to="/admin" className="underline">Admin</Link>
        </nav>
      </header>
      <Outlet />
    </div>
  )
}
