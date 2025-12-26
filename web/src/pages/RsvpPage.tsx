import { useParams, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { api } from '../api/client';
import type { Event } from '../types/models';
import ThaaliOrderForm from '../components/ThaaliOrderForm';
import NiyazRsvpForm from '../components/NiyazRsvpForm';

function formatDate(dateStr: string): string {
  // Parse as local date to avoid timezone offset issues
  const [year, month, day] = dateStr.split('-').map(Number);
  const date = new Date(year, month - 1, day);
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

  // Check registration status
  const now = new Date();
  const registrationOpenAt = event.registrationOpenAt ? new Date(event.registrationOpenAt) : null;
  const registrationCloseAt = event.registrationCloseAt ? new Date(event.registrationCloseAt) : null;
  const isRegistrationOpen = event.status === 'PUBLISHED' &&
    registrationOpenAt && registrationCloseAt &&
    now >= registrationOpenAt && now < registrationCloseAt;

  // Calculate days until deadline
  const getDaysUntilDeadline = () => {
    if (!registrationCloseAt) return null;
    const diffTime = registrationCloseAt.getTime() - now.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  };

  const daysUntilDeadline = getDaysUntilDeadline();

  // Format deadline date
  const formatDeadlineDate = (date: Date) => {
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      month: 'long',
      day: 'numeric',
      year: 'numeric'
    });
  };

  // If registration is not open, show error and redirect back
  if (!isRegistrationOpen) {
    const isClosed = registrationCloseAt && now >= registrationCloseAt;
    const notYetOpen = registrationOpenAt && now < registrationOpenAt;

    return (
      <div className="max-w-lg mx-auto">
        <div className={`border rounded-lg overflow-hidden ${isClosed ? 'border-red-200' : 'border-amber-200'}`}>
          <div className={`px-6 py-4 ${isClosed ? 'bg-red-500' : 'bg-amber-500'}`}>
            <h2 className="text-lg font-semibold text-white">
              {isClosed ? 'Registration Closed' : notYetOpen ? 'Registration Not Yet Open' : 'Registration Unavailable'}
            </h2>
          </div>
          <div className={`p-6 ${isClosed ? 'bg-red-50' : 'bg-amber-50'}`}>
            <p className={`${isClosed ? 'text-red-700' : 'text-amber-700'}`}>
              {isClosed
                ? `The deadline to ${isNiyaz ? 'RSVP' : 'place your order'} for "${event.title}" has passed.`
                : notYetOpen
                ? `Registration for "${event.title}" will open on ${registrationOpenAt?.toLocaleDateString('en-US', {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                  })}.`
                : 'Registration is not available for this event.'}
            </p>
            {isClosed && registrationCloseAt && (
              <p className={`mt-2 text-sm ${isClosed ? 'text-red-600' : 'text-amber-600'}`}>
                Registration closed on {formatDeadlineDate(registrationCloseAt)}
              </p>
            )}
            <div className="mt-6">
              <Link
                to={`/events/${id}`}
                className="inline-flex items-center gap-2 text-gray-700 hover:text-gray-900"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Back to event details
              </Link>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-lg mx-auto space-y-6">
      {/* Event Header Card */}
      <div className="card overflow-hidden">
        <div className={`px-5 py-4 ${isNiyaz ? 'bg-gradient-to-r from-purple-600 to-purple-700' : 'bg-gradient-to-r from-blue-600 to-blue-700'}`}>
          <div className="flex items-start justify-between">
            <div>
              <h1 className="text-xl font-bold text-white">{event.title}</h1>
              <p className="text-white/80 text-sm mt-1">{formatDate(event.eventDate)}</p>
            </div>
            <span className="px-2 py-1 text-xs font-medium rounded bg-white/20 text-white">
              {isNiyaz ? 'Niyaz' : 'Thaali'}
            </span>
          </div>
        </div>

        <div className="p-5 space-y-4">
          {/* Time & Miqaat Info */}
          <div className="flex flex-wrap gap-4 text-sm">
            {event.startTime && (
              <div className="flex items-center gap-2 text-gray-600">
                <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>{isNiyaz ? 'Starts at' : 'Pickup at'} <strong>{formatTime(event.startTime)}</strong></span>
              </div>
            )}
            {isNiyaz && event.miqaatName && (
              <div className="flex items-center gap-2 text-purple-600">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                </svg>
                <span>{event.miqaatName}</span>
              </div>
            )}
          </div>

          {/* Description */}
          {event.description && (
            <div className="border-t pt-4">
              <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">About this Event</h3>
              <p className="text-sm text-gray-600 leading-relaxed whitespace-pre-line">{event.description}</p>
            </div>
          )}
        </div>
      </div>

      {/* Deadline Warning */}
      {registrationCloseAt && daysUntilDeadline !== null && (
        <div className={`rounded-lg border-l-4 p-4 ${
          daysUntilDeadline <= 2
            ? 'bg-red-50 border-red-500'
            : daysUntilDeadline <= 5
            ? 'bg-amber-50 border-amber-500'
            : 'bg-blue-50 border-blue-500'
        }`}>
          <div className="flex items-start gap-3">
            <svg className={`w-5 h-5 flex-shrink-0 ${
              daysUntilDeadline <= 2
                ? 'text-red-500'
                : daysUntilDeadline <= 5
                ? 'text-amber-500'
                : 'text-blue-500'
            }`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p className={`text-sm font-medium ${
                daysUntilDeadline <= 2
                  ? 'text-red-800'
                  : daysUntilDeadline <= 5
                  ? 'text-amber-800'
                  : 'text-blue-800'
              }`}>
                {daysUntilDeadline === 0
                  ? 'Last day to register!'
                  : daysUntilDeadline === 1
                  ? 'Only 1 day left!'
                  : `${daysUntilDeadline} days left`
                }
              </p>
              <p className={`text-xs mt-0.5 ${
                daysUntilDeadline <= 2
                  ? 'text-red-600'
                  : daysUntilDeadline <= 5
                  ? 'text-amber-600'
                  : 'text-blue-600'
              }`}>
                Deadline: {formatDeadlineDate(registrationCloseAt)}
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Form Section */}
      <div className="card">
        <div className="border-b pb-4 mb-4">
          <h2 className="text-lg font-semibold text-gray-900">
            {isNiyaz ? 'RSVP for this Event' : 'Place Your Order'}
          </h2>
          <p className="text-sm text-gray-500 mt-1">
            {isNiyaz
              ? 'Please indicate how many will be attending'
              : 'Select your thaali preferences below'
            }
          </p>
        </div>

        {isNiyaz && <NiyazRsvpForm eventId={eventId} />}
        {isThaali && <ThaaliOrderForm eventId={eventId} />}
      </div>

      {/* Back link */}
      <div className="text-center pt-2">
        <Link
          to={`/events/${id}`}
          className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          Back to event details
        </Link>
      </div>
    </div>
  );
}
