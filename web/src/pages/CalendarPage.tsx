import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Link, useNavigate } from 'react-router-dom';
import { api } from '../api/client';
import { gregorianToHijri, getHijriShortMonthName, formatHijriDate } from '../lib/hijriDate';

type EventType = 'NIYAZ' | 'THAALI';
type EventStatus = 'DRAFT' | 'PUBLISHED' | 'CANCELLED';

type Event = {
  id: number;
  type: EventType;
  title: string;
  description?: string;
  eventDate: string;
  startTime?: string;
  status: EventStatus;
  miqaatName?: string;
};

const WEEKDAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MONTHS = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

// Get all days to display for a month (including padding from prev/next months)
function getCalendarDays(year: number, month: number): Date[] {
  const firstDay = new Date(year, month, 1);
  const lastDay = new Date(year, month + 1, 0);
  const startPadding = firstDay.getDay(); // 0 = Sunday
  const days: Date[] = [];

  // Previous month padding
  for (let i = startPadding - 1; i >= 0; i--) {
    days.push(new Date(year, month, -i));
  }

  // Current month days
  for (let d = 1; d <= lastDay.getDate(); d++) {
    days.push(new Date(year, month, d));
  }

  // Next month padding (fill to 42 cells = 6 weeks)
  while (days.length < 42) {
    days.push(new Date(year, month + 1, days.length - lastDay.getDate() - startPadding + 1));
  }

  return days;
}

// Format date as YYYY-MM-DD for comparison
function formatDateKey(date: Date): string {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

// Check if two dates are the same day
function isSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  );
}

// Check if date is in the current month
function isCurrentMonth(date: Date, currentYear: number, currentMonth: number): boolean {
  return date.getFullYear() === currentYear && date.getMonth() === currentMonth;
}

export default function CalendarPage() {
  const navigate = useNavigate();
  const today = new Date();
  const [currentYear, setCurrentYear] = useState(today.getFullYear());
  const [currentMonth, setCurrentMonth] = useState(today.getMonth());

  // Fetch events
  const { data: events, isLoading } = useQuery<Event[]>({
    queryKey: ['events-public'],
    queryFn: async () => (await api.get('/events/public')).data,
  });

  // Group events by date
  const eventsByDate = useMemo(() => {
    const map = new Map<string, Event[]>();
    if (!events) return map;

    for (const event of events) {
      const key = event.eventDate;
      if (!map.has(key)) {
        map.set(key, []);
      }
      map.get(key)!.push(event);
    }

    return map;
  }, [events]);

  // Get calendar days for current month
  const calendarDays = useMemo(() => {
    return getCalendarDays(currentYear, currentMonth);
  }, [currentYear, currentMonth]);

  // Get Hijri month range for the current view (first and last day of displayed month)
  const hijriMonthRange = useMemo(() => {
    const firstDay = new Date(currentYear, currentMonth, 1);
    const lastDay = new Date(currentYear, currentMonth + 1, 0);
    const hijriFirst = gregorianToHijri(firstDay);
    const hijriLast = gregorianToHijri(lastDay);

    if (hijriFirst.month === hijriLast.month && hijriFirst.year === hijriLast.year) {
      return `${getHijriShortMonthName(hijriFirst.month)} ${hijriFirst.year}H`;
    } else if (hijriFirst.year === hijriLast.year) {
      return `${getHijriShortMonthName(hijriFirst.month)} - ${getHijriShortMonthName(hijriLast.month)} ${hijriFirst.year}H`;
    } else {
      return `${getHijriShortMonthName(hijriFirst.month)} ${hijriFirst.year}H - ${getHijriShortMonthName(hijriLast.month)} ${hijriLast.year}H`;
    }
  }, [currentYear, currentMonth]);

  // Navigation handlers
  const goToPrevMonth = () => {
    if (currentMonth === 0) {
      setCurrentMonth(11);
      setCurrentYear(currentYear - 1);
    } else {
      setCurrentMonth(currentMonth - 1);
    }
  };

  const goToNextMonth = () => {
    if (currentMonth === 11) {
      setCurrentMonth(0);
      setCurrentYear(currentYear + 1);
    } else {
      setCurrentMonth(currentMonth + 1);
    }
  };

  const goToToday = () => {
    setCurrentYear(today.getFullYear());
    setCurrentMonth(today.getMonth());
  };

  // Handle event click
  const handleEventClick = (eventId: number) => {
    navigate(`/events/${eventId}`);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-gray-500">Loading calendar...</div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent">
            Event Calendar
          </h1>
          <p className="text-gray-500 mt-1">View upcoming Niyaz and Thaali events</p>
        </div>
        <Link
          to="/events"
          className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-medium rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all shadow-sm hover:shadow-md"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 10h16M4 14h16M4 18h16" />
          </svg>
          List View
        </Link>
      </div>

      {/* Calendar Container */}
      <div className="bg-white rounded-2xl shadow-lg overflow-hidden">
        {/* Month Navigation */}
        <div className="bg-gradient-to-r from-purple-600 to-blue-600 px-6 py-4">
          <div className="flex items-center justify-between">
            <button
              onClick={goToPrevMonth}
              className="p-2 rounded-lg hover:bg-white/20 transition-colors text-white"
              aria-label="Previous month"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </button>

            <div className="flex items-center gap-4">
              <div className="text-center">
                <h2 className="text-xl font-bold text-white">
                  {MONTHS[currentMonth]} {currentYear}
                </h2>
                <p className="text-sm text-white/80">
                  {hijriMonthRange}
                </p>
              </div>
              <button
                onClick={goToToday}
                className="px-3 py-1 text-sm font-medium rounded-lg bg-white/20 hover:bg-white/30 transition-colors text-white"
              >
                Today
              </button>
            </div>

            <button
              onClick={goToNextMonth}
              className="p-2 rounded-lg hover:bg-white/20 transition-colors text-white"
              aria-label="Next month"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        {/* Weekday Headers */}
        <div className="grid grid-cols-7 bg-gray-50 border-b border-gray-200">
          {WEEKDAYS.map((day) => (
            <div
              key={day}
              className="py-3 text-center text-sm font-semibold text-gray-600 uppercase tracking-wider"
            >
              {day}
            </div>
          ))}
        </div>

        {/* Calendar Grid */}
        <div className="grid grid-cols-7">
          {calendarDays.map((date, index) => {
            const dateKey = formatDateKey(date);
            const dayEvents = eventsByDate.get(dateKey) || [];
            const isToday = isSameDay(date, today);
            const isInCurrentMonth = isCurrentMonth(date, currentYear, currentMonth);
            const visibleEvents = dayEvents.slice(0, 2);
            const moreCount = dayEvents.length - 2;
            const hijriDate = gregorianToHijri(date);

            return (
              <div
                key={index}
                className={`
                  min-h-[100px] sm:min-h-[120px] p-2 border-b border-r border-gray-100
                  ${isInCurrentMonth ? 'bg-white' : 'bg-gray-50/50'}
                  ${isToday ? 'ring-2 ring-inset ring-purple-500 bg-purple-50/30' : ''}
                  ${index % 7 === 6 ? 'border-r-0' : ''}
                  ${index >= 35 ? 'border-b-0' : ''}
                `}
              >
                {/* Day Numbers - Gregorian and Hijri */}
                <div className="flex items-start justify-between mb-1">
                  <div
                    className={`
                      text-sm font-medium
                      ${isToday ? 'text-purple-600 font-bold' : ''}
                      ${!isInCurrentMonth ? 'text-gray-400' : 'text-gray-700'}
                    `}
                  >
                    {date.getDate()}
                  </div>
                  <div
                    className={`
                      text-xs text-right
                      ${isToday ? 'text-purple-500' : ''}
                      ${!isInCurrentMonth ? 'text-gray-300' : 'text-emerald-600'}
                    `}
                    title={formatHijriDate(hijriDate, 'long')}
                  >
                    {hijriDate.day === 1 ? (
                      <span className="font-medium">{getHijriShortMonthName(hijriDate.month).slice(0, 3)}</span>
                    ) : null}
                    <span className={hijriDate.day === 1 ? 'ml-0.5' : ''}>{hijriDate.day}</span>
                  </div>
                </div>

                {/* Events */}
                <div className="space-y-1">
                  {visibleEvents.map((event) => (
                    <button
                      key={event.id}
                      onClick={() => handleEventClick(event.id)}
                      className={`
                        w-full text-left text-xs px-2 py-1 rounded-md truncate
                        transition-colors cursor-pointer
                        ${event.type === 'NIYAZ'
                          ? 'bg-purple-100 text-purple-700 hover:bg-purple-200'
                          : 'bg-blue-100 text-blue-700 hover:bg-blue-200'
                        }
                      `}
                      title={event.title}
                    >
                      <span className="font-medium">
                        {event.type === 'NIYAZ' ? event.miqaatName || event.title : event.title}
                      </span>
                    </button>
                  ))}

                  {/* More events indicator */}
                  {moreCount > 0 && (
                    <div className="text-xs text-gray-500 px-2 font-medium">
                      +{moreCount} more
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Legend */}
      <div className="mt-6 flex flex-wrap items-center justify-center gap-6 text-sm text-gray-600">
        <div className="flex items-center gap-2">
          <span className="w-4 h-4 rounded bg-purple-100 border border-purple-200"></span>
          <span>Niyaz</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="w-4 h-4 rounded bg-blue-100 border border-blue-200"></span>
          <span>Thaali</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="w-4 h-4 rounded ring-2 ring-purple-500 bg-purple-50/30"></span>
          <span>Today</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs text-emerald-600 font-medium">21</span>
          <span>Hijri Date</span>
        </div>
      </div>
    </div>
  );
}
