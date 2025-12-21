// web/src/lib/api.ts
const API_BASE = import.meta.env.VITE_API_URL || '/api';

export const endpoints = {
  register:      () => `${API_BASE}/auth/register`,
  login:         () => `${API_BASE}/auth/login`,
  me:            () => `${API_BASE}/auth/me`,
  changePw:      () => `${API_BASE}/auth/password/change`,
  resetRequest:  () => `${API_BASE}/auth/password/reset/request`,
  resetConfirm:  () => `${API_BASE}/auth/password/reset/confirm`,
  pickupZones:   () => `${API_BASE}/auth/pickup-zones`,
};

export async function postJson<T>(url: string, body: unknown): Promise<T> {
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(`HTTP ${res.status} ${res.statusText}${text ? ` – ${text}` : ''}`);
  }
  return res.json();
}

export async function getPickupZones() {
  const res = await fetch(endpoints.pickupZones(), { credentials: 'include' });
  if (!res.ok) throw new Error('Failed to load pickup zones');
  return res.json() as Promise<Array<{ id: number; name: string }>>;
}

export async function login(body: { itsNumber: string; password: string }) {
  return postJson(`${API_BASE}/auth/login`, body);
}

export async function register(body: {
  itsNumber: string;
  firstName: string;
  lastName: string;
  phone: string;
  email: string;
  password: string;
  pickupZoneId: number;
}) {
  return postJson(endpoints.register(), body);
}
