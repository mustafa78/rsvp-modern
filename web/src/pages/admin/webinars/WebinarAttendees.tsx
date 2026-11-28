import { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { AssignableRow, FamilySeats, WebinarSummary, errMsg, fmtDateTime } from '../../../lib/webinars';
import { copyText, copyTextWhenReady } from '../../../lib/clipboard';
import { CopyIcon, SpinnerIcon, TrashIcon, iconAction } from '../../../components/ActionIcons';

type NewMember = { firstName: string; lastName: string; itsNumber: string };
const EMPTY_MEMBER: NewMember = { firstName: '', lastName: '', itsNumber: '' };

export default function WebinarAttendees() {
  const { id } = useParams();
  const qc = useQueryClient();
  const [search, setSearch] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [link, setLink] = useState<{ seatId: number; name: string; url: string } | null>(null);
  const [linkCopied, setLinkCopied] = useState(false);
  const [makingLinkFor, setMakingLinkFor] = useState<number | null>(null);
  const [removing, setRemoving] = useState<{ seatId: number; name: string } | null>(null);
  const [addingFor, setAddingFor] = useState<number | null>(null);
  const [newMember, setNewMember] = useState<NewMember>(EMPTY_MEMBER);
  const [copyFrom, setCopyFrom] = useState('');

  const { data: webinar } = useQuery<WebinarSummary>({
    queryKey: ['webinar', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}`)).data,
  });
  const { data: seats, isLoading } = useQuery<FamilySeats[]>({
    queryKey: ['webinar-seats', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/seats`)).data,
  });
  const { data: others } = useQuery<WebinarSummary[]>({
    queryKey: ['webinars'],
    queryFn: async () => (await api.get('/webinars/admin')).data,
  });
  const term = search.trim();
  const { data: results } = useQuery<AssignableRow[]>({
    queryKey: ['webinar-assignable', id, term],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/assignable?search=${encodeURIComponent(term)}`)).data,
    enabled: term.length >= 2,
  });

  const refresh = () => {
    qc.invalidateQueries({ queryKey: ['webinar-seats', id] });
    qc.invalidateQueries({ queryKey: ['webinar-assignable', id] });
    qc.invalidateQueries({ queryKey: ['webinars'] });
  };
  const fail = (e: unknown) => { setError(errMsg(e)); setNotice(null); };
  const ok = (message?: string) => { setError(null); setNotice(message ?? null); refresh(); };

  const giveSeat = useMutation({
    mutationFn: async (v: { personId: number; familyMemberId: number | null }) => api.post(`/webinars/admin/${id}/seats`, v),
    onSuccess: () => ok(),
    onError: fail,
  });
  const removeSeat = useMutation({
    mutationFn: async (seatId: number) => api.delete(`/webinars/admin/${id}/seats/${seatId}`),
    onSuccess: (_r, seatId) => {
      // The removed seat's link no longer works; do not keep showing it.
      setLink((current) => (current?.seatId === seatId ? null : current));
      ok();
    },
    onError: fail,
  });
  const addMember = useMutation({
    mutationFn: async (hofPersonId: number) =>
      api.post('/admin/family-members', { hofPersonId, ...newMember, webinarId: Number(id) }),
    onSuccess: () => { setAddingFor(null); setNewMember(EMPTY_MEMBER); ok('Family member added and given a seat.'); },
    onError: fail,
  });
  const copySeats = useMutation({
    mutationFn: async () => (await api.post(`/webinars/admin/${id}/seats/copy-from/${copyFrom}`, {})).data,
    onSuccess: (r: { added: number; skipped: number }) =>
      ok(`Copied ${r.added} seat${r.added === 1 ? '' : 's'}.` + (r.skipped ? ` Skipped ${r.skipped} (already seated or no longer eligible).` : '')),
    onError: fail,
  });
  // Issues a new join link for the seat (which cancels that person's previous link) and copies it.
  // The copy is started inside the click, before the request finishes, so browsers allow it.
  const copyNewLink = async (seatId: number, name: string) => {
    if (makingLinkFor !== null) return;
    setMakingLinkFor(seatId);
    const url: Promise<string> = api.post(`/webinars/admin/${id}/seats/${seatId}/link`, {}).then((r) => r.data.link);
    const copiedInClick = copyTextWhenReady(url);
    try {
      const newUrl = await url;
      const copied = (await copiedInClick) || (await copyText(newUrl));
      setError(null);
      setLink({ seatId, name, url: newUrl });
      setLinkCopied(copied);
      setNotice(copied
        ? `New link for ${name} copied. Any link sent to them earlier no longer works.`
        : `New link for ${name} is ready below. Press Copy to copy it.`);
    } catch (e) {
      fail(e);
    } finally {
      setMakingLinkFor(null);
    }
  };
  // Copies the link already shown. Does not issue a new one.
  const copyShownLink = async () => {
    if (!link) return;
    setLinkCopied(await copyText(link.url));
  };

  const seatButtons = (seatId: number, name: string) => (
    <span className="inline-flex items-center gap-1 whitespace-nowrap">
      <span className="mr-2 rounded-full bg-green-100 px-2 py-0.5 text-xs font-medium text-green-800">Seat</span>
      <button type="button" title={`Copy a new join link for ${name}`} aria-label={`Copy a new join link for ${name}`}
        className={iconAction()} disabled={makingLinkFor !== null} onClick={() => copyNewLink(seatId, name)}>
        {makingLinkFor === seatId ? <SpinnerIcon /> : <CopyIcon />}
      </button>
      <button type="button" title={`Remove ${name}'s seat`} aria-label={`Remove ${name}'s seat`}
        className={iconAction('red')} onClick={() => setRemoving({ seatId, name })}>
        <TrashIcon />
      </button>
    </span>
  );

  return (
    <div className="max-w-4xl">
      <Link to="/admin/webinars" className="text-sm text-blue-700 hover:underline">← All meetings</Link>
      <h1 className="text-2xl font-bold text-gray-900 mt-1">Attendees</h1>
      {webinar && (
        <p className="text-sm text-gray-600 mb-4">
          {webinar.title} · {fmtDateTime(webinar.scheduledStart)} · {webinar.accessMode === 'OPEN' ? 'Open' : 'Assigned'}
        </p>
      )}

      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}
      {notice && <div className="mb-3 rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">{notice}</div>}
      {link && (
        <div className="mb-3 rounded-lg border bg-white px-4 py-3 text-sm">
          <div className="text-gray-700 mb-1">Link for {link.name}. Copying a new link cancels this person's previous one.</div>
          <div className="flex gap-2">
            <input readOnly className="input font-mono text-xs flex-1" value={link.url} onFocus={(e) => e.target.select()}
              aria-label={`Join link for ${link.name}`} />
            <button className="rounded-lg border px-3 text-sm font-medium text-blue-700 hover:bg-blue-50 whitespace-nowrap"
              onClick={copyShownLink}>{linkCopied ? 'Copied' : 'Copy'}</button>
          </div>
        </div>
      )}

      <div className="rounded-xl border bg-white p-4 mb-4">
        <label className="block text-sm font-medium text-gray-700">Find a member or family member
          <input className="input mt-1" placeholder="Name or ITS (at least 2 characters)" value={search} onChange={(e) => setSearch(e.target.value)} />
        </label>
        {term.length >= 2 && (
          <ul className="mt-2 divide-y">
            {(results?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No matches.</li>}
            {results?.map((r) => (
              <li key={`${r.personId}-${r.familyMemberId ?? 'own'}`} className="flex flex-wrap items-center justify-between gap-2 py-2 text-sm">
                <span>
                  <span className="font-medium text-gray-900">{r.name}</span> <span className="text-gray-500">({r.itsNumber})</span>
                  {r.hofName && <span className="text-gray-500"> · family of {r.hofName}</span>}
                </span>
                <span className="space-x-3">
                  {r.hasSeat
                    ? <span className="text-gray-400">Has a seat</span>
                    : <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: r.personId, familyMemberId: r.familyMemberId })}>Give seat</button>}
                  {r.familyMemberId === null && r.hof && (
                    <button className="text-blue-700 hover:underline" onClick={() => { setAddingFor(r.personId); setNewMember(EMPTY_MEMBER); }}>Add family member</button>
                  )}
                </span>
              </li>
            ))}
          </ul>
        )}
        {addingFor !== null && !seats?.some((f) => f.personId === addingFor) && (
          <AddMemberForm value={newMember} onChange={setNewMember} pending={addMember.isPending}
            onCancel={() => setAddingFor(null)} onSave={() => addMember.mutate(addingFor)} />
        )}
      </div>

      <div className="rounded-xl border bg-white p-4 mb-4 flex flex-wrap items-end gap-3">
        <label className="text-sm font-medium text-gray-700">Copy seats from a previous meeting
          <select className="input mt-1" value={copyFrom} onChange={(e) => setCopyFrom(e.target.value)}>
            <option value="">Choose a meeting</option>
            {others?.filter((o) => String(o.id) !== id).map((o) => (
              <option key={o.id} value={o.id}>{o.title} · {fmtDateTime(o.scheduledStart)} · {o.seatCount} seats</option>
            ))}
          </select>
        </label>
        <button disabled={!copyFrom || copySeats.isPending} onClick={() => copySeats.mutate()} className="rounded-lg border px-4 py-2 text-sm font-medium text-blue-700 hover:bg-blue-50 disabled:opacity-50">
          Copy seats
        </button>
      </div>

      <div className="rounded-xl border bg-white">
        {isLoading && <div className="p-4 text-gray-500">Loading...</div>}
        {!isLoading && (seats?.length ?? 0) === 0 && <div className="p-4 text-gray-500">No one has a seat yet.</div>}
        <ul className="divide-y">
          {seats?.map((f) => (
            <li key={f.personId} className="p-4 text-sm">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span><span className="font-semibold text-gray-900">{f.name}</span> <span className="text-gray-500">({f.itsNumber})</span></span>
                {f.ownSeatId !== null
                  ? seatButtons(f.ownSeatId, f.name)
                  : <span className="space-x-3"><span className="text-gray-400">No seat</span>
                      <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: f.personId, familyMemberId: null })}>Give seat</button></span>}
              </div>
              <ul className="mt-2 ml-4 space-y-2 border-l pl-4">
                {f.family.map((m) => (
                  <li key={m.familyMemberId} className="flex flex-wrap items-center justify-between gap-2">
                    <span>{m.name} <span className="text-gray-500">({m.itsNumber})</span></span>
                    {m.seatId !== null
                      ? seatButtons(m.seatId, m.name)
                      : <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: f.personId, familyMemberId: m.familyMemberId })}>Give seat</button>}
                  </li>
                ))}
                {f.hof && addingFor !== f.personId && (
                  <li><button className="text-blue-700 hover:underline" onClick={() => { setAddingFor(f.personId); setNewMember(EMPTY_MEMBER); }}>+ Add family member</button></li>
                )}
                {addingFor === f.personId && (
                  <li><AddMemberForm value={newMember} onChange={setNewMember} pending={addMember.isPending}
                    onCancel={() => setAddingFor(null)} onSave={() => addMember.mutate(f.personId)} /></li>
                )}
              </ul>
            </li>
          ))}
        </ul>
      </div>
      {removing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4" role="dialog" aria-modal="true" aria-labelledby="remove-seat-title">
          <div className="w-full max-w-md rounded-xl bg-white p-6">
            <h2 id="remove-seat-title" className="text-lg font-semibold text-gray-900">Remove seat</h2>
            <p className="mt-2 text-sm text-gray-600">
              Remove {removing.name}'s seat for this webinar? Their join link will stop working. You can give them a seat again later, but they will need a new link.
            </p>
            <div className="mt-5 flex justify-end gap-2">
              <button onClick={() => setRemoving(null)} className="rounded-lg bg-gray-500 px-4 py-2 text-sm text-white">Cancel</button>
              <button onClick={() => { removeSeat.mutate(removing.seatId); setRemoving(null); }}
                className="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white">Remove seat</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function AddMemberForm(props: {
  value: NewMember; onChange: (v: NewMember) => void; onSave: () => void; onCancel: () => void; pending: boolean;
}) {
  const { value, onChange } = props;
  const valid = value.firstName.trim() && value.lastName.trim() && /^\d{8}$/.test(value.itsNumber);
  return (
    <div className="mt-2 grid grid-cols-1 sm:grid-cols-4 gap-2 items-end">
      <input className="input" placeholder="First name" value={value.firstName} onChange={(e) => onChange({ ...value, firstName: e.target.value })} />
      <input className="input" placeholder="Last name" value={value.lastName} onChange={(e) => onChange({ ...value, lastName: e.target.value })} />
      <input className="input" placeholder="ITS (8 digits)" inputMode="numeric" maxLength={8} value={value.itsNumber}
        onChange={(e) => onChange({ ...value, itsNumber: e.target.value.replace(/\D/g, '') })} />
      <div className="flex gap-2">
        <button disabled={!valid || props.pending} onClick={props.onSave} className="rounded-lg bg-blue-600 px-3 py-2 text-sm font-semibold text-white disabled:opacity-50">Save and seat</button>
        <button onClick={props.onCancel} className="rounded-lg bg-gray-500 px-3 py-2 text-sm text-white">Cancel</button>
      </div>
    </div>
  );
}
