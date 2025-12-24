import { useParams, Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'
import type { Event } from '../types/models'

export default function EventDetailPage() {
  const { id } = useParams()
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

  // Format date for display
  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr)
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

  return (
    <div className="space-y-4 max-w-2xl">
      <div className="card space-y-4">
        {/* Event Header */}
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className={`px-2 py-0.5 text-xs font-medium rounded ${
              isNiyaz ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
            }`}>
              {data.type}
            </span>
            <span className={`px-2 py-0.5 text-xs font-medium rounded ${
              data.status === 'PUBLISHED' ? 'bg-green-100 text-green-700' :
              data.status === 'CANCELLED' ? 'bg-red-100 text-red-700' :
              'bg-gray-100 text-gray-700'
            }`}>
              {data.status}
            </span>
          </div>
          <h1 className="text-2xl font-bold text-gray-900">{data.title}</h1>
          {isNiyaz && data.miqaatName && data.miqaatName !== data.title && (
            <p className="text-gray-600">{data.miqaatName}</p>
          )}
        </div>

        {/* Event Details */}
        <div className="border-t pt-4 space-y-2">
          <div className="flex items-center gap-2">
            <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            <span className="text-gray-700">
              {isNiyaz ? 'Miqaat Date: ' : isThaali ? 'Thaali Date: ' : 'Date: '}
              <strong>{formatDate(data.eventDate)}</strong>
            </span>
          </div>

          {data.startTime && (
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span className="text-gray-700">
                {isNiyaz ? 'Miqaat Start Time: ' : isThaali ? 'Pickup Time: ' : 'Start Time: '}
                <strong>{formatTime(data.startTime)}</strong>
              </span>
            </div>
          )}
        </div>

        {/* Description */}
        {data.description && (
          <div className="border-t pt-4">
            <p className="text-gray-600">{data.description}</p>
          </div>
        )}

        {/* Registration Info */}
        {(data.registrationOpenAt || data.registrationCloseAt) && (
          <div className="border-t pt-4 text-sm text-gray-500">
            {data.registrationOpenAt && (
              <p>Registration opens: {new Date(data.registrationOpenAt).toLocaleDateString()}</p>
            )}
            {data.registrationCloseAt && (
              <p>Registration closes: {new Date(data.registrationCloseAt).toLocaleDateString()}</p>
            )}
          </div>
        )}
      </div>

      {/* RSVP Button */}
      {data.status === 'PUBLISHED' && (
        <Link className="btn inline-block" to={`/events/${id}/rsvp`}>
          RSVP to this event
        </Link>
      )}

      {data.status === 'DRAFT' && (
        <p className="text-amber-600 text-sm">This event is not yet published for RSVPs.</p>
      )}

      {data.status === 'CANCELLED' && (
        <p className="text-red-600 text-sm">This event has been cancelled.</p>
      )}
    </div>
  )
}
