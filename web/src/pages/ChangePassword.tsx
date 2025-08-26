import { useState } from 'react';
import { api } from '../api/client';

export default function ChangePassword() {
  const [currentPassword, setCurrent] = useState('');
  const [newPassword, setNew] = useState('');
  const [msg, setMsg] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    try {
      await api.changePassword(currentPassword, newPassword);
      setMsg('Password updated.');
    } catch (e: any) {
      setMsg(e.message || 'Failed');
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-4">Change password</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="border rounded px-3 py-2 w-full" type="password" placeholder="Current password"
               value={currentPassword} onChange={e => setCurrent(e.target.value)} />
        <input className="border rounded px-3 py-2 w-full" type="password" placeholder="New password"
               value={newPassword} onChange={e => setNew(e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2">Update</button>
      </form>
      {msg && <div className="mt-4 text-sm">{msg}</div>}
    </div>
  );
}
