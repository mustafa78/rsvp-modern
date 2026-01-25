import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';

type AnnouncementType = 'MANUAL' | 'EVENT_UPDATE';

type AdminAnnouncement = {
  id: number;
  title: string | null;
  content: string;
  type: AnnouncementType;
  eventId: number | null;
  eventTitle: string | null;
  createdByName: string | null;
  createdAt: string;
  expiresAt: string | null;
  active: boolean;
  readCount: number;
};

type StatusFilter = 'all' | 'active' | 'inactive';
type TypeFilter = 'all' | 'MANUAL' | 'EVENT_UPDATE';

export default function AnnouncementList() {
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [createForm, setCreateForm] = useState({ title: '', content: '', expiresAt: '' });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editForm, setEditForm] = useState({ title: '', content: '', expiresAt: '' });
  const [error, setError] = useState<string | null>(null);
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all');
  const [typeFilter, setTypeFilter] = useState<TypeFilter>('all');
  const queryClient = useQueryClient();

  const { data: announcements, isLoading, isError } = useQuery<AdminAnnouncement[]>({
    queryKey: ['admin-announcements'],
    queryFn: async () => (await api.get('/announcements/admin')).data,
  });

  const createMutation = useMutation({
    mutationFn: async (data: { title: string; content: string; expiresAt: string | null }) =>
      api.post('/announcements', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-announcements'] });
      setShowCreateForm(false);
      setCreateForm({ title: '', content: '', expiresAt: '' });
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to create announcement'),
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => api.delete(`/announcements/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-announcements'] });
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to delete announcement'),
  });

  const toggleActiveMutation = useMutation({
    mutationFn: async (id: number) => api.post(`/announcements/${id}/toggle-active`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-announcements'] });
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to update announcement'),
  });

  const editMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: { title: string | null; content: string; expiresAt: string | null } }) =>
      api.put(`/announcements/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-announcements'] });
      setEditingId(null);
      setEditForm({ title: '', content: '', expiresAt: '' });
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to update announcement'),
  });

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!createForm.content.trim()) {
      setError('Announcement content is required');
      return;
    }
    createMutation.mutate({
      title: createForm.title || null,
      content: createForm.content,
      expiresAt: createForm.expiresAt || null,
    });
  };

  const handleDelete = (id: number) => {
    if (confirm('Are you sure you want to delete this announcement?')) {
      deleteMutation.mutate(id);
    }
  };

  const startEdit = (announcement: AdminAnnouncement) => {
    setEditingId(announcement.id);
    setEditForm({
      title: announcement.title || '',
      content: announcement.content,
      expiresAt: announcement.expiresAt ? announcement.expiresAt.slice(0, 16) : '',
    });
    setError(null);
  };

  const handleEditSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!editForm.content.trim()) {
      setError('Announcement content is required');
      return;
    }
    if (editingId) {
      editMutation.mutate({
        id: editingId,
        data: {
          title: editForm.title || null,
          content: editForm.content,
          expiresAt: editForm.expiresAt || null,
        },
      });
    }
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditForm({ title: '', content: '', expiresAt: '' });
    setError(null);
  };

  const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
    });
  };

  const formatRelativeTime = (dateStr: string) => {
    const date = new Date(dateStr);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    return formatDate(dateStr);
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading announcements...</div>;
  }

  if (isError) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Announcements</h1>
        <div className="bg-red-100 text-red-700 px-4 py-3 rounded">
          Failed to load announcements. Please try again.
        </div>
      </div>
    );
  }

  // Apply filters
  const filteredAnnouncements = (announcements || []).filter(a => {
    // Status filter
    if (statusFilter === 'active' && !a.active) return false;
    if (statusFilter === 'inactive' && a.active) return false;
    // Type filter
    if (typeFilter !== 'all' && a.type !== typeFilter) return false;
    return true;
  });

  const activeAnnouncements = filteredAnnouncements.filter(a => a.active);
  const inactiveAnnouncements = filteredAnnouncements.filter(a => !a.active);

  // Count for filter badges
  const allCount = announcements?.length || 0;
  const activeCount = announcements?.filter(a => a.active).length || 0;
  const inactiveCount = announcements?.filter(a => !a.active).length || 0;
  const manualCount = announcements?.filter(a => a.type === 'MANUAL').length || 0;
  const eventUpdateCount = announcements?.filter(a => a.type === 'EVENT_UPDATE').length || 0;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Announcements</h1>
          <p className="text-sm text-gray-500 mt-1">Create and manage community announcements</p>
        </div>
        {!showCreateForm && (
          <button
            onClick={() => setShowCreateForm(true)}
            className="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-medium rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all shadow-sm hover:shadow-md"
          >
            + New Announcement
          </button>
        )}
      </div>

      {/* Filters */}
      <div className="flex flex-wrap items-center gap-4 bg-white rounded-lg border border-gray-200 p-4">
        <div className="flex items-center gap-2">
          <span className="text-sm font-medium text-gray-700">Status:</span>
          <div className="flex rounded-lg border border-gray-200 overflow-hidden">
            <button
              onClick={() => setStatusFilter('all')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                statusFilter === 'all'
                  ? 'bg-purple-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              All ({allCount})
            </button>
            <button
              onClick={() => setStatusFilter('active')}
              className={`px-3 py-1.5 text-sm font-medium border-l border-gray-200 transition-colors ${
                statusFilter === 'active'
                  ? 'bg-green-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              Active ({activeCount})
            </button>
            <button
              onClick={() => setStatusFilter('inactive')}
              className={`px-3 py-1.5 text-sm font-medium border-l border-gray-200 transition-colors ${
                statusFilter === 'inactive'
                  ? 'bg-gray-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              Inactive ({inactiveCount})
            </button>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-sm font-medium text-gray-700">Type:</span>
          <div className="flex rounded-lg border border-gray-200 overflow-hidden">
            <button
              onClick={() => setTypeFilter('all')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                typeFilter === 'all'
                  ? 'bg-purple-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              All
            </button>
            <button
              onClick={() => setTypeFilter('MANUAL')}
              className={`px-3 py-1.5 text-sm font-medium border-l border-gray-200 transition-colors ${
                typeFilter === 'MANUAL'
                  ? 'bg-purple-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              Manual ({manualCount})
            </button>
            <button
              onClick={() => setTypeFilter('EVENT_UPDATE')}
              className={`px-3 py-1.5 text-sm font-medium border-l border-gray-200 transition-colors ${
                typeFilter === 'EVENT_UPDATE'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-gray-50'
              }`}
            >
              Event Update ({eventUpdateCount})
            </button>
          </div>
        </div>

        {(statusFilter !== 'all' || typeFilter !== 'all') && (
          <button
            onClick={() => {
              setStatusFilter('all');
              setTypeFilter('all');
            }}
            className="text-sm text-gray-500 hover:text-gray-700 underline"
          >
            Clear filters
          </button>
        )}
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      {/* Create Announcement Form */}
      {showCreateForm && (
        <div className="card">
          <h2 className="text-lg font-semibold mb-4">Create New Announcement</h2>
          <form onSubmit={handleCreateSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">Title (Optional)</label>
              <input
                className="input"
                value={createForm.title}
                onChange={(e) => setCreateForm({ ...createForm, title: e.target.value })}
                placeholder="e.g., Important Update"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Content *</label>
              <textarea
                className="input"
                rows={4}
                value={createForm.content}
                onChange={(e) => setCreateForm({ ...createForm, content: e.target.value })}
                placeholder="Baad us Salaam un Jameel..."
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Expires At (Optional)</label>
              <input
                type="datetime-local"
                className="input"
                value={createForm.expiresAt}
                onChange={(e) => setCreateForm({ ...createForm, expiresAt: e.target.value })}
              />
              <p className="text-xs text-gray-500 mt-1">Leave empty for no expiration</p>
            </div>
            <div className="flex gap-2">
              <button
                type="submit"
                className="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-medium rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all shadow-sm hover:shadow-md disabled:opacity-50"
                disabled={createMutation.isPending}
              >
                {createMutation.isPending ? 'Creating...' : 'Create Announcement'}
              </button>
              <button
                type="button"
                className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors"
                onClick={() => {
                  setShowCreateForm(false);
                  setCreateForm({ title: '', content: '', expiresAt: '' });
                  setError(null);
                }}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Active Announcements */}
      {(statusFilter === 'all' || statusFilter === 'active') && (
      <div className="card">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold">Active Announcements</h2>
          <span className="text-sm text-gray-500">{activeAnnouncements.length} announcements</span>
        </div>

        {activeAnnouncements.length === 0 ? (
          <p className="text-gray-500 text-center py-8">
            {typeFilter !== 'all'
              ? `No active ${typeFilter === 'MANUAL' ? 'manual' : 'event update'} announcements.`
              : 'No active announcements. Create one to notify users!'}
          </p>
        ) : (
          <div className="space-y-4">
            {activeAnnouncements.map((announcement) => (
              <div
                key={announcement.id}
                className="border rounded-lg p-4 hover:shadow-sm transition-shadow"
              >
                {editingId === announcement.id ? (
                  /* Edit Form */
                  <form onSubmit={handleEditSubmit} className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium mb-1">Title (Optional)</label>
                      <input
                        className="input"
                        value={editForm.title}
                        onChange={(e) => setEditForm({ ...editForm, title: e.target.value })}
                        placeholder="e.g., Important Update"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-1">Content *</label>
                      <textarea
                        className="input"
                        rows={4}
                        value={editForm.content}
                        onChange={(e) => setEditForm({ ...editForm, content: e.target.value })}
                        placeholder="Announcement content..."
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-1">Expires At (Optional)</label>
                      <input
                        type="datetime-local"
                        className="input"
                        value={editForm.expiresAt}
                        onChange={(e) => setEditForm({ ...editForm, expiresAt: e.target.value })}
                      />
                    </div>
                    <div className="flex gap-2">
                      <button
                        type="submit"
                        className="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-medium rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all shadow-sm hover:shadow-md disabled:opacity-50"
                        disabled={editMutation.isPending}
                      >
                        {editMutation.isPending ? 'Saving...' : 'Save Changes'}
                      </button>
                      <button
                        type="button"
                        className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors"
                        onClick={cancelEdit}
                      >
                        Cancel
                      </button>
                    </div>
                  </form>
                ) : (
                  /* Display View */
                  <div className="flex items-start justify-between gap-4">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-2">
                        <span
                          className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium ${
                            announcement.type === 'MANUAL'
                              ? 'bg-purple-100 text-purple-700'
                              : 'bg-blue-100 text-blue-700'
                          }`}
                        >
                          {announcement.type === 'MANUAL' ? 'Manual' : 'Event Update'}
                        </span>
                        <span className="text-xs text-gray-500">
                          {formatRelativeTime(announcement.createdAt)}
                        </span>
                        {announcement.readCount > 0 && (
                          <span className="text-xs text-gray-400">
                            ({announcement.readCount} read)
                          </span>
                        )}
                      </div>
                      {announcement.title && (
                        <h3 className="font-semibold text-gray-900 mb-1">{announcement.title}</h3>
                      )}
                      <p className="text-gray-600 text-sm whitespace-pre-line">{announcement.content}</p>
                      {announcement.eventTitle && (
                        <p className="text-xs text-gray-400 mt-2">
                          Related event: {announcement.eventTitle}
                        </p>
                      )}
                      {announcement.expiresAt && (
                        <p className="text-xs text-amber-600 mt-1">
                          Expires: {formatDate(announcement.expiresAt)}
                        </p>
                      )}
                    </div>
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => startEdit(announcement)}
                        className="text-sm text-blue-600 hover:text-blue-800"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => toggleActiveMutation.mutate(announcement.id)}
                        disabled={toggleActiveMutation.isPending}
                        className="text-sm text-amber-600 hover:text-amber-800 disabled:opacity-50"
                      >
                        Deactivate
                      </button>
                      <button
                        onClick={() => handleDelete(announcement.id)}
                        disabled={deleteMutation.isPending}
                        className="text-sm text-red-600 hover:text-red-800 disabled:opacity-50"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
      )}

      {/* Inactive Announcements */}
      {(statusFilter === 'all' || statusFilter === 'inactive') && (
        <div className="card">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-600">Inactive Announcements</h2>
            <span className="text-sm text-gray-500">{inactiveAnnouncements.length} announcements</span>
          </div>

          {inactiveAnnouncements.length === 0 ? (
            <p className="text-gray-500 text-center py-8">
              {typeFilter !== 'all'
                ? `No inactive ${typeFilter === 'MANUAL' ? 'manual' : 'event update'} announcements.`
                : 'No inactive announcements.'}
            </p>
          ) : (
          <div className="space-y-4 opacity-60">
            {inactiveAnnouncements.map((announcement) => (
              <div
                key={announcement.id}
                className={`border rounded-lg p-4 ${editingId === announcement.id ? 'bg-white opacity-100' : 'bg-gray-50'}`}
              >
                {editingId === announcement.id ? (
                  /* Edit Form */
                  <form onSubmit={handleEditSubmit} className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium mb-1">Title (Optional)</label>
                      <input
                        className="input"
                        value={editForm.title}
                        onChange={(e) => setEditForm({ ...editForm, title: e.target.value })}
                        placeholder="e.g., Important Update"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-1">Content *</label>
                      <textarea
                        className="input"
                        rows={4}
                        value={editForm.content}
                        onChange={(e) => setEditForm({ ...editForm, content: e.target.value })}
                        placeholder="Announcement content..."
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-1">Expires At (Optional)</label>
                      <input
                        type="datetime-local"
                        className="input"
                        value={editForm.expiresAt}
                        onChange={(e) => setEditForm({ ...editForm, expiresAt: e.target.value })}
                      />
                    </div>
                    <div className="flex gap-2">
                      <button
                        type="submit"
                        className="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-medium rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all shadow-sm hover:shadow-md disabled:opacity-50"
                        disabled={editMutation.isPending}
                      >
                        {editMutation.isPending ? 'Saving...' : 'Save Changes'}
                      </button>
                      <button
                        type="button"
                        className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors"
                        onClick={cancelEdit}
                      >
                        Cancel
                      </button>
                    </div>
                  </form>
                ) : (
                  /* Display View */
                  <div className="flex items-start justify-between gap-4">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-2">
                        <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-600">
                          {announcement.type === 'MANUAL' ? 'Manual' : 'Event Update'}
                        </span>
                        <span className="text-xs text-gray-500">
                          {formatRelativeTime(announcement.createdAt)}
                        </span>
                      </div>
                      {announcement.title && (
                        <h3 className="font-semibold text-gray-700 mb-1">{announcement.title}</h3>
                      )}
                      <p className="text-gray-500 text-sm line-clamp-2">{announcement.content}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => startEdit(announcement)}
                        className="text-sm text-blue-600 hover:text-blue-800"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => toggleActiveMutation.mutate(announcement.id)}
                        disabled={toggleActiveMutation.isPending}
                        className="text-sm text-green-600 hover:text-green-800 disabled:opacity-50"
                      >
                        Activate
                      </button>
                      <button
                        onClick={() => handleDelete(announcement.id)}
                        disabled={deleteMutation.isPending}
                        className="text-sm text-red-600 hover:text-red-800 disabled:opacity-50"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
          )}
        </div>
      )}

      {/* Help Text */}
      <div className="card bg-blue-50 border-blue-200">
        <h3 className="text-sm font-semibold text-blue-900 mb-2">About Announcements</h3>
        <ul className="text-sm text-blue-800 space-y-1">
          <li><strong>Manual announcements</strong> are created by admins for community updates.</li>
          <li><strong>Event updates</strong> are automatically generated when <em>published</em> events are modified (date/time changes, menu updates, or cancellations).</li>
          <li>Users can dismiss announcements, which tracks their "read" status.</li>
          <li>Deactivated announcements are hidden from users but can be reactivated.</li>
        </ul>
      </div>
    </div>
  );
}
