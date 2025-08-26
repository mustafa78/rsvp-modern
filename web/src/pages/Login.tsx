import { useState } from 'react';
import { api } from '../api/client';

export default function Login() {
  const [its, setIts] = useState('');
  const [password, setPassword] = useState('');
  const [msg, setMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setMsg(null);
    try {
      await api.login(its, password);
      setMsg('Logged in!');
      window.location.href = '/';
    } catch (e: any) {
      setMsg(e.message || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-4">Login</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="border rounded px-3 py-2 w-full" placeholder="ITS Number or Email"
               value={its} onChange={e => setIts(e.target.value)} />
        <input className="border rounded px-3 py-2 w-full" type="password" placeholder="Password"
               value={password} onChange={e => setPassword(e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2" disabled={loading}>
          {loading ? 'Please wait...' : 'Login'}
        </button>
      </form>
      <div className="mt-3 text-sm">
        <a href="/register" className="underline mr-4">Create account</a>
        <a href="/forgot-password" className="underline">Forgot password?</a>
      </div>
      {msg && <div className="mt-4 text-sm">{msg}</div>}
    </div>
  );
}
