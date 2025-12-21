import { useState } from 'react';
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

type StatusFilter = 'ALL' | 'DRAFT' | 'PUBLISHED' | 'CANCELLED';

export default function EventList() {
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('ALL');
  const [typeFilter, setTypeFilter] = useState<string>('ALL');
  const queryClient = useQueryClient();

  const { data: events, isLoading } = useQuery<Event[]>({
    queryKey: ['admin-events'],
    queryFn: async () => (await api.get('/events')).data,
  });

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

  const filteredEvents = events?.filter((e) => {
    if (statusFilter !== 'ALL' && e.status !== statusFilter) return false;
    if (typeFilter !== 'ALL' && e.type !== typeFilter) return false;
    return true;
  }) || [];

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
        <h1 className="text-2xl font-bold">All Events</h1>
        <div className="flex gap-2">
          <Link to="/admin/events/new/thaali" className="btn">
            + Thaali Event
          </Link>
          <Link to="/admin/events/new/niyaz" className="btn bg-gray-700">
            + Niyaz Event
          </Link>
        </div>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="flex gap-4 items-center">
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
          <div className="text-sm text-gray-500">
            Showing {filteredEvents.length} of {events?.length || 0} events
          </div>
        </div>
      </div>

      {/* Events Table */}
      <div className="card">
        {filteredEvents.length === 0 ? (
          <p className="text-gray-500">No events found</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Title</th>
                <th className="pb-2 font-medium">Type</th>
                <th className="pb-2 font-medium">Date</th>
                <th className="pb-2 font-medium">Registration</th>
                <th className="pb-2 font-medium">Status</th>
                <th className="pb-2 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredEvents.map((event) => (
                <tr key={event.id} className="border-b last:border-0">
                  <td className="py-3">
                    <Link
                      to={`/admin/events/${event.id}`}
                      className="text-blue-600 hover:underline font-medium"
                    >
                      {event.title}
                    </Link>
                    {event.description && (
                      <p className="text-sm text-gray-500 truncate max-w-xs">
                        {event.description}
                      </p>
                    )}
                  </td>
                  <td className="py-3">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        event.type === 'THAALI'
                          ? 'bg-purple-100 text-purple-700'
                          : 'bg-blue-100 text-blue-700'
                      }`}
                    >
                      {event.type}
                    </span>
                  </td>
                  <td className="py-3 text-gray-600">
                    {event.eventDate}
                    {event.startTime && (
                      <span className="text-gray-400 text-sm ml-1">
                        {event.startTime.slice(0, 5)}
                      </span>
                    )}
                  </td>
                  <td className="py-3 text-sm text-gray-500">
                    <div>{new Date(event.registrationOpenAt).toLocaleDateString()}</div>
                    <div className="text-gray-400">
                      to {new Date(event.registrationCloseAt).toLocaleDateString()}
                    </div>
                  </td>
                  <td className="py-3">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        event.status === 'PUBLISHED'
                          ? 'bg-green-100 text-green-700'
                          : event.status === 'DRAFT'
                          ? 'bg-yellow-100 text-yellow-700'
                          : 'bg-red-100 text-red-700'
                      }`}
                    >
                      {event.status}
                    </span>
                  </td>
                  <td className="py-3">
                    <div className="flex gap-2">
                      <Link
                        to={`/admin/events/${event.id}`}
                        className="text-sm text-blue-600 hover:underline"
                      >
                        Edit
                      </Link>
                      {event.status === 'DRAFT' && (
                        <button
                          onClick={() => handlePublish(event.id)}
                          className="text-sm text-green-600 hover:underline"
                          disabled={publishMutation.isPending}
                        >
                          Publish
                        </button>
                      )}
                      {event.status === 'PUBLISHED' && (
                        <button
                          onClick={() => handleCancel(event.id)}
                          className="text-sm text-red-600 hover:underline"
                          disabled={cancelMutation.isPending}
                        >
                          Cancel
                        </button>
                      )}
                      {event.type === 'THAALI' && event.status === 'PUBLISHED' && (
                        <Link
                          to={`/admin/reports/orders/${event.id}`}
                          className="text-sm text-purple-600 hover:underline"
                        >
                          Orders
                        </Link>
                      )}
                      {event.type === 'NIYAZ' && event.status === 'PUBLISHED' && (
                        <Link
                          to={`/admin/reports/rsvps/${event.id}`}
                          className="text-sm text-purple-600 hover:underline"
                        >
                          RSVPs
                        </Link>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
