import { useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'
import type { Event, NiyazRsvp } from '../types/models'

type GuestDetail = {
  name: string
  adults: number
  kids: number
}

type RsvpSummary = {
  familyCount: number
  totalAdults: number
  totalKids: number
  guests: GuestDetail[]
}

export default function EventDetailPage() {
  const { id } = useParams()
  const [showCalendarMenu, setShowCalendarMenu] = useState(false)
  const [showGuestList, setShowGuestList] = useState(false)

  const { data, isLoading } = useQuery<Event>({
    queryKey: ['event', id],
    queryFn: async () => (await api.get(`/events/${id}`)).data
  })

  // Fetch user's existing RSVP for Niyaz events
  const { data: myRsvp } = useQuery<NiyazRsvp | null>({
    queryKey: ['my-niyaz-rsvp', id],
    queryFn: async () => {
      try {
        const res = await api.get(`/niyaz/${id}/rsvp/my`)
        return res.data
      } catch {
        return null
      }
    },
    enabled: !!data && data.type === 'NIYAZ'
  })

  // Fetch RSVP summary for Niyaz events
  const { data: rsvpSummary } = useQuery<RsvpSummary>({
    queryKey: ['niyaz-rsvp-summary', id],
    queryFn: async () => (await api.get(`/niyaz/${id}/rsvp/summary`)).data,
    enabled: !!data && data.type === 'NIYAZ'
  })

  if (isLoading) {
    return (
      <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
        <div className="text-gray-500">Loading...</div>
      </div>
    )
  }

  if (!data) {
    return (
      <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
        <div className="text-red-500">Event not found</div>
      </div>
    )
  }

  const isNiyaz = data.type === 'NIYAZ'
  const isThaali = data.type === 'THAALI'

  // Check registration status
  const now = new Date()
  const registrationOpenAt = data.registrationOpenAt ? new Date(data.registrationOpenAt) : null
  const registrationCloseAt = data.registrationCloseAt ? new Date(data.registrationCloseAt) : null
  const isRegistrationOpen = data.status === 'PUBLISHED' &&
    registrationOpenAt && registrationCloseAt &&
    now >= registrationOpenAt && now < registrationCloseAt
  const isRegistrationNotYetOpen = data.status === 'PUBLISHED' &&
    registrationOpenAt && now < registrationOpenAt
  const isRegistrationClosed = data.status === 'PUBLISHED' &&
    registrationCloseAt && now >= registrationCloseAt

  // Calculate days until deadline
  const getDaysUntilDeadline = () => {
    if (!registrationCloseAt) return null
    const diffTime = registrationCloseAt.getTime() - now.getTime()
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    return diffDays
  }

  const daysUntilDeadline = getDaysUntilDeadline()

  // Format date for display (handles YYYY-MM-DD without timezone issues)
  const formatDate = (dateStr: string) => {
    const [year, month, day] = dateStr.split('-').map(Number)
    const date = new Date(year, month - 1, day)
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }

  // Format time for display
  const formatTime = (timeStr: string) => {
    const [hours, minutes] = timeStr.split(':')
    const hour = parseInt(hours, 10)
    const ampm = hour >= 12 ? 'PM' : 'AM'
    const displayHour = hour % 12 || 12
    return `${displayHour}:${minutes} ${ampm}`
  }

  // Format deadline date
  const formatDeadlineDate = (date: Date) => {
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      month: 'long',
      day: 'numeric',
      year: 'numeric'
    })
  }

  // Parse date string as local date to avoid timezone issues
  const parseLocalDate = (dateStr: string) => {
    const [year, month, day] = dateStr.split('-').map(Number)
    return new Date(year, month - 1, day)
  }

  // Generate calendar event URLs
  const generateCalendarUrls = () => {
    const eventDate = parseLocalDate(data.eventDate)
    let startDateTime = new Date(eventDate)
    let endDateTime = new Date(eventDate)

    if (data.startTime) {
      const [hours, minutes] = data.startTime.split(':')
      startDateTime.setHours(parseInt(hours), parseInt(minutes), 0)
      endDateTime = new Date(startDateTime)
      endDateTime.setHours(endDateTime.getHours() + 2)
    } else {
      startDateTime.setHours(18, 0, 0)
      endDateTime.setHours(20, 0, 0)
    }

    const title = encodeURIComponent(data.title)
    const description = encodeURIComponent(data.description || '')

    const formatGoogleDate = (d: Date) => {
      return d.toISOString().replace(/-|:|\.\d{3}/g, '').slice(0, 15)
    }

    const formatOutlookDate = (d: Date) => {
      return d.toISOString().slice(0, 19)
    }

    const formatICSDate = (d: Date) => {
      const pad = (n: number) => n.toString().padStart(2, '0')
      return `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}T${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`
    }

    const googleUrl = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${title}&dates=${formatGoogleDate(startDateTime)}/${formatGoogleDate(endDateTime)}&details=${description}`
    const outlookUrl = `https://outlook.live.com/calendar/0/deeplink/compose?subject=${title}&startdt=${formatOutlookDate(startDateTime)}&enddt=${formatOutlookDate(endDateTime)}&body=${description}&path=/calendar/action/compose&rru=addevent`

    const icsContent = `BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//RSVP App//Event//EN
BEGIN:VEVENT
DTSTART:${formatICSDate(startDateTime)}
DTEND:${formatICSDate(endDateTime)}
SUMMARY:${data.title}
DESCRIPTION:${(data.description || '').replace(/\n/g, '\\n')}
END:VEVENT
END:VCALENDAR`

    return { googleUrl, outlookUrl, icsContent }
  }

  const handleDownloadICS = () => {
    const { icsContent } = generateCalendarUrls()
    const blob = new Blob([icsContent], { type: 'text/calendar;charset=utf-8' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${data.title.replace(/[^a-z0-9]/gi, '_')}.ics`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    URL.revokeObjectURL(url)
    setShowCalendarMenu(false)
  }

  const { googleUrl, outlookUrl } = generateCalendarUrls()

  return (
    <div className="max-w-5xl mx-auto px-4 lg:px-6 py-8">
      {/* Back Navigation */}
      <div className="mb-6">
        <Link to="/" className="text-sm text-gray-500 hover:text-gray-700 inline-flex items-center gap-1.5">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          Back to Events
        </Link>
      </div>

      <div className="grid lg:grid-cols-3 gap-8">
        {/* Main Content - 2 columns on large screens */}
        <div className="lg:col-span-2 space-y-6">
          {/* Main Event Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            {/* Header with gradient */}
            <div className={`px-6 py-5 ${isNiyaz ? 'bg-gradient-to-r from-purple-600 to-purple-700' : 'bg-gradient-to-r from-blue-600 to-blue-700'}`}>
              <div className="flex items-center gap-2 mb-3">
                <span className="px-2.5 py-1 text-xs font-semibold rounded-full bg-white/20 text-white uppercase tracking-wide">
                  {isNiyaz ? 'Niyaz' : 'Thaali'}
                </span>
                {data.status === 'PUBLISHED' && isRegistrationOpen && (
                  <span className="px-2.5 py-1 text-xs font-medium rounded-full bg-green-400/30 text-green-100">
                    Open for Registration
                  </span>
                )}
                {/* "You're attending" badge for Niyaz events */}
                {isNiyaz && myRsvp && (
                  <span className="px-2.5 py-1 text-xs font-medium rounded-full bg-emerald-400/30 text-emerald-100 flex items-center gap-1">
                    <svg className="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    You're Attending
                  </span>
                )}
              </div>
              <h1 className="text-2xl lg:text-3xl font-bold text-white">{data.title}</h1>
              {isNiyaz && data.miqaatName && data.miqaatName !== data.title && (
                <p className="text-purple-100 mt-2 text-lg">{data.miqaatName}</p>
              )}
            </div>

            {/* Event Details */}
            <div className="p-6 space-y-6">
              {/* Date & Time Row */}
              <div className="flex flex-wrap gap-8">
                <div className="flex items-center gap-4">
                  <div className={`p-3 rounded-xl ${isNiyaz ? 'bg-purple-50' : 'bg-blue-50'}`}>
                    <svg className={`w-6 h-6 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500 font-medium">{isNiyaz ? 'Miqaat Date' : 'Event Date'}</p>
                    <p className="text-lg font-semibold text-gray-900">{formatDate(data.eventDate)}</p>
                  </div>
                </div>

                {data.startTime && (
                  <div className="flex items-center gap-4">
                    <div className={`p-3 rounded-xl ${isNiyaz ? 'bg-purple-50' : 'bg-blue-50'}`}>
                      <svg className={`w-6 h-6 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500 font-medium">{isNiyaz ? 'Start Time' : 'Pickup Time'}</p>
                      <p className="text-lg font-semibold text-gray-900">{formatTime(data.startTime)}</p>
                    </div>
                  </div>
                )}
              </div>

              {/* Description */}
              {data.description && (
                <div className="border-t pt-6">
                  <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-3">About this Event</h3>
                  <div className="prose prose-gray max-w-none">
                    <p className="text-gray-700 leading-relaxed whitespace-pre-line">{data.description}</p>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Add to Calendar */}
          <div className="relative inline-block">
            <button
              onClick={() => setShowCalendarMenu(!showCalendarMenu)}
              className="flex items-center gap-2 px-4 py-2.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors shadow-sm"
            >
              <svg className="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              Add to Calendar
              <svg className={`w-4 h-4 transition-transform ${showCalendarMenu ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </button>

            {showCalendarMenu && (
              <div className="absolute left-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-50">
                <a
                  href={googleUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100"
                  onClick={() => setShowCalendarMenu(false)}
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                  </svg>
                  Google Calendar
                </a>
                <a
                  href={outlookUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100"
                  onClick={() => setShowCalendarMenu(false)}
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24">
                    <path fill="#0078D4" d="M24 7.387v10.478c0 .23-.08.424-.238.576-.158.152-.356.228-.594.228h-8.457v-6.696l1.2.96c.106.085.23.128.374.128.143 0 .268-.043.374-.128l6.103-4.872c.17-.128.255-.298.255-.512v-.17c0-.213-.085-.383-.255-.51L16.71 2.85v-.512c0-.213.085-.383.255-.51.17-.128.34-.192.51-.192h5.693c.238 0 .437.076.595.228.158.152.237.347.237.576v4.948z"/>
                    <path fill="#0078D4" d="M15.711 7.47v6.697H8.457v5.503h-7.22c-.237 0-.436-.076-.594-.228C.485 19.29.406 19.096.406 18.866V5.133c0-.23.08-.424.237-.576.158-.152.357-.228.595-.228h7.22V9.83l3.626-2.902c.107-.085.231-.128.374-.128s.268.043.374.128l2.88 2.304v-1.76z"/>
                    <path fill="#28A8EA" d="M15.711 4.33v3.14l-2.88-2.303c-.106-.085-.23-.128-.374-.128-.143 0-.267.043-.374.128L8.457 7.87V4.33h7.254z"/>
                    <path fill="#0364B8" d="M8.457 9.83V4.33l-7.22-.001v5.502h7.22z"/>
                    <path fill="#0078D4" d="M8.457 14.168v5.502H1.237c-.238 0-.437-.076-.595-.228-.158-.152-.236-.347-.236-.576v-4.698h8.05z"/>
                  </svg>
                  Outlook Calendar
                </a>
                <div className="border-t border-gray-100 my-1"></div>
                <button
                  onClick={handleDownloadICS}
                  className="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100 text-left"
                >
                  <svg className="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                  </svg>
                  Download iCal (.ics)
                </button>
              </div>
            )}
          </div>
        </div>

        {/* Sidebar - 1 column on large screens */}
        <div className="space-y-6">
          {/* Registration Deadline Card */}
          {isRegistrationOpen && registrationCloseAt && (
            <div className={`rounded-xl p-5 ${
              daysUntilDeadline && daysUntilDeadline <= 2
                ? 'bg-red-50 border border-red-200'
                : daysUntilDeadline && daysUntilDeadline <= 5
                ? 'bg-amber-50 border border-amber-200'
                : 'bg-blue-50 border border-blue-200'
            }`}>
              <div className="flex items-center gap-3 mb-3">
                <div className={`p-2 rounded-lg ${
                  daysUntilDeadline && daysUntilDeadline <= 2
                    ? 'bg-red-100'
                    : daysUntilDeadline && daysUntilDeadline <= 5
                    ? 'bg-amber-100'
                    : 'bg-blue-100'
                }`}>
                  <svg className={`w-5 h-5 ${
                    daysUntilDeadline && daysUntilDeadline <= 2
                      ? 'text-red-600'
                      : daysUntilDeadline && daysUntilDeadline <= 5
                      ? 'text-amber-600'
                      : 'text-blue-600'
                  }`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div className={`text-2xl font-bold ${
                  daysUntilDeadline && daysUntilDeadline <= 2
                    ? 'text-red-700'
                    : daysUntilDeadline && daysUntilDeadline <= 5
                    ? 'text-amber-700'
                    : 'text-blue-700'
                }`}>
                  {daysUntilDeadline === 0
                    ? 'Last day!'
                    : daysUntilDeadline === 1
                    ? '1 day left'
                    : `${daysUntilDeadline} days left`
                  }
                </div>
              </div>
              <p className={`text-sm ${
                daysUntilDeadline && daysUntilDeadline <= 2
                  ? 'text-red-600'
                  : daysUntilDeadline && daysUntilDeadline <= 5
                  ? 'text-amber-600'
                  : 'text-blue-600'
              }`}>
                The deadline to {isNiyaz ? 'RSVP' : 'register'} is <strong>{formatDeadlineDate(registrationCloseAt)}</strong>
              </p>
            </div>
          )}

          {/* RSVP/Order Button */}
          {isRegistrationOpen && (
            <Link
              className={`flex items-center justify-center gap-2 w-full py-4 px-6 text-lg font-semibold text-white rounded-xl transition-all hover:shadow-lg ${
                isNiyaz
                  ? 'bg-purple-600 hover:bg-purple-700'
                  : 'bg-blue-600 hover:bg-blue-700'
              }`}
              to={`/events/${id}/rsvp`}
            >
              {isNiyaz ? 'RSVP to this Event' : 'Register for Thaali'}
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14 5l7 7m0 0l-7 7m7-7H3" />
              </svg>
            </Link>
          )}

          {isRegistrationNotYetOpen && (
            <div className="bg-amber-50 border border-amber-200 rounded-xl p-5">
              <div className="flex items-center gap-3 mb-2">
                <svg className="w-6 h-6 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                <p className="text-amber-800 font-semibold">Registration Opens Soon</p>
              </div>
              <p className="text-amber-700 text-sm">
                Registration will open on <strong>{registrationOpenAt?.toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                })}</strong>
              </p>
            </div>
          )}

          {isRegistrationClosed && (
            <div className="bg-red-50 border border-red-200 rounded-xl p-5">
              <div className="flex items-center gap-3 mb-2">
                <svg className="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <p className="text-red-800 font-semibold">Registration Closed</p>
              </div>
              <p className="text-red-700 text-sm">
                Registration closed on <strong>{registrationCloseAt?.toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                })}</strong>
              </p>
            </div>
          )}

          {data.status === 'DRAFT' && (
            <div className="bg-gray-50 border border-gray-200 rounded-xl p-5">
              <div className="flex items-center gap-3 mb-2">
                <svg className="w-6 h-6 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <p className="text-gray-700 font-semibold">Event Not Published</p>
              </div>
              <p className="text-gray-600 text-sm">This event is not yet open for registration.</p>
            </div>
          )}

          {data.status === 'CANCELLED' && (
            <div className="bg-red-50 border border-red-200 rounded-xl p-5">
              <div className="flex items-center gap-3 mb-2">
                <svg className="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                </svg>
                <p className="text-red-700 font-semibold">Event Cancelled</p>
              </div>
              <p className="text-red-600 text-sm">This event has been cancelled.</p>
            </div>
          )}

          {/* RSVP Summary Card for Niyaz events */}
          {isNiyaz && rsvpSummary && rsvpSummary.familyCount > 0 && (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div className="bg-purple-50 px-5 py-3 border-b border-purple-100">
                <h3 className="font-semibold text-purple-900 flex items-center gap-2">
                  <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                  </svg>
                  RSVP Summary
                </h3>
              </div>
              <div className="p-5">
                {/* Attendance count */}
                <div className="flex items-center justify-between mb-4">
                  <div className="text-center flex-1">
                    <p className="text-3xl font-bold text-purple-600">{rsvpSummary.familyCount}</p>
                    <p className="text-sm text-gray-500">{rsvpSummary.familyCount === 1 ? 'Family' : 'Families'}</p>
                  </div>
                  <div className="w-px h-12 bg-gray-200"></div>
                  <div className="text-center flex-1">
                    <p className="text-3xl font-bold text-purple-600">{rsvpSummary.totalAdults + rsvpSummary.totalKids}</p>
                    <p className="text-sm text-gray-500">Attendees</p>
                  </div>
                </div>

                {/* Breakdown */}
                <div className="flex justify-center gap-6 text-sm text-gray-600 mb-4">
                  <span>{rsvpSummary.totalAdults} adults</span>
                  <span>{rsvpSummary.totalKids} kids</span>
                </div>

                {/* Guest list (only if showRsvpSummary is enabled and there are guests) */}
                {data.showRsvpSummary && rsvpSummary.guests.length > 0 && (
                  <div className="border-t pt-4">
                    <button
                      onClick={() => setShowGuestList(!showGuestList)}
                      className="w-full flex items-center justify-between text-sm text-purple-600 hover:text-purple-800 font-medium"
                    >
                      <span>View Guest List</span>
                      <svg
                        className={`w-4 h-4 transition-transform ${showGuestList ? 'rotate-180' : ''}`}
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                      </svg>
                    </button>
                    {showGuestList && (
                      <div className="mt-3 max-h-64 overflow-y-auto">
                        <ul className="space-y-2">
                          {rsvpSummary.guests.map((guest, idx) => (
                            <li key={idx} className="flex items-start gap-2">
                              <span className="w-1.5 h-1.5 bg-purple-400 rounded-full flex-shrink-0 mt-1.5"></span>
                              <div className="min-w-0">
                                <span className="text-sm text-gray-700 font-medium">{guest.name}</span>
                                <span className="text-gray-400 italic text-xs ml-1">
                                  ({guest.adults}{guest.kids > 0 ? `, ${guest.kids}` : ''})
                                </span>
                              </div>
                            </li>
                          ))}
                        </ul>
                        <p className="text-xs text-gray-400 italic mt-3 pt-2 border-t border-gray-100">
                          (adults, kids)
                        </p>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
