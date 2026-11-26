import { useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { FamilyMember, Hof, errMsg } from '../../../lib/webinars';
import { BanIcon, CheckCircleIcon, EditIcon, iconAction } from '../../../components/ActionIcons';

type Form = { id: number | null; firstName: string; lastName: string; itsNumber: string };
const EMPTY: Form = { id: null, firstName: '', lastName: '', itsNumber: '' };

export default function FamilyMembers() {
  const qc = useQueryClient();
  const [params] = useSearchParams();
  const [search, setSearch] = useState(params.get('search') ?? '');
  const [hof, setHof] = useState<Hof | null>(null);
  const [form, setForm] = useState<Form>(EMPTY);
  const [error, setError] = useState<string | null>(null);

  const term = search.trim();
  const { data: hofs } = useQuery<Hof[]>({
    queryKey: ['family-hofs', term],
    queryFn: async () => (await api.get(`/admin/family-members/hofs?search=${encodeURIComponent(term)}`)).data,
    enabled: term.length >= 2,
  });
  const { data: members } = useQuery<FamilyMember[]>({
    queryKey: ['family-members', hof?.id],
    queryFn: async () => (await api.get(`/admin/family-members?hofPersonId=${hof!.id}`)).data,
    enabled: !!hof,
  });

  const done = () => {
    setError(null);
    setForm(EMPTY);
    qc.invalidateQueries({ queryKey: ['family-members', hof?.id] });
    qc.invalidateQueries({ queryKey: ['family-hofs'] });
  };
  const save = useMutation({
    mutationFn: async () => {
      const body = { hofPersonId: hof!.id, firstName: form.firstName, lastName: form.lastName, itsNumber: form.itsNumber };
      return form.id === null ? api.post('/admin/family-members', body) : api.put(`/admin/family-members/${form.id}`, body);
    },
    onSuccess: done,
    onError: (e) => setError(errMsg(e)),
  });
  const setActive = useMutation({
    mutationFn: async (v: { id: number; active: boolean }) => api.put(`/admin/family-members/${v.id}/active`, { active: v.active }),
    onSuccess: done,
    onError: (e) => setError(errMsg(e)),
  });

  const valid = form.firstName.trim() && form.lastName.trim() && /^\d{8}$/.test(form.itsNumber);

  return (
    <div className="max-w-3xl">
      <h1 className="text-2xl font-bold text-gray-900 mb-1">Family Members</h1>
      <p className="text-sm text-gray-500 mb-4">
        Family members saved under a head of family can be given their own webinar seats. They are not users and cannot log in.
      </p>
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <div className="rounded-xl border bg-white p-4 mb-4">
        <label className="block text-sm font-medium text-gray-700">Find a head of family
          <input className="input mt-1" placeholder="Name or ITS (at least 2 characters)" value={search} onChange={(e) => setSearch(e.target.value)} />
        </label>
        {term.length >= 2 && (
          <ul className="mt-2 divide-y">
            {(hofs?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No heads of family match.</li>}
            {hofs?.map((h) => (
              <li key={h.id} className="flex items-center justify-between py-2 text-sm">
                <span><span className="font-medium text-gray-900">{h.firstName} {h.lastName}</span> <span className="text-gray-500">({h.itsNumber}) · {h.familyMemberCount} saved</span></span>
                <button className="text-blue-700 hover:underline" onClick={() => { setHof(h); setForm(EMPTY); setError(null); }}>Select</button>
              </li>
            ))}
          </ul>
        )}
      </div>

      {hof && (
        <div className="rounded-xl border bg-white p-4">
          <h2 className="font-semibold text-gray-900 mb-3">Family of {hof.firstName} {hof.lastName} ({hof.itsNumber})</h2>
          <ul className="divide-y mb-4">
            {(members?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No family members saved yet.</li>}
            {members?.map((m) => (
              <li key={m.id} className="flex flex-wrap items-center justify-between gap-2 py-2 text-sm">
                <span className={m.active ? '' : 'text-gray-400 line-through'}>{m.firstName} {m.lastName} ({m.itsNumber})</span>
                <span className="inline-flex items-center gap-1">
                  <button type="button" className={iconAction()} title={`Edit ${m.firstName} ${m.lastName}`} aria-label={`Edit ${m.firstName} ${m.lastName}`}
                    onClick={() => setForm({ id: m.id, firstName: m.firstName, lastName: m.lastName, itsNumber: m.itsNumber })}>
                    <EditIcon />
                  </button>
                  <button type="button" className={iconAction(m.active ? 'red' : 'green')}
                    title={`${m.active ? 'Deactivate' : 'Reactivate'} ${m.firstName} ${m.lastName}`}
                    aria-label={`${m.active ? 'Deactivate' : 'Reactivate'} ${m.firstName} ${m.lastName}`}
                    onClick={() => setActive.mutate({ id: m.id, active: !m.active })}>
                    {m.active ? <BanIcon /> : <CheckCircleIcon />}
                  </button>
                </span>
              </li>
            ))}
          </ul>
          <div className="grid grid-cols-1 sm:grid-cols-4 gap-2 items-end">
            <input className="input" placeholder="First name" value={form.firstName} onChange={(e) => setForm({ ...form, firstName: e.target.value })} />
            <input className="input" placeholder="Last name" value={form.lastName} onChange={(e) => setForm({ ...form, lastName: e.target.value })} />
            <input className="input" placeholder="ITS (8 digits)" inputMode="numeric" maxLength={8} value={form.itsNumber}
              onChange={(e) => setForm({ ...form, itsNumber: e.target.value.replace(/\D/g, '') })} />
            <div className="flex gap-2">
              <button disabled={!valid || save.isPending} onClick={() => save.mutate()} className="rounded-lg bg-blue-600 px-3 py-2 text-sm font-semibold text-white disabled:opacity-50">
                {form.id === null ? 'Add' : 'Save'}
              </button>
              {form.id !== null && <button onClick={() => setForm(EMPTY)} className="rounded-lg bg-gray-500 px-3 py-2 text-sm text-white">Cancel</button>}
            </div>
          </div>
          <p className="mt-2 text-xs text-gray-500">Deactivating keeps past attendance records and cancels any live join links.</p>
        </div>
      )}
    </div>
  );
}
