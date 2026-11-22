import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { WebinarSummary, errMsg, fromLocalInput, toLocalInput } from '../../../lib/webinars';

type Form = {
  title: string; description: string; hostName: string; start: string; end: string;
  status: string; accessMode: string; joinUrl: string; before: string; after: string;
};

const EMPTY: Form = {
  title: '', description: '', hostName: '', start: '', end: '',
  status: 'DRAFT', accessMode: 'ASSIGNED', joinUrl: '', before: '10', after: '15',
};

export default function CreateWebinar() {
  const { id } = useParams();
  const isEdit = !!id;
  const navigate = useNavigate();
  const qc = useQueryClient();
  const [form, setForm] = useState<Form>(EMPTY);
  const [error, setError] = useState<string | null>(null);

  const { data: existing } = useQuery<WebinarSummary>({
    queryKey: ['webinar', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}`)).data,
    enabled: isEdit,
  });

  useEffect(() => {
    if (!existing) return;
    setForm({
      title: existing.title,
      description: existing.description ?? '',
      hostName: existing.hostName ?? '',
      start: toLocalInput(existing.scheduledStart),
      end: toLocalInput(existing.scheduledEnd),
      status: existing.status,
      accessMode: existing.accessMode,
      joinUrl: '', // write-only: the server never sends it back
      before: String(existing.joinWindowBeforeMin),
      after: String(existing.joinWindowAfterMin),
    });
  }, [existing]);

  const save = useMutation({
    mutationFn: async () => {
      const payload = {
        title: form.title,
        description: form.description || null,
        hostName: form.hostName || null,
        scheduledStart: form.start ? fromLocalInput(form.start) : null,
        scheduledEnd: form.end ? fromLocalInput(form.end) : null,
        status: form.status,
        accessMode: form.accessMode,
        joinUrl: form.joinUrl || null,
        joinWindowBeforeMin: Number(form.before),
        joinWindowAfterMin: Number(form.after),
      };
      return isEdit ? api.put(`/webinars/admin/${id}`, payload) : api.post('/webinars/admin', payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['webinars'] });
      qc.invalidateQueries({ queryKey: ['webinar', id] });
      navigate('/admin/webinars');
    },
    onError: (e) => setError(errMsg(e)),
  });

  const set = (key: keyof Form) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) =>
    setForm({ ...form, [key]: e.target.value });

  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-bold text-gray-900 mb-4">{isEdit ? 'Edit Webinar' : 'New Webinar'}</h1>
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <form
        className="space-y-4 rounded-xl border bg-white p-6"
        onSubmit={(e) => { e.preventDefault(); setError(null); save.mutate(); }}
      >
        <label className="block text-sm font-medium text-gray-700">Title
          <input className="input mt-1" value={form.title} onChange={set('title')} required maxLength={200} />
        </label>
        <label className="block text-sm font-medium text-gray-700">Host name
          <input className="input mt-1" value={form.hostName} onChange={set('hostName')} maxLength={200} />
        </label>
        <label className="block text-sm font-medium text-gray-700">Description
          <textarea className="input mt-1" rows={3} value={form.description} onChange={set('description')} maxLength={2000} />
        </label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Starts
            <input type="datetime-local" className="input mt-1" value={form.start} onChange={set('start')} required />
          </label>
          <label className="block text-sm font-medium text-gray-700">Ends
            <input type="datetime-local" className="input mt-1" value={form.end} onChange={set('end')} required />
          </label>
        </div>
        <label className="block text-sm font-medium text-gray-700">Zoom link
          <input
            className="input mt-1" value={form.joinUrl} onChange={set('joinUrl')} autoComplete="off"
            placeholder={isEdit && existing?.hasJoinUrl ? 'A link is saved. Leave blank to keep it.' : 'https://zoom.us/j/...'}
          />
          <span className="mt-1 block text-xs font-normal text-gray-500">
            Attendees never see this link. It is not shown again after saving.
          </span>
        </label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Who can join
            <select className="input mt-1" value={form.accessMode} onChange={set('accessMode')}>
              <option value="ASSIGNED">Only people given a seat</option>
              <option value="OPEN">Any active member (family members still need a seat)</option>
            </select>
          </label>
          <label className="block text-sm font-medium text-gray-700">Status
            <select className="input mt-1" value={form.status} onChange={set('status')}>
              <option value="DRAFT">Draft</option>
              <option value="PUBLISHED">Published</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </label>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Join opens (minutes before start)
            <input type="number" min={0} className="input mt-1" value={form.before} onChange={set('before')} />
          </label>
          <label className="block text-sm font-medium text-gray-700">Join closes (minutes after end)
            <input type="number" min={0} className="input mt-1" value={form.after} onChange={set('after')} />
          </label>
        </div>
        <div className="flex justify-end gap-2 pt-2">
          <button type="button" onClick={() => navigate('/admin/webinars')} className="rounded-lg bg-gray-500 px-4 py-2 text-sm text-white">Cancel</button>
          <button type="submit" disabled={save.isPending} className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50">
            {save.isPending ? 'Saving...' : 'Save'}
          </button>
        </div>
      </form>
    </div>
  );
}
