import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';

type EventSummary = {
  id: number;
  type: string;
  title: string;
  description: string;
  eventDate: string;
  startTime: string | null;
  registrationOpenAt: string;
  registrationCloseAt: string;
  status: 'DRAFT' | 'PUBLISHED' | 'CANCELLED';
};

export default function EventDetail() {
  const { id } = useParams<{ id: string }>();

  const { data: event, isLoading, error } = useQuery<EventSummary>({
    queryKey: ['event', id],
    queryFn: async () => (await api.get(`/events/${id}`)).data,
    enabled: !!id,
  });

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  if (error || !event) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Event Not Found</h1>
        <p className="text-gray-500">The event you're looking for doesn't exist.</p>
        <Link to="/admin/events" className="text-blue-600 hover:underline">
          ← Back to Events
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-3xl">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">{event.title}</h1>
        <div className="flex gap-2 items-center">
          <span
            className={`text-xs px-2 py-1 rounded ${
              event.type === 'THAALI'
                ? 'bg-purple-100 text-purple-700'
                : 'bg-blue-100 text-blue-700'
            }`}
          >
            {event.type}
          </span>
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
        </div>
      </div>

      <div className="card space-y-4">
        <h2 className="text-lg font-semibold">Event Details</h2>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm text-gray-500">Event Date</label>
            <p className="font-medium">{event.eventDate}</p>
          </div>
          <div>
            <label className="text-sm text-gray-500">Start Time</label>
            <p className="font-medium">{event.startTime ? event.startTime.slice(0, 5) : 'Not set'}</p>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm text-gray-500">Registration Opens</label>
            <p className="font-medium">{new Date(event.registrationOpenAt).toLocaleString()}</p>
          </div>
          <div>
            <label className="text-sm text-gray-500">Registration Closes</label>
            <p className="font-medium">{new Date(event.registrationCloseAt).toLocaleString()}</p>
          </div>
        </div>

        {event.description && (
          <div>
            <label className="text-sm text-gray-500">Description</label>
            <p>{event.description}</p>
          </div>
        )}
      </div>

      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Actions</h2>
        <div className="flex gap-3 flex-wrap">
          {event.type === 'NIYAZ' && (
            <Link to={`/admin/events/edit/niyaz/${event.id}`} className="btn">
              Edit Event
            </Link>
          )}
          {event.type === 'THAALI' && (
            <Link to={`/admin/events/edit/thaali/${event.id}`} className="btn">
              Edit Event
            </Link>
          )}
          {event.type === 'THAALI' && event.status === 'PUBLISHED' && (
            <Link to={`/admin/reports/orders/${event.id}`} className="btn bg-purple-600">
              View Orders
            </Link>
          )}
          {event.type === 'NIYAZ' && event.status === 'PUBLISHED' && (
            <Link to={`/admin/reports/rsvps/${event.id}`} className="btn bg-purple-600">
              View RSVPs
            </Link>
          )}
          <Link to="/admin/events" className="btn bg-gray-500">
            ← Back to Events
          </Link>
        </div>
      </div>
    </div>
  );
}
