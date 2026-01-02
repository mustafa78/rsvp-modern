import { useState, useEffect } from 'react';
import { api } from '../api/client';

export default function Login() {
  const [its, setIts] = useState('');
  const [password, setPassword] = useState('');
  const [msg, setMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  // Check for expired parameter on mount
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    if (params.get('expired') === '1') {
      setMsg('Your account has expired. Please contact an administrator to extend your access.');
      // Clean up the URL
      window.history.replaceState({}, '', '/login');
    }
  }, []);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setMsg(null);
    try {
      await api.login(its, password);
      setMsg('Logged in!');
      window.location.href = '/';
    } catch (e: any) {
      // Parse error message and show user-friendly text
      let errorMsg = 'Login failed';
      try {
        const parsed = JSON.parse(e.message);
        if (parsed.error === 'invalid_credentials') {
          errorMsg = 'Invalid ITS number or password. Please try again.';
        } else if (parsed.error === 'account_expired') {
          errorMsg = parsed.message || 'Your account has expired. Please contact an administrator to extend your access.';
        } else if (parsed.error) {
          errorMsg = parsed.error;
        }
      } catch {
        // Not JSON, use as-is if it's a meaningful message
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
      <h1 className="text-2xl font-semibold mb-4">Login</h1>
      <form onSubmit={onSubmit} className="space-y-3">
        <input className="border rounded px-3 py-2 w-full" placeholder="ITS Number"
               value={its} onChange={e => setIts(e.target.value)} />
        <input className="border rounded px-3 py-2 w-full" type="password" placeholder="Password"
               value={password} onChange={e => setPassword(e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2" disabled={loading}>
          {loading ? 'Please wait...' : 'Login'}
        </button>
      </form>
      <div className="mt-3 text-sm space-y-1">
        <div>
          <a href="/forgot-password" className="text-blue-600 hover:underline">Forgot password?</a>
        </div>
        <div>
          <a href="/change-password-public" className="text-blue-600 hover:underline">Change password</a>
        </div>
      </div>
      {msg && (
        <div className={`mt-4 text-sm ${msg === 'Logged in!' ? 'text-green-600' : 'text-red-600'}`}>
          {msg}
        </div>
      )}
    </div>
  );
}
