import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { WebinarSummary, errMsg, fmtDateTime } from '../../../lib/webinars';
import ZoomSyncModal from './ZoomSyncModal';

const STATUS_STYLE: Record<string, string> = {
  PUBLISHED: 'bg-green-100 text-green-800',
  DRAFT: 'bg-amber-100 text-amber-800',
  CANCELLED: 'bg-red-100 text-red-800',
};

export default function WebinarList() {
  const qc = useQueryClient();
  const [syncOpen, setSyncOpen] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [confirm, setConfirm] = useState<{ kind: 'invite' | 'delete'; webinar: WebinarSummary } | null>(null);

  const { data, isLoading } = useQuery<WebinarSummary[]>({
    queryKey: ['webinars'],
    queryFn: async () => (await api.get('/webinars/admin')).data,
  });

  const sendInvites = useMutation({
    mutationFn: async (id: number) => (await api.post(`/webinars/admin/${id}/send-invites`, {})).data,
    onSuccess: (r: { sent: number; skipped: string[] }) => {
      setNotice(`Invites sent to ${r.sent} ${r.sent === 1 ? 'family' : 'families'}.`
        + (r.skipped.length ? ` Skipped: ${r.skipped.join(', ')}.` : ''));
      setError(null);
    },
    onError: (e) => setError(errMsg(e)),
  });

  const remove = useMutation({
    mutationFn: async (id: number) => api.delete(`/webinars/admin/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['webinars'] }),
    onError: (e) => setError(errMsg(e)),
  });

  const runConfirmed = () => {
    if (!confirm) return;
    if (confirm.kind === 'invite') sendInvites.mutate(confirm.webinar.id);
    else remove.mutate(confirm.webinar.id);
    setConfirm(null);
  };

  return (
    <div>
      <div className="flex flex-wrap items-center justify-between gap-3 mb-4">
        <h1 className="text-2xl font-bold text-gray-900">Webinars</h1>
        <div className="flex gap-2">
          <button onClick={() => setSyncOpen(true)} className="rounded-lg border px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
            Sync from Zoom
          </button>
          <Link to="/admin/webinars/new" className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-sm font-semibold text-white">
            New Webinar
          </Link>
        </div>
      </div>

      {notice && <div className="mb-3 rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">{notice}</div>}
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <div className="overflow-x-auto rounded-xl border bg-white">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-50 text-left text-xs uppercase tracking-wide text-gray-500">
            <tr>
              <th className="px-4 py-3">Webinar</th>
              <th className="px-4 py-3">Starts</th>
              <th className="px-4 py-3">Access</th>
              <th className="px-4 py-3">Seats</th>
              <th className="px-4 py-3">Status</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {isLoading && <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-500">Loading...</td></tr>}
            {!isLoading && (data?.length ?? 0) === 0 && (
              <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-500">No webinars yet.</td></tr>
            )}
            {data?.map((w) => (
              <tr key={w.id}>
                <td className="px-4 py-3">
                  <div className="font-medium text-gray-900">{w.title}</div>
                  <div className="text-xs text-gray-500">
                    {w.hostName ?? ''}{w.managedByZoom ? ' · from Zoom' : ''}{!w.hasJoinUrl ? ' · no Zoom link' : ''}
                  </div>
                </td>
                <td className="px-4 py-3 whitespace-nowrap">{fmtDateTime(w.scheduledStart)}</td>
                <td className="px-4 py-3">{w.accessMode === 'OPEN' ? 'Open' : 'Assigned'}</td>
                <td className="px-4 py-3">{w.seatCount}</td>
                <td className="px-4 py-3">
                  <span className={`rounded-full px-2 py-1 text-xs font-medium ${STATUS_STYLE[w.status]}`}>
                    {w.status.charAt(0) + w.status.slice(1).toLowerCase()}
                  </span>
                </td>
                <td className="px-4 py-3 whitespace-nowrap space-x-3">
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/edit`}>Edit</Link>
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/attendees`}>Attendees</Link>
                  <button className="text-blue-700 hover:underline" onClick={() => setConfirm({ kind: 'invite', webinar: w })}>Send Invites</button>
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/report`}>Report</Link>
                  <button className="text-red-600 hover:underline" onClick={() => setConfirm({ kind: 'delete', webinar: w })}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {confirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-md rounded-xl bg-white p-6">
            <h2 className="text-lg font-semibold text-gray-900">
              {confirm.kind === 'invite' ? 'Send invites' : 'Delete webinar'}
            </h2>
            <p className="mt-2 text-sm text-gray-600">
              {confirm.kind === 'invite'
                ? `Each family with a seat on "${confirm.webinar.title}" will be emailed fresh links. Any links sent or copied earlier for this webinar will stop working.`
                : `Delete "${confirm.webinar.title}" with its seats, links and attendance records? This cannot be undone.`}
            </p>
            <div className="mt-5 flex justify-end gap-2">
              <button onClick={() => setConfirm(null)} className="rounded-lg bg-gray-500 px-4 py-2 text-sm text-white">Cancel</button>
              <button onClick={runConfirmed} className={`rounded-lg px-4 py-2 text-sm font-semibold text-white ${confirm.kind === 'delete' ? 'bg-red-600' : 'bg-blue-600'}`}>
                {confirm.kind === 'invite' ? 'Send' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}

      {syncOpen && <ZoomSyncModal onClose={() => setSyncOpen(false)} />}
    </div>
  );
}
