import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

type RsvpDetail = {
  personId: number;
  personName: string;
  adults: number;
  kids: number;
};

export default function NiyazRsvpReport() {
  const { eventId } = useParams<{ eventId: string }>();

  const { data: event, isLoading: eventLoading } = useQuery<Event>({
    queryKey: ['event', eventId],
    queryFn: async () => (await api.get(`/events/${eventId}`)).data,
    enabled: !!eventId,
  });

  const { data: adults, isLoading: adultsLoading } = useQuery<number>({
    queryKey: ['niyaz-adults', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/totals/adults`)).data,
    enabled: !!eventId,
  });

  const { data: kids, isLoading: kidsLoading } = useQuery<number>({
    queryKey: ['niyaz-kids', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/totals/kids`)).data,
    enabled: !!eventId,
  });

  const { data: rsvps, isLoading: rsvpsLoading } = useQuery<RsvpDetail[]>({
    queryKey: ['niyaz-rsvps', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/all`)).data,
    enabled: !!eventId,
  });

  if (eventLoading || adultsLoading || kidsLoading || rsvpsLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  if (!event) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Event Not Found</h1>
        <Link to="/admin/events" className="text-blue-600 hover:underline">
          ← Back to Events
        </Link>
      </div>
    );
  }

  const totalAttendees = (adults || 0) + (kids || 0);
  const equivalentServings = (adults || 0) + (kids || 0) * 0.5;
  const numberOfThaal = equivalentServings / 8;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Niyaz RSVP Report</h1>
          <p className="text-gray-500">{event.title} - {event.eventDate}</p>
        </div>
        <Link to="/admin/events" className="btn bg-gray-500">
          ← Back to Events
        </Link>
      </div>

      {/* Attendance Summary */}
      <div className="card overflow-hidden p-0">
        <div className="bg-purple-600 px-6 py-4">
          <h2 className="text-lg font-semibold text-white">Attendance Summary</h2>
        </div>
        <div className="p-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-blue-50 rounded-lg p-4 text-center">
              <div className="text-3xl font-bold text-blue-600">{adults || 0}</div>
              <div className="text-sm text-gray-600 mt-1">Adults</div>
            </div>
            <div className="bg-green-50 rounded-lg p-4 text-center">
              <div className="text-3xl font-bold text-green-600">{kids || 0}</div>
              <div className="text-sm text-gray-600 mt-1">Children</div>
            </div>
            <div className="bg-purple-50 rounded-lg p-4 text-center">
              <div className="text-3xl font-bold text-purple-600">{totalAttendees}</div>
              <div className="text-sm text-gray-600 mt-1">Total Attendees</div>
            </div>
            <div className="bg-orange-50 rounded-lg p-4 text-center">
              <div className="text-3xl font-bold text-orange-600">{rsvps?.length || 0}</div>
              <div className="text-sm text-gray-600 mt-1">Total RSVPs</div>
            </div>
          </div>
        </div>
      </div>

      {/* Planning Notes */}
      <div className="card bg-yellow-50 border border-yellow-200">
        <h2 className="text-lg font-semibold mb-3">Planning Notes</h2>
        <ul className="text-sm text-gray-700 space-y-2">
          <li>• Expected adult servings: <strong>{adults || 0}</strong></li>
          <li>• Expected child servings (typically ½ portion): <strong>{kids || 0}</strong></li>
          <li>• Equivalent full servings: <strong>{equivalentServings.toFixed(1)}</strong></li>
          <li className="text-base">• <strong className="text-purple-700">Number of Thaals: {numberOfThaal.toFixed(1)}</strong> <span className="text-gray-500">(8 persons per thaal)</span></li>
        </ul>
      </div>

      {/* RSVP List */}
      <div className="card overflow-hidden p-0">
        <div className="bg-purple-600 px-6 py-4">
          <h2 className="text-lg font-semibold text-white">RSVP List</h2>
          <p className="text-sm text-purple-200">{rsvps?.length || 0} families have responded</p>
        </div>
        <div className="p-0">
          {rsvps && rsvps.length > 0 ? (
            <table className="w-full">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-6 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">#</th>
                  <th className="py-3 px-6 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Name</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Adults</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Children</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {rsvps.map((rsvp, idx) => (
                  <tr key={rsvp.personId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    <td className="py-3 px-6 text-gray-500 text-sm">{idx + 1}</td>
                    <td className="py-3 px-6 font-medium text-gray-900">{rsvp.personName}</td>
                    <td className="py-3 px-4 text-center text-blue-600 font-medium">{rsvp.adults}</td>
                    <td className="py-3 px-4 text-center text-green-600 font-medium">{rsvp.kids}</td>
                    <td className="py-3 px-4 text-center font-bold text-purple-600">{rsvp.adults + rsvp.kids}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr className="bg-gray-100 border-t-2 border-gray-300">
                  <td className="py-3 px-6"></td>
                  <td className="py-3 px-6 font-bold text-gray-900">Total</td>
                  <td className="py-3 px-4 text-center font-bold text-blue-600">{adults || 0}</td>
                  <td className="py-3 px-4 text-center font-bold text-green-600">{kids || 0}</td>
                  <td className="py-3 px-4 text-center font-bold text-purple-600">{totalAttendees}</td>
                </tr>
              </tfoot>
            </table>
          ) : (
            <p className="p-6 text-gray-500">No RSVPs yet.</p>
          )}
        </div>
      </div>

      {/* Print Button */}
      <div className="flex gap-3">
        <button onClick={() => window.print()} className="btn bg-purple-600 hover:bg-purple-700">
          Print Report
        </button>
      </div>
    </div>
  );
}
