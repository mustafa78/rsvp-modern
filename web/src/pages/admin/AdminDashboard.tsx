import { useQuery } from '@tanstack/react-query';
import { Link } from 'react-router-dom';
import { api } from '../../api/client';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

export default function AdminDashboard() {
  const { data: events, isLoading } = useQuery<Event[]>({
    queryKey: ['admin-events'],
    queryFn: async () => (await api.get('/events')).data,
  });

  const today = new Date().toISOString().split('T')[0];
  const upcomingEvents = events?.filter((e) => e.eventDate >= today) || [];
  const pastEvents = events?.filter((e) => e.eventDate < today) || [];
  const publishedEvents = events?.filter((e) => e.status === 'PUBLISHED') || [];
  const draftEvents = events?.filter((e) => e.status === 'DRAFT') || [];

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="card">
          <div className="text-3xl font-bold text-blue-600">{upcomingEvents.length}</div>
          <div className="text-gray-500 text-sm">Upcoming Events</div>
        </div>
        <div className="card">
          <div className="text-3xl font-bold text-green-600">{publishedEvents.length}</div>
          <div className="text-gray-500 text-sm">Published</div>
        </div>
        <div className="card">
          <div className="text-3xl font-bold text-yellow-600">{draftEvents.length}</div>
          <div className="text-gray-500 text-sm">Drafts</div>
        </div>
        <div className="card">
          <div className="text-3xl font-bold text-gray-600">{pastEvents.length}</div>
          <div className="text-gray-500 text-sm">Past Events</div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Quick Actions</h2>
        <div className="flex gap-3">
          <Link to="/admin/events/new/thaali" className="btn">
            + Create Thaali Event
          </Link>
          <Link to="/admin/events/new/niyaz" className="btn bg-gray-700">
            + Create Niyaz Event
          </Link>
        </div>
      </div>

      {/* Recent Events */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Upcoming Events</h2>
        {upcomingEvents.length === 0 ? (
          <p className="text-gray-500">No upcoming events</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Title</th>
                <th className="pb-2 font-medium">Type</th>
                <th className="pb-2 font-medium">Date</th>
                <th className="pb-2 font-medium">Status</th>
              </tr>
            </thead>
            <tbody>
              {upcomingEvents.slice(0, 5).map((event) => (
                <tr key={event.id} className="border-b last:border-0">
                  <td className="py-2">
                    <Link to={`/admin/events/${event.id}`} className="text-blue-600 hover:underline">
                      {event.title}
                    </Link>
                  </td>
                  <td className="py-2">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        event.type === 'THAALI' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
                      }`}
                    >
                      {event.type}
                    </span>
                  </td>
                  <td className="py-2 text-gray-600">{event.eventDate}</td>
                  <td className="py-2">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        event.status === 'PUBLISHED'
                          ? 'bg-green-100 text-green-700'
                          : event.status === 'DRAFT'
                          ? 'bg-yellow-100 text-yellow-700'
                          : 'bg-red-100 text-red-700'
                      }`}
                    >
                      {event.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {upcomingEvents.length > 5 && (
          <div className="mt-4">
            <Link to="/admin/events" className="text-blue-600 hover:underline text-sm">
              View all events →
            </Link>
          </div>
        )}
      </div>
    </div>
  );
}
