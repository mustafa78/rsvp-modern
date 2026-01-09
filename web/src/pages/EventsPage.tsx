import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Link } from 'react-router-dom';
import { api } from '../api/client';
import type { Event } from '../types/models';

// Types for RSVP/Order status
type NiyazRsvp = {
  eventId: number;
  personId: number;
  adults: number;
  kids: number;
};

type ThaaliOrderItem = {
  menuItemId: number;
  dishName: string;
  size: 'LARGE' | 'SMALL' | 'BARAKATI';
};

type ThaaliOrder = {
  id: number;
  eventId: number;
  personId: number;
  pickupZoneId: number;
  pickupZoneName: string;
  notes: string | null;
  items: ThaaliOrderItem[];
};

// Custom hook to fetch user's event status
function useEventStatus(event: Event) {
  const { data: niyazRsvp, isLoading: niyazLoading } = useQuery<NiyazRsvp | null>({
    queryKey: ['my-niyaz-rsvp', event.id],
    queryFn: async () => {
      try {
        const response = await api.get(`/niyaz/${event.id}/rsvp/my`);
        return response.data;
      } catch {
        return null;
      }
    },
    enabled: event.type === 'NIYAZ',
    retry: false,
  });

  const { data: thaaliOrder, isLoading: thaaliLoading } = useQuery<ThaaliOrder | null>({
    queryKey: ['my-thaali-order', event.id],
    queryFn: async () => {
      try {
        const response = await api.get(`/thaali/${event.id}/orders/my`);
        return response.data;
      } catch {
        return null;
      }
    },
    enabled: event.type === 'THAALI',
    retry: false,
  });

  const isLoading = (event.type === 'NIYAZ' && niyazLoading) || (event.type === 'THAALI' && thaaliLoading);

  const hasRegistered = event.type === 'NIYAZ'
    ? !!(niyazRsvp && (niyazRsvp.adults > 0 || niyazRsvp.kids > 0))
    : !!(thaaliOrder && thaaliOrder.items && thaaliOrder.items.length > 0);

  return { niyazRsvp, thaaliOrder, isLoading, hasRegistered };
}

// Component to display user's RSVP/Order status for an event
function UserEventStatus({
  event,
  isPast,
  niyazRsvp,
  thaaliOrder,
  isLoading
}: {
  event: Event;
  isPast: boolean;
  niyazRsvp: NiyazRsvp | null | undefined;
  thaaliOrder: ThaaliOrder | null | undefined;
  isLoading: boolean;
}) {
  // Loading state
  if (isLoading) {
    return (
      <div className="flex items-center gap-2">
        <div className="w-2 h-2 bg-gray-300 rounded-full animate-pulse" />
        <span className="text-xs text-gray-400">Loading...</span>
      </div>
    );
  }

  // Niyaz RSVP status
  if (event.type === 'NIYAZ') {
    if (niyazRsvp && (niyazRsvp.adults > 0 || niyazRsvp.kids > 0)) {
      return (
        <div className={`inline-flex items-center gap-2 px-2.5 py-1.5 rounded-lg ${isPast ? 'bg-gray-100' : 'bg-purple-50 border border-purple-200'}`}>
          <div className={`w-5 h-5 rounded-full flex items-center justify-center ${isPast ? 'bg-gray-400' : 'bg-purple-500'}`}>
            <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <div className="text-xs">
            <span className={`font-semibold ${isPast ? 'text-gray-600' : 'text-purple-700'}`}>{niyazRsvp.adults}</span>
            <span className={isPast ? 'text-gray-500' : 'text-purple-600'}> adult{niyazRsvp.adults !== 1 ? 's' : ''}</span>
            {niyazRsvp.kids > 0 && (
              <>
                <span className={isPast ? 'text-gray-400' : 'text-purple-400'}>, </span>
                <span className={`font-semibold ${isPast ? 'text-gray-600' : 'text-purple-700'}`}>{niyazRsvp.kids}</span>
                <span className={isPast ? 'text-gray-500' : 'text-purple-600'}> child{niyazRsvp.kids !== 1 ? 'ren' : ''}</span>
              </>
            )}
          </div>
        </div>
      );
    }
    return (
      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-100 text-gray-500 text-xs">
        <span className="w-1.5 h-1.5 rounded-full bg-gray-400" />
        Not RSVP'd
      </span>
    );
  }

  // Thaali Order status
  if (event.type === 'THAALI') {
    if (thaaliOrder && thaaliOrder.items && thaaliOrder.items.length > 0) {
      const getSizeInfo = (size: string) => {
        switch (size) {
          case 'LARGE': return { label: 'L', color: isPast ? 'bg-gray-200 text-gray-600' : 'bg-blue-100 text-blue-700' };
          case 'SMALL': return { label: 'S', color: isPast ? 'bg-gray-200 text-gray-600' : 'bg-green-100 text-green-700' };
          case 'BARAKATI': return { label: 'B', color: isPast ? 'bg-gray-200 text-gray-600' : 'bg-amber-100 text-amber-700' };
          default: return { label: size[0], color: 'bg-gray-100 text-gray-700' };
        }
      };

      return (
        <div className={`inline-flex items-center gap-2 px-2.5 py-1.5 rounded-lg ${isPast ? 'bg-gray-100' : 'bg-blue-50 border border-blue-200'}`}>
          <div className={`w-5 h-5 rounded-full flex items-center justify-center ${isPast ? 'bg-gray-400' : 'bg-blue-500'}`}>
            <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <div className="flex items-center gap-1.5 flex-wrap">
            {thaaliOrder.items.slice(0, 2).map((item, idx) => {
              const sizeInfo = getSizeInfo(item.size);
              return (
                <div key={idx} className="flex items-center gap-1">
                  <span className={`inline-flex items-center justify-center w-4 h-4 rounded text-[10px] font-bold ${sizeInfo.color}`}>
                    {sizeInfo.label}
                  </span>
                  <span className={`text-xs truncate max-w-[80px] ${isPast ? 'text-gray-600' : 'text-gray-700'}`} title={item.dishName}>
                    {item.dishName}
                  </span>
                </div>
              );
            })}
            {thaaliOrder.items.length > 2 && (
              <span className="text-xs text-gray-400 font-medium">+{thaaliOrder.items.length - 2}</span>
            )}
          </div>
        </div>
      );
    }
    return (
      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-100 text-gray-500 text-xs">
        <span className="w-1.5 h-1.5 rounded-full bg-gray-400" />
        Not Registered
      </span>
    );
  }

  return null;
}

// Row component to use the hook and share status between cells
function EventRow({ event, isPast, idx }: { event: Event; isPast: boolean; idx: number }) {
  const isNiyaz = event.type === 'NIYAZ';
  const { niyazRsvp, thaaliOrder, isLoading, hasRegistered } = useEventStatus(event);

  // Determine button text
  const buttonText = hasRegistered
    ? 'Update'
    : (isNiyaz ? 'RSVP' : 'Register');

  return (
    <tr className={`${idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'} ${isPast ? 'opacity-75' : ''}`}>
      {/* Date Column */}
      <td className="py-3 px-4 w-28">
        <div className="text-sm font-medium text-gray-900">
          {formatDate(event.eventDate)}
        </div>
        {event.startTime && (
          <div className="text-xs text-gray-500">
            {formatTime(event.startTime)}
          </div>
        )}
      </td>

      {/* Type Badge */}
      <td className="py-3 px-2 w-20">
        <span
          className={`inline-flex items-center px-2 py-0.5 text-xs font-medium rounded ${
            isNiyaz
              ? 'bg-purple-100 text-purple-700'
              : 'bg-blue-100 text-blue-700'
          }`}
        >
          {isNiyaz ? 'Niyaz' : 'Thaali'}
        </span>
      </td>

      {/* Event Details */}
      <td className="py-3 px-4">
        <div className="font-medium text-gray-900">{event.title}</div>
        {isNiyaz && event.miqaatName && event.miqaatName !== event.title && (
          <div className="text-xs text-purple-600">{event.miqaatName}</div>
        )}
        {event.description && (
          <div className="text-xs text-gray-500 line-clamp-1 max-w-md">
            {event.description}
          </div>
        )}
      </td>

      {/* My Status */}
      <td className="py-3 px-4">
        <UserEventStatus
          event={event}
          isPast={isPast}
          niyazRsvp={niyazRsvp}
          thaaliOrder={thaaliOrder}
          isLoading={isLoading}
        />
      </td>

      {/* Actions */}
      <td className="py-3 px-4 w-32 text-right">
        <div className="flex items-center justify-end gap-2">
          <Link
            to={`/events/${event.id}`}
            className="text-sm text-gray-600 hover:text-gray-900"
          >
            Details
          </Link>
          {!isPast && (
            <Link
              to={`/events/${event.id}/rsvp`}
              className={`text-sm text-white px-3 py-1 rounded ${
                hasRegistered
                  ? 'bg-green-600 hover:bg-green-700'
                  : 'bg-blue-600 hover:bg-blue-700'
              }`}
            >
              {buttonText}
            </Link>
          )}
        </div>
      </td>
    </tr>
  );
}

// Parse date string as local date to avoid timezone issues
function parseLocalDate(dateStr: string): Date {
  const [year, month, day] = dateStr.split('-').map(Number);
  return new Date(year, month - 1, day);
}

function formatDate(dateStr: string): string {
  const date = parseLocalDate(dateStr);
  return date.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
  });
}

function formatTime(timeStr: string): string {
  const [hours, minutes] = timeStr.split(':');
  const hour = parseInt(hours, 10);
  const ampm = hour >= 12 ? 'PM' : 'AM';
  const hour12 = hour % 12 || 12;
  return `${hour12}:${minutes} ${ampm}`;
}

function getWeekLabel(dateStr: string): string {
  const date = parseLocalDate(dateStr);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const eventDate = new Date(date);
  eventDate.setHours(0, 0, 0, 0);

  const diffDays = Math.floor((eventDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays === 0) return 'Today';
  if (diffDays === 1) return 'Tomorrow';
  if (diffDays > 1 && diffDays <= 7) return 'This Week';
  if (diffDays > 7 && diffDays <= 14) return 'Next Week';

  // For future dates, show month
  return date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
}

function getPastWeekLabel(dateStr: string): string {
  const date = parseLocalDate(dateStr);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const eventDate = new Date(date);
  eventDate.setHours(0, 0, 0, 0);

  const diffDays = Math.floor((today.getTime() - eventDate.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays === 0) return 'Today';
  if (diffDays === 1) return 'Yesterday';
  if (diffDays > 1 && diffDays <= 7) return 'Last Week';

  // For older dates, show month
  return date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
}

type Tab = 'upcoming' | 'past';
type FilterType = 'all' | 'niyaz' | 'thaali';

export default function EventsPage() {
  const [activeTab, setActiveTab] = useState<Tab>('upcoming');
  const [filterType, setFilterType] = useState<FilterType>('all');

  const { data, isLoading } = useQuery<Event[]>({
    queryKey: ['events-public'],
    queryFn: async () => (await api.get('/events/public')).data,
  });

  const { upcomingEvents, pastEvents } = useMemo(() => {
    if (!data) return { upcomingEvents: [], pastEvents: [] };

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const upcoming: Event[] = [];
    const past: Event[] = [];

    data.forEach(event => {
      const eventDate = parseLocalDate(event.eventDate);
      eventDate.setHours(0, 0, 0, 0);

      if (eventDate >= today) {
        upcoming.push(event);
      } else {
        past.push(event);
      }
    });

    // Sort upcoming by date ascending (nearest first)
    upcoming.sort((a, b) => parseLocalDate(a.eventDate).getTime() - parseLocalDate(b.eventDate).getTime());
    // Sort past by date descending (most recent first)
    past.sort((a, b) => parseLocalDate(b.eventDate).getTime() - parseLocalDate(a.eventDate).getTime());

    return { upcomingEvents: upcoming, pastEvents: past };
  }, [data]);

  const filteredEvents = useMemo(() => {
    const events = activeTab === 'upcoming' ? upcomingEvents : pastEvents;
    if (filterType === 'all') return events;
    return events.filter(e => e.type === filterType.toUpperCase());
  }, [activeTab, filterType, upcomingEvents, pastEvents]);

  // Group events by week/month
  const groupedEvents = useMemo(() => {
    const groups: { label: string; events: Event[] }[] = [];
    let currentLabel = '';

    filteredEvents.forEach(event => {
      const label = activeTab === 'upcoming'
        ? getWeekLabel(event.eventDate)
        : getPastWeekLabel(event.eventDate);

      if (label !== currentLabel) {
        groups.push({ label, events: [event] });
        currentLabel = label;
      } else {
        groups[groups.length - 1].events.push(event);
      }
    });

    return groups;
  }, [filteredEvents, activeTab]);

  const niyazCount = useMemo(() => {
    const events = activeTab === 'upcoming' ? upcomingEvents : pastEvents;
    return events.filter(e => e.type === 'NIYAZ').length;
  }, [activeTab, upcomingEvents, pastEvents]);

  const thaaliCount = useMemo(() => {
    const events = activeTab === 'upcoming' ? upcomingEvents : pastEvents;
    return events.filter(e => e.type === 'THAALI').length;
  }, [activeTab, upcomingEvents, pastEvents]);

  if (isLoading) {
    return (
      <div className="max-w-6xl mx-auto px-4 lg:px-6 py-6">
        <div className="text-gray-500">Loading...</div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 lg:px-6 py-6 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Events</h1>
      </div>

      {/* Tabs */}
      <div className="border-b border-gray-200">
        <div className="flex gap-4">
          <button
            onClick={() => setActiveTab('upcoming')}
            className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
              activeTab === 'upcoming'
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700'
            }`}
          >
            Upcoming
            <span className="ml-2 px-2 py-0.5 text-xs rounded-full bg-green-100 text-green-700">
              {upcomingEvents.length}
            </span>
          </button>
          <button
            onClick={() => setActiveTab('past')}
            className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
              activeTab === 'past'
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700'
            }`}
          >
            Past
            <span className="ml-2 px-2 py-0.5 text-xs rounded-full bg-gray-100 text-gray-600">
              {pastEvents.length}
            </span>
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="flex gap-2">
        <button
          onClick={() => setFilterType('all')}
          className={`px-3 py-1.5 text-sm rounded-full border transition-colors ${
            filterType === 'all'
              ? 'bg-gray-900 text-white border-gray-900'
              : 'bg-white text-gray-600 border-gray-300 hover:border-gray-400'
          }`}
        >
          All Events
        </button>
        <button
          onClick={() => setFilterType('niyaz')}
          className={`px-3 py-1.5 text-sm rounded-full border transition-colors ${
            filterType === 'niyaz'
              ? 'bg-purple-600 text-white border-purple-600'
              : 'bg-white text-gray-600 border-gray-300 hover:border-purple-400'
          }`}
        >
          Niyaz
          <span className="ml-1.5 text-xs opacity-75">({niyazCount})</span>
        </button>
        <button
          onClick={() => setFilterType('thaali')}
          className={`px-3 py-1.5 text-sm rounded-full border transition-colors ${
            filterType === 'thaali'
              ? 'bg-blue-600 text-white border-blue-600'
              : 'bg-white text-gray-600 border-gray-300 hover:border-blue-400'
          }`}
        >
          Thaali
          <span className="ml-1.5 text-xs opacity-75">({thaaliCount})</span>
        </button>
      </div>

      {/* Events List */}
      {filteredEvents.length === 0 ? (
        <div className="text-center py-12 text-gray-500">
          <p>No {filterType === 'all' ? '' : filterType} events {activeTab === 'upcoming' ? 'coming up' : 'in the past'}.</p>
        </div>
      ) : (
        <div className="space-y-6">
          {groupedEvents.map((group) => (
            <div key={group.label}>
              {/* Group Header */}
              <div className="flex items-center gap-3 mb-3">
                <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wider">
                  {group.label}
                </h3>
                <div className="flex-1 border-t border-gray-200" />
              </div>

              {/* Events Table */}
              <div className="card overflow-hidden p-0">
                <table className="w-full">
                  <tbody className="divide-y divide-gray-100">
                    {group.events.map((event, idx) => (
                      <EventRow
                        key={event.id}
                        event={event}
                        isPast={activeTab === 'past'}
                        idx={idx}
                      />
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
