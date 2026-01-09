import { Link } from 'react-router-dom';
import type { Event } from '../types/models';

function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

function formatTime(timeStr: string): string {
  // Handle HH:mm:ss format
  const [hours, minutes] = timeStr.split(':');
  const hour = parseInt(hours, 10);
  const ampm = hour >= 12 ? 'PM' : 'AM';
  const hour12 = hour % 12 || 12;
  return `${hour12}:${minutes} ${ampm}`;
}

export default function EventCard({ e }: { e: Event }) {
  const isNiyaz = e.type === 'NIYAZ';
  const isThaali = e.type === 'THAALI';

  return (
    <div className={`card border-l-4 ${isNiyaz ? 'border-l-green-500' : 'border-l-purple-500'}`}>
      <div className="flex items-start justify-between mb-2">
        <h3 className="text-lg font-semibold">{e.title}</h3>
        <span
          className={`text-xs px-2 py-1 rounded ${
            isNiyaz ? 'bg-green-100 text-green-700' : 'bg-purple-100 text-purple-700'
          }`}
        >
          {isNiyaz ? 'Niyaz' : 'Thaali'}
        </span>
      </div>

      <div className="text-sm text-gray-600 space-y-1">
        <p className="font-medium">{formatDate(e.eventDate)}</p>
        {e.startTime && <p>Time: {formatTime(e.startTime)}</p>}
        {isNiyaz && e.miqaatName && (
          <p className="text-green-700">Miqaat: {e.miqaatName}</p>
        )}
        {e.description && (
          <p className="text-gray-500 text-xs mt-2 line-clamp-2">{e.description}</p>
        )}
      </div>

      <div className="mt-3 flex gap-3">
        <Link
          className="text-sm text-blue-600 hover:underline"
          to={`/events/${e.id}`}
        >
          Details
        </Link>
        <Link
          className="text-sm bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700"
          to={`/events/${e.id}/rsvp`}
        >
          {isNiyaz ? 'RSVP' : 'Register'}
        </Link>
      </div>
    </div>
  );
}
