import { useState, useEffect } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../api/client';

type Profile = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string | null;
  roles: string[];
  pickupZoneId: number | null;
  pickupZoneName: string | null;
  userType: string;
  isHof: boolean;
  lastLoginAt: string | null;
  createdAt: string | null;
};

type PickupZone = {
  id: number;
  name: string;
};

type NiyazRsvpHistoryItem = {
  rsvpId: number;
  eventId: number;
  eventTitle: string;
  eventDate: string;
  eventStatus: string;
  adults: number;
  kids: number;
  notes: string | null;
};

type ThaaliOrderHistoryItem = {
  orderId: number;
  eventId: number;
  eventTitle: string;
  eventDate: string;
  eventStatus: string;
  pickupZoneName: string | null;
  items: { dishName: string; size: string }[];
  notes: string | null;
};

type RsvpHistory = {
  niyazRsvps: NiyazRsvpHistoryItem[];
  thaaliOrders: ThaaliOrderHistoryItem[];
};

function formatPhoneNumber(value: string): string {
  const digits = value.replace(/\D/g, '');
  const limited = digits.slice(0, 10);
  if (limited.length === 0) return '';
  if (limited.length <= 3) return `(${limited}`;
  if (limited.length <= 6) return `(${limited.slice(0, 3)}) ${limited.slice(3)}`;
  return `(${limited.slice(0, 3)}) ${limited.slice(3, 6)}-${limited.slice(6)}`;
}

function formatDate(dateString: string | null): string {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
}

function formatDateTime(dateString: string | null): string {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  });
}

export default function ProfilePage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const queryClient = useQueryClient();
  const initialTab = searchParams.get('tab') || 'profile';
  const [activeTab, setActiveTab] = useState(initialTab);

  // Profile form state
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [pickupZoneId, setPickupZoneId] = useState<number | null>(null);
  const [profileMsg, setProfileMsg] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  // Password form state
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordMsg, setPasswordMsg] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  // Fetch profile
  const { data: profile, isLoading: profileLoading } = useQuery<Profile>({
    queryKey: ['profile'],
    queryFn: async () => (await api.get('/profile')).data,
  });

  // Fetch pickup zones
  const { data: pickupZones } = useQuery<PickupZone[]>({
    queryKey: ['profile-pickup-zones'],
    queryFn: async () => (await api.get('/profile/pickup-zones')).data,
  });

  // Fetch RSVP history
  const { data: rsvpHistory, isLoading: historyLoading } = useQuery<RsvpHistory>({
    queryKey: ['rsvp-history'],
    queryFn: async () => (await api.get('/profile/rsvp-history')).data,
  });

  // Initialize form when profile loads
  useEffect(() => {
    if (profile) {
      setEmail(profile.email || '');
      setPhone(profile.phone ? formatPhoneNumber(profile.phone) : '');
      setPickupZoneId(profile.pickupZoneId);
    }
  }, [profile]);

  // Update profile mutation
  const updateProfileMutation = useMutation({
    mutationFn: async (data: { email: string; phone: string | null; pickupZoneId: number | null }) =>
      (await api.put('/profile', data)).data,
    onSuccess: () => {
      setProfileMsg({ type: 'success', text: 'Profile updated successfully!' });
      queryClient.invalidateQueries({ queryKey: ['profile'] });
      queryClient.invalidateQueries({ queryKey: ['me'] });
    },
    onError: (error: Error) => {
      setProfileMsg({ type: 'error', text: error.message || 'Failed to update profile' });
    },
  });

  // Change password mutation
  const changePasswordMutation = useMutation({
    mutationFn: async (data: { currentPassword: string; newPassword: string }) =>
      (await api.post('/profile/change-password', data)).data,
    onSuccess: () => {
      setPasswordMsg({ type: 'success', text: 'Password changed successfully!' });
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    },
    onError: (error: Error) => {
      let msg = 'Failed to change password';
      try {
        const parsed = JSON.parse(error.message);
        msg = parsed.error || msg;
      } catch {
        msg = error.message || msg;
      }
      setPasswordMsg({ type: 'error', text: msg });
    },
  });

  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
    setSearchParams(tab === 'profile' ? {} : { tab });
  };

  const handleProfileSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setProfileMsg(null);
    updateProfileMutation.mutate({
      email,
      phone: phone || null,
      pickupZoneId,
    });
  };

  const handlePasswordSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setPasswordMsg(null);

    if (newPassword !== confirmPassword) {
      setPasswordMsg({ type: 'error', text: 'New passwords do not match' });
      return;
    }

    if (newPassword.length < 7) {
      setPasswordMsg({ type: 'error', text: 'Password must be at least 7 characters' });
      return;
    }

    changePasswordMutation.mutate({ currentPassword, newPassword });
  };

  if (profileLoading) {
    return (
      <div className="min-h-[60vh] flex items-center justify-center">
        <div className="text-gray-500">Loading...</div>
      </div>
    );
  }

  const tabs = [
    { id: 'profile', label: 'Profile', icon: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z' },
    { id: 'security', label: 'Security', icon: 'M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z' },
    { id: 'preferences', label: 'Preferences', icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z M15 12a3 3 0 11-6 0 3 3 0 016 0z' },
    { id: 'history', label: 'RSVP History', icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' },
  ];

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-4 mb-4">
          <div className="w-16 h-16 rounded-full bg-gradient-to-br from-purple-600 to-blue-600 flex items-center justify-center">
            <span className="text-2xl font-bold text-white">
              {profile?.firstName?.charAt(0)}{profile?.lastName?.charAt(0)}
            </span>
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {profile?.firstName} {profile?.lastName}
            </h1>
            <p className="text-gray-500">ITS: {profile?.itsNumber}</p>
            <div className="flex items-center gap-2 mt-1">
              <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
                profile?.userType === 'REGISTERED' ? 'bg-green-100 text-green-800' :
                profile?.userType === 'STUDENT' ? 'bg-blue-100 text-blue-800' :
                'bg-amber-100 text-amber-800'
              }`}>
                {profile?.userType}
              </span>
              {profile?.isHof && (
                <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-purple-100 text-purple-800">
                  Head of Family
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="border-b border-gray-200 mb-6">
        <nav className="flex gap-4 -mb-px">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => handleTabChange(tab.id)}
              className={`flex items-center gap-2 px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
                activeTab === tab.id
                  ? 'border-purple-600 text-purple-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={tab.icon} />
              </svg>
              {tab.label}
            </button>
          ))}
        </nav>
      </div>

      {/* Tab Content */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200">
        {/* Profile Tab */}
        {activeTab === 'profile' && (
          <div className="p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">Personal Information</h2>

            {profileMsg && (
              <div className={`mb-6 p-4 rounded-lg text-sm ${
                profileMsg.type === 'success'
                  ? 'bg-green-50 text-green-700 border border-green-200'
                  : 'bg-red-50 text-red-700 border border-red-200'
              }`}>
                {profileMsg.text}
              </div>
            )}

            <form onSubmit={handleProfileSubmit} className="space-y-6">
              {/* Read-only fields */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                  <input
                    type="text"
                    value={profile?.firstName || ''}
                    disabled
                    className="w-full px-4 py-2 border border-gray-200 rounded-lg bg-gray-50 text-gray-500"
                  />
                  <p className="mt-1 text-xs text-gray-400">Contact admin to update</p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                  <input
                    type="text"
                    value={profile?.lastName || ''}
                    disabled
                    className="w-full px-4 py-2 border border-gray-200 rounded-lg bg-gray-50 text-gray-500"
                  />
                  <p className="mt-1 text-xs text-gray-400">Contact admin to update</p>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">ITS Number</label>
                <input
                  type="text"
                  value={profile?.itsNumber || ''}
                  disabled
                  className="w-full px-4 py-2 border border-gray-200 rounded-lg bg-gray-50 text-gray-500"
                />
              </div>

              {/* Editable fields */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email <span className="text-red-500">*</span>
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(formatPhoneNumber(e.target.value))}
                  placeholder="(555) 123-4567"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                />
              </div>

              {/* Account Info */}
              <div className="pt-4 border-t border-gray-200">
                <h3 className="text-sm font-medium text-gray-700 mb-4">Account Information</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-gray-500">Member Since:</span>
                    <span className="ml-2 text-gray-900">{formatDate(profile?.createdAt || null)}</span>
                  </div>
                  <div>
                    <span className="text-gray-500">Last Login:</span>
                    <span className="ml-2 text-gray-900">{formatDateTime(profile?.lastLoginAt || null)}</span>
                  </div>
                </div>
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={updateProfileMutation.isPending}
                  className="px-6 py-2 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 disabled:opacity-50 transition-colors"
                >
                  {updateProfileMutation.isPending ? 'Saving...' : 'Save Changes'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Security Tab */}
        {activeTab === 'security' && (
          <div className="p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">Change Password</h2>

            {passwordMsg && (
              <div className={`mb-6 p-4 rounded-lg text-sm ${
                passwordMsg.type === 'success'
                  ? 'bg-green-50 text-green-700 border border-green-200'
                  : 'bg-red-50 text-red-700 border border-red-200'
              }`}>
                {passwordMsg.text}
              </div>
            )}

            <form onSubmit={handlePasswordSubmit} className="space-y-6 max-w-md">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Current Password <span className="text-red-500">*</span>
                </label>
                <input
                  type="password"
                  value={currentPassword}
                  onChange={(e) => setCurrentPassword(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  New Password <span className="text-red-500">*</span>
                </label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  required
                  minLength={7}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                />
                <p className="mt-1 text-xs text-gray-500">Minimum 7 characters</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Confirm New Password <span className="text-red-500">*</span>
                </label>
                <input
                  type="password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                />
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={changePasswordMutation.isPending}
                  className="px-6 py-2 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 disabled:opacity-50 transition-colors"
                >
                  {changePasswordMutation.isPending ? 'Changing...' : 'Change Password'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Preferences Tab */}
        {activeTab === 'preferences' && (
          <div className="p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">Preferences</h2>

            {profileMsg && (
              <div className={`mb-6 p-4 rounded-lg text-sm ${
                profileMsg.type === 'success'
                  ? 'bg-green-50 text-green-700 border border-green-200'
                  : 'bg-red-50 text-red-700 border border-red-200'
              }`}>
                {profileMsg.text}
              </div>
            )}

            <form onSubmit={handleProfileSubmit} className="space-y-6 max-w-md">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Default Pickup Zone
                </label>
                <select
                  value={pickupZoneId || ''}
                  onChange={(e) => setPickupZoneId(e.target.value ? Number(e.target.value) : null)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Select a pickup zone</option>
                  {pickupZones?.map((zone) => (
                    <option key={zone.id} value={zone.id}>
                      {zone.name}
                    </option>
                  ))}
                </select>
                <p className="mt-1 text-xs text-gray-500">
                  This will be pre-selected when you register for Thaali events
                </p>
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={updateProfileMutation.isPending}
                  className="px-6 py-2 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 disabled:opacity-50 transition-colors"
                >
                  {updateProfileMutation.isPending ? 'Saving...' : 'Save Preferences'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* RSVP History Tab */}
        {activeTab === 'history' && (
          <div className="p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">RSVP History</h2>

            {historyLoading ? (
              <div className="text-center py-8 text-gray-500">Loading history...</div>
            ) : (
              <div className="space-y-8">
                {/* Niyaz RSVPs */}
                <div>
                  <h3 className="text-md font-semibold text-purple-700 mb-4 flex items-center gap-2">
                    <span className="w-3 h-3 rounded-full bg-purple-600"></span>
                    Niyaz Events ({rsvpHistory?.niyazRsvps?.length || 0})
                  </h3>
                  {rsvpHistory?.niyazRsvps?.length === 0 ? (
                    <p className="text-gray-500 text-sm">No Niyaz RSVPs yet</p>
                  ) : (
                    <div className="space-y-3">
                      {rsvpHistory?.niyazRsvps?.map((rsvp) => (
                        <Link
                          key={rsvp.rsvpId}
                          to={`/events/${rsvp.eventId}`}
                          className="block p-4 border border-gray-200 rounded-lg hover:border-purple-300 hover:shadow-sm transition-all"
                        >
                          <div className="flex justify-between items-start">
                            <div>
                              <p className="font-medium text-gray-900">{rsvp.eventTitle}</p>
                              <p className="text-sm text-gray-500">{formatDate(rsvp.eventDate)}</p>
                            </div>
                            <span className={`px-2 py-0.5 rounded text-xs font-medium ${
                              rsvp.eventStatus === 'PUBLISHED' ? 'bg-green-100 text-green-800' :
                              rsvp.eventStatus === 'CANCELLED' ? 'bg-red-100 text-red-800' :
                              'bg-gray-100 text-gray-800'
                            }`}>
                              {rsvp.eventStatus}
                            </span>
                          </div>
                          <div className="mt-2 text-sm text-gray-600">
                            <span className="font-medium">{rsvp.adults}</span> adults,{' '}
                            <span className="font-medium">{rsvp.kids}</span> kids
                          </div>
                        </Link>
                      ))}
                    </div>
                  )}
                </div>

                {/* Thaali Orders */}
                <div>
                  <h3 className="text-md font-semibold text-blue-700 mb-4 flex items-center gap-2">
                    <span className="w-3 h-3 rounded-full bg-blue-600"></span>
                    Thaali Orders ({rsvpHistory?.thaaliOrders?.length || 0})
                  </h3>
                  {rsvpHistory?.thaaliOrders?.length === 0 ? (
                    <p className="text-gray-500 text-sm">No Thaali orders yet</p>
                  ) : (
                    <div className="space-y-3">
                      {rsvpHistory?.thaaliOrders?.map((order) => (
                        <Link
                          key={order.orderId}
                          to={`/events/${order.eventId}`}
                          className="block p-4 border border-gray-200 rounded-lg hover:border-blue-300 hover:shadow-sm transition-all"
                        >
                          <div className="flex justify-between items-start">
                            <div>
                              <p className="font-medium text-gray-900">{order.eventTitle}</p>
                              <p className="text-sm text-gray-500">{formatDate(order.eventDate)}</p>
                            </div>
                            <span className={`px-2 py-0.5 rounded text-xs font-medium ${
                              order.eventStatus === 'PUBLISHED' ? 'bg-green-100 text-green-800' :
                              order.eventStatus === 'CANCELLED' ? 'bg-red-100 text-red-800' :
                              'bg-gray-100 text-gray-800'
                            }`}>
                              {order.eventStatus}
                            </span>
                          </div>
                          <div className="mt-2 text-sm text-gray-600">
                            {order.items.map((item, idx) => (
                              <span key={idx}>
                                {item.dishName} ({item.size})
                                {idx < order.items.length - 1 && ', '}
                              </span>
                            ))}
                          </div>
                          {order.pickupZoneName && (
                            <p className="mt-1 text-xs text-gray-400">
                              Pickup: {order.pickupZoneName}
                            </p>
                          )}
                        </Link>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
