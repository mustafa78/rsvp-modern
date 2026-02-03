import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../api/client';
import type { ThaaliEvent, ThaaliOrder, ThaaliOrderRequest, MealSize, PickupZone } from '../types/models';

type Props = {
  eventId: number;
};

type MenuItemSelection = {
  menuItemId: number;
  dishName: string;
  size: MealSize | null; // null means not ordering this item
};

const MEAL_SIZES: { value: MealSize; label: string; description: string }[] = [
  { value: 'LARGE', label: 'Large', description: '32 oz (1 quart)' },
  { value: 'SMALL', label: 'Small', description: '16 oz (1/2 quart)' },
  { value: 'BARAKATI', label: 'Barakati', description: '8 oz (1/4 quart)' },
];

export default function ThaaliOrderForm({ eventId }: Props) {
  const queryClient = useQueryClient();
  const [selections, setSelections] = useState<MenuItemSelection[]>([]);
  const [pickupZoneId, setPickupZoneId] = useState<number | null>(null);
  const [notes, setNotes] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [showCancelConfirm, setShowCancelConfirm] = useState(false);

  // Fetch event details with menu
  const { data: event, isLoading: eventLoading } = useQuery<ThaaliEvent>({
    queryKey: ['thaali-event', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}`)).data,
  });

  // Fetch user's existing order
  const { data: existingOrder } = useQuery<ThaaliOrder | null>({
    queryKey: ['my-thaali-order', eventId],
    queryFn: async () => {
      try {
        const res = await api.get(`/thaali/${eventId}/orders/my`);
        return res.data;
      } catch {
        return null;
      }
    },
  });

  // Fetch pickup zones
  const { data: zones } = useQuery<PickupZone[]>({
    queryKey: ['pickup-zones'],
    queryFn: async () => (await api.get('/pickup-zones')).data,
  });

  // Fetch current user for default pickup zone
  const { data: user } = useQuery({
    queryKey: ['me'],
    queryFn: () => api.me(),
  });

  // Initialize menu selections when event menu loads
  useEffect(() => {
    if (event?.menu) {
      const initialSelections: MenuItemSelection[] = event.menu.map((item) => {
        // Check if there's an existing order for this menu item
        const existingItem = existingOrder?.items?.find((oi) => oi.menuItemId === item.id);
        return {
          menuItemId: item.id,
          dishName: item.name || 'Unknown Dish',
          size: existingItem?.size || null,
        };
      });
      setSelections(initialSelections);

      // Set notes from existing order
      if (existingOrder) {
        setNotes(existingOrder.notes || '');
      }
    }
  }, [event, existingOrder]);

  // Set pickup zone: prefer existing order, then user's default
  useEffect(() => {
    if (existingOrder) {
      setPickupZoneId(existingOrder.pickupZoneId);
    } else if (user?.pickupZoneId && !pickupZoneId) {
      setPickupZoneId(user.pickupZoneId);
    }
  }, [existingOrder, user, pickupZoneId]);

  const submitMutation = useMutation({
    mutationFn: async (request: ThaaliOrderRequest) => {
      return api.post(`/thaali/${eventId}/orders`, request);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-thaali-order', eventId] });
      setError(null);
      alert('Your thaali registration has been saved!');
    },
    onError: (err: Error) => {
      setError(err.message || 'Failed to save thaali registration');
    },
  });

  const cancelMutation = useMutation({
    mutationFn: async () => {
      return api.delete(`/thaali/${eventId}/orders/my`);
    },
    onSuccess: () => {
      // Immediately update cache to null so UI reflects cancellation
      queryClient.setQueryData(['my-thaali-order', eventId], null);
      queryClient.invalidateQueries({ queryKey: ['my-thaali-order', eventId] });
      setError(null);
      setShowCancelConfirm(false);
      // Reset form to initial state
      setSelections((prev) => prev.map((s) => ({ ...s, size: null })));
      setNotes('');
      alert('Your thaali registration has been cancelled.');
    },
    onError: (err: Error) => {
      setError(err.message || 'Failed to cancel registration');
      setShowCancelConfirm(false);
    },
  });

  const handleSizeChange = (menuItemId: number, size: MealSize | null) => {
    setSelections((prev) =>
      prev.map((s) => (s.menuItemId === menuItemId ? { ...s, size } : s))
    );
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    // Filter to only items that have a size selected
    const items = selections
      .filter((s) => s.size !== null)
      .map((s) => ({ menuItemId: s.menuItemId, size: s.size as MealSize }));

    if (items.length === 0) {
      setError('Please select at least one thaali item');
      return;
    }

    if (!pickupZoneId) {
      setError('Please select a pickup zone');
      return;
    }

    submitMutation.mutate({
      pickupZoneId,
      notes: notes || undefined,
      items,
    });
  };

  if (eventLoading) {
    return <div className="text-gray-500">Loading event details...</div>;
  }

  if (!event) {
    return <div className="text-red-600">Event not found</div>;
  }

  if (!event.menu || event.menu.length === 0) {
    return <div className="text-gray-500">No menu items available for this event</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      {/* Menu Items */}
      <div className="space-y-4">
        <h3 className="text-lg font-semibold">Select Your Thaalis</h3>
        <p className="text-sm text-gray-600">
          Choose a size for each dish you want to order. Leave unselected to skip.
        </p>

        {selections.map((selection) => (
          <div key={selection.menuItemId} className="card">
            <div className="font-medium mb-2">{selection.dishName}</div>
            <div className="flex flex-wrap gap-2">
              <button
                type="button"
                onClick={() => handleSizeChange(selection.menuItemId, null)}
                className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                  selection.size === null
                    ? 'bg-gray-600 text-white border-gray-600'
                    : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-100'
                }`}
              >
                Skip
              </button>
              {MEAL_SIZES.map((ms) => (
                <button
                  key={ms.value}
                  type="button"
                  onClick={() => handleSizeChange(selection.menuItemId, ms.value)}
                  className={`px-3 py-1 rounded-full text-sm border transition-colors ${
                    selection.size === ms.value
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-100'
                  }`}
                  title={ms.description}
                >
                  {ms.label}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>

      {/* Pickup Zone */}
      <div>
        <label className="block text-sm font-medium mb-1">Pickup Zone *</label>
        <select
          className="input"
          value={pickupZoneId || ''}
          onChange={(e) => setPickupZoneId(e.target.value ? Number(e.target.value) : null)}
          required
        >
          <option value="">-- Select pickup zone --</option>
          {zones
            ?.filter((z) => z.active)
            .map((zone) => (
              <option key={zone.id} value={zone.id}>
                {zone.name}
              </option>
            ))}
        </select>
      </div>

      {/* Notes */}
      <div>
        <label className="block text-sm font-medium mb-1">Special Instructions</label>
        <textarea
          className="input"
          rows={2}
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Any dietary restrictions or special requests..."
        />
      </div>

      {/* Summary */}
      <div className="bg-gray-50 rounded p-4">
        <h4 className="font-medium mb-2">Thaali Summary</h4>
        {selections.filter((s) => s.size !== null).length === 0 ? (
          <p className="text-gray-500 text-sm">No items selected</p>
        ) : (
          <ul className="text-sm space-y-1">
            {selections
              .filter((s) => s.size !== null)
              .map((s) => (
                <li key={s.menuItemId}>
                  {s.dishName}: <span className="font-medium">{s.size}</span>
                </li>
              ))}
          </ul>
        )}
      </div>

      {/* Submit */}
      <button
        type="submit"
        className="btn w-full"
        disabled={submitMutation.isPending}
      >
        {submitMutation.isPending
          ? 'Saving...'
          : existingOrder
          ? 'Update Thaali'
          : 'Register'}
      </button>

      {existingOrder && (
        <button
          type="button"
          onClick={() => setShowCancelConfirm(true)}
          className="w-full mt-2 px-4 py-2 text-red-600 border border-red-300 rounded-lg hover:bg-red-50 transition-colors"
          disabled={cancelMutation.isPending}
        >
          Cancel Registration
        </button>
      )}

      {/* Cancel Confirmation Modal */}
      {showCancelConfirm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 max-w-sm mx-4 shadow-xl">
            <h3 className="text-lg font-semibold mb-2">Cancel Registration?</h3>
            <p className="text-gray-600 mb-4">
              Are you sure you want to cancel your thaali registration? This will remove your order for this event.
            </p>
            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => setShowCancelConfirm(false)}
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
                disabled={cancelMutation.isPending}
              >
                Keep Registration
              </button>
              <button
                type="button"
                onClick={() => cancelMutation.mutate()}
                className="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
                disabled={cancelMutation.isPending}
              >
                {cancelMutation.isPending ? 'Cancelling...' : 'Yes, Cancel'}
              </button>
            </div>
          </div>
        </div>
      )}
    </form>
  );
}
