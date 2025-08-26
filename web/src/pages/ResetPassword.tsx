import { useEffect, useState } from 'react';
import { api } from '../api/client';

export default function ResetPassword() {
  const [token, setToken] = useState('');
  const [password, setPassword] = useState('');
  const [msg, setMsg] = useState<string | null>(null);

  useEffect(() => {
    const url = new URL(window.location.href);
    setToken(url.searchParams.get('token') || '');
  }, []);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    try {
      await api.confirmReset(token, password);
      setMsg('Password reset. You can login now.');
    } catch (e: any) {
      setMsg(e.message || 'Failed');
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-4">Set a new password</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="border rounded px-3 py-2 w-full" placeholder="Reset token" value={token}
               onChange={e => setToken(e.target.value)} />
        <input className="border rounded px-3 py-2 w-full" type="password" placeholder="New password"
               value={password} onChange={e => setPassword(e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2">Update password</button>
      </form>
      {msg && <div className="mt-4 text-sm">{msg}</div>}
    </div>
  );
}
