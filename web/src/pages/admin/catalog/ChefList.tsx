import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

// Format phone number as (xxx) xxx-xxxx
function formatPhoneNumber(value: string): string {
  // Remove all non-digit characters
  const digits = value.replace(/\D/g, '');

  // Limit to 10 digits
  const limited = digits.slice(0, 10);

  // Format based on length
  if (limited.length === 0) return '';
  if (limited.length <= 3) return `(${limited}`;
  if (limited.length <= 6) return `(${limited.slice(0, 3)}) ${limited.slice(3)}`;
  return `(${limited.slice(0, 3)}) ${limited.slice(3, 6)}-${limited.slice(6)}`;
}

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
    setValue,
    watch,
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

  const phoneValue = watch('phone');

  const handlePhoneChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatPhoneNumber(e.target.value);
    setValue('phone', formatted);
  };

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
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Chefs & Cooking Groups</h1>
          <p className="text-gray-500 mt-1">Manage cooking groups, individual chefs, and external vendors</p>
        </div>
        {!showForm && (
          <button onClick={() => setShowForm(true)} className="btn bg-blue-600 hover:bg-blue-700">
            + Add Chef/Group
          </button>
        )}
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-3 rounded-lg">{error}</div>
      )}

      {/* Create/Edit Form */}
      {showForm && (
        <div className="card overflow-hidden p-0">
          <div className="bg-blue-600 px-6 py-4">
            <h2 className="text-lg font-semibold text-white">
              {editingId ? 'Edit Chef/Group' : 'New Chef/Group'}
            </h2>
          </div>
          <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-5">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Name *</label>
                <input className="input" {...register('name')} placeholder="e.g., Jamaat Kitchen" />
                {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Type *</label>
                <select className="input" {...register('type')}>
                  <option value="GROUP">Group</option>
                  <option value="PERSON">Individual</option>
                  <option value="EXTERNAL">External Vendor</option>
                </select>
              </div>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Email</label>
                <input type="email" className="input" {...register('email')} placeholder="contact@example.com" />
                {errors.email && <p className="text-red-500 text-sm mt-1">{errors.email.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Phone</label>
                <input
                  className="input"
                  value={phoneValue || ''}
                  onChange={handlePhoneChange}
                  placeholder="(xxx) xxx-xxxx"
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Notes</label>
              <textarea className="input" rows={2} {...register('notes')} placeholder="Optional notes" />
            </div>
            <div className="flex items-center gap-2">
              <input type="checkbox" id="active" {...register('active')} className="rounded" />
              <label htmlFor="active" className="text-sm text-gray-700">Active</label>
            </div>
            <div className="flex gap-3 pt-2">
              <button type="submit" className="btn bg-blue-600 hover:bg-blue-700" disabled={isSubmitting}>
                {isSubmitting ? 'Saving...' : editingId ? 'Update' : 'Create'}
              </button>
              <button type="button" className="btn bg-gray-500 hover:bg-gray-600" onClick={cancelEdit}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Chefs Table */}
      <div className="card overflow-hidden p-0">
        <div className="bg-gray-50 px-6 py-4 border-b">
          <h2 className="text-lg font-semibold text-gray-800">All Chefs & Groups</h2>
          <p className="text-sm text-gray-500 mt-0.5">{chefs?.length || 0} total</p>
        </div>
        {!chefs || chefs.length === 0 ? (
          <div className="p-6">
            <p className="text-gray-500">No chefs/groups yet. Click "Add Chef/Group" to create your first one.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-6 font-semibold text-gray-600 uppercase tracking-wider text-xs">Name</th>
                  <th className="py-3 px-4 font-semibold text-gray-600 uppercase tracking-wider text-xs">Type</th>
                  <th className="py-3 px-4 font-semibold text-gray-600 uppercase tracking-wider text-xs">Contact</th>
                  <th className="py-3 px-4 font-semibold text-gray-600 uppercase tracking-wider text-xs">Status</th>
                  <th className="py-3 px-4 font-semibold text-gray-600 uppercase tracking-wider text-xs">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {chefs.map((chef, idx) => (
                  <tr key={chef.id} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    <td className="py-4 px-6">
                      <div className="font-medium text-gray-900">{chef.name}</div>
                      {chef.notes && (
                        <div className="text-sm text-gray-500 truncate max-w-xs mt-0.5">{chef.notes}</div>
                      )}
                    </td>
                    <td className="py-4 px-4">
                      <span
                        className={`text-xs font-medium px-2.5 py-1 rounded-full ${
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
                    <td className="py-4 px-4 text-gray-600">
                      {chef.email && <div>{chef.email}</div>}
                      {chef.phone && <div className="mt-0.5">{chef.phone}</div>}
                      {!chef.email && !chef.phone && <span className="text-gray-400">—</span>}
                    </td>
                    <td className="py-4 px-4">
                      <span
                        className={`text-xs font-medium px-2.5 py-1 rounded-full ${
                          chef.active ? 'bg-green-100 text-green-700' : 'bg-gray-200 text-gray-600'
                        }`}
                      >
                        {chef.active ? 'Active' : 'Inactive'}
                      </span>
                    </td>
                    <td className="py-4 px-4">
                      <button
                        onClick={() => startEdit(chef)}
                        className="text-sm font-medium text-blue-600 hover:text-blue-800 hover:underline"
                      >
                        Edit
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
