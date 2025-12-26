import { useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'
import type { Event } from '../types/models'

export default function EventDetailPage() {
  const { id } = useParams()
  const [showCalendarMenu, setShowCalendarMenu] = useState(false)

  const { data, isLoading } = useQuery<Event>({
    queryKey: ['event', id],
    queryFn: async () => (await api.get(`/events/${id}`)).data
  })

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>
  }

  if (!data) {
    return <div className="text-red-500">Event not found</div>
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
    // Parse as local date to avoid timezone offset issues
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
      endDateTime.setHours(endDateTime.getHours() + 2) // Assume 2 hour event
    } else {
      startDateTime.setHours(18, 0, 0) // Default to 6 PM
      endDateTime.setHours(20, 0, 0)
    }

    const title = encodeURIComponent(data.title)
    const description = encodeURIComponent(data.description || '')

    // Format for Google Calendar (YYYYMMDDTHHmmss)
    const formatGoogleDate = (d: Date) => {
      return d.toISOString().replace(/-|:|\.\d{3}/g, '').slice(0, 15)
    }

    // Format for Outlook (ISO format)
    const formatOutlookDate = (d: Date) => {
      return d.toISOString().slice(0, 19)
    }

    // Format for ICS
    const formatICSDate = (d: Date) => {
      const pad = (n: number) => n.toString().padStart(2, '0')
      return `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}T${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`
    }

    // Google Calendar URL
    const googleUrl = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${title}&dates=${formatGoogleDate(startDateTime)}/${formatGoogleDate(endDateTime)}&details=${description}`

    // Outlook Web Calendar URL
    const outlookUrl = `https://outlook.live.com/calendar/0/deeplink/compose?subject=${title}&startdt=${formatOutlookDate(startDateTime)}&enddt=${formatOutlookDate(endDateTime)}&body=${description}&path=/calendar/action/compose&rru=addevent`

    // Generate ICS content for Apple Calendar and download
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
    <div className="space-y-6 max-w-2xl">
      {/* Main Event Card */}
      <div className="card overflow-hidden">
        {/* Header with gradient */}
        <div className={`px-6 py-4 ${isNiyaz ? 'bg-gradient-to-r from-purple-600 to-purple-700' : 'bg-gradient-to-r from-blue-600 to-blue-700'}`}>
          <div className="flex items-center gap-2 mb-2">
            <span className="px-2 py-0.5 text-xs font-medium rounded bg-white/20 text-white">
              {isNiyaz ? 'NIYAZ' : 'THAALI'}
            </span>
            {data.status === 'PUBLISHED' && (
              <span className="px-2 py-0.5 text-xs font-medium rounded bg-green-400/20 text-green-100">
                Open for Registration
              </span>
            )}
          </div>
          <h1 className="text-2xl font-bold text-white">{data.title}</h1>
          {isNiyaz && data.miqaatName && data.miqaatName !== data.title && (
            <p className="text-purple-100 mt-1">{data.miqaatName}</p>
          )}
        </div>

        {/* Event Details */}
        <div className="p-6 space-y-6">
          {/* Date & Time */}
          <div className="flex flex-wrap gap-6">
            <div className="flex items-start gap-3">
              <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-100' : 'bg-blue-100'}`}>
                <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <div>
                <p className="text-sm text-gray-500">{isNiyaz ? 'Miqaat Date' : isThaali ? 'Thaali Date' : 'Event Date'}</p>
                <p className="font-semibold text-gray-900">{formatDate(data.eventDate)}</p>
              </div>
            </div>

            {data.startTime && (
              <div className="flex items-start gap-3">
                <div className={`p-2 rounded-lg ${isNiyaz ? 'bg-purple-100' : 'bg-blue-100'}`}>
                  <svg className={`w-5 h-5 ${isNiyaz ? 'text-purple-600' : 'text-blue-600'}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div>
                  <p className="text-sm text-gray-500">{isNiyaz ? 'Start Time' : isThaali ? 'Pickup Time' : 'Time'}</p>
                  <p className="font-semibold text-gray-900">{formatTime(data.startTime)}</p>
                </div>
              </div>
            )}
          </div>

          {/* Description */}
          {data.description && (
            <div className="border-t pt-6">
              <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-3">About this Event</h3>
              <div className="prose prose-sm max-w-none">
                <p className="text-gray-700 leading-relaxed whitespace-pre-line">{data.description}</p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Add to Calendar Button - Outside card to avoid overflow clipping */}
      <div className="relative inline-block">
        <button
          onClick={() => setShowCalendarMenu(!showCalendarMenu)}
          className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors shadow-sm"
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
            {/* Google Calendar */}
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

            {/* Outlook Calendar */}
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
                <path fill="#14447D" d="M0 6.992v10.356c0 .553.2 1.025.598 1.416.399.39.878.586 1.438.586h4.33V6.406H1.438c-.347 0-.66.086-.937.258-.278.171-.496.399-.655.682C-.051 7.63 0 7.298 0 6.992z"/>
                <path fill="#28A8EA" d="M9.6 6.406v12.944h-3.6c-.347 0-.66-.086-.937-.258-.278-.171-.496-.399-.655-.682V6.406H9.6z"/>
              </svg>
              Outlook Calendar
            </a>

            <div className="border-t border-gray-100 my-1"></div>

            {/* Apple Calendar */}
            <button
              onClick={handleDownloadICS}
              className="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100 text-left"
            >
              <svg className="w-5 h-5" viewBox="0 0 24 24">
                <path fill="#FF3B30" d="M19.5 3h-3V1.5c0-.398-.352-.75-.75-.75s-.75.352-.75.75V3h-6V1.5c0-.398-.352-.75-.75-.75S7.5 1.102 7.5 1.5V3h-3C3.122 3 2 4.121 2 5.5v14C2 20.879 3.122 22 4.5 22h15c1.378 0 2.5-1.121 2.5-2.5v-14C22 4.121 20.878 3 19.5 3zm1 16.5c0 .552-.449 1-1 1h-15c-.551 0-1-.448-1-1V9h17v10.5zm0-12h-17V5.5c0-.552.449-1 1-1h3v1c0 .398.352.75.75.75s.75-.352.75-.75v-1h6v1c0 .398.352.75.75.75s.75-.352.75-.75v-1h3c.551 0 1 .448 1 1V7.5z"/>
              </svg>
              Apple Calendar
            </button>

            {/* Download iCal */}
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

      {/* Registration Deadline Card */}
      {isRegistrationOpen && registrationCloseAt && (
        <div className={`rounded-lg border-l-4 p-4 ${
          daysUntilDeadline && daysUntilDeadline <= 2
            ? 'bg-red-50 border-red-500'
            : daysUntilDeadline && daysUntilDeadline <= 5
            ? 'bg-amber-50 border-amber-500'
            : 'bg-blue-50 border-blue-500'
        }`}>
          <div className="flex items-start gap-3">
            <svg className={`w-6 h-6 flex-shrink-0 ${
              daysUntilDeadline && daysUntilDeadline <= 2
                ? 'text-red-500'
                : daysUntilDeadline && daysUntilDeadline <= 5
                ? 'text-amber-500'
                : 'text-blue-500'
            }`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p className={`font-semibold ${
                daysUntilDeadline && daysUntilDeadline <= 2
                  ? 'text-red-800'
                  : daysUntilDeadline && daysUntilDeadline <= 5
                  ? 'text-amber-800'
                  : 'text-blue-800'
              }`}>
                {daysUntilDeadline === 0
                  ? 'Last day to register!'
                  : daysUntilDeadline === 1
                  ? 'Only 1 day left to register!'
                  : `${daysUntilDeadline} days left to register`
                }
              </p>
              <p className={`text-sm mt-1 ${
                daysUntilDeadline && daysUntilDeadline <= 2
                  ? 'text-red-600'
                  : daysUntilDeadline && daysUntilDeadline <= 5
                  ? 'text-amber-600'
                  : 'text-blue-600'
              }`}>
                The deadline to {isNiyaz ? 'RSVP' : 'place your order'} is <strong>{formatDeadlineDate(registrationCloseAt)}</strong>
              </p>
            </div>
          </div>
        </div>
      )}

      {/* RSVP/Order Button */}
      {isRegistrationOpen && (
        <Link
          className={`inline-flex items-center justify-center gap-2 w-full py-3 px-6 text-lg font-semibold text-white rounded-lg transition-all hover:shadow-lg ${
            isNiyaz
              ? 'bg-purple-600 hover:bg-purple-700'
              : 'bg-blue-600 hover:bg-blue-700'
          }`}
          to={`/events/${id}/rsvp`}
        >
          {isNiyaz ? 'RSVP to this Event' : 'Place Your Order'}
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14 5l7 7m0 0l-7 7m7-7H3" />
          </svg>
        </Link>
      )}

      {isRegistrationNotYetOpen && (
        <div className="bg-amber-50 border border-amber-200 rounded-lg p-5">
          <div className="flex items-start gap-3">
            <svg className="w-6 h-6 text-amber-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            <div>
              <p className="text-amber-800 font-semibold">Registration Opens Soon</p>
              <p className="text-amber-700 mt-1">
                Registration will open on <strong>{registrationOpenAt?.toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                })}</strong>
              </p>
            </div>
          </div>
        </div>
      )}

      {isRegistrationClosed && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-5">
          <div className="flex items-start gap-3">
            <svg className="w-6 h-6 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p className="text-red-800 font-semibold">Registration Closed</p>
              <p className="text-red-700 mt-1">
                Registration closed on <strong>{registrationCloseAt?.toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                })}</strong>
              </p>
            </div>
          </div>
        </div>
      )}

      {data.status === 'DRAFT' && (
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-5">
          <div className="flex items-start gap-3">
            <svg className="w-6 h-6 text-gray-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p className="text-gray-700 font-semibold">Event Not Published</p>
              <p className="text-gray-600 mt-1">This event is not yet open for registration.</p>
            </div>
          </div>
        </div>
      )}

      {data.status === 'CANCELLED' && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-5">
          <div className="flex items-start gap-3">
            <svg className="w-6 h-6 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
            </svg>
            <div>
              <p className="text-red-700 font-semibold">Event Cancelled</p>
              <p className="text-red-600 mt-1">This event has been cancelled.</p>
            </div>
          </div>
        </div>
      )}

      {/* Back to Events */}
      <div className="pt-2">
        <Link to="/" className="text-sm text-gray-600 hover:text-gray-900 inline-flex items-center gap-1">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          Back to Events
        </Link>
      </div>
    </div>
  )
}
