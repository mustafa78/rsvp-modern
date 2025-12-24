import { useState, useMemo } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Ingredient = {
  id: number;
  name: string;
  unit: string;
  category: string | null;
  defaultStore: string | null;
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
  const [searchQuery, setSearchQuery] = useState('');
  const queryClient = useQueryClient();

  const { data: ingredients, isLoading } = useQuery<Ingredient[]>({
    queryKey: ['ingredients'],
    queryFn: async () => (await api.get('/ingredients')).data,
  });

  // Filter ingredients based on search query
  const filteredIngredients = useMemo(() => {
    if (!ingredients) return [];
    if (!searchQuery.trim()) return ingredients;
    const query = searchQuery.toLowerCase();
    return ingredients.filter(i =>
      i.name.toLowerCase().includes(query) ||
      i.unit.toLowerCase().includes(query) ||
      i.category?.toLowerCase().includes(query) ||
      i.defaultStore?.toLowerCase().includes(query) ||
      i.notes?.toLowerCase().includes(query)
    );
  }, [ingredients, searchQuery]);

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

      {/* Search Bar */}
      {!showForm && (
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
          <input
            type="text"
            className="input pl-10"
            placeholder="Search ingredients by name, unit, category, or store..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          {searchQuery && (
            <button
              className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
              onClick={() => setSearchQuery('')}
            >
              <svg className="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          )}
        </div>
      )}

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
      <div className="card overflow-hidden">
        {!ingredients || ingredients.length === 0 ? (
          <p className="text-gray-500 p-4">No ingredients yet. Create your first ingredient above.</p>
        ) : filteredIngredients.length === 0 ? (
          <p className="text-gray-500 p-4">No ingredients match your search "{searchQuery}"</p>
        ) : (
          <table className="w-full text-left table-fixed">
            <thead>
              <tr className="bg-gray-50 border-b">
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[30%]">Name</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[10%] text-center">Unit</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[15%]">Category</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[15%]">Store</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[20%]">Notes</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[10%] text-center">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredIngredients.map((ingredient, idx) => (
                <tr key={ingredient.id} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                  <td className="py-3 px-4 font-medium text-gray-900">{ingredient.name}</td>
                  <td className="py-3 px-4 text-center">
                    <span className="inline-block px-2 py-0.5 bg-blue-50 text-blue-700 rounded text-sm font-medium">
                      {ingredient.unit}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    {ingredient.category ? (
                      <span className="text-sm text-gray-600 capitalize">{ingredient.category}</span>
                    ) : (
                      <span className="text-sm text-gray-400">-</span>
                    )}
                  </td>
                  <td className="py-3 px-4">
                    {ingredient.defaultStore ? (
                      <span className="inline-block px-2 py-0.5 bg-gray-100 text-gray-700 rounded text-xs">
                        {ingredient.defaultStore}
                      </span>
                    ) : (
                      <span className="text-sm text-gray-400">-</span>
                    )}
                  </td>
                  <td className="py-3 px-4 text-gray-500 text-sm truncate">
                    {ingredient.notes || '-'}
                  </td>
                  <td className="py-3 px-4 text-center">
                    <button
                      onClick={() => startEdit(ingredient)}
                      className="inline-flex items-center px-3 py-1.5 text-sm font-medium text-blue-600 hover:text-blue-800 hover:bg-blue-50 rounded transition-colors"
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

      {/* Stats */}
      {ingredients && ingredients.length > 0 && (
        <div className="text-sm text-gray-500">
          {searchQuery ? (
            <>Showing {filteredIngredients.length} of {ingredients.length} ingredients</>
          ) : (
            <>Showing {ingredients.length} ingredient{ingredients.length !== 1 ? 's' : ''}</>
          )}
        </div>
      )}
    </div>
  );
}
