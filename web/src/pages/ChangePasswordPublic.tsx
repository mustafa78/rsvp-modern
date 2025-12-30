import { useState } from 'react';
import { api } from '../api/client';

export default function ChangePasswordPublic() {
  const [itsNumber, setItsNumber] = useState('');
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [msg, setMsg] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    setSuccess(false);

    if (newPassword !== confirmPassword) {
      setMsg('New passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      setMsg('New password must be at least 6 characters');
      return;
    }

    setLoading(true);
    try {
      await api.changePasswordUnauthenticated(itsNumber, currentPassword, newPassword);
      setSuccess(true);
      setMsg('Password updated successfully! You can now login with your new password.');
      setItsNumber('');
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    } catch (e: any) {
      let errorMsg = 'Failed to change password';
      try {
        const parsed = JSON.parse(e.message);
        if (parsed.error === 'invalid_credentials') {
          errorMsg = 'Invalid ITS number or current password';
        } else if (parsed.error) {
          errorMsg = parsed.error;
        }
      } catch {
        if (e.message && !e.message.startsWith('{')) {
          errorMsg = e.message;
        }
      }
      setMsg(errorMsg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-2">Change Password</h1>
      <p className="text-gray-600 text-sm mb-4">
        Enter your ITS number and current password to set a new password.
      </p>
      <form onSubmit={onSubmit} className="space-y-3">
        <input
          className="border rounded px-3 py-2 w-full"
          placeholder="ITS Number"
          value={itsNumber}
          onChange={e => setItsNumber(e.target.value)}
          required
        />
        <input
          className="border rounded px-3 py-2 w-full"
          type="password"
          placeholder="Current Password"
          value={currentPassword}
          onChange={e => setCurrentPassword(e.target.value)}
          required
        />
        <input
          className="border rounded px-3 py-2 w-full"
          type="password"
          placeholder="New Password"
          value={newPassword}
          onChange={e => setNewPassword(e.target.value)}
          required
        />
        <input
          className="border rounded px-3 py-2 w-full"
          type="password"
          placeholder="Confirm New Password"
          value={confirmPassword}
          onChange={e => setConfirmPassword(e.target.value)}
          required
        />
        <button
          className="bg-black text-white rounded px-4 py-2 w-full"
          disabled={loading}
        >
          {loading ? 'Please wait...' : 'Change Password'}
        </button>
      </form>
      <div className="mt-4 text-sm">
        <a href="/login" className="text-blue-600 hover:underline">← Back to Login</a>
      </div>
      {msg && (
        <div className={`mt-4 text-sm ${success ? 'text-green-600' : 'text-red-600'}`}>
          {msg}
        </div>
      )}
    </div>
  );
}
