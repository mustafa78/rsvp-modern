import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Ingredient = {
  id: number;
  name: string;
  unit: string;
  notes: string | null;
};

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  unit: z.string().min(1, 'Unit is required'),
  notes: z.string().optional(),
});

type FormValues = z.infer<typeof schema>;

const commonUnits = ['g', 'kg', 'lb', 'oz', 'tsp', 'tbsp', 'cup', 'ml', 'l', 'piece', 'bunch'];

export default function IngredientList() {
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const { data: ingredients, isLoading } = useQuery<Ingredient[]>({
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
      unit: 'g',
      notes: '',
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: any) => api.post('/ingredients', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ingredients'] });
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: any }) => api.put(`/ingredients/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ingredients'] });
      setEditingId(null);
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const onSubmit = (values: FormValues) => {
    const payload = {
      name: values.name,
      unit: values.unit,
      notes: values.notes || null,
    };

    if (editingId) {
      updateMutation.mutate({ id: editingId, data: payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const startEdit = (ingredient: Ingredient) => {
    setEditingId(ingredient.id);
    setShowForm(true);
    reset({
      name: ingredient.name,
      unit: ingredient.unit,
      notes: ingredient.notes || '',
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setShowForm(false);
    reset({
      name: '',
      unit: 'g',
      notes: '',
    });
    setError(null);
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Ingredients</h1>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn">
            + Add Ingredient
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
            {editingId ? 'Edit Ingredient' : 'New Ingredient'}
          </h2>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input className="input" {...register('name')} placeholder="e.g., Rice" />
                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Unit *</label>
                <select className="input" {...register('unit')}>
                  {commonUnits.map((u) => (
                    <option key={u} value={u}>
                      {u}
                    </option>
                  ))}
                </select>
                {errors.unit && <p className="text-red-500 text-sm mt-1">{errors.unit.message}</p>}
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Notes</label>
              <textarea className="input" rows={2} {...register('notes')} placeholder="Optional notes" />
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

      {/* Ingredients Table */}
      <div className="card">
        {!ingredients || ingredients.length === 0 ? (
          <p className="text-gray-500">No ingredients yet. Create your first ingredient above.</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Name</th>
                <th className="pb-2 font-medium">Unit</th>
                <th className="pb-2 font-medium">Notes</th>
                <th className="pb-2 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {ingredients.map((ingredient) => (
                <tr key={ingredient.id} className="border-b last:border-0">
                  <td className="py-3 font-medium">{ingredient.name}</td>
                  <td className="py-3">
                    <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-sm">
                      {ingredient.unit}
                    </span>
                  </td>
                  <td className="py-3 text-gray-500 text-sm">
                    {ingredient.notes || '-'}
                  </td>
                  <td className="py-3">
                    <button
                      onClick={() => startEdit(ingredient)}
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
