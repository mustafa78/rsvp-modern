import { useState, useRef } from 'react';
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
  isHof: boolean;
  pickupZoneId: number | null;
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

type FormData = {
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  password: string;
  pickupZoneId: string;
  roles: string[];
  userType: UserType;
  accountExpiresAt: string;
  accountStatus: AccountStatus;
  isHof: boolean;
};

const initialFormData: FormData = {
  itsNumber: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  password: '',
  pickupZoneId: '',
  roles: ['USER'],
  userType: 'REGISTERED',
  accountExpiresAt: '',
  accountStatus: 'ACTIVE',
  isHof: true,
};

export default function UserList() {
  const [editingUserId, setEditingUserId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState<FormData>(initialFormData);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const queryClient = useQueryClient();
  const formRef = useRef<HTMLDivElement>(null);

  const isEditing = editingUserId !== null;

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
    mutationFn: async (data: FormData) => {
      const payload = {
        itsNumber: data.itsNumber,
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        phone: data.phone || null,
        password: data.password,
        pickupZoneId: data.pickupZoneId ? Number(data.pickupZoneId) : null,
        roles: data.roles,
        userType: data.userType,
        accountExpiresAt: data.accountExpiresAt ? new Date(data.accountExpiresAt).toISOString() : null,
        isHof: data.isHof,
      };
      return api.post('/admin/users', payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      resetForm();
    },
    onError: (err: any) => setError(err.message),
  });

  const updateUserInfoMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: FormData }) =>
      api.put(`/admin/users/${id}/info`, {
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        phone: data.phone || null,
        pickupZoneId: data.pickupZoneId ? Number(data.pickupZoneId) : null,
        isHof: data.isHof,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
    },
    onError: (err: any) => setError(err.message),
  });

  const updateRolesMutation = useMutation({
    mutationFn: async ({ id, roles }: { id: number; roles: string[] }) =>
      api.put(`/admin/users/${id}/roles`, { roles }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
    },
    onError: (err: any) => setError(err.message),
  });

  const updateStatusMutation = useMutation({
    mutationFn: async ({ id, status }: { id: number; status: AccountStatus }) =>
      api.put(`/admin/users/${id}/status`, { status }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
    },
    onError: (err: any) => setError(err.message),
  });

  const updateUserTypeMutation = useMutation({
    mutationFn: async ({ id, userType, accountExpiresAt }: { id: number; userType: UserType; accountExpiresAt: string | null }) =>
      api.put(`/admin/users/${id}/user-type`, {
        userType,
        accountExpiresAt: accountExpiresAt ? new Date(accountExpiresAt).toISOString() : null,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
    },
    onError: (err: any) => setError(err.message),
  });

  const extendExpirationMutation = useMutation({
    mutationFn: async ({ id, newExpiresAt }: { id: number; newExpiresAt: string }) =>
      api.put(`/admin/users/${id}/extend`, { newExpiresAt: new Date(newExpiresAt).toISOString() }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      resetForm();
    },
    onError: (err: any) => setError(err.message),
  });

  const convertToRegisteredMutation = useMutation({
    mutationFn: async (id: number) =>
      api.post(`/admin/users/${id}/convert-to-registered`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] });
      resetForm();
    },
    onError: (err: any) => setError(err.message),
  });

  const resetForm = () => {
    setShowForm(false);
    setEditingUserId(null);
    setFormData(initialFormData);
    setError(null);
  };

  const startCreate = () => {
    setEditingUserId(null);
    setFormData(initialFormData);
    setShowForm(true);
    setError(null);
  };

  const startEdit = (user: User) => {
    setEditingUserId(user.id);
    setFormData({
      itsNumber: user.itsNumber,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone || '',
      password: '', // Not used for editing
      pickupZoneId: user.pickupZoneId ? String(user.pickupZoneId) : '',
      roles: user.userType !== 'REGISTERED' ? ['USER'] : [...user.roles],
      userType: user.userType || 'REGISTERED',
      accountExpiresAt: user.accountExpiresAt ? user.accountExpiresAt.split('T')[0] : '',
      accountStatus: user.accountStatus,
      isHof: user.isHof,
    });
    setShowForm(true);
    setError(null);
    // Scroll to form after state update
    setTimeout(() => {
      formRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 0);
  };

  const handleUserTypeChange = (newType: UserType) => {
    setFormData({
      ...formData,
      userType: newType,
      // Clear expiration when switching to Registered
      accountExpiresAt: newType === 'REGISTERED' ? '' : formData.accountExpiresAt,
      // Reset roles to just USER for Student/Mehmaan
      roles: newType === 'REGISTERED' ? formData.roles : ['USER'],
    });
  };

  const toggleRole = (role: string) => {
    if (role === 'USER') return; // USER role is required
    if (formData.roles.includes(role)) {
      setFormData({ ...formData, roles: formData.roles.filter((r) => r !== role) });
    } else {
      setFormData({ ...formData, roles: [...formData.roles, role] });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (isEditing && editingUserId) {
      // Get original user data for comparison
      const originalUser = users?.find(u => u.id === editingUserId);
      if (!originalUser) return;

      const promises: Promise<any>[] = [];

      // Check what changed and call appropriate endpoints
      const infoChanged =
        formData.firstName !== originalUser.firstName ||
        formData.lastName !== originalUser.lastName ||
        formData.email !== originalUser.email ||
        formData.phone !== (originalUser.phone || '') ||
        formData.pickupZoneId !== (originalUser.pickupZoneId ? String(originalUser.pickupZoneId) : '') ||
        formData.isHof !== originalUser.isHof;

      const rolesChanged = JSON.stringify([...formData.roles].sort()) !== JSON.stringify([...originalUser.roles].sort());
      const statusChanged = formData.accountStatus !== originalUser.accountStatus;
      const userTypeChanged = formData.userType !== originalUser.userType;
      const expiresAtChanged = formData.accountExpiresAt !== (originalUser.accountExpiresAt?.split('T')[0] || '');

      if (infoChanged) {
        promises.push(updateUserInfoMutation.mutateAsync({ id: editingUserId, data: formData }));
      }
      if (rolesChanged) {
        promises.push(updateRolesMutation.mutateAsync({ id: editingUserId, roles: formData.roles }));
      }
      if (statusChanged) {
        promises.push(updateStatusMutation.mutateAsync({ id: editingUserId, status: formData.accountStatus }));
      }
      if (userTypeChanged || expiresAtChanged) {
        promises.push(updateUserTypeMutation.mutateAsync({
          id: editingUserId,
          userType: formData.userType,
          accountExpiresAt: formData.accountExpiresAt || null,
        }));
      }

      if (promises.length > 0) {
        try {
          await Promise.all(promises);
          resetForm();
        } catch {
          // Error is handled by individual mutations
        }
      } else {
        resetForm();
      }
    } else {
      createUserMutation.mutate(formData);
    }
  };

  const extendByDays = (days: number) => {
    if (!editingUserId) return;
    const newDate = new Date();
    newDate.setDate(newDate.getDate() + days);
    extendExpirationMutation.mutate({
      id: editingUserId,
      newExpiresAt: newDate.toISOString().split('T')[0],
    });
  };

  const handleConvertToRegistered = () => {
    if (!editingUserId) return;
    convertToRegisteredMutation.mutate(editingUserId);
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

  const isSaving = createUserMutation.isPending ||
    updateUserInfoMutation.isPending ||
    updateRolesMutation.isPending ||
    updateStatusMutation.isPending ||
    updateUserTypeMutation.isPending;

  // Get original user for showing expired warning
  const editingUser = editingUserId ? users?.find(u => u.id === editingUserId) : null;

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
          {!showForm && (
            <button
              onClick={startCreate}
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

      {error && !showForm && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">{error}</div>
      )}

      {/* Create/Edit User Form */}
      {showForm && (
        <div ref={formRef} className="card">
          <h2 className="text-lg font-semibold mb-4">
            {isEditing ? `Edit User: ${editingUser?.firstName} ${editingUser?.lastName}` : 'Create New User'}
          </h2>

          {error && (
            <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4">{error}</div>
          )}

          {isEditing && editingUser?.isExpired && (
            <div className="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">
              This user's account has expired and they cannot log in.
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            {/* ITS Number and Email - ITS only for create */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">ITS Number *</label>
                {isEditing ? (
                  <div className="input bg-gray-50 text-gray-600">{formData.itsNumber}</div>
                ) : (
                  <input
                    className="input"
                    value={formData.itsNumber}
                    onChange={(e) => setFormData({ ...formData, itsNumber: e.target.value })}
                    placeholder="e.g., 30702040"
                    required
                  />
                )}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Email *</label>
                <input
                  type="email"
                  className="input"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="user@example.com"
                  required
                />
              </div>
            </div>

            {/* First Name and Last Name */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">First Name *</label>
                <input
                  className="input"
                  value={formData.firstName}
                  onChange={(e) => setFormData({ ...formData, firstName: e.target.value })}
                  placeholder="First name"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Last Name *</label>
                <input
                  className="input"
                  value={formData.lastName}
                  onChange={(e) => setFormData({ ...formData, lastName: e.target.value })}
                  placeholder="Last name"
                  required
                />
              </div>
            </div>

            {/* Phone and Password */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Phone</label>
                <input
                  className="input"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="(555) 123-4567"
                />
              </div>
              {!isEditing && (
                <div>
                  <label className="block text-sm font-medium mb-1">Password *</label>
                  <input
                    type="password"
                    className="input"
                    value={formData.password}
                    onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                    placeholder="Initial password"
                    required
                  />
                </div>
              )}
              {isEditing && (
                <div>
                  <label className="block text-sm font-medium mb-1">Account Status</label>
                  <select
                    className="input"
                    value={formData.accountStatus}
                    onChange={(e) => setFormData({ ...formData, accountStatus: e.target.value as AccountStatus })}
                  >
                    <option value="ACTIVE">Active</option>
                    <option value="LOCKED">Locked</option>
                    <option value="DISABLED">Disabled</option>
                  </select>
                </div>
              )}
            </div>

            {/* User Type and Expires At */}
            <div className={`grid gap-4 ${formData.userType === 'REGISTERED' ? 'grid-cols-1' : 'grid-cols-2'}`}>
              <div>
                <label className="block text-sm font-medium mb-1">User Type *</label>
                <select
                  className="input"
                  value={formData.userType}
                  onChange={(e) => handleUserTypeChange(e.target.value as UserType)}
                >
                  <option value="REGISTERED">Registered (Permanent)</option>
                  <option value="STUDENT">Student (60 days default)</option>
                  <option value="MEHMAAN">Mehmaan (30 days default)</option>
                </select>
                <p className="text-xs text-gray-500 mt-1">
                  {formData.userType === 'REGISTERED' && 'Permanent member with no expiration'}
                  {formData.userType === 'STUDENT' && 'Temporary access - expires in 60 days by default'}
                  {formData.userType === 'MEHMAAN' && 'Guest access - expires in 30 days by default'}
                </p>
              </div>
              {formData.userType !== 'REGISTERED' && (
                <div>
                  <label className="block text-sm font-medium mb-1">Expires At</label>
                  <input
                    type="date"
                    className="input"
                    value={formData.accountExpiresAt}
                    onChange={(e) => setFormData({ ...formData, accountExpiresAt: e.target.value })}
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Leave empty for default: {getDefaultExpirationDate(formData.userType)}
                  </p>
                </div>
              )}
            </div>

            {/* Head of Family Checkbox */}
            <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
              <label className="flex items-start gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  className="mt-1 h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  checked={formData.isHof}
                  onChange={(e) => setFormData({
                    ...formData,
                    isHof: e.target.checked,
                    // Clear pickup zone when HOF is unchecked
                    pickupZoneId: e.target.checked ? formData.pickupZoneId : '',
                  })}
                />
                <div>
                  <span className="font-medium text-gray-900">Head of Family (HOF)</span>
                  <p className="text-sm text-gray-600 mt-0.5">
                    HOF users can RSVP for events and register for thaalis. Non-HOF users are operational staff
                    who only have access to the Admin panel based on their assigned roles.
                  </p>
                </div>
              </label>
            </div>

            {/* Quick Actions for Student/Mehmaan (Edit mode only) */}
            {isEditing && formData.userType !== 'REGISTERED' && (
              <div className="bg-gray-50 rounded-lg p-4">
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
                  Quick actions save immediately without needing to click Save
                </p>
              </div>
            )}

            {/* Pickup Zone (only for HOF users) and Roles */}
            <div className={`grid gap-4 ${formData.isHof ? 'grid-cols-2' : 'grid-cols-1'}`}>
              {formData.isHof && (
                <div>
                  <label className="block text-sm font-medium mb-1">Pickup Zone</label>
                  <select
                    className="input"
                    value={formData.pickupZoneId}
                    onChange={(e) => setFormData({ ...formData, pickupZoneId: e.target.value })}
                  >
                    <option value="">-- No zone --</option>
                    {zones?.filter(z => z.active).map((zone) => (
                      <option key={zone.id} value={zone.id}>{zone.name}</option>
                    ))}
                  </select>
                  <p className="text-xs text-gray-500 mt-1">Required for thaali registration</p>
                </div>
              )}
              <div>
                <label className="block text-sm font-medium mb-1">Roles</label>
                {formData.userType === 'REGISTERED' ? (
                  <>
                    <div className="flex flex-wrap gap-2 mt-1">
                      {availableRoles?.map((role) => (
                        <button
                          key={role.name}
                          type="button"
                          onClick={() => toggleRole(role.name)}
                          disabled={role.name === 'USER'}
                          className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                            formData.roles.includes(role.name)
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
                      {formData.userType === 'STUDENT' ? 'Students' : 'Mehmaan'} can only have the User role
                    </p>
                  </>
                )}
              </div>
            </div>

            {/* Form Actions */}
            <div className="flex gap-2 pt-4">
              <button
                type="submit"
                className="btn"
                disabled={isSaving}
              >
                {isSaving ? 'Saving...' : (isEditing ? 'Save Changes' : 'Create User')}
              </button>
              <button
                type="button"
                className="btn bg-gray-500"
                onClick={resetForm}
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

      {/* Users Table */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-x-auto">
        {!filteredUsers || filteredUsers.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            {searchTerm ? 'No users match your search.' : 'No users found.'}
          </div>
        ) : (
          <table className="w-full table-fixed">
            <thead>
              <tr className="bg-gray-50 border-b border-gray-200">
                <th className="w-[20%] px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  User
                </th>
                <th className="w-[18%] px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Contact
                </th>
                <th className="w-[16%] px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Account
                </th>
                <th className="w-[6%] px-4 py-3 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  HOF
                </th>
                <th className="w-[15%] px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Roles
                </th>
                <th className="w-[17%] px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Zone
                </th>
                <th className="w-[8%] px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">
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
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-2">
                      <div className="w-9 h-9 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white font-medium text-xs flex-shrink-0">
                        {user.firstName.charAt(0)}{user.lastName.charAt(0)}
                      </div>
                      <div>
                        <div className="font-medium text-gray-900">
                          {user.firstName} {user.lastName}
                        </div>
                        <div className="text-xs text-gray-500">
                          {user.itsNumber}
                        </div>
                      </div>
                    </div>
                  </td>

                  {/* Contact: Email + Phone */}
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900 truncate" title={user.email}>{user.email}</div>
                    {user.phone && (
                      <div className="text-xs text-gray-500">{user.phone}</div>
                    )}
                  </td>

                  {/* Account: Type + Status + Expiration */}
                  <td className="px-4 py-3">
                    <div className="flex flex-col gap-1">
                      <div className="flex flex-wrap items-center gap-1">
                        <span className={`inline-flex px-2 py-0.5 rounded-full text-xs font-medium ${userTypeColors[user.userType]}`}>
                          {userTypeLabels[user.userType]}
                        </span>
                        <span className={`inline-flex px-2 py-0.5 rounded-full text-xs font-medium ${statusColors[user.accountStatus]}`}>
                          {statusLabels[user.accountStatus]}
                        </span>
                      </div>
                      {user.accountExpiresAt && (
                        <div className="text-xs">
                          {user.isExpired ? (
                            <span className="text-red-600 font-medium">Expired</span>
                          ) : (
                            <span className="text-gray-500">
                              {formatDate(user.accountExpiresAt)}
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  </td>

                  {/* HOF Status */}
                  <td className="px-4 py-3 text-center">
                    {user.isHof ? (
                      <span className="inline-flex items-center justify-center w-6 h-6 rounded-full bg-green-100 text-green-600">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                        </svg>
                      </span>
                    ) : (
                      <span className="inline-flex items-center justify-center w-6 h-6 rounded-full bg-gray-100 text-gray-400">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                      </span>
                    )}
                  </td>

                  {/* Roles */}
                  <td className="px-4 py-3">
                    <div className="flex flex-wrap gap-1">
                      {user.roles.map((role) => (
                        <span
                          key={role}
                          className={`inline-flex px-1.5 py-0.5 rounded text-xs font-medium ${getRoleColor(role)}`}
                        >
                          {formatRoleName(role)}
                        </span>
                      ))}
                    </div>
                  </td>

                  {/* Zone */}
                  <td className="px-4 py-3">
                    {user.pickupZoneName ? (
                      <span className="text-sm text-gray-600 truncate block" title={user.pickupZoneName}>
                        {user.pickupZoneName}
                      </span>
                    ) : (
                      <span className="text-gray-400">—</span>
                    )}
                  </td>

                  {/* Actions */}
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => startEdit(user)}
                      className="text-sm font-medium text-blue-600 hover:text-blue-800"
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
