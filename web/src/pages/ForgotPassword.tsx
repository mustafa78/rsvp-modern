import { useState } from 'react';
import { api } from '../api/client';

export default function ForgotPassword() {
  const [id, setId] = useState('');
  const [msg, setMsg] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    try {
      await api.requestReset(id);
      setMsg('If the account exists, a reset link has been sent.');
    } catch (e: any) {
      setMsg(e.message || 'Failed');
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-4">Forgot password</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="border rounded px-3 py-2 w-full" placeholder="ITS Number or Email"
               value={id} onChange={e => setId(e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2">Send reset link</button>
      </form>
      {msg && <div className="mt-4 text-sm">{msg}</div>}
    </div>
  );
}
