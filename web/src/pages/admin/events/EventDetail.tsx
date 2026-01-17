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

type Host = {
  id: number;
  firstName: string;
  lastName: string;
  fullName: string;
};

type NiyazEventDetail = {
  id: number;
  showRsvpSummary: boolean;
  hosts: Host[];
};

type ChefSummary = {
  id: number;
  name: string;
  type: string;
};

type MenuItem = {
  id: number;
  name: string;
  description: string | null;
  dishId: number;
  position: number;
};

type ThaaliEventDetail = {
  id: number;
  menu: MenuItem[];
  chefs: ChefSummary[];
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

  // Fetch detailed Niyaz event info (hosts, showRsvpSummary)
  const { data: niyazDetail } = useQuery<NiyazEventDetail>({
    queryKey: ['niyaz-detail', id],
    queryFn: async () => (await api.get(`/niyaz/${id}`)).data,
    enabled: !!event && event.type === 'NIYAZ',
  });

  // Fetch detailed Thaali event info (menu, chefs)
  const { data: thaaliDetail, error: thaaliError } = useQuery<ThaaliEventDetail>({
    queryKey: ['thaali-detail', id],
    queryFn: async () => (await api.get(`/thaali/${id}`)).data,
    enabled: !!event && event.type === 'THAALI',
    retry: false,
  });

  // Debug: log thaali detail for troubleshooting
  if (thaaliError) {
    console.error('Failed to fetch thaali details:', thaaliError);
  }
  if (thaaliDetail) {
    console.log('Thaali detail loaded:', thaaliDetail);
  }

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

          {/* Niyaz-specific: Hosts and Show RSVP Summary */}
          {isNiyaz && niyazDetail && (
            <>
              {/* Hosts */}
              {niyazDetail.hosts && niyazDetail.hosts.length > 0 && (
                <div className="border-t pt-6">
                  <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-3">
                    {niyazDetail.hosts.length === 1 ? 'Host' : 'Hosts'}
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {niyazDetail.hosts.map((host) => (
                      <span
                        key={host.id}
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-purple-50 text-purple-700 rounded-full text-sm font-medium"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        {host.fullName}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              {/* Show RSVP Summary Setting */}
              <div className="border-t pt-6">
                <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-3">RSVP Summary Visibility</h3>
                <div className={`inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-sm font-medium ${
                  niyazDetail.showRsvpSummary
                    ? 'bg-green-50 text-green-700'
                    : 'bg-gray-100 text-gray-600'
                }`}>
                  {niyazDetail.showRsvpSummary ? (
                    <>
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                      </svg>
                      RSVP list visible to attendees
                    </>
                  ) : (
                    <>
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                      </svg>
                      RSVP list hidden from attendees
                    </>
                  )}
                </div>
              </div>
            </>
          )}

          {/* Thaali-specific: Menu and Cooking Group */}
          {isThaali && thaaliDetail && (
            <>
              {/* Menu/Dishes */}
              {thaaliDetail.menu && thaaliDetail.menu.length > 0 && (
                <div className="border-t pt-6">
                  <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-3">Menu</h3>
                  <div className="space-y-2">
                    {thaaliDetail.menu
                      .sort((a, b) => (a.position || 0) - (b.position || 0))
                      .map((item, idx) => (
                        <div
                          key={item.id}
                          className="flex items-center gap-3 py-2 px-3 bg-blue-50 rounded-lg"
                        >
                          <span className="w-6 h-6 flex items-center justify-center bg-blue-100 text-blue-700 rounded-full text-xs font-semibold">
                            {idx + 1}
                          </span>
                          <span className="text-gray-900 font-medium">{item.name}</span>
                        </div>
                      ))}
                  </div>
                </div>
              )}

              {/* Cooking Group/Chefs */}
              {thaaliDetail.chefs && thaaliDetail.chefs.length > 0 && (
                <div className="border-t pt-6">
                  <h3 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-3">Chef / Cooking Group</h3>
                  <div className="flex flex-wrap gap-2">
                    {thaaliDetail.chefs.map((chef) => (
                      <span
                        key={chef.id}
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-amber-50 text-amber-700 rounded-full text-sm font-medium"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                        {chef.name}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </>
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
