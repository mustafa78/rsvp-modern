import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';

type Role = {
  id: number;
  name: string;
  description: string | null;
  active: boolean;
  createdAt: string | null;
  updatedAt: string | null;
};

// System roles that cannot be deactivated
const SYSTEM_ROLES = ['USER', 'SUPER_USER', 'ADMIN'];

export default function RoleManagement() {
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingRole, setEditingRole] = useState<Role | null>(null);
  const [createForm, setCreateForm] = useState({ name: '', description: '' });
  const [editForm, setEditForm] = useState({ description: '' });
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const { data: roles, isLoading, isError, error: queryError } = useQuery<Role[]>({
    queryKey: ['roles'],
    queryFn: async () => (await api.get('/roles')).data,
    retry: 1, // Only retry once to avoid slow loading on errors
    staleTime: 30000, // Cache for 30 seconds
  });

  const createMutation = useMutation({
    mutationFn: async (data: { name: string; description: string }) =>
      api.post('/roles', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['roles'] });
      setShowCreateForm(false);
      setCreateForm({ name: '', description: '' });
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to create role'),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: { description?: string; active?: boolean } }) =>
      api.put(`/roles/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['roles'] });
      setEditingRole(null);
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to update role'),
  });

  const activateMutation = useMutation({
    mutationFn: async (id: number) => api.put(`/roles/${id}/activate`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['roles'] });
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to activate role'),
  });

  const deactivateMutation = useMutation({
    mutationFn: async (id: number) => api.put(`/roles/${id}/deactivate`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['roles'] });
      setError(null);
    },
    onError: (err: any) => setError(err.response?.data?.message || err.message || 'Failed to deactivate role'),
  });

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!createForm.name.trim()) {
      setError('Role name is required');
      return;
    }
    createMutation.mutate(createForm);
  };

  const handleEditSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingRole) return;
    updateMutation.mutate({ id: editingRole.id, data: { description: editForm.description } });
  };

  const startEdit = (role: Role) => {
    setEditingRole(role);
    setEditForm({ description: role.description || '' });
    setError(null);
  };

  const cancelEdit = () => {
    setEditingRole(null);
    setError(null);
  };

  const isSystemRole = (name: string) => SYSTEM_ROLES.includes(name);

  const activeRoles = roles?.filter(r => r.active) || [];
  const inactiveRoles = roles?.filter(r => !r.active) || [];

  if (isLoading) {
    return <div className="text-gray-500">Loading roles...</div>;
  }

  if (isError) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Role Management</h1>
        <div className="bg-red-100 text-red-700 px-4 py-3 rounded">
          <p className="font-medium">Failed to load roles</p>
          <p className="text-sm mt-1">
            {(queryError as any)?.response?.status === 404
              ? 'The roles table may not exist yet. Please restart the server to run database migrations.'
              : (queryError as any)?.message || 'Unknown error occurred'}
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Role Management</h1>
          <p className="text-sm text-gray-500 mt-1">Create and manage system roles</p>
        </div>
        {!showCreateForm && (
          <button onClick={() => setShowCreateForm(true)} className="btn">
            + Add Role
          </button>
        )}
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      {/* Create Role Form */}
      {showCreateForm && (
        <div className="card">
          <h2 className="text-lg font-semibold mb-4">Create New Role</h2>
          <form onSubmit={handleCreateSubmit} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Role Name *</label>
                <input
                  className="input"
                  value={createForm.name}
                  onChange={(e) => setCreateForm({ ...createForm, name: e.target.value })}
                  placeholder="e.g., COOK, VOLUNTEER, TREASURER"
                />
                <p className="text-xs text-gray-500 mt-1">Will be converted to uppercase with underscores</p>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Description</label>
                <input
                  className="input"
                  value={createForm.description}
                  onChange={(e) => setCreateForm({ ...createForm, description: e.target.value })}
                  placeholder="Brief description of the role"
                />
              </div>
            </div>
            <div className="flex gap-2">
              <button
                type="submit"
                className="btn"
                disabled={createMutation.isPending}
              >
                {createMutation.isPending ? 'Creating...' : 'Create Role'}
              </button>
              <button
                type="button"
                className="btn bg-gray-500"
                onClick={() => {
                  setShowCreateForm(false);
                  setCreateForm({ name: '', description: '' });
                  setError(null);
                }}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Edit Role Modal */}
      {editingRole && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md mx-4">
            <h2 className="text-lg font-semibold mb-4">Edit Role: {editingRole.name}</h2>
            <form onSubmit={handleEditSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">Description</label>
                <textarea
                  className="input"
                  rows={3}
                  value={editForm.description}
                  onChange={(e) => setEditForm({ description: e.target.value })}
                  placeholder="Brief description of the role"
                />
              </div>
              <div className="flex gap-2">
                <button
                  type="submit"
                  className="btn"
                  disabled={updateMutation.isPending}
                >
                  {updateMutation.isPending ? 'Saving...' : 'Save Changes'}
                </button>
                <button type="button" className="btn bg-gray-500" onClick={cancelEdit}>
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Active Roles */}
      <div className="card">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold">Active Roles</h2>
          <span className="text-sm text-gray-500">{activeRoles.length} roles</span>
        </div>

        {activeRoles.length === 0 ? (
          <p className="text-gray-500">No active roles.</p>
        ) : (
          <div className="overflow-hidden border rounded-lg">
            <table className="w-full text-left table-fixed">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[20%]">Role Name</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[45%]">Description</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[15%] text-center">Status</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[20%] text-center">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {activeRoles.map((role, idx) => (
                  <tr key={role.id} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                    <td className="py-3 px-4">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium ${
                        role.name === 'ADMIN' ? 'bg-red-100 text-red-700' :
                        role.name === 'SUPER_USER' ? 'bg-purple-100 text-purple-700' :
                        role.name === 'USER' ? 'bg-gray-100 text-gray-700' :
                        'bg-blue-100 text-blue-700'
                      }`}>
                        {role.name}
                      </span>
                      {isSystemRole(role.name) && (
                        <span className="ml-2 text-xs text-gray-400">(System)</span>
                      )}
                    </td>
                    <td className="py-3 px-4 text-gray-600 text-sm">
                      {role.description || <span className="text-gray-400 italic">No description</span>}
                    </td>
                    <td className="py-3 px-4 text-center">
                      <span className="inline-flex items-center gap-1 text-xs text-green-600">
                        <span className="w-2 h-2 rounded-full bg-green-500" />
                        Active
                      </span>
                    </td>
                    <td className="py-3 px-4 text-center">
                      <div className="flex items-center justify-center gap-2">
                        <button
                          onClick={() => startEdit(role)}
                          className="text-sm text-blue-600 hover:text-blue-800"
                        >
                          Edit
                        </button>
                        {!isSystemRole(role.name) && (
                          <button
                            onClick={() => deactivateMutation.mutate(role.id)}
                            disabled={deactivateMutation.isPending}
                            className="text-sm text-red-600 hover:text-red-800 disabled:opacity-50"
                          >
                            Deactivate
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Inactive Roles */}
      {inactiveRoles.length > 0 && (
        <div className="card">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-600">Inactive Roles</h2>
            <span className="text-sm text-gray-500">{inactiveRoles.length} roles</span>
          </div>

          <div className="overflow-hidden border rounded-lg">
            <table className="w-full text-left table-fixed">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[20%]">Role Name</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[45%]">Description</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[15%] text-center">Status</th>
                  <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[20%] text-center">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {inactiveRoles.map((role, idx) => (
                  <tr key={role.id} className={`${idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'} opacity-60`}>
                    <td className="py-3 px-4">
                      <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-500">
                        {role.name}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-gray-500 text-sm">
                      {role.description || <span className="text-gray-400 italic">No description</span>}
                    </td>
                    <td className="py-3 px-4 text-center">
                      <span className="inline-flex items-center gap-1 text-xs text-gray-500">
                        <span className="w-2 h-2 rounded-full bg-gray-400" />
                        Inactive
                      </span>
                    </td>
                    <td className="py-3 px-4 text-center">
                      <div className="flex items-center justify-center gap-2">
                        <button
                          onClick={() => startEdit(role)}
                          className="text-sm text-blue-600 hover:text-blue-800"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => activateMutation.mutate(role.id)}
                          disabled={activateMutation.isPending}
                          className="text-sm text-green-600 hover:text-green-800 disabled:opacity-50"
                        >
                          Activate
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Help Text */}
      <div className="card bg-blue-50 border-blue-200">
        <h3 className="text-sm font-semibold text-blue-900 mb-2">About Roles</h3>
        <ul className="text-sm text-blue-800 space-y-1">
          <li><strong>USER, SUPER_USER, ADMIN</strong> are system roles and cannot be deactivated.</li>
          <li>Custom roles can be created for specific purposes (e.g., COOK, VOLUNTEER, TREASURER).</li>
          <li>Deactivated roles cannot be assigned to new users but existing assignments remain.</li>
          <li>Role names are automatically converted to uppercase with underscores.</li>
        </ul>
      </div>
    </div>
  );
}
