export const API_BASE =
  (import.meta as any).env?.VITE_API_URL
    ? (import.meta as any).env.VITE_API_URL
    : '';

async function jsonFetch<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(API_BASE + path, {
    credentials: 'include',
    headers: { 'Content-Type': 'application/json', ...(init?.headers || {}) },
    ...init,
  });
  if (!res.ok) {
    const txt = await res.text();
    // Check for account_expired error and redirect to login
    try {
      const parsed = JSON.parse(txt);
      if (parsed.error === 'account_expired' && res.status === 401) {
        // Session expired due to account expiration, redirect to login
        window.location.href = '/login?expired=1';
        return undefined as any;
      }
    } catch {
      // Not JSON, proceed with normal error handling
    }
    throw new Error(txt || res.statusText);
  }
  return res.headers.get('content-type')?.includes('application/json')
    ? await res.json()
    : (undefined as any);
}

export const api = {
  get: async (path: string) => ({ data: await jsonFetch<any>(`/api${path}`, { method: 'GET' }) }),

  post: async (path: string, data: any) => ({ data: await jsonFetch<any>(`/api${path}`, { method: 'POST', body: JSON.stringify(data) }) }),

  put: async (path: string, data: any) => ({ data: await jsonFetch<any>(`/api${path}`, { method: 'PUT', body: JSON.stringify(data) }) }),

  delete: async (path: string) => {
    const res = await fetch(API_BASE + `/api${path}`, {
      method: 'DELETE',
      credentials: 'include',
    });
    if (!res.ok) {
      const txt = await res.text();
      throw new Error(txt || res.statusText);
    }
    return { data: undefined };
  },

  login: (itsNumber: string, password: string) =>
    jsonFetch('/api/auth/login', { method: 'POST', body: JSON.stringify({ itsNumber, password }) }),

  register: (payload: any) =>
    jsonFetch('/api/auth/register', { method: 'POST', body: JSON.stringify(payload) }),

  me: () => jsonFetch('/api/auth/me', { method: 'GET' }),

  logout: () => jsonFetch('/api/auth/logout', { method: 'POST' }),

  changePassword: (currentPassword: string, newPassword: string) =>
    jsonFetch('/api/auth/password/change', { method: 'POST', body: JSON.stringify({ currentPassword, newPassword }) }),

  changePasswordUnauthenticated: (itsNumber: string, currentPassword: string, newPassword: string) =>
    jsonFetch('/api/auth/password/change-unauthenticated', { method: 'POST', body: JSON.stringify({ itsNumber, currentPassword, newPassword }) }),

  requestReset: (itsNumberOrEmail: string) =>
    jsonFetch('/api/auth/password/reset/request', { method: 'POST', body: JSON.stringify({ itsNumberOrEmail }) }),

  confirmReset: (token: string, newPassword: string) =>
    jsonFetch('/api/auth/password/reset/confirm', { method: 'POST', body: JSON.stringify({ token, newPassword }) }),
};
