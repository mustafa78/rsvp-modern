import { Link } from 'react-router-dom'
import type { Event } from '../types/models'

export default function EventCard({ e }: { e: Event }){
  return (
    <div className="card">
      <h3 className="text-xl font-semibold">{e.date}</h3>
      <p>Start: {e.startTime ?? '—'}</p>
      <p>Capacity: {e.capacity ?? '—'}</p>
      <div className="mt-2 space-x-3">
        <Link className="underline" to={`/events/${e.id}`}>Details</Link>
        <Link className="underline" to={`/events/${e.id}/rsvp`}>RSVP</Link>
      </div>
    </div>
  )
}
