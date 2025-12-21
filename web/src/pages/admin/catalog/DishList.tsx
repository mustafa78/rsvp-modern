import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Ingredient = { id: number; name: string; unit: string };
type DishIngredient = { ingredientId: number; ingredientName: string; unit: string; qtyPerQuart: number };
type Dish = {
  id: number;
  name: string;
  description: string | null;
  defaultQuartsPerThaaliUnit: number;
  active: boolean;
  ingredients: DishIngredient[];
};

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  defaultQuartsPerThaaliUnit: z.coerce.number().positive('Must be positive'),
  active: z.boolean(),
});

type FormValues = z.infer<typeof schema>;

export default function DishList() {
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const { data: dishes, isLoading } = useQuery<Dish[]>({
    queryKey: ['dishes'],
    queryFn: async () => (await api.get('/dishes')).data,
  });

  const { data: ingredients } = useQuery<Ingredient[]>({
    queryKey: ['ingredients'],
    queryFn: async () => (await api.get('/ingredients')).data,
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
      description: '',
      defaultQuartsPerThaaliUnit: 1,
      active: true,
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: any) => api.post('/dishes', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['dishes'] });
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: any }) => api.put(`/dishes/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['dishes'] });
      setEditingId(null);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const onSubmit = (values: FormValues) => {
    const payload = {
      name: values.name,
      description: values.description || null,
      defaultQuartsPerThaaliUnit: values.defaultQuartsPerThaaliUnit,
      active: values.active,
      ingredients: [], // For simplicity, not editing ingredients inline
    };

    if (editingId) {
      updateMutation.mutate({ id: editingId, data: payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const startEdit = (dish: Dish) => {
    setEditingId(dish.id);
    setShowForm(true);
    reset({
      name: dish.name,
      description: dish.description || '',
      defaultQuartsPerThaaliUnit: dish.defaultQuartsPerThaaliUnit,
      active: dish.active,
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setShowForm(false);
    reset({
      name: '',
      description: '',
      defaultQuartsPerThaaliUnit: 1,
      active: true,
    });
    setError(null);
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Dishes</h1>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn">
            + Add Dish
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
            {editingId ? 'Edit Dish' : 'New Dish'}
          </h2>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input className="input" {...register('name')} placeholder="e.g., Biryani" />
                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Quarts per Thaali Unit *</label>
                <input
                  type="number"
                  step="0.01"
                  className="input"
                  {...register('defaultQuartsPerThaaliUnit')}
                />
                {errors.defaultQuartsPerThaaliUnit && (
                  <p className="text-red-500 text-sm mt-1">{errors.defaultQuartsPerThaaliUnit.message}</p>
                )}
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Description</label>
              <textarea className="input" rows={2} {...register('description')} />
            </div>
            <div className="flex items-center gap-2">
              <input type="checkbox" id="active" {...register('active')} className="rounded" />
              <label htmlFor="active" className="text-sm">Active</label>
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

      {/* Dishes Table */}
      <div className="card">
        {!dishes || dishes.length === 0 ? (
          <p className="text-gray-500">No dishes yet. Create your first dish above.</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Name</th>
                <th className="pb-2 font-medium">Quarts/Unit</th>
                <th className="pb-2 font-medium">Ingredients</th>
                <th className="pb-2 font-medium">Status</th>
                <th className="pb-2 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {dishes.map((dish) => (
                <tr key={dish.id} className="border-b last:border-0">
                  <td className="py-3">
                    <div className="font-medium">{dish.name}</div>
                    {dish.description && (
                      <div className="text-sm text-gray-500 truncate max-w-xs">{dish.description}</div>
                    )}
                  </td>
                  <td className="py-3">{dish.defaultQuartsPerThaaliUnit}</td>
                  <td className="py-3">
                    {dish.ingredients.length > 0 ? (
                      <span className="text-sm text-gray-600">
                        {dish.ingredients.map((i) => i.ingredientName).join(', ')}
                      </span>
                    ) : (
                      <span className="text-sm text-gray-400">None</span>
                    )}
                  </td>
                  <td className="py-3">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        dish.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
                      }`}
                    >
                      {dish.active ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td className="py-3">
                    <button
                      onClick={() => startEdit(dish)}
                      className="text-sm text-blue-600 hover:underline"
                    >
                      Edit
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
