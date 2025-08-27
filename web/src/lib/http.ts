export async function postJson<T>(url: string, body: unknown): Promise<T> {
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include', // keep if your API sets cookies
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(⁠ HTTP ${res.status} ${res.statusText}${text ? ` — ${text} ⁠ : ''}`);
  }
  return (await res.json()) as T;
}