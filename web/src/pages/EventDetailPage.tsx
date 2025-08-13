import { useParams, Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'
import type { Event } from '../types/models'

export default function EventDetailPage(){
  const { id } = useParams()
  const { data } = useQuery<Event>({ queryKey: ['event', id], queryFn: async () => (await api.get(`/events/${id}`)).data })
  if (!data) return null
  return (
    <div className="space-y-3">
      <div className="card">
        <h2 className="text-2xl font-bold">Event on {data.date}</h2>
        <p>Start: {data.startTime ?? '—'}</p>
        <p>Capacity: {data.capacity ?? '—'}</p>
        <p>{data.notes}</p>
      </div>
      <Link className="btn" to={`/events/${id}/rsvp`}>RSVP to this event</Link>
    </div>
  )
}
