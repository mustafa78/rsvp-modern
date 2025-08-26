import { useState } from 'react';
import { api } from '../api/client';

export default function Register() {
  const [form, setForm] = useState<any>({
    itsNumber: '', firstName: '', lastName: '', phone: '', email: '', pickupZone: 'SELF_PICKUP_NAJMI_MASJID', password: ''
  });
  const [msg, setMsg] = useState<string | null>(null);

  const set = (k: string, v: any) => setForm((f: any) => ({ ...f, [k]: v }));

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    try {
      await api.register(form);
      setMsg('Account created. You can now login.');
    } catch (e: any) {
      setMsg(e.message || 'Failed');
    }
  };

  return (
    <div className="max-w-lg mx-auto p-6">
      <h1 className="text-2xl font-semibold mb-4">Create account</h1>
      <form onSubmit={onSubmit} className="grid grid-cols-2 gap-3">
        <input className="border rounded px-3 py-2 col-span-2" placeholder="ITS Number"
               value={form.itsNumber} onChange={e => set('itsNumber', e.target.value)} />
        <input className="border rounded px-3 py-2" placeholder="First name"
               value={form.firstName} onChange={e => set('firstName', e.target.value)} />
        <input className="border rounded px-3 py-2" placeholder="Last name"
               value={form.lastName} onChange={e => set('lastName', e.target.value)} />
        <input className="border rounded px-3 py-2 col-span-2" placeholder="Phone"
               value={form.phone} onChange={e => set('phone', e.target.value)} />
        <input className="border rounded px-3 py-2 col-span-2" placeholder="Email"
               value={form.email} onChange={e => set('email', e.target.value)} />
        <select className="border rounded px-3 py-2 col-span-2"
                value={form.pickupZone} onChange={e => set('pickupZone', e.target.value)}>
          <option value="SELF_PICKUP_NAJMI_MASJID">Self Pickup Najmi Masjid</option>
          <option value="NORTH_POTOMAC_ROCKVILLE">North Potomac/Rockville</option>
          <option value="GERMANTOWN">Germantown</option>
          <option value="WASHINGTON_DC">Washington DC</option>
          <option value="FREDERICK">Frederick</option>
          <option value="ELLICOTT_CITY_COLUMBIA">Ellicott City/Columbia</option>
          <option value="CLARKSVILLE">Clarksville</option>
        </select>
        <input className="border rounded px-3 py-2 col-span-2" type="password" placeholder="Password"
               value={form.password} onChange={e => set('password', e.target.value)} />
        <button className="bg-black text-white rounded px-4 py-2 col-span-2">Register</button>
      </form>
      {msg && <div className="mt-4 text-sm">{msg}</div>}
    </div>
  );
}
