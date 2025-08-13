import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'
import EventCard from '../components/EventCard'
import type { Event } from '../types/models'

export default function EventsPage(){
  const { data, isLoading } = useQuery<Event[]>({ queryKey: ['events'], queryFn: async () => (await api.get('/events')).data })
  if (isLoading) return <div>Loading…</div>
  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {data?.map(e => <EventCard key={e.id} e={e} />)}
    </div>
  )
}
