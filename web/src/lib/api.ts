// web/src/lib/api.ts
export const API_BASE =
  (import.meta.env.VITE_API_URL as string | undefined) ?? '/api';

export const endpoints = {
  register: () => ⁠ ${API_BASE}/auth/register ⁠,
  login:    () => ⁠ ${API_BASE}/auth/login ⁠,
  // add more as needed
};