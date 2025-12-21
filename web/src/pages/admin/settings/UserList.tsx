import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';

type RoleName = 'USER' | 'SUPER_USER' | 'ADMIN';
type AccountStatus = 'ACTIVE' | 'LOCKED' | 'DISABLED';

type User = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string | null;
  roles: RoleName[];
  accountStatus: AccountStatus;
  pickupZoneName: string | null;
  lastLoginAt: string | null;
};

const roleLabels: Record<RoleName, string> = {
  USER: 'User',
  SUPER_USER: 'Super User',
  ADMIN: 'Admin',
};

const statusLabels: Record<AccountStatus, string> = {
  ACTIVE: 'Active',
  LOCKED: 'Locked',
  DISABLED: 'Disabled',
};

const statusColors: Record<AccountStatus, string> = {
  ACTIVE: 'bg-green-100 text-green-700',
  LOCKED: 'bg-yellow-100 text-yellow-700',
  DISABLED: 'bg-red-100 text-red-700',
};

export default function UserList() {
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [editRoles, setEditRoles] = useState<RoleName[]>([]);
  const [editStatus, setEditStatus] = useState<AccountStatus>('ACTIVE');
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const queryClient = useQueryClient();

  const { data: users, isLoading } = useQuery<User[]>({
    queryKey: ['admin-users'],
    queryFn: async () => (await api.get('/admin/users')).data,
  });

  const updateRolesMutation = useMutation({
    mutationFn: async ({ id, roles }: { id: number; roles: RoleName[] }) =>
      api.put(`/admin/users/${id}/roles`, { roles }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setEditingUser(null);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateStatusMutation = useMutation({
    mutationFn: async ({ id, status }: { id: number; status: AccountStatus }) =>
      api.put(`/admin/users/${id}/status`, { status }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setEditingUser(null);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const startEdit = (user: User) => {
    setEditingUser(user);
    setEditRoles([...user.roles]);
    setEditStatus(user.accountStatus);
    setError(null);
  };

  const cancelEdit = () => {
    setEditingUser(null);
    setError(null);
  };

  const toggleRole = (role: RoleName) => {
    if (editRoles.includes(role)) {
      setEditRoles(editRoles.filter((r) => r !== role));
    } else {
      setEditRoles([...editRoles, role]);
    }
  };

  const saveChanges = () => {
    if (!editingUser) return;

    const rolesChanged = JSON.stringify([...editRoles].sort()) !== JSON.stringify([...editingUser.roles].sort());
    const statusChanged = editStatus !== editingUser.accountStatus;

    if (rolesChanged) {
      updateRolesMutation.mutate({ id: editingUser.id, roles: editRoles });
    }
    if (statusChanged) {
      updateStatusMutation.mutate({ id: editingUser.id, status: editStatus });
    }
    if (!rolesChanged && !statusChanged) {
      setEditingUser(null);
    }
  };

  const filteredUsers = users?.filter((user) => {
    const term = searchTerm.toLowerCase();
    return (
      user.firstName.toLowerCase().includes(term) ||
      user.lastName.toLowerCase().includes(term) ||
      user.email.toLowerCase().includes(term) ||
      user.itsNumber.toLowerCase().includes(term)
    );
  });

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Users</h1>
        <div className="text-sm text-gray-500">
          {users?.length || 0} total users
        </div>
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      {/* Search */}
      <div className="card">
        <input
          type="text"
          className="input"
          placeholder="Search by name, email, or ITS number..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {/* Edit Modal */}
      {editingUser && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md mx-4">
            <h2 className="text-lg font-semibold mb-4">
              Edit User: {editingUser.firstName} {editingUser.lastName}
            </h2>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2">Roles</label>
                <div className="flex flex-wrap gap-2">
                  {(['USER', 'SUPER_USER', 'ADMIN'] as RoleName[]).map((role) => (
                    <button
                      key={role}
                      type="button"
                      onClick={() => toggleRole(role)}
                      className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                        editRoles.includes(role)
                          ? 'bg-blue-600 text-white border-blue-600'
                          : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-100'
                      }`}
                    >
                      {roleLabels[role]}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium mb-2">Account Status</label>
                <select
                  className="input"
                  value={editStatus}
                  onChange={(e) => setEditStatus(e.target.value as AccountStatus)}
                >
                  <option value="ACTIVE">Active</option>
                  <option value="LOCKED">Locked</option>
                  <option value="DISABLED">Disabled</option>
                </select>
              </div>
            </div>

            <div className="flex gap-2 mt-6">
              <button
                onClick={saveChanges}
                className="btn"
                disabled={updateRolesMutation.isPending || updateStatusMutation.isPending}
              >
                {updateRolesMutation.isPending || updateStatusMutation.isPending
                  ? 'Saving...'
                  : 'Save Changes'}
              </button>
              <button onClick={cancelEdit} className="btn bg-gray-500">
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Users Table */}
      <div className="card overflow-x-auto">
        {!filteredUsers || filteredUsers.length === 0 ? (
          <p className="text-gray-500">
            {searchTerm ? 'No users match your search.' : 'No users found.'}
          </p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Name</th>
                <th className="pb-2 font-medium">ITS #</th>
                <th className="pb-2 font-medium">Contact</th>
                <th className="pb-2 font-medium">Roles</th>
                <th className="pb-2 font-medium">Status</th>
                <th className="pb-2 font-medium">Zone</th>
                <th className="pb-2 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr key={user.id} className="border-b last:border-0">
                  <td className="py-3">
                    <div className="font-medium">
                      {user.firstName} {user.lastName}
                    </div>
                  </td>
                  <td className="py-3 text-sm text-gray-600">{user.itsNumber}</td>
                  <td className="py-3">
                    <div className="text-sm">{user.email}</div>
                    {user.phone && (
                      <div className="text-xs text-gray-500">{user.phone}</div>
                    )}
                  </td>
                  <td className="py-3">
                    <div className="flex flex-wrap gap-1">
                      {user.roles.map((role) => (
                        <span
                          key={role}
                          className={`text-xs px-2 py-0.5 rounded ${
                            role === 'ADMIN'
                              ? 'bg-red-100 text-red-700'
                              : role === 'SUPER_USER'
                              ? 'bg-purple-100 text-purple-700'
                              : 'bg-gray-100 text-gray-700'
                          }`}
                        >
                          {roleLabels[role]}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td className="py-3">
                    <span className={`text-xs px-2 py-1 rounded ${statusColors[user.accountStatus]}`}>
                      {statusLabels[user.accountStatus]}
                    </span>
                  </td>
                  <td className="py-3 text-sm text-gray-600">
                    {user.pickupZoneName || '-'}
                  </td>
                  <td className="py-3">
                    <button
                      onClick={() => startEdit(user)}
                      className="text-sm text-blue-600 hover:underline"
                    >
                      Edit
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
