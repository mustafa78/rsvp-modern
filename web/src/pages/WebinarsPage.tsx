import { useQuery } from '@tanstack/react-query';
import { useSearchParams } from 'react-router-dom';
import { api, API_BASE } from '../api/client';
import { MemberWebinar, fmtDateTime, fmtTime } from '../lib/webinars';

export default function WebinarsPage() {
  const [params] = useSearchParams();
  const joinError = params.get('joinError');
  const { data, isLoading, isError } = useQuery<MemberWebinar[]>({
    queryKey: ['my-webinars'],
    queryFn: async () => (await api.get('/webinars')).data,
    refetchInterval: 30_000, // keeps the Join button in step with the join window
  });

  return (
    <div className="max-w-3xl mx-auto px-4 py-6">
      <h1 className="text-2xl font-bold text-gray-900 mb-1">Webinars</h1>
      <p className="text-sm text-gray-500 mb-6">
        Sessions you can join. The Join button becomes available shortly before the start time.
      </p>

      {joinError && (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
          {joinError}
        </div>
      )}

      {isLoading && <div className="text-gray-500">Loading...</div>}
      {!isLoading && !data && isError && (
        <div className="rounded-xl border border-red-200 bg-red-50 p-8 text-center text-sm text-red-800">
          Could not load your webinars. Please refresh the page to try again.
        </div>
      )}
      {!isLoading && data?.length === 0 && (
        <div className="rounded-xl border bg-white p-8 text-center">
          <p className="font-medium text-gray-900">No webinars are scheduled for you right now.</p>
          <p className="mt-2 text-sm text-gray-600">
            When one is, it will appear here, and the Join button opens shortly before it starts.
          </p>
          <p className="mt-2 text-sm text-gray-600">
            Family members can request their own link, which will be sent by email to the head of family.
          </p>
          <p className="mt-2 text-sm text-gray-600">
            Expecting a webinar that is not listed? Please contact your webinar coordinator.
          </p>
        </div>
      )}

      <div className="space-y-3">
        {data?.map((w) => (
          <div key={w.id} className="rounded-xl border-l-4 border-indigo-500 bg-white p-4 shadow-sm flex flex-wrap items-center justify-between gap-3">
            <div>
              <div className="font-semibold text-gray-900">{w.title}</div>
              {w.hostName && <div className="text-sm text-gray-500">Host: {w.hostName}</div>}
              <div className="text-sm text-gray-700 mt-1">
                {fmtDateTime(w.scheduledStart)} – {fmtTime(w.scheduledEnd)}
              </div>
            </div>
            {w.joinOpen ? (
              <a
                href={`${API_BASE}/api/webinars/${w.id}/launch`}
                target="_blank"
                rel="noopener noreferrer"
                className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-5 py-2 text-sm font-semibold text-white"
              >
                Join
              </a>
            ) : (
              <span className="rounded-lg bg-gray-100 px-4 py-2 text-sm text-gray-500">Not open yet</span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
