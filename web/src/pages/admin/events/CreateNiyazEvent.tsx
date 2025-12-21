import { useState } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Chef = { id: number; name: string; type: string; active: boolean };

const schema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().optional(),
  eventDate: z.string().min(1, 'Event date is required'),
  startTime: z.string().optional(),
  registrationOpenAt: z.string().min(1, 'Registration open date is required'),
  registrationCloseAt: z.string().min(1, 'Registration close date is required'),
  miqaatName: z.string().min(1, 'Miqaat name is required'),
  miqaatDate: z.string().min(1, 'Miqaat date is required'),
  miqaatTime: z.string().optional(),
});

type FormValues = z.infer<typeof schema>;

export default function CreateNiyazEvent() {
  const navigate = useNavigate();
  const [selectedChefs, setSelectedChefs] = useState<number[]>([]);
  const [error, setError] = useState<string | null>(null);

  const { data: chefs } = useQuery<Chef[]>({
    queryKey: ['chefs'],
    queryFn: async () => (await api.get('/chefs')).data,
  });

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      title: '',
      description: '',
      eventDate: '',
      startTime: '',
      registrationOpenAt: '',
      registrationCloseAt: '',
      miqaatName: '',
      miqaatDate: '',
      miqaatTime: '',
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: any) => {
      return await api.post('/events/niyaz', data);
    },
    onSuccess: () => {
      navigate('/admin/events');
    },
    onError: (err: any) => {
      setError(err.message || 'Failed to create event');
    },
  });

  const onSubmit = (values: FormValues) => {
    setError(null);
    const payload = {
      title: values.title,
      description: values.description || null,
      eventDate: values.eventDate,
      startTime: values.startTime || null,
      registrationOpenAt: values.registrationOpenAt ? `${values.registrationOpenAt}T00:00:00Z` : null,
      registrationCloseAt: values.registrationCloseAt ? `${values.registrationCloseAt}T23:59:59Z` : null,
      status: 'DRAFT',
      miqaatName: values.miqaatName,
      miqaatDate: values.miqaatDate,
      miqaatTime: values.miqaatTime || null,
      chefIds: selectedChefs,
    };
    createMutation.mutate(payload);
  };

  const toggleChef = (chefId: number) => {
    if (selectedChefs.includes(chefId)) {
      setSelectedChefs(selectedChefs.filter((id) => id !== chefId));
    } else {
      setSelectedChefs([...selectedChefs, chefId]);
    }
  };

  const activeChefs = chefs?.filter((c) => c.active) || [];

  return (
    <div className="space-y-6 max-w-3xl">
      <h1 className="text-2xl font-bold">Create Niyaz Event</h1>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Miqaat Info */}
        <div className="card space-y-4">
          <h2 className="text-lg font-semibold">Miqaat Details</h2>

          <div>
            <label className="block text-sm font-medium mb-1">Miqaat Name *</label>
            <input className="input" {...register('miqaatName')} placeholder="e.g., Urus Mubarak" />
            {errors.miqaatName && <p className="text-red-500 text-sm mt-1">{errors.miqaatName.message}</p>}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Miqaat Date *</label>
              <input type="date" className="input" {...register('miqaatDate')} />
              {errors.miqaatDate && <p className="text-red-500 text-sm mt-1">{errors.miqaatDate.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Miqaat Time</label>
              <input type="time" className="input" {...register('miqaatTime')} />
            </div>
          </div>
        </div>

        {/* Event Details */}
        <div className="card space-y-4">
          <h2 className="text-lg font-semibold">Event Details</h2>

          <div>
            <label className="block text-sm font-medium mb-1">Title *</label>
            <input className="input" {...register('title')} placeholder="e.g., Niyaz for Urus Mubarak" />
            {errors.title && <p className="text-red-500 text-sm mt-1">{errors.title.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Description</label>
            <textarea className="input" rows={3} {...register('description')} placeholder="Optional description" />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Event Date *</label>
              <input type="date" className="input" {...register('eventDate')} />
              {errors.eventDate && <p className="text-red-500 text-sm mt-1">{errors.eventDate.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Start Time</label>
              <input type="time" className="input" {...register('startTime')} />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Registration Opens *</label>
              <input type="date" className="input" {...register('registrationOpenAt')} />
              {errors.registrationOpenAt && (
                <p className="text-red-500 text-sm mt-1">{errors.registrationOpenAt.message}</p>
              )}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Registration Closes *</label>
              <input type="date" className="input" {...register('registrationCloseAt')} />
              {errors.registrationCloseAt && (
                <p className="text-red-500 text-sm mt-1">{errors.registrationCloseAt.message}</p>
              )}
            </div>
          </div>
        </div>

        {/* Chef Selection */}
        <div className="card space-y-4">
          <h2 className="text-lg font-semibold">Chefs / Cooking Groups</h2>
          <p className="text-sm text-gray-500">Select who will be cooking for this event (optional)</p>

          <div className="flex gap-2 flex-wrap">
            {activeChefs.map((chef) => {
              const isSelected = selectedChefs.includes(chef.id);
              return (
                <button
                  key={chef.id}
                  type="button"
                  onClick={() => toggleChef(chef.id)}
                  className={`px-3 py-1 rounded-full text-sm border ${
                    isSelected
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-700 border-gray-300 hover:border-blue-400'
                  }`}
                >
                  {chef.name}
                  {isSelected && ' ✓'}
                </button>
              );
            })}
          </div>

          {activeChefs.length === 0 && (
            <p className="text-gray-400 text-sm">No chefs available. Create chefs in the Catalog first.</p>
          )}
        </div>

        {/* Submit */}
        <div className="flex gap-3">
          <button type="submit" className="btn" disabled={isSubmitting || createMutation.isPending}>
            {isSubmitting || createMutation.isPending ? 'Creating...' : 'Create Event'}
          </button>
          <button type="button" className="btn bg-gray-500" onClick={() => navigate('/admin/events')}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
