// web/src/pages/Register.tsx
import { FormEvent, useEffect, useState } from 'react';
import { getPickupZones, register } from '../lib/api';
import { Link, useNavigate } from 'react-router-dom';

type Zone = { id: number; name: string };

export default function RegisterPage() {
  const navigate = useNavigate();
  const [zones, setZones] = useState<Zone[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [form, setForm] = useState({
    itsNumber: '',
    firstName: '',
    lastName: '',
    phone: '',
    email: '',
    password: '',
    pickupZoneId: 0,
  });

  useEffect(() => {
    getPickupZones()
      .then((zs) => {
        setZones(zs);
        if (zs.length && form.pickupZoneId === 0) {
          setForm((f) => ({ ...f, pickupZoneId: zs[0].id }));
        }
      })
      .catch(() => setError('Failed to load pickup zones'));
  }, []);

  const onChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setForm((f) => ({ ...f, [name]: name === 'pickupZoneId' ? Number(value) : value }));
  };

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      await register(form);
      navigate('/login');
    } catch (err: any) {
      setError(err?.message ?? 'Registration failed');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="max-w-xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-semibold mb-6">Create account</h1>
      <form onSubmit={onSubmit} className="space-y-4">
        <input className="w-full border rounded px-3 py-2" name="itsNumber" placeholder="ITS Number" value={form.itsNumber} onChange={onChange} />
        <div className="grid grid-cols-2 gap-3">
          <input className="border rounded px-3 py-2" name="firstName" placeholder="First name" value={form.firstName} onChange={onChange} />
          <input className="border rounded px-3 py-2" name="lastName" placeholder="Last name" value={form.lastName} onChange={onChange} />
        </div>
        <input className="w-full border rounded px-3 py-2" name="phone" placeholder="Phone" value={form.phone} onChange={onChange} />
        <input className="w-full border rounded px-3 py-2" name="email" type="email" placeholder="Email" value={form.email} onChange={onChange} />

        <select className="w-full border rounded px-3 py-2" name="pickupZoneId" value={form.pickupZoneId} onChange={onChange}>
          {zones.map((z) => (
            <option key={z.id} value={z.id}>{z.name}</option>
          ))}
        </select>

        <input className="w-full border rounded px-3 py-2" name="password" type="password" placeholder="Password" value={form.password} onChange={onChange} />

        {error && <p className="text-red-600 text-sm">{error}</p>}
        <button disabled={submitting} className="w-full rounded bg-black text-white py-2 disabled:opacity-60">
          {submitting ? 'Registering…' : 'Register'}
        </button>
      </form>

      <p className="mt-4 text-sm">
        Already have an account? <Link className="underline" to="/login">Login</Link>
      </p>
    </div>
  );
}