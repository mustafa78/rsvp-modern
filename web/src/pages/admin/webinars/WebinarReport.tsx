import { useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import * as XLSX from 'xlsx';
import { api } from '../../../api/client';
import { AttendanceReport, AttendeeRow, fmtDateTime } from '../../../lib/webinars';

type Filter = 'all' | 'joined' | 'absent';
type Sort = 'family' | 'name';

export default function WebinarReport() {
  const { id } = useParams();
  const [filter, setFilter] = useState<Filter>('all');
  const [sort, setSort] = useState<Sort>('family');

  const { data, isLoading } = useQuery<AttendanceReport>({
    queryKey: ['webinar-report', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/report`)).data,
  });

  // The server returns rows grouped by family. "name" re-sorts by attendee name.
  const rows = useMemo(() => {
    const all = (data?.rows ?? []).filter((r) => filter === 'all' || (filter === 'joined') === r.joined);
    return sort === 'name' ? [...all].sort((a, b) => a.name.localeCompare(b.name)) : all;
  }, [data, filter, sort]);

  const hofText = (r: AttendeeRow) => (r.hofName ? `${r.hofName} (${r.hofIts})` : '');
  const joinedText = (r: AttendeeRow) => (r.firstJoinedAt ? fmtDateTime(r.firstJoinedAt) : '');
  const fileBase = `webinar-attendance-${(data?.webinar.title ?? 'report').replace(/[^a-z0-9]+/gi, '-').toLowerCase()}`;

  const exportExcel = () => {
    if (!data) return;
    const sheet = XLSX.utils.json_to_sheet(rows.map((r) => ({
      ITS: r.itsNumber, Name: r.name, Type: r.type, 'Head of family': hofText(r),
      Joined: r.joined ? 'Yes' : 'No', 'First joined': joinedText(r), Launches: r.launchCount,
    })));
    const book = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(book, sheet, 'Attendance');
    XLSX.writeFile(book, `${fileBase}.xlsx`);
  };

  const exportPdf = () => {
    if (!data) return;
    const doc = new jsPDF();
    doc.setFontSize(14);
    doc.text(data.webinar.title, 14, 16);
    doc.setFontSize(10);
    doc.text(fmtDateTime(data.webinar.scheduledStart), 14, 23);
    doc.text(`Seats: ${data.seatCount}   Joined: ${data.joinedCount}   Not joined: ${data.seatCount - data.joinedCount}`, 14, 29);
    autoTable(doc, {
      startY: 35,
      head: [['ITS', 'Name', 'Type', 'Head of family', 'Joined', 'First joined', 'Launches']],
      body: rows.map((r) => [r.itsNumber, r.name, r.type, hofText(r), r.joined ? 'Yes' : 'No', joinedText(r), String(r.launchCount)]),
      styles: { fontSize: 8 },
      headStyles: { fillColor: [79, 70, 229] },
      alternateRowStyles: { fillColor: [245, 245, 250] },
    });
    doc.save(`${fileBase}.pdf`);
  };

  if (isLoading) return <div className="text-gray-500">Loading...</div>;
  if (!data) return <div className="text-gray-500">Report not available.</div>;

  const pill = (active: boolean) => `px-3 py-1.5 text-sm ${active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`;

  return (
    <div>
      <Link to="/admin/webinars" className="text-sm text-blue-700 hover:underline">← All webinars</Link>
      <div className="flex flex-wrap items-center justify-between gap-3 mt-1 mb-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Attendance</h1>
          <p className="text-sm text-gray-600">{data.webinar.title} · {fmtDateTime(data.webinar.scheduledStart)}</p>
        </div>
        <div className="flex gap-2">
          <button onClick={exportExcel} className="rounded-lg border px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Export to Excel</button>
          <button onClick={exportPdf} className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white">Export to PDF</button>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-3 mb-4">
        {[['Seats', data.seatCount], ['Joined', data.joinedCount], ['Not joined', data.seatCount - data.joinedCount]].map(([label, value]) => (
          <div key={label} className="rounded-xl border bg-white p-4">
            <div className="text-xs uppercase tracking-wide text-gray-500">{label}</div>
            <div className="text-2xl font-bold text-gray-900">{value}</div>
          </div>
        ))}
      </div>

      <div className="flex flex-wrap gap-3 mb-3">
        <div className="inline-flex rounded-lg border overflow-hidden">
          <button className={pill(filter === 'all')} onClick={() => setFilter('all')}>All</button>
          <button className={pill(filter === 'joined')} onClick={() => setFilter('joined')}>Joined</button>
          <button className={pill(filter === 'absent')} onClick={() => setFilter('absent')}>Not joined</button>
        </div>
        <div className="inline-flex rounded-lg border overflow-hidden">
          <button className={pill(sort === 'family')} onClick={() => setSort('family')}>By family</button>
          <button className={pill(sort === 'name')} onClick={() => setSort('name')}>By name</button>
        </div>
      </div>

      <div className="overflow-x-auto rounded-xl border bg-white">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-50 text-left text-xs uppercase tracking-wide text-gray-500">
            <tr>
              <th className="px-4 py-3">ITS</th><th className="px-4 py-3">Name</th><th className="px-4 py-3">Type</th>
              <th className="px-4 py-3">Head of family</th><th className="px-4 py-3">Joined</th>
              <th className="px-4 py-3">First joined</th><th className="px-4 py-3">Launches</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {rows.length === 0 && <tr><td colSpan={7} className="px-4 py-6 text-center text-gray-500">No attendees match.</td></tr>}
            {rows.map((r) => (
              <tr key={`${r.itsNumber}-${r.type}`}>
                <td className="px-4 py-2 font-mono">{r.itsNumber}</td>
                <td className="px-4 py-2 font-medium text-gray-900">{r.name}</td>
                <td className="px-4 py-2">{r.type}</td>
                <td className="px-4 py-2 text-gray-600">{hofText(r)}</td>
                <td className="px-4 py-2">{r.joined ? <span className="text-green-700 font-semibold">Yes</span> : <span className="text-gray-400">No</span>}</td>
                <td className="px-4 py-2 whitespace-nowrap">{joinedText(r)}</td>
                <td className="px-4 py-2">{r.launchCount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <p className="mt-3 text-xs text-gray-500">
        "Joined" means the attendee opened Zoom through their own link or the portal. It does not show how long they stayed.
      </p>
    </div>
  );
}
