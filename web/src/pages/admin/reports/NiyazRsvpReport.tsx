import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

type RsvpDetail = {
  rsvpId: number;
  personId: number;
  personName: string;
  personPhone: string | null;
  adults: number;
  kids: number;
};

type PersonBasic = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  phone: string | null;
};

type RsvpFormData = {
  personId: number | null;
  adults: number;
  kids: number;
};

// Check if event date is in the past
function isEventPast(eventDate: string): boolean {
  const [year, month, day] = eventDate.split('-').map(Number);
  const eventDateObj = new Date(year, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return eventDateObj < today;
}

export default function NiyazRsvpReport() {
  const { eventId } = useParams<{ eventId: string }>();
  const queryClient = useQueryClient();

  // Modal state
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [selectedRsvp, setSelectedRsvp] = useState<RsvpDetail | null>(null);
  const [formData, setFormData] = useState<RsvpFormData>({
    personId: null,
    adults: 1,
    kids: 0,
  });
  const [formError, setFormError] = useState<string | null>(null);

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

  // Additional queries for admin RSVP management
  const { data: usersWithoutRsvps } = useQuery<PersonBasic[]>({
    queryKey: ['niyaz-users-without-rsvps', eventId],
    queryFn: async () => (await api.get(`/niyaz/${eventId}/rsvp/users-without-rsvps`)).data,
    enabled: !!eventId && showAddModal,
  });

  // Mutations for admin RSVP management
  const createRsvpMutation = useMutation({
    mutationFn: async (data: { personId: number; adults: number; kids: number }) =>
      api.post(`/niyaz/${eventId}/rsvp/admin`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['niyaz-rsvps', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-adults', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-kids', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-users-without-rsvps', eventId] });
      setShowAddModal(false);
      resetForm();
    },
    onError: (err: any) => setFormError(err.message),
  });

  const updateRsvpMutation = useMutation({
    mutationFn: async ({ rsvpId, data }: { rsvpId: number; data: { personId: number; adults: number; kids: number } }) =>
      api.put(`/niyaz/${eventId}/rsvp/admin/${rsvpId}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['niyaz-rsvps', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-adults', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-kids', eventId] });
      setShowEditModal(false);
      resetForm();
    },
    onError: (err: any) => setFormError(err.message),
  });

  const deleteRsvpMutation = useMutation({
    mutationFn: async (rsvpId: number) => api.delete(`/niyaz/${eventId}/rsvp/admin/${rsvpId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['niyaz-rsvps', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-adults', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-kids', eventId] });
      queryClient.invalidateQueries({ queryKey: ['niyaz-users-without-rsvps', eventId] });
      setShowDeleteModal(false);
      setSelectedRsvp(null);
    },
    onError: (err: any) => setFormError(err.message),
  });

  // Form helpers
  const resetForm = () => {
    setFormData({ personId: null, adults: 1, kids: 0 });
    setFormError(null);
    setSelectedRsvp(null);
  };

  const openAddModal = () => {
    resetForm();
    setShowAddModal(true);
  };

  const openEditModal = (rsvp: RsvpDetail) => {
    setSelectedRsvp(rsvp);
    setFormData({
      personId: rsvp.personId,
      adults: rsvp.adults,
      kids: rsvp.kids,
    });
    setFormError(null);
    setShowEditModal(true);
  };

  const openDeleteModal = (rsvp: RsvpDetail) => {
    setSelectedRsvp(rsvp);
    setShowDeleteModal(true);
  };

  const handleSubmitAdd = () => {
    if (!formData.personId) {
      setFormError('Please select a person.');
      return;
    }
    if (formData.adults < 0 || formData.kids < 0) {
      setFormError('Adults and children must be non-negative.');
      return;
    }
    if (formData.adults === 0 && formData.kids === 0) {
      setFormError('Please enter at least 1 adult or child.');
      return;
    }
    createRsvpMutation.mutate({
      personId: formData.personId,
      adults: formData.adults,
      kids: formData.kids,
    });
  };

  const handleSubmitEdit = () => {
    if (!selectedRsvp) return;
    if (formData.adults < 0 || formData.kids < 0) {
      setFormError('Adults and children must be non-negative.');
      return;
    }
    if (formData.adults === 0 && formData.kids === 0) {
      setFormError('Please enter at least 1 adult or child.');
      return;
    }
    updateRsvpMutation.mutate({
      rsvpId: selectedRsvp.rsvpId,
      data: {
        personId: selectedRsvp.personId,
        adults: formData.adults,
        kids: formData.kids,
      },
    });
  };

  const handleConfirmDelete = () => {
    if (selectedRsvp) {
      deleteRsvpMutation.mutate(selectedRsvp.rsvpId);
    }
  };

  // Export to PDF
  const exportToPDF = () => {
    const doc = new jsPDF();
    const date = new Date().toLocaleDateString();
    let yPos = 20;

    const totalAttendees = (adults || 0) + (kids || 0);
    const equivalentServings = (adults || 0) + (kids || 0) * 0.5;
    const numberOfThaal = equivalentServings / 10;

    // Title
    doc.setFontSize(20);
    doc.setFont('helvetica', 'bold');
    doc.text('Niyaz RSVP Report', 14, yPos);
    yPos += 10;

    // Event info
    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(100);
    doc.text(`${event?.title} - ${event?.eventDate}`, 14, yPos);
    yPos += 6;
    doc.text(`Generated: ${date}`, 14, yPos);
    yPos += 12;

    // Attendance Summary section
    doc.setFillColor(147, 51, 234); // purple-600
    doc.rect(14, yPos - 5, 182, 8, 'F');
    doc.setFontSize(12);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(255);
    doc.text('Attendance Summary', 16, yPos);
    yPos += 10;

    const summaryData = [
      ['Adults', String(adults || 0)],
      ['Children', String(kids || 0)],
      ['Total Attendees', String(totalAttendees)],
      ['Total RSVPs (Families)', String(rsvps?.length || 0)],
    ];

    autoTable(doc, {
      startY: yPos,
      head: [['Category', 'Count']],
      body: summaryData,
      theme: 'striped',
      headStyles: {
        fillColor: [243, 244, 246],
        textColor: [75, 85, 99],
        fontStyle: 'bold',
        fontSize: 10,
      },
      bodyStyles: {
        fontSize: 10,
        textColor: [31, 41, 55],
      },
      columnStyles: {
        0: { cellWidth: 100 },
        1: { cellWidth: 50, halign: 'right', fontStyle: 'bold' },
      },
      margin: { left: 14, right: 14 },
    });

    yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 15;

    // Planning Notes section
    doc.setFillColor(234, 179, 8); // yellow-500
    doc.rect(14, yPos - 5, 182, 8, 'F');
    doc.setFontSize(12);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(0);
    doc.text('Planning Notes', 16, yPos);
    yPos += 10;

    const planningData = [
      ['Expected adult servings', String(adults || 0)],
      ['Expected child servings (½ portion)', String(kids || 0)],
      ['Equivalent full servings', equivalentServings.toFixed(1)],
      ['Number of Thaals (10 persons/thaal)', numberOfThaal.toFixed(1)],
    ];

    autoTable(doc, {
      startY: yPos,
      head: [['Item', 'Value']],
      body: planningData,
      theme: 'striped',
      headStyles: {
        fillColor: [254, 249, 195], // yellow-100
        textColor: [75, 85, 99],
        fontStyle: 'bold',
        fontSize: 10,
      },
      bodyStyles: {
        fontSize: 10,
        textColor: [31, 41, 55],
      },
      columnStyles: {
        0: { cellWidth: 120 },
        1: { cellWidth: 50, halign: 'right', fontStyle: 'bold' },
      },
      margin: { left: 14, right: 14 },
    });

    yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 15;

    // RSVP List section
    if (rsvps && rsvps.length > 0) {
      doc.setFillColor(147, 51, 234); // purple-600
      doc.rect(14, yPos - 5, 182, 8, 'F');
      doc.setFontSize(12);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(255);
      doc.text(`RSVP List (${rsvps.length} families)`, 16, yPos);
      yPos += 10;

      const rsvpData = rsvps.map((rsvp, idx) => [
        String(idx + 1),
        rsvp.personName,
        rsvp.personPhone || '-',
        String(rsvp.adults),
        String(rsvp.kids),
        String(rsvp.adults + rsvp.kids),
      ]);

      // Add total row
      rsvpData.push(['', 'Total', '', String(adults || 0), String(kids || 0), String(totalAttendees)]);

      autoTable(doc, {
        startY: yPos,
        head: [['#', 'Name', 'Phone', 'Adults', 'Children', 'Total']],
        body: rsvpData,
        theme: 'striped',
        headStyles: {
          fillColor: [243, 244, 246],
          textColor: [75, 85, 99],
          fontStyle: 'bold',
          fontSize: 9,
        },
        bodyStyles: {
          fontSize: 9,
          textColor: [31, 41, 55],
        },
        columnStyles: {
          0: { cellWidth: 12, halign: 'center' },
          1: { cellWidth: 55 },
          2: { cellWidth: 35 },
          3: { cellWidth: 22, halign: 'center' },
          4: { cellWidth: 22, halign: 'center' },
          5: { cellWidth: 22, halign: 'center', fontStyle: 'bold' },
        },
        margin: { left: 14, right: 14 },
        didParseCell: (data) => {
          // Style the total row
          if (data.row.index === rsvpData.length - 1) {
            data.cell.styles.fontStyle = 'bold';
            data.cell.styles.fillColor = [243, 244, 246];
          }
        },
      });
    }

    const fileName = `niyaz-rsvp-${event?.title?.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
  };

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
  const numberOfThaal = equivalentServings / 10;
  const isPast = isEventPast(event.eventDate);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Niyaz RSVP Report</h1>
          <p className="text-gray-500">{event.title} - {event.eventDate}</p>
        </div>
        <Link to="/admin/events" className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors">
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
          <li className="text-base">• <strong className="text-purple-700">Number of Thaals: {numberOfThaal.toFixed(1)}</strong> <span className="text-gray-500">(10 persons per thaal)</span></li>
        </ul>
      </div>

      {/* RSVP List */}
      <div className="card overflow-hidden p-0">
        <div className={`${isPast ? 'bg-gray-600' : 'bg-purple-600'} px-6 py-4 flex items-center justify-between`}>
          <div>
            <h2 className="text-lg font-semibold text-white">RSVP List</h2>
            <p className={`text-sm ${isPast ? 'text-gray-300' : 'text-purple-200'}`}>{rsvps?.length || 0} families have responded</p>
          </div>
          {!isPast && (
            <button
              onClick={openAddModal}
              className="px-4 py-2 text-sm font-medium rounded-md bg-green-500 text-white hover:bg-green-600 transition-colors flex items-center gap-2"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
              Add RSVP
            </button>
          )}
        </div>
        <div className="p-0">
          {rsvps && rsvps.length > 0 ? (
            <table className="w-full">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-6 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">#</th>
                  <th className="py-3 px-6 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Name</th>
                  <th className="py-3 px-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Phone</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Adults</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Children</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Total</th>
                  {!isPast && (
                    <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-24">Actions</th>
                  )}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {rsvps.map((rsvp, idx) => (
                  <tr key={rsvp.rsvpId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    <td className="py-3 px-6 text-gray-500 text-sm">{idx + 1}</td>
                    <td className="py-3 px-6 font-medium text-gray-900">{rsvp.personName}</td>
                    <td className="py-3 px-4 text-gray-600 text-sm">{rsvp.personPhone || '-'}</td>
                    <td className="py-3 px-4 text-center text-blue-600 font-medium">{rsvp.adults}</td>
                    <td className="py-3 px-4 text-center text-green-600 font-medium">{rsvp.kids}</td>
                    <td className="py-3 px-4 text-center font-bold text-purple-600">{rsvp.adults + rsvp.kids}</td>
                    {!isPast && (
                      <td className="py-3 px-4 text-center">
                        <div className="flex items-center justify-center gap-2">
                          <button
                            onClick={() => openEditModal(rsvp)}
                            className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                            title="Edit RSVP"
                          >
                            Edit
                          </button>
                          <button
                            onClick={() => openDeleteModal(rsvp)}
                            className="text-red-600 hover:text-red-800 text-sm font-medium"
                            title="Delete RSVP"
                          >
                            Delete
                          </button>
                        </div>
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr className="bg-gray-100 border-t-2 border-gray-300">
                  <td className="py-3 px-6"></td>
                  <td className="py-3 px-6 font-bold text-gray-900">Total</td>
                  <td className="py-3 px-4"></td>
                  <td className="py-3 px-4 text-center font-bold text-blue-600">{adults || 0}</td>
                  <td className="py-3 px-4 text-center font-bold text-green-600">{kids || 0}</td>
                  <td className="py-3 px-4 text-center font-bold text-purple-600">{totalAttendees}</td>
                  {!isPast && <td className="py-3 px-4"></td>}
                </tr>
              </tfoot>
            </table>
          ) : (
            <p className="p-6 text-gray-500">No RSVPs yet.</p>
          )}
        </div>
      </div>

      {/* Export Buttons */}
      <div className="flex gap-3">
        <button onClick={exportToPDF} className="px-4 py-2 bg-gradient-to-r from-purple-600 to-purple-700 text-white font-medium rounded-lg hover:from-purple-700 hover:to-purple-800 transition-all shadow-sm hover:shadow-md">
          Export to PDF
        </button>
      </div>

      {/* Add RSVP Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
            <div className="bg-purple-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Add RSVP</h3>
              <p className="text-sm text-purple-200">Add an RSVP for a user who hasn't responded yet</p>
            </div>
            <div className="p-6 space-y-4">
              {formError && (
                <div className="bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}

              {/* Person Select */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Select Person *</label>
                <select
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
                  value={formData.personId || ''}
                  onChange={(e) => setFormData({ ...formData, personId: e.target.value ? Number(e.target.value) : null })}
                >
                  <option value="">Select a person...</option>
                  {usersWithoutRsvps?.map((person) => (
                    <option key={person.id} value={person.id}>
                      {person.firstName} {person.lastName} ({person.itsNumber})
                    </option>
                  ))}
                </select>
                {usersWithoutRsvps?.length === 0 && (
                  <p className="text-sm text-gray-500 mt-1">All users have already responded to this event.</p>
                )}
              </div>

              {/* Adults */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Adults *</label>
                <input
                  type="number"
                  min="0"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
                  value={formData.adults}
                  onChange={(e) => setFormData({ ...formData, adults: parseInt(e.target.value) || 0 })}
                />
              </div>

              {/* Children */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Children</label>
                <input
                  type="number"
                  min="0"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
                  value={formData.kids}
                  onChange={(e) => setFormData({ ...formData, kids: parseInt(e.target.value) || 0 })}
                />
              </div>
            </div>

            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowAddModal(false); resetForm(); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitAdd}
                disabled={createRsvpMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-purple-600 rounded-md hover:bg-purple-700 disabled:opacity-50"
              >
                {createRsvpMutation.isPending ? 'Creating...' : 'Add RSVP'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit RSVP Modal */}
      {showEditModal && selectedRsvp && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
            <div className="bg-purple-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Edit RSVP</h3>
              <p className="text-sm text-purple-200">Editing RSVP for {selectedRsvp.personName}</p>
            </div>
            <div className="p-6 space-y-4">
              {formError && (
                <div className="bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}

              {/* Person (readonly) */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Person</label>
                <div className="w-full rounded-md border border-gray-200 bg-gray-100 px-3 py-2 text-sm text-gray-600">
                  {selectedRsvp.personName}
                </div>
              </div>

              {/* Adults */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Adults *</label>
                <input
                  type="number"
                  min="0"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
                  value={formData.adults}
                  onChange={(e) => setFormData({ ...formData, adults: parseInt(e.target.value) || 0 })}
                />
              </div>

              {/* Children */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Children</label>
                <input
                  type="number"
                  min="0"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
                  value={formData.kids}
                  onChange={(e) => setFormData({ ...formData, kids: parseInt(e.target.value) || 0 })}
                />
              </div>
            </div>

            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowEditModal(false); resetForm(); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitEdit}
                disabled={updateRsvpMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-purple-600 rounded-md hover:bg-purple-700 disabled:opacity-50"
              >
                {updateRsvpMutation.isPending ? 'Saving...' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteModal && selectedRsvp && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
            <div className="bg-red-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Delete RSVP</h3>
            </div>
            <div className="p-6">
              <p className="text-gray-600">
                Are you sure you want to delete the RSVP for <strong>{selectedRsvp.personName}</strong>?
                This action cannot be undone.
              </p>
              {formError && (
                <div className="mt-4 bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}
            </div>
            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowDeleteModal(false); setSelectedRsvp(null); setFormError(null); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleConfirmDelete}
                disabled={deleteRsvpMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 disabled:opacity-50"
              >
                {deleteRsvpMutation.isPending ? 'Deleting...' : 'Delete RSVP'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
