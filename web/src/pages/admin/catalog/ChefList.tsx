import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type ChefType = 'PERSON' | 'GROUP' | 'EXTERNAL';

type Chef = {
  id: number;
  name: string;
  type: ChefType;
  email: string | null;
  phone: string | null;
  notes: string | null;
  active: boolean;
};

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  type: z.enum(['PERSON', 'GROUP', 'EXTERNAL']),
  email: z.string().email().optional().or(z.literal('')),
  phone: z.string().optional(),
  notes: z.string().optional(),
  active: z.boolean(),
});

type FormValues = z.infer<typeof schema>;

const chefTypeLabels: Record<ChefType, string> = {
  PERSON: 'Individual',
  GROUP: 'Group',
  EXTERNAL: 'External Vendor',
};

export default function ChefList() {
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const queryClient = useQueryClient();

  const { data: chefs, isLoading } = useQuery<Chef[]>({
    queryKey: ['chefs'],
    queryFn: async () => (await api.get('/chefs')).data,
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
      type: 'GROUP',
      email: '',
      phone: '',
      notes: '',
      active: true,
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: any) => api.post('/chefs', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['chefs'] });
      setShowForm(false);
      reset();
      setError(null);
    },
    onError: (err: any) => setError(err.message),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: any }) => api.put(`/chefs/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['chefs'] });
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
      type: values.type,
      email: values.email || null,
      phone: values.phone || null,
      notes: values.notes || null,
      active: values.active,
    };

    if (editingId) {
      updateMutation.mutate({ id: editingId, data: payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const startEdit = (chef: Chef) => {
    setEditingId(chef.id);
    setShowForm(true);
    reset({
      name: chef.name,
      type: chef.type,
      email: chef.email || '',
      phone: chef.phone || '',
      notes: chef.notes || '',
      active: chef.active,
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setShowForm(false);
    reset({
      name: '',
      type: 'GROUP',
      email: '',
      phone: '',
      notes: '',
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
        <h1 className="text-2xl font-bold">Chefs & Cooking Groups</h1>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn">
            + Add Chef/Group
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
            {editingId ? 'Edit Chef/Group' : 'New Chef/Group'}
          </h2>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <input className="input" {...register('name')} placeholder="e.g., Jamaat Kitchen" />
                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Type *</label>
                <select className="input" {...register('type')}>
                  <option value="GROUP">Group</option>
                  <option value="PERSON">Individual</option>
                  <option value="EXTERNAL">External Vendor</option>
                </select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Email</label>
                <input type="email" className="input" {...register('email')} placeholder="contact@example.com" />
                {errors.email && <p className="text-red-500 text-sm mt-1">{errors.email.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Phone</label>
                <input className="input" {...register('phone')} placeholder="(555) 123-4567" />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Notes</label>
              <textarea className="input" rows={2} {...register('notes')} placeholder="Optional notes" />
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

      {/* Chefs Table */}
      <div className="card">
        {!chefs || chefs.length === 0 ? (
          <p className="text-gray-500">No chefs/groups yet. Create your first one above.</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Name</th>
                <th className="pb-2 font-medium">Type</th>
                <th className="pb-2 font-medium">Contact</th>
                <th className="pb-2 font-medium">Status</th>
                <th className="pb-2 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {chefs.map((chef) => (
                <tr key={chef.id} className="border-b last:border-0">
                  <td className="py-3">
                    <div className="font-medium">{chef.name}</div>
                    {chef.notes && (
                      <div className="text-sm text-gray-500 truncate max-w-xs">{chef.notes}</div>
                    )}
                  </td>
                  <td className="py-3">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        chef.type === 'GROUP'
                          ? 'bg-blue-100 text-blue-700'
                          : chef.type === 'PERSON'
                          ? 'bg-purple-100 text-purple-700'
                          : 'bg-orange-100 text-orange-700'
                      }`}
                    >
                      {chefTypeLabels[chef.type]}
                    </span>
                  </td>
                  <td className="py-3 text-sm text-gray-600">
                    {chef.email && <div>{chef.email}</div>}
                    {chef.phone && <div>{chef.phone}</div>}
                    {!chef.email && !chef.phone && <span className="text-gray-400">-</span>}
                  </td>
                  <td className="py-3">
                    <span
                      className={`text-xs px-2 py-1 rounded ${
                        chef.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
                      }`}
                    >
                      {chef.active ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td className="py-3">
                    <button
                      onClick={() => startEdit(chef)}
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
