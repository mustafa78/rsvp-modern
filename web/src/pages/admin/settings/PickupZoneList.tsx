import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type PickupZone = {
  id: number;
  name: string;
  active: boolean;
};

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  active: z.boolean(),
});

type FormValues = z.infer<typeof schema>;

export default function PickupZoneList() {
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const { data: zones, isLoading } = useQuery<PickupZone[]>({
    queryKey: ['pickup-zones'],
    queryFn: async () => (await api.get('/pickup-zones')).data,
  });

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      name: '',
      active: true,
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: FormValues) => api.post('/pickup-zones', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pickup-zones'] });
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: FormValues }) =>
      api.put(`/pickup-zones/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pickup-zones'] });
      setEditingId(null);
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const onSubmit = (values: FormValues) => {
    if (editingId) {
      updateMutation.mutate({ id: editingId, data: values });
    } else {
      createMutation.mutate(values);
    }
  };

  const startEdit = (zone: PickupZone) => {
    setEditingId(zone.id);
    setShowForm(true);
    reset({
      name: zone.name,
      active: zone.active,
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setShowForm(false);
    reset({
      name: '',
      active: true,
    });
    setError(null);
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  const activeZones = zones?.filter((z) => z.active) || [];
  const inactiveZones = zones?.filter((z) => !z.active) || [];

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Pickup Zones</h1>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn">
            + Add Zone
          </button>
        )}
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      {/* Create/Edit Form */}
      {showForm && (
        <div className="card">
          <h2 className="text-lg font-semibold mb-4">
            {editingId ? 'Edit Zone' : 'New Zone'}
          </h2>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">Zone Name *</label>
              <input
                className="input"
                {...register('name')}
                placeholder="e.g., North Side, Downtown, West Area"
              />
              {errors.name && (
                <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>
              )}
            </div>
            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="active"
                {...register('active')}
                className="rounded"
              />
              <label htmlFor="active" className="text-sm">
                Active (available for selection)
              </label>
            </div>
            <div className="flex gap-2">
              <button type="submit" className="btn" disabled={isSubmitting}>
                {isSubmitting ? 'Saving...' : editingId ? 'Update' : 'Create'}
              </button>
              <button type="button" className="btn bg-gray-500" onClick={cancelEdit}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Active Zones */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Active Zones ({activeZones.length})</h2>
        {activeZones.length === 0 ? (
          <p className="text-gray-500">No active zones. Create your first zone above.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {activeZones.map((zone) => (
              <div
                key={zone.id}
                className="flex items-center justify-between p-3 bg-green-50 border border-green-200 rounded-lg"
              >
                <div className="flex items-center gap-2">
                  <span className="w-2 h-2 bg-green-500 rounded-full"></span>
                  <span className="font-medium">{zone.name}</span>
                </div>
                <button
                  onClick={() => startEdit(zone)}
                  className="text-sm text-blue-600 hover:underline"
                >
                  Edit
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Inactive Zones */}
      {inactiveZones.length > 0 && (
        <div className="card">
          <h2 className="text-lg font-semibold mb-4">Inactive Zones ({inactiveZones.length})</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {inactiveZones.map((zone) => (
              <div
                key={zone.id}
                className="flex items-center justify-between p-3 bg-gray-50 border border-gray-200 rounded-lg"
              >
                <div className="flex items-center gap-2">
                  <span className="w-2 h-2 bg-gray-400 rounded-full"></span>
                  <span className="font-medium text-gray-600">{zone.name}</span>
                </div>
                <button
                  onClick={() => startEdit(zone)}
                  className="text-sm text-blue-600 hover:underline"
                >
                  Edit
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Info */}
      <div className="card bg-blue-50 border border-blue-200">
        <h3 className="font-semibold mb-2">About Pickup Zones</h3>
        <p className="text-sm text-gray-700">
          Pickup zones are used to organize Thaali order delivery/pickup locations.
          Users can select their preferred zone when placing orders. Inactive zones
          won't appear in the selection list but will still be visible on existing orders.
        </p>
      </div>
    </div>
  );
}
