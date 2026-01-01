import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';

type EventSummary = {
  id: number;
  type: string;
  title: string;
  miqaatName?: string;
  description: string;
  eventDate: string;
  startTime: string | null;
  registrationOpenAt: string;
  registrationCloseAt: string;
  status: 'DRAFT' | 'PUBLISHED' | 'CANCELLED';
};

// Format date as "Wednesday, December 31, 2025"
function formatDate(dateStr: string): string {
  const [year, month, day] = dateStr.split('-').map(Number);
  const date = new Date(year, month - 1, day);
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });
}

// Format time as "6:10 PM"
function formatTime(timeStr: string): string {
  const [hours, minutes] = timeStr.split(':');
  const hour = parseInt(hours, 10);
  const ampm = hour >= 12 ? 'PM' : 'AM';
  const hour12 = hour % 12 || 12;
  return `${hour12}:${minutes} ${ampm}`;
}

// Format datetime as "Dec 26, 2025 at 7:00 PM"
function formatDateTime(dateTimeStr: string): string {
  const date = new Date(dateTimeStr);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  }) + ' at ' + date.toLocaleTimeString('en-US', {
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
  });
}

// Check if event date is in the past
function isEventPast(eventDate: string): boolean {
  const [year, month, day] = eventDate.split('-').map(Number);
  const eventDateObj = new Date(year, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return eventDateObj < today;
}

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

  const isNiyaz = event.type === 'NIYAZ';
  const isThaali = event.type === 'THAALI';
  const isPast = isEventPast(event.eventDate);

  return (
    <div className="space-y-6 max-w-3xl">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{event.title}</h1>
          {isNiyaz && event.miqaatName && event.miqaatName !== event.title && (
            <p className="text-purple-600 mt-1">{event.miqaatName}</p>
          )}
        </div>
        <div className="flex gap-2 items-center">
          <span
            className={`text-xs font-medium px-3 py-1 rounded-full ${
              isPast
                ? 'bg-gray-100 text-gray-600'
                : isNiyaz
                ? 'bg-purple-100 text-purple-700'
                : 'bg-blue-100 text-blue-700'
            }`}
          >
            {isNiyaz ? 'Niyaz' : 'Thaali'}
          </span>
          <span
            className={`text-xs font-medium px-3 py-1 rounded-full ${
              isPast && event.status === 'PUBLISHED'
                ? 'bg-gray-100 text-gray-700'
                : event.status === 'PUBLISHED'
                ? 'bg-green-100 text-green-700'
                : event.status === 'DRAFT'
                ? 'bg-amber-100 text-amber-700'
                : 'bg-red-100 text-red-700'
            }`}
          >
            {isPast && event.status === 'PUBLISHED' ? 'Completed' : event.status}
          </span>
        </div>
      </div>

      {/* Main Details Card */}
      <div className="card overflow-hidden">
        <div className={`px-6 py-4 ${isNiyaz ? 'bg-purple-600' : 'bg-blue-600'}`}>
          <h2 className="text-lg font-semibold text-white">
            {isNiyaz ? 'Miqaat Details' : 'Thaali Details'}
          </h2>
        </div>

        <div className="p-6 space-y-6">
          {/* Date and Time Row */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="flex items-start gap-3">
              <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-100' : 'bg-blue-100'}`}>
                <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <div>
                <label className="text-xs font-medium text-gray-500 uppercase tracking-wide">
                  {isNiyaz ? 'Miqaat Date' : 'Thaali Date'}
                </label>
                <p className="font-semibold text-gray-900 mt-1">{formatDate(event.eventDate)}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-100' : 'bg-blue-100'}`}>
                <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div>
                <label className="text-xs font-medium text-gray-500 uppercase tracking-wide">
                  {isNiyaz ? 'Start Time' : 'Pickup Time'}
                </label>
                <p className="font-semibold text-gray-900 mt-1">
                  {event.startTime ? formatTime(event.startTime) : 'Not set'}
                </p>
              </div>
            </div>
          </div>

          {/* Registration Period */}
          <div className="border-t pt-6">
            <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-4">Registration Period</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="flex items-start gap-3">
                <div className="p-2 rounded-lg bg-green-100">
                  <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 11V7a4 4 0 118 0m-4 8v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2z" />
                  </svg>
                </div>
                <div>
                  <label className="text-xs font-medium text-gray-500 uppercase tracking-wide">Opens</label>
                  <p className="font-medium text-gray-900 mt-1">{formatDateTime(event.registrationOpenAt)}</p>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <div className="p-2 rounded-lg bg-red-100">
                  <svg className="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                  </svg>
                </div>
                <div>
                  <label className="text-xs font-medium text-gray-500 uppercase tracking-wide">Closes</label>
                  <p className="font-medium text-gray-900 mt-1">{formatDateTime(event.registrationCloseAt)}</p>
                </div>
              </div>
            </div>
          </div>

          {/* Description */}
          {event.description && (
            <div className="border-t pt-6">
              <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-3">Description</h3>
              <div className="bg-gray-50 rounded-lg p-4">
                <p className="text-gray-700 whitespace-pre-line leading-relaxed">{event.description}</p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Actions Card */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Actions</h2>
        <div className="flex gap-3 flex-wrap">
          {/* Edit button - only for upcoming events */}
          {!isPast && isNiyaz && (
            <Link to={`/admin/events/edit/niyaz/${event.id}`} className="btn">
              Edit Event
            </Link>
          )}
          {!isPast && isThaali && (
            <Link to={`/admin/events/edit/thaali/${event.id}`} className="btn">
              Edit Event
            </Link>
          )}
          {/* View reports - different styling for past vs upcoming */}
          {isThaali && event.status === 'PUBLISHED' && (
            <Link
              to={`/admin/reports/orders/${event.id}`}
              className={`btn ${isPast ? 'bg-gray-500 hover:bg-gray-600' : 'bg-blue-600 hover:bg-blue-700'}`}
            >
              {isPast ? 'View Summary' : 'View Signups'}
            </Link>
          )}
          {isNiyaz && event.status === 'PUBLISHED' && (
            <Link
              to={`/admin/reports/rsvps/${event.id}`}
              className={`btn ${isPast ? 'bg-gray-500 hover:bg-gray-600' : 'bg-purple-600 hover:bg-purple-700'}`}
            >
              {isPast ? 'View Summary' : 'View RSVPs'}
            </Link>
          )}
          <Link to="/admin/events" className="btn bg-gray-500 hover:bg-gray-600">
            Back to Events
          </Link>
        </div>
      </div>
    </div>
  );
}
