import { useState, useMemo } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Link } from 'react-router-dom';
import { api } from '../../../api/client';

type Event = {
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

type User = {
  personId: number;
  roles: string[];
};

type StatusFilter = 'ALL' | 'DRAFT' | 'PUBLISHED' | 'CANCELLED';
type TimeFilter = 'upcoming' | 'past';

// Format date as "Wed, Dec 31"
function formatDate(dateStr: string): string {
  const [year, month, day] = dateStr.split('-').map(Number);
  const date = new Date(year, month - 1, day);
  return date.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
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

// Format short date as "Dec 26"
function formatShortDate(dateTimeStr: string): string {
  const date = new Date(dateTimeStr);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  });
}

// Role helpers
const hasRole = (roles: string[], role: string) => roles?.includes(role) ?? false;
const isAdmin = (roles: string[]) => hasRole(roles, 'ADMIN');
const isNiyazCoordinator = (roles: string[]) => hasRole(roles, 'NIYAZ_COORDINATOR');
const isThaaliCoordinator = (roles: string[]) => hasRole(roles, 'THAALI_COORDINATOR');
const isDanaCoordinator = (roles: string[]) => hasRole(roles, 'DANA_COORDINATOR');

// Check if event date is in the past (compare dates only, not time)
function isEventPast(eventDate: string): boolean {
  const [year, month, day] = eventDate.split('-').map(Number);
  const eventDateObj = new Date(year, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return eventDateObj < today;
}

export default function EventList() {
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('ALL');
  const [typeFilter, setTypeFilter] = useState<string>('ALL');
  const [timeFilter, setTimeFilter] = useState<TimeFilter>('upcoming');
  const queryClient = useQueryClient();

  const { data: user } = useQuery<User>({
    queryKey: ['me'],
    queryFn: () => api.me() as Promise<User>,
    staleTime: 1000 * 60 * 5,
  });

  const { data: events, isLoading } = useQuery<Event[]>({
    queryKey: ['admin-events'],
    queryFn: async () => (await api.get('/events')).data,
  });

  // Determine what event types the user can see/create based on roles
  const userRoles = user?.roles || [];
  const canSeeAllTypes = isAdmin(userRoles);
  const canSeeThaali = canSeeAllTypes || isThaaliCoordinator(userRoles);
  const canSeeNiyaz = canSeeAllTypes || isNiyazCoordinator(userRoles) || isDanaCoordinator(userRoles);
  const canCreateThaali = canSeeAllTypes || isThaaliCoordinator(userRoles);
  const canCreateNiyaz = canSeeAllTypes || isNiyazCoordinator(userRoles); // Dana Coordinator cannot create

  const publishMutation = useMutation({
    mutationFn: async (id: number) => {
      await api.post(`/events/${id}/publish`, {});
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-events'] });
    },
  });

  const cancelMutation = useMutation({
    mutationFn: async (id: number) => {
      await api.post(`/events/${id}/cancel`, {});
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-events'] });
    },
  });

  // Split events into upcoming and past, then apply filters
  const { upcomingEvents, pastEvents } = useMemo(() => {
    const upcoming: Event[] = [];
    const past: Event[] = [];

    events?.forEach((e) => {
      // Role-based type filtering
      if (e.type === 'THAALI' && !canSeeThaali) return;
      if (e.type === 'NIYAZ' && !canSeeNiyaz) return;
      // User-selected filters
      if (statusFilter !== 'ALL' && e.status !== statusFilter) return;
      if (typeFilter !== 'ALL' && e.type !== typeFilter) return;

      if (isEventPast(e.eventDate)) {
        past.push(e);
      } else {
        upcoming.push(e);
      }
    });

    // Sort upcoming by nearest date first
    upcoming.sort((a, b) => a.eventDate.localeCompare(b.eventDate));
    // Sort past by most recent first
    past.sort((a, b) => b.eventDate.localeCompare(a.eventDate));

    return { upcomingEvents: upcoming, pastEvents: past };
  }, [events, canSeeThaali, canSeeNiyaz, statusFilter, typeFilter]);

  const displayedEvents = timeFilter === 'upcoming' ? upcomingEvents : pastEvents;

  // Determine page title based on role
  const pageTitle = canSeeAllTypes
    ? 'All Events'
    : canSeeNiyaz && !canSeeThaali
    ? 'Niyaz Events'
    : canSeeThaali && !canSeeNiyaz
    ? 'Thaali Events'
    : 'Events';

  const handlePublish = (id: number) => {
    if (confirm('Publish this event? Users will be able to see and register for it.')) {
      publishMutation.mutate(id);
    }
  };

  const handleCancel = (id: number) => {
    if (confirm('Cancel this event? This action cannot be undone.')) {
      cancelMutation.mutate(id);
    }
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">{pageTitle}</h1>
        <div className="flex gap-2">
          {canCreateThaali && (
            <Link
              to="/admin/events/new/thaali"
              className="inline-flex items-center gap-1.5 px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white font-medium rounded-lg hover:from-blue-700 hover:to-blue-800 transition-all shadow-sm"
            >
              + Thaali Event
            </Link>
          )}
          {canCreateNiyaz && (
            <Link
              to="/admin/events/new/niyaz"
              className="inline-flex items-center gap-1.5 px-4 py-2 bg-gradient-to-r from-purple-600 to-purple-700 text-white font-medium rounded-lg hover:from-purple-700 hover:to-purple-800 transition-all shadow-sm"
            >
              + Niyaz Event
            </Link>
          )}
        </div>
      </div>

      {/* Tabs and Filters */}
      <div className="card">
        <div className="flex flex-col sm:flex-row sm:items-center gap-4">
          {/* Tabs */}
          <div className="flex gap-1 bg-gray-100 p-1 rounded-lg">
            <button
              onClick={() => setTimeFilter('upcoming')}
              className={`px-4 py-2 text-sm font-medium rounded-md transition-colors ${
                timeFilter === 'upcoming'
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Upcoming
              <span className={`ml-1.5 px-1.5 py-0.5 text-xs rounded-full ${
                timeFilter === 'upcoming'
                  ? 'bg-blue-100 text-blue-700'
                  : 'bg-gray-200 text-gray-600'
              }`}>
                {upcomingEvents.length}
              </span>
            </button>
            <button
              onClick={() => setTimeFilter('past')}
              className={`px-4 py-2 text-sm font-medium rounded-md transition-colors ${
                timeFilter === 'past'
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Past
              <span className={`ml-1.5 px-1.5 py-0.5 text-xs rounded-full ${
                timeFilter === 'past'
                  ? 'bg-gray-600 text-white'
                  : 'bg-gray-200 text-gray-600'
              }`}>
                {pastEvents.length}
              </span>
            </button>
          </div>

          {/* Divider */}
          <div className="hidden sm:block w-px h-8 bg-gray-200" />

          {/* Filters */}
          <div className="flex gap-4 items-center flex-wrap">
            <div>
              <label className="text-sm text-gray-500 mr-2">Status:</label>
              <select
                className="input w-auto"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value as StatusFilter)}
              >
                <option value="ALL">All</option>
                <option value="DRAFT">Draft</option>
                <option value="PUBLISHED">Published</option>
                <option value="CANCELLED">Cancelled</option>
              </select>
            </div>
            {/* Only show type filter if user can see both types */}
            {canSeeAllTypes && (
              <div>
                <label className="text-sm text-gray-500 mr-2">Type:</label>
                <select
                  className="input w-auto"
                  value={typeFilter}
                  onChange={(e) => setTypeFilter(e.target.value)}
                >
                  <option value="ALL">All</option>
                  <option value="THAALI">Thaali</option>
                  <option value="NIYAZ">Niyaz</option>
                </select>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Events Table */}
      <div className="card overflow-hidden p-0">
        {displayedEvents.length === 0 ? (
          <p className="text-gray-500 p-6">
            {timeFilter === 'upcoming' ? 'No upcoming events' : 'No past events'}
          </p>
        ) : (
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50 border-b border-gray-200">
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Event</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Date</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider w-32">Registration</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Status</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider w-40">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {displayedEvents.map((event, idx) => {
                const isNiyaz = event.type === 'NIYAZ';
                const isPast = isEventPast(event.eventDate);
                return (
                  <tr key={event.id} className={`${idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'} ${isPast ? 'opacity-75' : ''}`}>
                    {/* Event Info */}
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <span
                          className={`flex-shrink-0 w-2 h-10 rounded-full ${
                            isPast
                              ? 'bg-gray-400'
                              : isNiyaz
                              ? 'bg-purple-500'
                              : 'bg-blue-500'
                          }`}
                        />
                        <div className="min-w-0">
                          <Link
                            to={`/admin/events/${event.id}`}
                            className={`font-medium block truncate ${
                              isPast ? 'text-gray-600 hover:text-gray-800' : 'text-gray-900 hover:text-blue-600'
                            }`}
                          >
                            {event.title}
                          </Link>
                          <span
                            className={`inline-flex items-center text-xs font-medium ${
                              isPast
                                ? 'text-gray-500'
                                : isNiyaz
                                ? 'text-purple-600'
                                : 'text-blue-600'
                            }`}
                          >
                            {isNiyaz ? 'Niyaz' : 'Thaali'}
                          </span>
                        </div>
                      </div>
                    </td>

                    {/* Date */}
                    <td className="px-4 py-4 whitespace-nowrap">
                      <div className={`text-sm ${isPast ? 'text-gray-500' : 'text-gray-900'}`}>
                        {formatDate(event.eventDate)}
                        {event.startTime && (
                          <span className="text-gray-500"> · {formatTime(event.startTime)}</span>
                        )}
                      </div>
                    </td>

                    {/* Registration Period */}
                    <td className="px-4 py-4">
                      <div className="text-xs text-gray-600">
                        <span className={isPast ? 'text-gray-500' : 'text-green-600'}>
                          {formatShortDate(event.registrationOpenAt)}
                        </span>
                        <span className="text-gray-400 mx-1">-</span>
                        <span className={isPast ? 'text-gray-500' : 'text-red-600'}>
                          {formatShortDate(event.registrationCloseAt)}
                        </span>
                      </div>
                    </td>

                    {/* Status */}
                    <td className="px-4 py-4 text-center">
                      {isPast && event.status === 'PUBLISHED' ? (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-700">
                          <span className="w-1.5 h-1.5 rounded-full bg-gray-500 mr-1.5" />
                          Completed
                        </span>
                      ) : (
                        <span
                          className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                            event.status === 'PUBLISHED'
                              ? 'bg-green-100 text-green-800'
                              : event.status === 'DRAFT'
                              ? 'bg-amber-100 text-amber-800'
                              : 'bg-red-100 text-red-800'
                          }`}
                        >
                          {event.status === 'PUBLISHED' && (
                            <span className="w-1.5 h-1.5 rounded-full bg-green-500 mr-1.5" />
                          )}
                          {event.status === 'DRAFT' && (
                            <span className="w-1.5 h-1.5 rounded-full bg-amber-500 mr-1.5" />
                          )}
                          {event.status === 'CANCELLED' && (
                            <span className="w-1.5 h-1.5 rounded-full bg-red-500 mr-1.5" />
                          )}
                          {event.status.charAt(0) + event.status.slice(1).toLowerCase()}
                        </span>
                      )}
                    </td>

                    {/* Actions */}
                    <td className="px-4 py-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <Link
                          to={`/admin/events/${event.id}`}
                          className="inline-flex items-center px-2.5 py-1.5 text-xs font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50"
                        >
                          Details
                        </Link>

                        {/* Upcoming event actions */}
                        {!isPast && (
                          <>
                            {event.status === 'DRAFT' && (
                              <button
                                onClick={() => handlePublish(event.id)}
                                className="inline-flex items-center px-2.5 py-1.5 text-xs font-medium text-white bg-green-600 rounded hover:bg-green-700"
                                disabled={publishMutation.isPending}
                              >
                                Publish
                              </button>
                            )}
                            {event.status === 'PUBLISHED' && (
                              <>
                                {event.type === 'THAALI' && (
                                  <Link
                                    to={`/admin/reports/orders/${event.id}`}
                                    className="inline-flex items-center px-2.5 py-1.5 text-xs font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
                                  >
                                    Signups
                                  </Link>
                                )}
                                {event.type === 'NIYAZ' && (
                                  <Link
                                    to={`/admin/reports/rsvps/${event.id}`}
                                    className="inline-flex items-center px-2.5 py-1.5 text-xs font-medium text-white bg-purple-600 rounded hover:bg-purple-700"
                                  >
                                    RSVPs
                                  </Link>
                                )}
                                <button
                                  onClick={() => handleCancel(event.id)}
                                  className="text-xs text-red-600 hover:text-red-800 hover:underline ml-1"
                                  disabled={cancelMutation.isPending}
                                >
                                  Cancel
                                </button>
                              </>
                            )}
                          </>
                        )}

                        {/* Past event actions */}
                        {isPast && event.status === 'PUBLISHED' && (
                          <Link
                            to={event.type === 'THAALI' ? `/admin/reports/orders/${event.id}` : `/admin/reports/rsvps/${event.id}`}
                            className="inline-flex items-center px-2.5 py-1.5 text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200 rounded hover:bg-gray-200"
                          >
                            Summary
                          </Link>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
