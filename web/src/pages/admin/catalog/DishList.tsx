import { useState, useMemo, useRef, useEffect } from 'react';
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

type SelectedIngredient = {
  ingredientId: number;
  name: string;
  unit: string;
  qtyPerQuart: string;
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
  const [selectedIngredients, setSelectedIngredients] = useState<SelectedIngredient[]>([]);
  const [ingredientSearch, setIngredientSearch] = useState('');
  const [showIngredientDropdown, setShowIngredientDropdown] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const ingredientSearchRef = useRef<HTMLDivElement>(null);
  const queryClient = useQueryClient();

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (ingredientSearchRef.current && !ingredientSearchRef.current.contains(event.target as Node)) {
        setShowIngredientDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const { data: dishes, isLoading } = useQuery<Dish[]>({
    queryKey: ['dishes'],
    queryFn: async () => (await api.get('/dishes')).data,
  });

  const { data: ingredients } = useQuery<Ingredient[]>({
    queryKey: ['ingredients'],
    queryFn: async () => (await api.get('/ingredients')).data,
  });

  // Filter dishes based on search query
  const filteredDishes = useMemo(() => {
    if (!dishes) return [];
    if (!searchQuery.trim()) return dishes;
    const query = searchQuery.toLowerCase();
    return dishes.filter(d =>
      d.name.toLowerCase().includes(query) ||
      d.description?.toLowerCase().includes(query) ||
      d.ingredients.some(i => i.ingredientName.toLowerCase().includes(query))
    );
  }, [dishes, searchQuery]);

  // Filter ingredients for dropdown (exclude already selected)
  const filteredIngredients = useMemo(() => {
    if (!ingredients) return [];
    const selectedIds = new Set(selectedIngredients.map(s => s.ingredientId));
    return ingredients
      .filter(i => !selectedIds.has(i.id))
      .filter(i => i.name.toLowerCase().includes(ingredientSearch.toLowerCase()))
      .slice(0, 10); // Limit dropdown to 10 items
  }, [ingredients, selectedIngredients, ingredientSearch]);

  const addIngredient = (ingredient: Ingredient) => {
    setSelectedIngredients(prev => [
      ...prev,
      { ingredientId: ingredient.id, name: ingredient.name, unit: ingredient.unit, qtyPerQuart: '1' }
    ]);
    setIngredientSearch('');
    setShowIngredientDropdown(false);
  };

  const removeIngredient = (ingredientId: number) => {
    setSelectedIngredients(prev => prev.filter(i => i.ingredientId !== ingredientId));
  };

  const updateIngredientQty = (ingredientId: number, qty: string) => {
    setSelectedIngredients(prev =>
      prev.map(i => i.ingredientId === ingredientId ? { ...i, qtyPerQuart: qty } : i)
    );
  };

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
      setSelectedIngredients([]);
      setIngredientSearch('');
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: any }) => api.put(`/dishes/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['dishes'] });
      setEditingId(null);
      setShowForm(false);
      reset();
      setSelectedIngredients([]);
      setIngredientSearch('');
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const onSubmit = (values: FormValues) => {
    // Validate ingredients have valid quantities
    const ingredientsPayload = selectedIngredients
      .filter(i => i.qtyPerQuart && parseFloat(i.qtyPerQuart) > 0)
      .map(i => ({
        ingredientId: i.ingredientId,
        qtyPerQuart: parseFloat(i.qtyPerQuart),
      }));

    const payload = {
      name: values.name,
      description: values.description || null,
      defaultQuartsPerThaaliUnit: values.defaultQuartsPerThaaliUnit,
      active: values.active,
      ingredients: ingredientsPayload,
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
    // Load existing ingredients
    setSelectedIngredients(
      dish.ingredients.map(i => ({
        ingredientId: i.ingredientId,
        name: i.ingredientName,
        unit: i.unit,
        qtyPerQuart: i.qtyPerQuart.toString(),
      }))
    );
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
    setSelectedIngredients([]);
    setIngredientSearch('');
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
            className="w-full rounded-xl border py-2 pl-10 pr-10"
            placeholder="Search dishes by name, description, or ingredient..."
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

            {/* Ingredients Section */}
            <div className="border-t pt-4 mt-4">
              <label className="block text-sm font-medium mb-1">
                Ingredients ({selectedIngredients.length} selected)
              </label>
              <p className="text-xs text-gray-500 mb-2">
                Specify the quantity of each ingredient needed per quart of this dish.
              </p>

              {/* Ingredient Search */}
              <div className="relative mb-3" ref={ingredientSearchRef}>
                <input
                  type="text"
                  className="input"
                  placeholder="Search ingredients to add..."
                  value={ingredientSearch}
                  onChange={(e) => {
                    setIngredientSearch(e.target.value);
                    setShowIngredientDropdown(true);
                  }}
                  onFocus={() => setShowIngredientDropdown(true)}
                />
                {showIngredientDropdown && ingredientSearch && filteredIngredients.length > 0 && (
                  <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-md shadow-lg max-h-60 overflow-auto">
                    {filteredIngredients.map((ing) => (
                      <button
                        key={ing.id}
                        type="button"
                        className="w-full text-left px-3 py-2 hover:bg-gray-100 flex justify-between items-center"
                        onClick={() => addIngredient(ing)}
                      >
                        <span>{ing.name}</span>
                        <span className="text-gray-400 text-sm">{ing.unit}</span>
                      </button>
                    ))}
                  </div>
                )}
                {showIngredientDropdown && ingredientSearch && filteredIngredients.length === 0 && (
                  <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-md shadow-lg p-3 text-gray-500 text-sm">
                    No matching ingredients found
                  </div>
                )}
              </div>

              {/* Selected Ingredients List */}
              {selectedIngredients.length > 0 && (
                <div className="border rounded-md divide-y">
                  {selectedIngredients.map((ing) => (
                    <div key={ing.ingredientId} className="flex items-center gap-3 p-2">
                      <div className="flex-1 font-medium">{ing.name}</div>
                      <div className="flex items-center gap-2">
                        <input
                          type="number"
                          step="0.001"
                          min="0"
                          className="input w-20 text-right"
                          value={ing.qtyPerQuart}
                          onChange={(e) => updateIngredientQty(ing.ingredientId, e.target.value)}
                        />
                        <span className="text-xs font-medium text-blue-700 bg-blue-50 px-2 py-1 rounded w-20 text-center">
                          {ing.unit}
                        </span>
                      </div>
                      <button
                        type="button"
                        className="text-red-500 hover:text-red-700 px-2"
                        onClick={() => removeIngredient(ing.ingredientId)}
                        title="Remove ingredient"
                      >
                        &times;
                      </button>
                    </div>
                  ))}
                </div>
              )}
              {selectedIngredients.length === 0 && (
                <p className="text-gray-400 text-sm">No ingredients added. Search above to add ingredients.</p>
              )}
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
      <div className="card overflow-hidden">
        {!dishes || dishes.length === 0 ? (
          <p className="text-gray-500 p-4">No dishes yet. Create your first dish above.</p>
        ) : filteredDishes.length === 0 ? (
          <p className="text-gray-500 p-4">No dishes match your search "{searchQuery}"</p>
        ) : (
          <table className="w-full text-left table-fixed">
            <thead>
              <tr className="bg-gray-50 border-b">
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[25%]">Name</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[10%] text-center">Qt/Unit</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[45%]">Ingredients</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[10%] text-center">Status</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[10%] text-center">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredDishes.map((dish, idx) => (
                <tr key={dish.id} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                  <td className="py-3 px-4">
                    <div className="font-medium text-gray-900">{dish.name}</div>
                    {dish.description && (
                      <div className="text-xs text-gray-500 truncate">{dish.description}</div>
                    )}
                  </td>
                  <td className="py-3 px-4 text-center">
                    <span className="inline-flex items-center justify-center w-8 h-8 bg-blue-50 text-blue-700 font-semibold rounded-full text-sm">
                      {dish.defaultQuartsPerThaaliUnit}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    {dish.ingredients.length > 0 ? (
                      <div className="flex flex-wrap gap-1">
                        {dish.ingredients.slice(0, 4).map((i) => (
                          <span key={i.ingredientId} className="inline-block px-2 py-0.5 bg-gray-100 text-gray-700 text-xs rounded">
                            {i.ingredientName}
                          </span>
                        ))}
                        {dish.ingredients.length > 4 && (
                          <span className="inline-block px-2 py-0.5 bg-gray-200 text-gray-600 text-xs rounded font-medium">
                            +{dish.ingredients.length - 4} more
                          </span>
                        )}
                      </div>
                    ) : (
                      <span className="text-sm text-gray-400 italic">No ingredients</span>
                    )}
                  </td>
                  <td className="py-3 px-4 text-center">
                    {dish.active ? (
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700">
                        <span className="w-1.5 h-1.5 bg-green-500 rounded-full"></span>
                        Active
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-600">
                        <span className="w-1.5 h-1.5 bg-gray-400 rounded-full"></span>
                        Inactive
                      </span>
                    )}
                  </td>
                  <td className="py-3 px-4 text-center">
                    <button
                      onClick={() => startEdit(dish)}
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
      {dishes && dishes.length > 0 && (
        <div className="text-sm text-gray-500">
          {searchQuery ? (
            <>Showing {filteredDishes.length} of {dishes.length} dishes</>
          ) : (
            <>Showing {dishes.length} dish{dishes.length !== 1 ? 'es' : ''} ({dishes.filter(d => d.active).length} active)</>
          )}
        </div>
      )}
    </div>
  );
}
