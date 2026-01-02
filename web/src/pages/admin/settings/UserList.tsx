import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';

type AccountStatus = 'ACTIVE' | 'LOCKED' | 'DISABLED';
type UserType = 'REGISTERED' | 'STUDENT' | 'MEHMAAN';

type User = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string | null;
  roles: string[];
  accountStatus: AccountStatus;
  userType: UserType;
  accountExpiresAt: string | null;
  isExpired: boolean;
  pickupZoneName: string | null;
  lastLoginAt: string | null;
};

type PickupZone = {
  id: number;
  name: string;
  active: boolean;
};

type Role = {
  id: number;
  name: string;
  description: string | null;
  active: boolean;
};

// Format role name for display (e.g., NIYAZ_COORDINATOR -> Niyaz Coordinator)
const formatRoleName = (name: string): string => {
  return name
    .split('_')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(' ');
};

// Get role badge color based on role name
const getRoleColor = (role: string): string => {
  switch (role) {
    case 'ADMIN':
      return 'bg-red-100 text-red-700';
    case 'SUPER_USER':
      return 'bg-purple-100 text-purple-700';
    case 'NIYAZ_COORDINATOR':
      return 'bg-green-100 text-green-700';
    case 'THAALI_COORDINATOR':
      return 'bg-orange-100 text-orange-700';
    default:
      return 'bg-gray-100 text-gray-700';
  }
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

const userTypeLabels: Record<UserType, string> = {
  REGISTERED: 'Registered',
  STUDENT: 'Student',
  MEHMAAN: 'Mehmaan',
};

const userTypeColors: Record<UserType, string> = {
  REGISTERED: 'bg-blue-100 text-blue-700',
  STUDENT: 'bg-purple-100 text-purple-700',
  MEHMAAN: 'bg-amber-100 text-amber-700',
};

const formatDate = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
};

const getDefaultExpirationDate = (userType: UserType): string => {
  const date = new Date();
  if (userType === 'STUDENT') {
    date.setDate(date.getDate() + 60);
  } else if (userType === 'MEHMAAN') {
    date.setDate(date.getDate() + 30);
  }
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
};

const initialCreateForm = {
  itsNumber: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  password: '',
  pickupZoneId: '',
  roles: ['USER'] as string[],
  userType: 'REGISTERED' as UserType,
  accountExpiresAt: '',
};

export default function UserList() {
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [editRoles, setEditRoles] = useState<string[]>([]);
  const [editStatus, setEditStatus] = useState<AccountStatus>('ACTIVE');
  const [editUserType, setEditUserType] = useState<UserType>('REGISTERED');
  const [editExpiresAt, setEditExpiresAt] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [createForm, setCreateForm] = useState(initialCreateForm);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const queryClient = useQueryClient();

  const { data: users, isLoading } = useQuery<User[]>({
    queryKey: ['admin-users'],
    queryFn: async () => (await api.get('/admin/users')).data,
  });

  const { data: zones } = useQuery<PickupZone[]>({
    queryKey: ['pickup-zones'],
    queryFn: async () => (await api.get('/pickup-zones')).data,
  });

  const { data: availableRoles } = useQuery<Role[]>({
    queryKey: ['roles-active'],
    queryFn: async () => (await api.get('/roles/active')).data,
  });

  const createUserMutation = useMutation({
    mutationFn: async (data: typeof createForm) => {
      const payload = {
        ...data,
        pickupZoneId: data.pickupZoneId ? Number(data.pickupZoneId) : null,
        accountExpiresAt: data.accountExpiresAt ? new Date(data.accountExpiresAt).toISOString() : null,
      };
      return api.post('/admin/users', payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setShowCreateForm(false);
      setCreateForm(initialCreateForm);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateRolesMutation = useMutation({
    mutationFn: async ({ id, roles }: { id: number; roles: string[] }) =>
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

  const updateUserTypeMutation = useMutation({
    mutationFn: async ({ id, userType, accountExpiresAt }: { id: number; userType: UserType; accountExpiresAt: string | null }) =>
      api.put(`/admin/users/${id}/user-type`, { userType, accountExpiresAt: accountExpiresAt ? new Date(accountExpiresAt).toISOString() : null }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setEditingUser(null);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const extendExpirationMutation = useMutation({
    mutationFn: async ({ id, newExpiresAt }: { id: number; newExpiresAt: string }) =>
      api.put(`/admin/users/${id}/extend`, { newExpiresAt: new Date(newExpiresAt).toISOString() }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setEditingUser(null);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const convertToRegisteredMutation = useMutation({
    mutationFn: async (id: number) =>
      api.post(`/admin/users/${id}/convert-to-registered`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      setEditingUser(null);
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const startEdit = (user: User) => {
    setEditingUser(user);
    setEditStatus(user.accountStatus);

    // Handle userType - default to REGISTERED if not set
    const userType = user.userType || 'REGISTERED';
    setEditUserType(userType);

    // For Student/Mehmaan, force roles to just USER (same logic as onChange)
    if (userType !== 'REGISTERED') {
      setEditRoles(['USER']);
      // Convert ISO date to YYYY-MM-DD for the date input
      setEditExpiresAt(user.accountExpiresAt ? user.accountExpiresAt.split('T')[0] : '');
    } else {
      setEditRoles([...user.roles]);
      setEditExpiresAt(''); // Registered users don't have expiration
    }

    setError(null);
  };

  const cancelEdit = () => {
    setEditingUser(null);
    setError(null);
  };

  const toggleRole = (role: string) => {
    if (editRoles.includes(role)) {
      // Don't allow removing USER role - it's required
      if (role === 'USER') return;
      setEditRoles(editRoles.filter((r) => r !== role));
    } else {
      setEditRoles([...editRoles, role]);
    }
  };

  const toggleCreateRole = (role: string) => {
    if (createForm.roles.includes(role)) {
      // Don't allow removing USER role - it's required
      if (role === 'USER') return;
      setCreateForm({ ...createForm, roles: createForm.roles.filter((r) => r !== role) });
    } else {
      setCreateForm({ ...createForm, roles: [...createForm.roles, role] });
    }
  };

  const saveChanges = () => {
    if (!editingUser) return;

    const rolesChanged = JSON.stringify([...editRoles].sort()) !== JSON.stringify([...editingUser.roles].sort());
    const statusChanged = editStatus !== editingUser.accountStatus;
    const userTypeChanged = editUserType !== editingUser.userType;
    const expiresAtChanged = editExpiresAt !== (editingUser.accountExpiresAt?.split('T')[0] || '');

    if (rolesChanged) {
      updateRolesMutation.mutate({ id: editingUser.id, roles: editRoles });
    }
    if (statusChanged) {
      updateStatusMutation.mutate({ id: editingUser.id, status: editStatus });
    }
    if (userTypeChanged || expiresAtChanged) {
      updateUserTypeMutation.mutate({
        id: editingUser.id,
        userType: editUserType,
        accountExpiresAt: editExpiresAt || null,
      });
    }
    if (!rolesChanged && !statusChanged && !userTypeChanged && !expiresAtChanged) {
      setEditingUser(null);
    }
  };

  const extendByDays = (days: number) => {
    if (!editingUser) return;
    const newDate = new Date();
    newDate.setDate(newDate.getDate() + days);
    extendExpirationMutation.mutate({
      id: editingUser.id,
      newExpiresAt: newDate.toISOString().split('T')[0],
    });
  };

  const handleConvertToRegistered = () => {
    if (!editingUser) return;
    convertToRegisteredMutation.mutate(editingUser.id);
  };

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    createUserMutation.mutate(createForm);
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
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading users...</div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Users</h1>
          <p className="text-sm text-gray-500 mt-1">
            Manage user accounts, roles, and access permissions
          </p>
        </div>
        <div className="flex items-center gap-4">
          <span className="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
            {users?.length || 0} users
          </span>
          {!showCreateForm && (
            <button
              onClick={() => setShowCreateForm(true)}
              className="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors shadow-sm"
            >
              <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
              Create User
            </button>
          )}
        </div>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">{error}</div>
      )}

      {/* Create User Form */}
      {showCreateForm && (
        <div className="card">
          <h2 className="text-lg font-semibold mb-4">Create New User</h2>
          <form onSubmit={handleCreateSubmit} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">ITS Number *</label>
                <input
                  className="input"
                  value={createForm.itsNumber}
                  onChange={(e) => setCreateForm({ ...createForm, itsNumber: e.target.value })}
                  placeholder="e.g., 30702040"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Email *</label>
                <input
                  type="email"
                  className="input"
                  value={createForm.email}
                  onChange={(e) => setCreateForm({ ...createForm, email: e.target.value })}
                  placeholder="user@example.com"
                  required
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">First Name *</label>
                <input
                  className="input"
                  value={createForm.firstName}
                  onChange={(e) => setCreateForm({ ...createForm, firstName: e.target.value })}
                  placeholder="First name"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Last Name *</label>
                <input
                  className="input"
                  value={createForm.lastName}
                  onChange={(e) => setCreateForm({ ...createForm, lastName: e.target.value })}
                  placeholder="Last name"
                  required
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Phone</label>
                <input
                  className="input"
                  value={createForm.phone}
                  onChange={(e) => setCreateForm({ ...createForm, phone: e.target.value })}
                  placeholder="(555) 123-4567"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Password *</label>
                <input
                  type="password"
                  className="input"
                  value={createForm.password}
                  onChange={(e) => setCreateForm({ ...createForm, password: e.target.value })}
                  placeholder="Initial password"
                  required
                />
              </div>
            </div>
            <div className={`grid gap-4 ${createForm.userType === 'REGISTERED' ? 'grid-cols-1' : 'grid-cols-2'}`}>
              <div>
                <label className="block text-sm font-medium mb-1">User Type *</label>
                <select
                  className="input"
                  value={createForm.userType}
                  onChange={(e) => {
                    const newType = e.target.value as UserType;
                    setCreateForm({
                      ...createForm,
                      userType: newType,
                      // Clear expiration when switching to Registered
                      accountExpiresAt: newType === 'REGISTERED' ? '' : createForm.accountExpiresAt,
                      // Reset roles to just USER for Student/Mehmaan
                      roles: newType === 'REGISTERED' ? createForm.roles : ['USER'],
                    });
                  }}
                >
                  <option value="REGISTERED">Registered (Permanent)</option>
                  <option value="STUDENT">Student (60 days default)</option>
                  <option value="MEHMAAN">Mehmaan (30 days default)</option>
                </select>
                <p className="text-xs text-gray-500 mt-1">
                  {createForm.userType === 'REGISTERED' && 'Permanent member with no expiration'}
                  {createForm.userType === 'STUDENT' && 'Temporary access - expires in 60 days by default'}
                  {createForm.userType === 'MEHMAAN' && 'Guest access - expires in 30 days by default'}
                </p>
              </div>
              {createForm.userType !== 'REGISTERED' && (
                <div>
                  <label className="block text-sm font-medium mb-1">Expires At</label>
                  <input
                    type="date"
                    className="input"
                    value={createForm.accountExpiresAt}
                    onChange={(e) => setCreateForm({ ...createForm, accountExpiresAt: e.target.value })}
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Leave empty for default: {getDefaultExpirationDate(createForm.userType)}
                  </p>
                </div>
              )}
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Pickup Zone</label>
                <select
                  className="input"
                  value={createForm.pickupZoneId}
                  onChange={(e) => setCreateForm({ ...createForm, pickupZoneId: e.target.value })}
                >
                  <option value="">-- No zone --</option>
                  {zones?.filter(z => z.active).map((zone) => (
                    <option key={zone.id} value={zone.id}>{zone.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Roles</label>
                {createForm.userType === 'REGISTERED' ? (
                  <>
                    <div className="flex flex-wrap gap-2 mt-1">
                      {availableRoles?.map((role) => (
                        <button
                          key={role.name}
                          type="button"
                          onClick={() => toggleCreateRole(role.name)}
                          disabled={role.name === 'USER'}
                          className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                            createForm.roles.includes(role.name)
                              ? 'bg-blue-600 text-white border-blue-600'
                              : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-100'
                          } ${role.name === 'USER' ? 'opacity-75 cursor-not-allowed' : ''}`}
                          title={role.name === 'USER' ? 'User role is required' : role.description || ''}
                        >
                          {formatRoleName(role.name)}
                        </button>
                      ))}
                    </div>
                    <p className="text-xs text-gray-500 mt-1">User role is required and cannot be removed</p>
                  </>
                ) : (
                  <>
                    <div className="flex flex-wrap gap-2 mt-1">
                      <span className="px-3 py-1 rounded-full text-sm bg-gray-100 text-gray-700 border border-gray-300">
                        User
                      </span>
                    </div>
                    <p className="text-xs text-gray-500 mt-1">
                      {createForm.userType === 'STUDENT' ? 'Students' : 'Mehmaan'} can only have the User role
                    </p>
                  </>
                )}
              </div>
            </div>
            <div className="flex gap-2">
              <button
                type="submit"
                className="btn"
                disabled={createUserMutation.isPending}
              >
                {createUserMutation.isPending ? 'Creating...' : 'Create User'}
              </button>
              <button
                type="button"
                className="btn bg-gray-500"
                onClick={() => {
                  setShowCreateForm(false);
                  setCreateForm(initialCreateForm);
                  setError(null);
                }}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Search */}
      <div className="relative">
        <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
          <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <input
          type="text"
          className="w-full pl-11 pr-4 py-3 bg-white border border-gray-200 rounded-lg text-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-shadow"
          placeholder="Search by name, email, or ITS number..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {/* Edit Modal */}
      {editingUser && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-lg mx-4 max-h-[90vh] overflow-y-auto">
            <h2 className="text-lg font-semibold mb-4">
              Edit User: {editingUser.firstName} {editingUser.lastName}
            </h2>

            {editingUser.isExpired && (
              <div className="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">
                This user's account has expired and they cannot log in.
              </div>
            )}

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2">Roles</label>
                {editUserType === 'REGISTERED' ? (
                  <>
                    <div className="flex flex-wrap gap-2">
                      {availableRoles?.map((role) => (
                        <button
                          key={role.name}
                          type="button"
                          onClick={() => toggleRole(role.name)}
                          disabled={role.name === 'USER'}
                          className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                            editRoles.includes(role.name)
                              ? 'bg-blue-600 text-white border-blue-600'
                              : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-100'
                          } ${role.name === 'USER' ? 'opacity-75 cursor-not-allowed' : ''}`}
                          title={role.name === 'USER' ? 'User role is required' : role.description || ''}
                        >
                          {formatRoleName(role.name)}
                        </button>
                      ))}
                    </div>
                    <p className="text-xs text-gray-500 mt-1">User role is required and cannot be removed</p>
                  </>
                ) : (
                  <>
                    <div className="flex flex-wrap gap-2">
                      <span className="px-3 py-1 rounded-full text-sm bg-gray-100 text-gray-700 border border-gray-300">
                        User
                      </span>
                    </div>
                    <p className="text-xs text-gray-500 mt-1">
                      {editUserType === 'STUDENT' ? 'Students' : 'Mehmaan'} can only have the User role
                    </p>
                  </>
                )}
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

              <div className="border-t pt-4">
                <label className="block text-sm font-medium mb-2">User Type</label>
                <select
                  className="input"
                  value={editUserType}
                  onChange={(e) => {
                    const newType = e.target.value as UserType;
                    setEditUserType(newType);
                    // Clear expiration when switching to Registered
                    if (newType === 'REGISTERED') {
                      setEditExpiresAt('');
                    }
                    // Reset roles to just USER for Student/Mehmaan
                    if (newType !== 'REGISTERED') {
                      setEditRoles(['USER']);
                    }
                  }}
                >
                  <option value="REGISTERED">Registered (Permanent)</option>
                  <option value="STUDENT">Student (Temporary)</option>
                  <option value="MEHMAAN">Mehmaan (Guest)</option>
                </select>
              </div>

              {editUserType !== 'REGISTERED' && (
                <div>
                  <label className="block text-sm font-medium mb-2">Expires At</label>
                  <input
                    type="date"
                    className="input"
                    value={editExpiresAt}
                    onChange={(e) => setEditExpiresAt(e.target.value)}
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Leave empty for default: {getDefaultExpirationDate(editUserType)}
                  </p>
                </div>
              )}

              {editUserType !== 'REGISTERED' && (
                <div className="border-t pt-4">
                  <label className="block text-sm font-medium mb-2">Quick Actions</label>
                  <div className="flex flex-wrap gap-2">
                    <button
                      type="button"
                      onClick={() => extendByDays(30)}
                      className="px-3 py-1.5 bg-green-100 text-green-700 rounded text-sm hover:bg-green-200 transition-colors"
                      disabled={extendExpirationMutation.isPending}
                    >
                      +30 Days
                    </button>
                    <button
                      type="button"
                      onClick={() => extendByDays(60)}
                      className="px-3 py-1.5 bg-green-100 text-green-700 rounded text-sm hover:bg-green-200 transition-colors"
                      disabled={extendExpirationMutation.isPending}
                    >
                      +60 Days
                    </button>
                    <button
                      type="button"
                      onClick={handleConvertToRegistered}
                      className="px-3 py-1.5 bg-blue-100 text-blue-700 rounded text-sm hover:bg-blue-200 transition-colors"
                      disabled={convertToRegisteredMutation.isPending}
                    >
                      Convert to Registered
                    </button>
                  </div>
                  <p className="text-xs text-gray-500 mt-2">
                    Quick actions save immediately without needing to click Save Changes
                  </p>
                </div>
              )}
            </div>

            <div className="flex gap-2 mt-6">
              <button
                onClick={saveChanges}
                className="btn"
                disabled={updateRolesMutation.isPending || updateStatusMutation.isPending || updateUserTypeMutation.isPending}
              >
                {updateRolesMutation.isPending || updateStatusMutation.isPending || updateUserTypeMutation.isPending
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
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        {!filteredUsers || filteredUsers.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            {searchTerm ? 'No users match your search.' : 'No users found.'}
          </div>
        ) : (
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50 border-b border-gray-200">
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  User
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Contact
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Account
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Roles
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Zone
                </th>
                <th className="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredUsers.map((user, index) => (
                <tr
                  key={user.id}
                  className={`
                    ${user.isExpired ? 'bg-red-50' : index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}
                    hover:bg-blue-50/50 transition-colors
                  `}
                >
                  {/* User Info: Name + ITS */}
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white font-medium text-sm">
                        {user.firstName.charAt(0)}{user.lastName.charAt(0)}
                      </div>
                      <div>
                        <div className="font-medium text-gray-900">
                          {user.firstName} {user.lastName}
                        </div>
                        <div className="text-sm text-gray-500">
                          ITS: {user.itsNumber}
                        </div>
                      </div>
                    </div>
                  </td>

                  {/* Contact: Email + Phone */}
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-900">{user.email}</div>
                    {user.phone && (
                      <div className="text-sm text-gray-500">{user.phone}</div>
                    )}
                  </td>

                  {/* Account: Type + Status + Expiration */}
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1.5">
                      <div className="flex items-center gap-2">
                        <span className={`inline-flex px-2.5 py-1 rounded-full text-xs font-medium ${userTypeColors[user.userType]}`}>
                          {userTypeLabels[user.userType]}
                        </span>
                        <span className={`inline-flex px-2.5 py-1 rounded-full text-xs font-medium ${statusColors[user.accountStatus]}`}>
                          {statusLabels[user.accountStatus]}
                        </span>
                      </div>
                      {user.accountExpiresAt && (
                        <div className="text-xs">
                          {user.isExpired ? (
                            <span className="text-red-600 font-medium">Expired</span>
                          ) : (
                            <span className="text-gray-500">
                              Expires: {formatDate(user.accountExpiresAt)}
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  </td>

                  {/* Roles */}
                  <td className="px-6 py-4">
                    <div className="flex flex-wrap gap-1.5">
                      {user.roles.map((role) => (
                        <span
                          key={role}
                          className={`inline-flex px-2 py-0.5 rounded text-xs font-medium ${getRoleColor(role)}`}
                        >
                          {formatRoleName(role)}
                        </span>
                      ))}
                    </div>
                  </td>

                  {/* Zone */}
                  <td className="px-6 py-4">
                    <span className="text-sm text-gray-600">
                      {user.pickupZoneName ? (
                        user.pickupZoneName.length > 20
                          ? user.pickupZoneName.substring(0, 20) + '...'
                          : user.pickupZoneName
                      ) : (
                        <span className="text-gray-400">—</span>
                      )}
                    </span>
                  </td>

                  {/* Actions */}
                  <td className="px-6 py-4 text-right">
                    <button
                      onClick={() => startEdit(user)}
                      className="inline-flex items-center px-3 py-1.5 text-sm font-medium text-blue-600 hover:text-blue-800 hover:bg-blue-100 rounded-md transition-colors"
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
