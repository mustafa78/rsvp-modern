import { useParams, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { api } from '../api/client';
import type { Event } from '../types/models';
import ThaaliOrderForm from '../components/ThaaliOrderForm';
import NiyazRsvpForm from '../components/NiyazRsvpForm';

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
    return (
      <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
        <div className="text-gray-500">Loading event...</div>
      </div>
    );
  }

  if (error || !event) {
    return (
      <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
        <div className="text-red-600">
          Event not found.{' '}
          <Link to="/" className="text-blue-600 hover:underline">
            Go back to events
          </Link>
        </div>
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
      <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
        {/* Back Navigation */}
        <div className="mb-6">
          <Link to={`/events/${id}`} className="text-sm text-gray-500 hover:text-gray-700 inline-flex items-center gap-1.5">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to event details
          </Link>
        </div>

        <div className="max-w-xl mx-auto">
          <div className={`bg-white rounded-xl shadow-sm border overflow-hidden ${isClosed ? 'border-red-200' : 'border-amber-200'}`}>
            <div className={`px-6 py-5 ${isClosed ? 'bg-red-500' : 'bg-amber-500'}`}>
              <div className="flex items-center gap-3">
                <div className="p-2 rounded-lg bg-white/20">
                  <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    {isClosed ? (
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    ) : (
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    )}
                  </svg>
                </div>
                <h2 className="text-xl font-semibold text-white">
                  {isClosed ? 'Registration Closed' : notYetOpen ? 'Registration Not Yet Open' : 'Registration Unavailable'}
                </h2>
              </div>
            </div>
            <div className={`p-6 ${isClosed ? 'bg-red-50' : 'bg-amber-50'}`}>
              <p className={`text-lg ${isClosed ? 'text-red-700' : 'text-amber-700'}`}>
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
                <p className={`mt-3 text-sm ${isClosed ? 'text-red-600' : 'text-amber-600'}`}>
                  Registration closed on {formatDeadlineDate(registrationCloseAt)}
                </p>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
      {/* Back Navigation */}
      <div className="mb-6">
        <Link to={`/events/${id}`} className="text-sm text-gray-500 hover:text-gray-700 inline-flex items-center gap-1.5">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          Back to event details
        </Link>
      </div>

      <div className="grid lg:grid-cols-5 gap-8">
        {/* Event Info Sidebar - 2 columns on large screens */}
        <div className="lg:col-span-2 space-y-6">
          {/* Event Header Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className={`px-5 py-4 ${isNiyaz ? 'bg-gradient-to-r from-purple-600 to-purple-700' : 'bg-gradient-to-r from-blue-600 to-blue-700'}`}>
              <div className="flex items-center gap-2 mb-2">
                <span className="px-2 py-0.5 text-xs font-semibold rounded-full bg-white/20 text-white uppercase tracking-wide">
                  {isNiyaz ? 'Niyaz' : 'Thaali'}
                </span>
              </div>
              <h1 className="text-xl font-bold text-white">{event.title}</h1>
            </div>

            <div className="p-5 space-y-4">
              {/* Date & Time */}
              <div className="space-y-3">
                <div className="flex items-center gap-3">
                  <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-50' : 'bg-blue-50'}`}>
                    <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500 font-medium uppercase tracking-wide">{isNiyaz ? 'Miqaat Date' : 'Event Date'}</p>
                    <p className="font-semibold text-gray-900">{formatDate(event.eventDate)}</p>
                  </div>
                </div>

                {event.startTime && (
                  <div className="flex items-center gap-3">
                    <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-50' : 'bg-blue-50'}`}>
                      <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-xs text-gray-500 font-medium uppercase tracking-wide">{isNiyaz ? 'Start Time' : 'Pickup Time'}</p>
                      <p className="font-semibold text-gray-900">{formatTime(event.startTime)}</p>
                    </div>
                  </div>
                )}

                {isNiyaz && event.miqaatName && event.miqaatName !== event.title && (
                  <div className="flex items-center gap-3">
                    <div className="p-2 rounded-lg bg-purple-50">
                      <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-xs text-gray-500 font-medium uppercase tracking-wide">Miqaat</p>
                      <p className="font-semibold text-purple-700">{event.miqaatName}</p>
                    </div>
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
            <div className={`rounded-xl p-4 ${
              daysUntilDeadline <= 2
                ? 'bg-red-50 border border-red-200'
                : daysUntilDeadline <= 5
                ? 'bg-amber-50 border border-amber-200'
                : 'bg-blue-50 border border-blue-200'
            }`}>
              <div className="flex items-center gap-3">
                <div className={`p-2 rounded-lg ${
                  daysUntilDeadline <= 2
                    ? 'bg-red-100'
                    : daysUntilDeadline <= 5
                    ? 'bg-amber-100'
                    : 'bg-blue-100'
                }`}>
                  <svg className={`w-5 h-5 ${
                    daysUntilDeadline <= 2
                      ? 'text-red-600'
                      : daysUntilDeadline <= 5
                      ? 'text-amber-600'
                      : 'text-blue-600'
                  }`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div>
                  <p className={`font-bold text-lg ${
                    daysUntilDeadline <= 2
                      ? 'text-red-700'
                      : daysUntilDeadline <= 5
                      ? 'text-amber-700'
                      : 'text-blue-700'
                  }`}>
                    {daysUntilDeadline === 0
                      ? 'Last day!'
                      : daysUntilDeadline === 1
                      ? '1 day left'
                      : `${daysUntilDeadline} days left`
                    }
                  </p>
                  <p className={`text-sm ${
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
        </div>

        {/* Form Section - 3 columns on large screens */}
        <div className="lg:col-span-3">
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="border-b pb-4 mb-6">
              <h2 className="text-xl font-semibold text-gray-900">
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
        </div>
      </div>
    </div>
  );
}
