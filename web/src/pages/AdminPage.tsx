import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'

type Summary = { upcomingEventsCount: number; rsvpCountsByRole: Record<string, number> }

export default function AdminPage(){
  const { data } = useQuery<Summary>({ queryKey: ['summary'], queryFn: async ()=> (await api.get('/stats/summary')).data })
  return (
    <div className="card">
      <h2 className="text-xl font-semibold mb-2">Summary</h2>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  )
}
