export type Event = { id: number; date: string; startTime?: string; capacity?: number; notes?: string }
export type RsvpStatus = 'YES'|'NO'|'MAYBE'
export type RsvpRole = 'COOK'|'FILL'|'OTHER'
export type Rsvp = { name: string; email: string; phone?: string; status: RsvpStatus; role?: RsvpRole; headcount: number }
