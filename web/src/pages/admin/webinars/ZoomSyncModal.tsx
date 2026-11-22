import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { ZoomSyncRow, errMsg, fmtDateTime } from '../../../lib/webinars';

export default function ZoomSyncModal({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const [kind, setKind] = useState<'meetings' | 'webinars'>('meetings');
  const [accessMode, setAccessMode] = useState('ASSIGNED');
  const [error, setError] = useState<string | null>(null);

  const { data, isLoading, error: loadError } = useQuery<ZoomSyncRow[]>({
    queryKey: ['zoom-preview', kind],
    queryFn: async () => (await api.get(`/webinars/admin/zoom/preview?kind=${kind}`)).data,
    retry: false,
  });

  const importOne = useMutation({
    mutationFn: async (row: ZoomSyncRow) =>
      api.post('/webinars/admin/zoom/import', { kind, zoomMeetingId: row.zoomMeetingId, start: row.start, accessMode }),
    onSuccess: () => {
      setError(null);
      qc.invalidateQueries({ queryKey: ['zoom-preview', kind] });
      qc.invalidateQueries({ queryKey: ['webinars'] });
    },
    onError: (e) => setError(errMsg(e)),
  });

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
      <div className="w-full max-w-2xl rounded-xl bg-white p-6 max-h-[85vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Sync from Zoom</h2>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-800">Close</button>
        </div>

        <div className="flex flex-wrap items-center gap-3 mb-4">
          <div className="inline-flex rounded-lg border overflow-hidden text-sm">
            {(['meetings', 'webinars'] as const).map((k) => (
              <button key={k} onClick={() => setKind(k)} className={`px-3 py-1.5 ${kind === k ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}>
                {k === 'meetings' ? 'Meetings' : 'Webinars'}
              </button>
            ))}
          </div>
          <label className="text-sm text-gray-700">Import as
            <select className="ml-2 rounded-lg border p-1.5" value={accessMode} onChange={(e) => setAccessMode(e.target.value)}>
              <option value="ASSIGNED">Assigned</option>
              <option value="OPEN">Open</option>
            </select>
          </label>
        </div>

        {(error || loadError) && (
          <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
            {error ?? errMsg(loadError)}
          </div>
        )}
        {isLoading && <div className="text-gray-500">Loading from Zoom...</div>}
        {!isLoading && !loadError && (data?.length ?? 0) === 0 && (
          <div className="text-gray-500">Nothing scheduled on Zoom.</div>
        )}

        <ul className="divide-y">
          {data?.map((row) => (
            <li key={`${row.zoomMeetingId}-${row.start}`} className="flex items-center justify-between gap-3 py-3">
              <div>
                <div className="font-medium text-gray-900">{row.topic}</div>
                <div className="text-sm text-gray-500">{fmtDateTime(row.start)}</div>
              </div>
              <button
                onClick={() => importOne.mutate(row)}
                disabled={importOne.isPending}
                className="rounded-lg border px-3 py-1.5 text-sm font-medium text-blue-700 hover:bg-blue-50 disabled:opacity-50"
              >
                {row.alreadyImported ? 'Update from Zoom' : 'Import'}
              </button>
            </li>
          ))}
        </ul>
        <p className="mt-4 text-xs text-gray-500">Imported sessions start as drafts. Publish them when ready.</p>
      </div>
    </div>
  );
}
