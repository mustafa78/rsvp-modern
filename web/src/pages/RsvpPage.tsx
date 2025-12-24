import { useParams, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { api } from '../api/client';
import type { Event } from '../types/models';
import ThaaliOrderForm from '../components/ThaaliOrderForm';
import NiyazRsvpForm from '../components/NiyazRsvpForm';

function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });
}

function formatTime(timeStr: string): string {
  const [hours, minutes] = timeStr.split(':');
  const hour = parseInt(hours, 10);
  const ampm = hour >= 12 ? 'PM' : 'AM';
  const hour12 = hour % 12 || 12;
  return `${hour12}:${minutes} ${ampm}`;
}

export default function RsvpPage() {
  const { id } = useParams();
  const eventId = Number(id);

  const { data: event, isLoading, error } = useQuery<Event>({
    queryKey: ['event', id],
    queryFn: async () => (await api.get(`/events/${id}`)).data,
  });

  if (isLoading) {
    return <div className="text-gray-500">Loading event...</div>;
  }

  if (error || !event) {
    return (
      <div className="text-red-600">
        Event not found.{' '}
        <Link to="/" className="text-blue-600 hover:underline">
          Go back to events
        </Link>
      </div>
    );
  }

  const isNiyaz = event.type === 'NIYAZ';
  const isThaali = event.type === 'THAALI';

  return (
    <div className="max-w-lg mx-auto">
      {/* Event Header */}
      <div className="card mb-6">
        <div className="flex items-start justify-between mb-2">
          <h1 className="text-xl font-bold">{event.title}</h1>
          <span
            className={`text-xs px-2 py-1 rounded ${
              isNiyaz
                ? 'bg-green-100 text-green-700'
                : 'bg-purple-100 text-purple-700'
            }`}
          >
            {isNiyaz ? 'Niyaz' : 'Thaali'}
          </span>
        </div>

        <div className="text-sm text-gray-600 space-y-1">
          <p className="font-medium">{formatDate(event.eventDate)}</p>
          {event.startTime && <p>Time: {formatTime(event.startTime)}</p>}
          {isNiyaz && event.miqaatName && (
            <p className="text-green-700">Miqaat: {event.miqaatName}</p>
          )}
          {event.description && (
            <p className="text-gray-500 mt-2">{event.description}</p>
          )}
        </div>
      </div>

      {/* Form based on event type */}
      <h2 className="text-lg font-semibold mb-4">
        {isNiyaz ? 'RSVP for this event' : 'Place your order'}
      </h2>

      {isNiyaz && <NiyazRsvpForm eventId={eventId} />}
      {isThaali && <ThaaliOrderForm eventId={eventId} />}

      {/* Back link */}
      <div className="mt-6 text-center">
        <Link to={`/events/${id}`} className="text-sm text-blue-600 hover:underline">
          Back to event details
        </Link>
      </div>
    </div>
  );
}
