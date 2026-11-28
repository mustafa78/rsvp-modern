export type WebinarSummary = {
  id: number;
  title: string;
  description: string | null;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  status: 'DRAFT' | 'PUBLISHED' | 'CANCELLED';
  accessMode: 'OPEN' | 'ASSIGNED';
  managedByZoom: boolean;
  joinWindowBeforeMin: number;
  joinWindowAfterMin: number;
  hasJoinUrl: boolean;
  seatCount: number;
};

export type MemberWebinar = {
  id: number;
  title: string;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  joinOpen: boolean;
};

export type MagicJoinInfo = {
  title: string;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  joinOpen: boolean;
  attendeeName: string;
  attendeeIts: string;
};

export type FamilyMember = {
  id: number;
  hofPersonId: number;
  firstName: string;
  lastName: string;
  itsNumber: string;
  active: boolean;
};

export type Hof = { id: number; firstName: string; lastName: string; itsNumber: string; familyMemberCount: number };

export type FamilySeatRow = { familyMemberId: number; itsNumber: string; name: string; seatId: number | null };

export type FamilySeats = {
  personId: number;
  itsNumber: string;
  name: string;
  hof: boolean;
  ownSeatId: number | null;
  family: FamilySeatRow[];
};

export type AssignableRow = {
  personId: number;
  familyMemberId: number | null;
  itsNumber: string;
  name: string;
  hofName: string | null;
  hof: boolean;
  hasSeat: boolean;
};

export type AttendeeRow = {
  itsNumber: string;
  name: string;
  type: 'Member' | 'Family';
  hofName: string | null;
  hofIts: string | null;
  joined: boolean;
  firstJoinedAt: string | null;
  launchCount: number;
};

export type AttendanceReport = { webinar: WebinarSummary; seatCount: number; joinedCount: number; rows: AttendeeRow[] };

export type ZoomSyncRow = { zoomMeetingId: string; topic: string; start: string; end: string; alreadyImported: boolean };

/** The API throws Error(responseBody); the body is usually {"error":"..."}. */
export function errMsg(e: unknown): string {
  const raw = e instanceof Error ? e.message : String(e);
  try {
    const parsed = JSON.parse(raw);
    return parsed.error || parsed.message || raw;
  } catch {
    return raw;
  }
}

/** An ISO instant shown in the viewer's own time zone. */
export function fmtDateTime(iso: string): string {
  return new Date(iso).toLocaleString(undefined, {
    weekday: 'short', month: 'short', day: 'numeric', year: 'numeric', hour: 'numeric', minute: '2-digit',
  });
}

export function fmtTime(iso: string): string {
  return new Date(iso).toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
}

/** ISO instant -> value for <input type="datetime-local"> in local time. */
export function toLocalInput(iso?: string | null): string {
  if (!iso) return '';
  const d = new Date(iso);
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

/** <input type="datetime-local"> value (local time) -> ISO instant with offset. */
export function fromLocalInput(value: string): string {
  return new Date(value).toISOString();
}
