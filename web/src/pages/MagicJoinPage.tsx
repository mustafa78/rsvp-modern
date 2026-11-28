import { useQuery } from '@tanstack/react-query';
import { useParams, useSearchParams } from 'react-router-dom';
import { api, API_BASE } from '../api/client';
import { MagicJoinInfo, fmtDateTime, fmtTime } from '../lib/webinars';

export default function MagicJoinPage() {
  const { token } = useParams();
  const [params] = useSearchParams();
  const joinError = params.get('joinError');
  const { data, isLoading } = useQuery<MagicJoinInfo>({
    queryKey: ['magic-join', token],
    queryFn: async () => (await api.get(`/webinars/public/${encodeURIComponent(token ?? '')}`)).data,
    retry: false,
    refetchInterval: 30_000,
  });

  if (isLoading) return <div className="text-center text-gray-500 py-12">Loading...</div>;

  // Only when nothing valid is held: a failed background refetch keeps showing the last good data.
  if (!data) {
    return (
      <div className="rounded-xl border bg-white p-8 text-center">
        <h1 className="text-xl font-semibold text-gray-900 mb-2">This link is invalid or has expired</h1>
        <p className="text-sm text-gray-600">Please ask your head of family or the coordinator for a new link.</p>
      </div>
    );
  }

  return (
    <div className="rounded-xl border bg-white p-6 shadow-sm">
      <h1 className="text-xl font-bold text-gray-900">{data.title}</h1>
      {data.hostName && <p className="text-sm text-gray-500">Host: {data.hostName}</p>}
      <p className="mt-2 text-gray-800">{fmtDateTime(data.scheduledStart)} – {fmtTime(data.scheduledEnd)}</p>

      <div className="mt-4 rounded-lg bg-indigo-50 px-4 py-3 text-sm text-indigo-900">
        Seat for <span className="font-semibold">{data.attendeeName}</span> ({data.attendeeIts}).
        If this is not you, please do not use this link.
      </div>

      {joinError && (
        <div className="mt-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{joinError}</div>
      )}

      <div className="mt-6">
        {data.joinOpen ? (
          <a
            href={`${API_BASE}/api/webinars/public/${encodeURIComponent(token ?? '')}/launch`}
            className="block rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-5 py-3 text-center font-semibold text-white"
          >
            Join meeting
          </a>
        ) : (
          <div className="rounded-lg bg-gray-100 px-5 py-3 text-center text-gray-600">
            Joining opens shortly before the start time. Keep this page open; the button will appear.
          </div>
        )}
      </div>
    </div>
  );
}
