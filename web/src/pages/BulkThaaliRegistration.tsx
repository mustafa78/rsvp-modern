import { useState, useEffect, useMemo } from 'react'
import { Link } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '../api/client'
import type { Event, PickupZone, MealSize } from '../types/models'

type ThaaliEvent = Event & {
  menu: Array<{
    id: number
    name: string
  }>
}

type ThaaliOrder = {
  id: number
  eventId: number
  items: Array<{
    menuItemId: number
    size: MealSize
  }>
}

type MenuItemSelection = {
  menuItemId: number
  dishName: string
  size: MealSize | null
}

type EventRegistration = {
  eventId: number
  selected: boolean
  selections: MenuItemSelection[]
  existingOrder: ThaaliOrder | null
}

const MEAL_SIZES: { value: MealSize; label: string; shortLabel: string }[] = [
  { value: 'LARGE', label: 'Large', shortLabel: 'L' },
  { value: 'SMALL', label: 'Small', shortLabel: 'S' },
  { value: 'BARAKATI', label: 'Barakati', shortLabel: 'B' },
]

function parseLocalDate(dateStr: string): Date {
  const [year, month, day] = dateStr.split('-').map(Number)
  return new Date(year, month - 1, day)
}

function formatDate(dateStr: string): string {
  const date = parseLocalDate(dateStr)
  return date.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
  })
}

function formatTime(timeStr: string): string {
  const [hours, minutes] = timeStr.split(':')
  const hour = parseInt(hours, 10)
  const ampm = hour >= 12 ? 'PM' : 'AM'
  const hour12 = hour % 12 || 12
  return `${hour12}:${minutes} ${ampm}`
}

export default function BulkThaaliRegistration() {
  const queryClient = useQueryClient()
  const [pickupZoneId, setPickupZoneId] = useState<number | null>(null)
  const [defaultSize, setDefaultSize] = useState<MealSize>('SMALL')
  const [registrations, setRegistrations] = useState<EventRegistration[]>([])
  const [submitting, setSubmitting] = useState(false)
  const [submitResults, setSubmitResults] = useState<{ eventId: number; success: boolean; message: string }[]>([])

  // Fetch all public events
  const { data: allEvents, isLoading: eventsLoading } = useQuery<Event[]>({
    queryKey: ['events-public'],
    queryFn: async () => (await api.get('/events/public')).data,
  })

  // Filter to open Thaali events only
  const openThaaliEvents = useMemo(() => {
    if (!allEvents) return []
    const now = new Date()
    return allEvents.filter(event => {
      if (event.type !== 'THAALI') return false
      if (event.status !== 'PUBLISHED') return false
      const openAt = event.registrationOpenAt ? new Date(event.registrationOpenAt) : null
      const closeAt = event.registrationCloseAt ? new Date(event.registrationCloseAt) : null
      return openAt && closeAt && now >= openAt && now < closeAt
    }).sort((a, b) => parseLocalDate(a.eventDate).getTime() - parseLocalDate(b.eventDate).getTime())
  }, [allEvents])

  // Fetch detailed info for each Thaali event (including menu)
  const { data: thaaliEventsWithMenu, isLoading: menusLoading } = useQuery<ThaaliEvent[]>({
    queryKey: ['thaali-events-with-menu', openThaaliEvents.map(e => e.id)],
    queryFn: async () => {
      const results = await Promise.all(
        openThaaliEvents.map(async (event) => {
          try {
            const res = await api.get(`/thaali/${event.id}`)
            return res.data as ThaaliEvent
          } catch {
            return { ...event, menu: [] } as ThaaliEvent
          }
        })
      )
      return results
    },
    enabled: openThaaliEvents.length > 0,
  })

  // Fetch existing orders for each event
  const { data: existingOrders } = useQuery<Map<number, ThaaliOrder>>({
    queryKey: ['my-thaali-orders-bulk', openThaaliEvents.map(e => e.id)],
    queryFn: async () => {
      const ordersMap = new Map<number, ThaaliOrder>()
      await Promise.all(
        openThaaliEvents.map(async (event) => {
          try {
            const res = await api.get(`/thaali/${event.id}/orders/my`)
            if (res.data) {
              ordersMap.set(event.id, res.data)
            }
          } catch {
            // No existing order
          }
        })
      )
      return ordersMap
    },
    enabled: openThaaliEvents.length > 0,
  })

  // Fetch pickup zones
  const { data: zones } = useQuery<PickupZone[]>({
    queryKey: ['pickup-zones'],
    queryFn: async () => (await api.get('/pickup-zones')).data,
  })

  // Fetch current user for default pickup zone
  const { data: user } = useQuery({
    queryKey: ['me'],
    queryFn: () => api.me(),
  })

  // Initialize registrations when data loads
  useEffect(() => {
    if (thaaliEventsWithMenu && existingOrders !== undefined) {
      const regs: EventRegistration[] = thaaliEventsWithMenu.map(event => {
        const existingOrder = existingOrders?.get(event.id) || null
        const selections: MenuItemSelection[] = (event.menu || []).map(item => {
          const existingItem = existingOrder?.items?.find(oi => oi.menuItemId === item.id)
          return {
            menuItemId: item.id,
            dishName: item.name || 'Unknown Dish',
            size: existingItem?.size || null,
          }
        })
        return {
          eventId: event.id,
          selected: !existingOrder, // Pre-select events without existing orders
          selections,
          existingOrder,
        }
      })
      setRegistrations(regs)
    }
  }, [thaaliEventsWithMenu, existingOrders])

  // Set default pickup zone from user profile
  useEffect(() => {
    if (user?.pickupZoneId && !pickupZoneId) {
      setPickupZoneId(user.pickupZoneId)
    }
  }, [user, pickupZoneId])

  // Toggle event selection
  const toggleEventSelection = (eventId: number) => {
    setRegistrations(prev =>
      prev.map(reg =>
        reg.eventId === eventId ? { ...reg, selected: !reg.selected } : reg
      )
    )
  }

  // Update size for a specific menu item in an event
  const updateItemSize = (eventId: number, menuItemId: number, size: MealSize | null) => {
    setRegistrations(prev =>
      prev.map(reg => {
        if (reg.eventId !== eventId) return reg
        return {
          ...reg,
          selections: reg.selections.map(sel =>
            sel.menuItemId === menuItemId ? { ...sel, size } : sel
          ),
        }
      })
    )
  }

  // Apply default size to all items in selected events
  const applyDefaultToAll = () => {
    setRegistrations(prev =>
      prev.map(reg => {
        if (!reg.selected) return reg
        return {
          ...reg,
          selections: reg.selections.map(sel => ({ ...sel, size: defaultSize })),
        }
      })
    )
  }

  // Apply default size to all items in a specific event
  const applyDefaultToEvent = (eventId: number) => {
    setRegistrations(prev =>
      prev.map(reg => {
        if (reg.eventId !== eventId) return reg
        return {
          ...reg,
          selections: reg.selections.map(sel => ({ ...sel, size: defaultSize })),
        }
      })
    )
  }

  // Submit all selected registrations
  const handleSubmit = async () => {
    if (!pickupZoneId) {
      alert('Please select a pickup zone')
      return
    }

    const selectedRegs = registrations.filter(reg => reg.selected)
    if (selectedRegs.length === 0) {
      alert('Please select at least one Thaali event')
      return
    }

    // Validate each selected registration has at least one item
    for (const reg of selectedRegs) {
      const items = reg.selections.filter(s => s.size !== null)
      if (items.length === 0) {
        const event = thaaliEventsWithMenu?.find(e => e.id === reg.eventId)
        alert(`Please select at least one item for "${event?.title || 'Unknown event'}"`)
        return
      }
    }

    setSubmitting(true)
    setSubmitResults([])

    const results: { eventId: number; success: boolean; message: string }[] = []

    for (const reg of selectedRegs) {
      const items = reg.selections
        .filter(s => s.size !== null)
        .map(s => ({ menuItemId: s.menuItemId, size: s.size as MealSize }))

      try {
        await api.post(`/thaali/${reg.eventId}/orders`, {
          pickupZoneId,
          items,
        })
        results.push({ eventId: reg.eventId, success: true, message: 'Registered successfully' })
        // Invalidate the query for this event
        queryClient.invalidateQueries({ queryKey: ['my-thaali-order', reg.eventId] })
      } catch (err: any) {
        results.push({
          eventId: reg.eventId,
          success: false,
          message: err.message || 'Failed to register',
        })
      }
    }

    setSubmitResults(results)
    setSubmitting(false)

    // Invalidate bulk queries
    queryClient.invalidateQueries({ queryKey: ['my-thaali-orders-bulk'] })

    const successCount = results.filter(r => r.success).length
    if (successCount === results.length) {
      // All successful - update UI
      setRegistrations(prev =>
        prev.map(reg => {
          if (results.find(r => r.eventId === reg.eventId && r.success)) {
            return { ...reg, selected: false }
          }
          return reg
        })
      )
    }
  }

  const selectedCount = registrations.filter(r => r.selected).length
  const totalCount = registrations.length

  if (eventsLoading || menusLoading) {
    return (
      <div className="max-w-4xl mx-auto px-4 lg:px-6 py-8">
        <div className="text-gray-500">Loading Thaali events...</div>
      </div>
    )
  }

  if (openThaaliEvents.length === 0) {
    return (
      <div className="max-w-4xl mx-auto px-4 lg:px-6 py-8">
        <div className="mb-6">
          <Link to="/" className="text-sm text-gray-500 hover:text-gray-700 inline-flex items-center gap-1.5">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Events
          </Link>
        </div>
        <div className="text-center py-12">
          <div className="w-16 h-16 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
            <svg className="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
          </div>
          <h2 className="text-xl font-semibold text-gray-700 mb-2">No Open Thaali Registrations</h2>
          <p className="text-gray-500">There are no Thaali events open for registration at this time.</p>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto px-4 lg:px-6 py-8">
      {/* Back Navigation */}
      <div className="mb-6">
        <Link to="/" className="text-sm text-gray-500 hover:text-gray-700 inline-flex items-center gap-1.5">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          Back to Events
        </Link>
      </div>

      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Quick Thaali Registration</h1>
        <p className="text-gray-600">
          Register for multiple Thaalis at once. Select the thaalis you want and choose your portion sizes.
        </p>
      </div>

      {/* Success/Error Messages */}
      {submitResults.length > 0 && (
        <div className="mb-6 space-y-2">
          {submitResults.map(result => {
            const event = thaaliEventsWithMenu?.find(e => e.id === result.eventId)
            return (
              <div
                key={result.eventId}
                className={`px-4 py-3 rounded-lg flex items-center gap-3 ${
                  result.success
                    ? 'bg-green-50 border border-green-200'
                    : 'bg-red-50 border border-red-200'
                }`}
              >
                {result.success ? (
                  <svg className="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                ) : (
                  <svg className="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                  </svg>
                )}
                <span className={result.success ? 'text-green-700' : 'text-red-700'}>
                  <strong>{event?.title}</strong>: {result.message}
                </span>
              </div>
            )
          })}
        </div>
      )}

      {/* Global Settings Card */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 mb-6">
        <h2 className="text-sm font-semibold text-gray-700 uppercase tracking-wide mb-4">Quick Settings</h2>
        <div className="grid sm:grid-cols-3 gap-4">
          {/* Pickup Zone */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Pickup Zone</label>
            <select
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              value={pickupZoneId || ''}
              onChange={(e) => setPickupZoneId(e.target.value ? Number(e.target.value) : null)}
            >
              <option value="">Select zone...</option>
              {zones?.filter(z => z.active).map(zone => (
                <option key={zone.id} value={zone.id}>{zone.name}</option>
              ))}
            </select>
          </div>

          {/* Default Size */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Default Size</label>
            <select
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              value={defaultSize}
              onChange={(e) => setDefaultSize(e.target.value as MealSize)}
            >
              {MEAL_SIZES.map(size => (
                <option key={size.value} value={size.value}>{size.label}</option>
              ))}
            </select>
          </div>

          {/* Apply to All Button */}
          <div className="flex items-end">
            <button
              type="button"
              onClick={applyDefaultToAll}
              disabled={selectedCount === 0}
              className="w-full px-4 py-2 bg-blue-50 text-blue-700 font-medium rounded-lg hover:bg-blue-100 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Apply to All Selected
            </button>
          </div>
        </div>
      </div>

      {/* Events List */}
      <div className="space-y-4 mb-6">
        {registrations.map(reg => {
          const event = thaaliEventsWithMenu?.find(e => e.id === reg.eventId)
          if (!event) return null

          const hasExistingOrder = !!reg.existingOrder
          const selectedItems = reg.selections.filter(s => s.size !== null)

          return (
            <div
              key={reg.eventId}
              className={`bg-white rounded-xl shadow-sm border overflow-hidden transition-all ${
                reg.selected
                  ? 'border-blue-300 ring-2 ring-blue-100'
                  : 'border-gray-200'
              }`}
            >
              {/* Event Header */}
              <div
                className={`px-5 py-4 flex items-center gap-4 cursor-pointer ${
                  reg.selected ? 'bg-blue-50' : 'bg-gray-50'
                }`}
                onClick={() => toggleEventSelection(reg.eventId)}
              >
                {/* Checkbox */}
                <div className={`w-6 h-6 rounded border-2 flex items-center justify-center transition-colors ${
                  reg.selected
                    ? 'bg-blue-600 border-blue-600'
                    : 'bg-white border-gray-300'
                }`}>
                  {reg.selected && (
                    <svg className="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                    </svg>
                  )}
                </div>

                {/* Event Info */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-3 flex-wrap">
                    <span className="font-semibold text-gray-900">{formatDate(event.eventDate)}</span>
                    {event.startTime && (
                      <span className="text-sm text-gray-500">{formatTime(event.startTime)}</span>
                    )}
                    {hasExistingOrder && (
                      <span className="px-2 py-0.5 text-xs font-medium rounded-full bg-green-100 text-green-700">
                        Already Registered
                      </span>
                    )}
                  </div>
                  <p className="text-gray-600 text-sm truncate">{event.title}</p>
                </div>

                {/* Quick Apply Button */}
                {reg.selected && (
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation()
                      applyDefaultToEvent(reg.eventId)
                    }}
                    className="px-3 py-1.5 text-xs font-medium text-blue-600 bg-white border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors"
                  >
                    Apply {defaultSize}
                  </button>
                )}
              </div>

              {/* Menu Items - Always visible but muted when not selected */}
              <div className={`px-5 py-4 border-t ${reg.selected ? 'border-blue-100' : 'border-gray-100'}`}>
                <div className="space-y-3">
                  {reg.selections.map(sel => (
                    <div key={sel.menuItemId} className="flex items-center gap-3">
                      <span className={`flex-1 text-sm ${reg.selected ? 'text-gray-700' : 'text-gray-400'}`}>
                        {sel.dishName}
                      </span>
                      <div className="flex items-center gap-1">
                        {/* Skip Button */}
                        <button
                          type="button"
                          onClick={() => updateItemSize(reg.eventId, sel.menuItemId, null)}
                          disabled={!reg.selected}
                          className={`px-2 py-1 text-xs font-medium rounded transition-colors ${
                            sel.size === null
                              ? 'bg-gray-600 text-white'
                              : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                          } ${!reg.selected ? 'opacity-50 cursor-not-allowed' : ''}`}
                        >
                          Skip
                        </button>
                        {/* Size Buttons */}
                        {MEAL_SIZES.map(size => (
                          <button
                            key={size.value}
                            type="button"
                            onClick={() => updateItemSize(reg.eventId, sel.menuItemId, size.value)}
                            disabled={!reg.selected}
                            className={`w-8 h-8 text-xs font-bold rounded transition-colors ${
                              sel.size === size.value
                                ? size.value === 'LARGE'
                                  ? 'bg-blue-600 text-white'
                                  : size.value === 'SMALL'
                                  ? 'bg-green-600 text-white'
                                  : 'bg-amber-500 text-white'
                                : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                            } ${!reg.selected ? 'opacity-50 cursor-not-allowed' : ''}`}
                            title={size.label}
                          >
                            {size.shortLabel}
                          </button>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>

                {/* Selection Summary */}
                {reg.selected && selectedItems.length > 0 && (
                  <div className="mt-3 pt-3 border-t border-gray-100">
                    <p className="text-xs text-gray-500">
                      Selected: {selectedItems.map(s => `${s.dishName} (${s.size?.[0]})`).join(', ')}
                    </p>
                  </div>
                )}
              </div>
            </div>
          )
        })}
      </div>

      {/* Bottom Action Bar */}
      <div className="sticky bottom-0 bg-white border-t border-gray-200 -mx-4 px-4 py-4 lg:-mx-6 lg:px-6 shadow-lg">
        <div className="max-w-4xl mx-auto flex items-center justify-between gap-4">
          <div className="text-sm text-gray-600">
            <span className="font-semibold text-gray-900">{selectedCount}</span> of {totalCount} Thaalis selected
          </div>
          <button
            type="button"
            onClick={handleSubmit}
            disabled={submitting || selectedCount === 0 || !pickupZoneId}
            className="px-6 py-3 bg-blue-600 text-white font-semibold rounded-xl hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
          >
            {submitting ? (
              <>
                <svg className="animate-spin w-5 h-5" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
                Registering...
              </>
            ) : (
              <>
                Register {selectedCount} {selectedCount === 1 ? 'Thaali' : 'Thaalis'}
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </>
            )}
          </button>
        </div>
      </div>

      {/* Size Legend */}
      <div className="mt-6 text-center">
        <p className="text-xs text-gray-400">
          <span className="inline-flex items-center gap-1 mr-3"><span className="w-5 h-5 bg-blue-600 text-white text-xs font-bold rounded flex items-center justify-center">L</span> Large (32oz)</span>
          <span className="inline-flex items-center gap-1 mr-3"><span className="w-5 h-5 bg-green-600 text-white text-xs font-bold rounded flex items-center justify-center">S</span> Small (16oz)</span>
          <span className="inline-flex items-center gap-1"><span className="w-5 h-5 bg-amber-500 text-white text-xs font-bold rounded flex items-center justify-center">B</span> Barakati (8oz)</span>
        </p>
      </div>
    </div>
  )
}
