import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

export default function NiyazRsvpReport() {
  const { eventId } = useParams<{ eventId: string }>();

  const { data: event, isLoading: eventLoading } = useQuery<Event>({
    queryKey: ['event', eventId],
    queryFn: async () => (await api.get(`/events/${eventId}`)).data,
    enabled: !!eventId,
  });

  const { data: adults, isLoading: adultsLoading } = useQuery<number>({
    queryKey: ['niyaz-adults', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/totals/adults`)).data,
    enabled: !!eventId,
  });

  const { data: kids, isLoading: kidsLoading } = useQuery<number>({
    queryKey: ['niyaz-kids', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/totals/kids`)).data,
    enabled: !!eventId,
  });

  if (eventLoading || adultsLoading || kidsLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  if (!event) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Event Not Found</h1>
        <Link to="/admin/events" className="text-blue-600 hover:underline">
          ← Back to Events
        </Link>
      </div>
    );
  }

  const totalAttendees = (adults || 0) + (kids || 0);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Niyaz RSVP Report</h1>
          <p className="text-gray-500">{event.title} - {event.eventDate}</p>
        </div>
        <Link to="/admin/events" className="btn bg-gray-500">
          ← Back to Events
        </Link>
      </div>

      {/* Attendance Summary */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Attendance Summary</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-blue-50 rounded-lg p-6 text-center">
            <div className="text-4xl font-bold text-blue-600">{adults || 0}</div>
            <div className="text-sm text-gray-600 mt-1">Adults</div>
          </div>
          <div className="bg-green-50 rounded-lg p-6 text-center">
            <div className="text-4xl font-bold text-green-600">{kids || 0}</div>
            <div className="text-sm text-gray-600 mt-1">Children</div>
          </div>
          <div className="bg-purple-50 rounded-lg p-6 text-center">
            <div className="text-4xl font-bold text-purple-600">{totalAttendees}</div>
            <div className="text-sm text-gray-600 mt-1">Total Attendees</div>
          </div>
        </div>
      </div>

      {/* Planning Notes */}
      <div className="card bg-yellow-50 border border-yellow-200">
        <h2 className="text-lg font-semibold mb-2">Planning Notes</h2>
        <ul className="text-sm text-gray-700 space-y-1">
          <li>• Expected adult servings: <strong>{adults || 0}</strong></li>
          <li>• Expected child servings (typically ½ portion): <strong>{kids || 0}</strong></li>
          <li>• Equivalent full servings: <strong>{((adults || 0) + (kids || 0) * 0.5).toFixed(1)}</strong></li>
        </ul>
      </div>

      {/* Print Button */}
      <div className="flex gap-3">
        <button onClick={() => window.print()} className="btn">
          Print Report
        </button>
      </div>
    </div>
  );
}
