import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type LookupItem = {
  id: number;
  name: string;
  displayOrder: number;
  active: boolean;
};

type LookupType = 'categories' | 'stores' | 'storage-locations' | 'units';

type Props = {
  type: LookupType;
  title: string;
  description: string;
};

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  displayOrder: z.coerce.number().int().min(0, 'Must be 0 or greater'),
  active: z.boolean(),
});

type FormValues = z.infer<typeof schema>;

export default function LookupManagement({ type, title, description }: Props) {
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const endpoint = `/ingredient-lookups/${type}`;

  const { data: items, isLoading } = useQuery<LookupItem[]>({
    queryKey: ['ingredient-lookups', type],
    queryFn: async () => (await api.get(`${endpoint}?activeOnly=false`)).data,
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
      displayOrder: 0,
      active: true,
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: { name: string; displayOrder: number }) =>
      api.post(endpoint, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ingredient-lookups', type] });
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: FormValues }) =>
      api.put(`${endpoint}/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ingredient-lookups', type] });
      setEditingId(null);
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => api.delete(`${endpoint}/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ingredient-lookups', type] });
    },
    onError: (err: any) => setError(err.message),
  });

  const onSubmit = (values: FormValues) => {
    if (editingId) {
      updateMutation.mutate({ id: editingId, data: values });
    } else {
      createMutation.mutate({ name: values.name, displayOrder: values.displayOrder });
    }
  };

  const startEdit = (item: LookupItem) => {
    setEditingId(item.id);
    setShowForm(true);
    reset({
      name: item.name,
      displayOrder: item.displayOrder,
      active: item.active,
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setShowForm(false);
    reset({
      name: '',
      displayOrder: 0,
      active: true,
    });
    setError(null);
  };

  const handleDelete = (item: LookupItem) => {
    if (window.confirm(`Are you sure you want to delete "${item.name}"?`)) {
      deleteMutation.mutate(item.id);
    }
  };

  if (isLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">{title}</h1>
          <p className="text-sm text-gray-500 mt-1">{description}</p>
        </div>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn">
            + Add {title.slice(0, -1)}
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
            {editingId ? `Edit ${title.slice(0, -1)}` : `New ${title.slice(0, -1)}`}
          </h2>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input className="input" {...register('name')} placeholder="Enter name" />
                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Display Order</label>
                <input
                  type="number"
                  className="input"
                  {...register('displayOrder')}
                  placeholder="0"
                />
                {errors.displayOrder && (
                  <p className="text-red-500 text-sm mt-1">{errors.displayOrder.message}</p>
                )}
              </div>
            </div>
            {editingId && (
              <div className="flex items-center gap-2">
                <input type="checkbox" id="active" {...register('active')} className="rounded" />
                <label htmlFor="active" className="text-sm">Active</label>
              </div>
            )}
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

      {/* Items Table */}
      <div className="card overflow-hidden">
        {!items || items.length === 0 ? (
          <p className="text-gray-500 p-4">No items yet. Create your first one above.</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="bg-gray-50 border-b">
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider">Name</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-24 text-center">Order</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-24 text-center">Status</th>
                <th className="py-3 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-32 text-center">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {items.map((item, idx) => (
                <tr key={item.id} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                  <td className="py-3 px-4 font-medium text-gray-900 capitalize">{item.name}</td>
                  <td className="py-3 px-4 text-center text-gray-600">{item.displayOrder}</td>
                  <td className="py-3 px-4 text-center">
                    {item.active ? (
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
                      onClick={() => startEdit(item)}
                      className="text-sm font-medium text-blue-600 hover:text-blue-800 mr-3"
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(item)}
                      className="text-sm font-medium text-red-600 hover:text-red-800"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Stats */}
      {items && items.length > 0 && (
        <div className="text-sm text-gray-500">
          Showing {items.length} item{items.length !== 1 ? 's' : ''} ({items.filter(i => i.active).length} active)
        </div>
      )}
    </div>
  );
}
