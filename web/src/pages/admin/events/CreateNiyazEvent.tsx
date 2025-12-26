import { useState, useMemo, useEffect } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useNavigate, useParams } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Person = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string | null;
};

type NiyazEventData = {
  id: number;
  title: string;
  description: string | null;
  eventDate: string;
  startTime: string | null;
  registrationOpenAt: string;
  registrationCloseAt: string;
  status: string;
  miqaatName: string;
  hostIds: number[];
};

const schema = z.object({
  miqaatName: z.string().min(1, 'Miqaat name is required'),
  description: z.string().optional(),
  eventDate: z.string().min(1, 'Miqaat date is required'),
  startTime: z.string().optional(),
  registrationOpenAt: z.string().min(1, 'Registration open date is required'),
  registrationCloseAt: z.string().min(1, 'Registration close date is required'),
  status: z.string().optional(),
});

type FormValues = z.infer<typeof schema>;

export default function CreateNiyazEvent() {
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const isEditMode = !!id;

  const [selectedHosts, setSelectedHosts] = useState<number[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [hostSearch, setHostSearch] = useState('');

  const { data: persons } = useQuery<Person[]>({
    queryKey: ['persons'],
    queryFn: async () => (await api.get('/admin/users')).data,
  });

  // Fetch existing event data in edit mode
  const { data: existingEvent, isLoading: isLoadingEvent } = useQuery<NiyazEventData>({
    queryKey: ['niyaz-event', id],
    queryFn: async () => (await api.get(`/niyaz/${id}`)).data,
    enabled: isEditMode,
  });

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      miqaatName: '',
      description: '',
      eventDate: '',
      startTime: '',
      registrationOpenAt: '',
      registrationCloseAt: '',
      status: 'DRAFT',
    },
  });

  // Populate form with existing data in edit mode
  useEffect(() => {
    if (existingEvent) {
      reset({
        miqaatName: existingEvent.miqaatName || '',
        description: existingEvent.description || '',
        eventDate: existingEvent.eventDate || '',
        startTime: existingEvent.startTime?.slice(0, 5) || '',
        registrationOpenAt: existingEvent.registrationOpenAt?.split('T')[0] || '',
        registrationCloseAt: existingEvent.registrationCloseAt?.split('T')[0] || '',
        status: existingEvent.status || 'DRAFT',
      });
      setSelectedHosts(existingEvent.hostIds || []);
    }
  }, [existingEvent, reset]);

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

  const updateMutation = useMutation({
    mutationFn: async (data: any) => {
      return await api.put(`/events/niyaz/${id}`, data);
    },
    onSuccess: () => {
      navigate('/admin/events');
    },
    onError: (err: any) => {
      setError(err.message || 'Failed to update event');
    },
  });

  const onSubmit = (values: FormValues) => {
    setError(null);
    const payload = {
      title: values.miqaatName,
      description: values.description || null,
      eventDate: values.eventDate,
      startTime: values.startTime || null,
      registrationOpenAt: values.registrationOpenAt ? `${values.registrationOpenAt}T00:00:00Z` : null,
      registrationCloseAt: values.registrationCloseAt ? `${values.registrationCloseAt}T23:59:59Z` : null,
      status: isEditMode ? values.status : 'DRAFT',
      miqaatName: values.miqaatName,
      hostIds: selectedHosts,
    };

    if (isEditMode) {
      updateMutation.mutate(payload);
    } else {
      createMutation.mutate(payload);
    }
  };

  const addHost = (personId: number) => {
    if (!selectedHosts.includes(personId)) {
      setSelectedHosts([...selectedHosts, personId]);
    }
  };

  const removeHost = (personId: number) => {
    setSelectedHosts(selectedHosts.filter((id) => id !== personId));
  };

  // Filter persons based on search
  const filteredPersons = useMemo(() => {
    if (!persons) return [];
    if (!hostSearch.trim()) return persons;
    const query = hostSearch.toLowerCase();
    return persons.filter(p =>
      p.firstName.toLowerCase().includes(query) ||
      p.lastName.toLowerCase().includes(query) ||
      p.itsNumber.toLowerCase().includes(query) ||
      p.email.toLowerCase().includes(query)
    );
  }, [persons, hostSearch]);

  // Separate selected and unselected persons
  const selectedHostIds = new Set(selectedHosts);
  const unselectedPersons = filteredPersons.filter(p => !selectedHostIds.has(p.id));

  if (isEditMode && isLoadingEvent) {
    return <div className="text-gray-500">Loading event...</div>;
  }

  return (
    <div className="space-y-6 max-w-3xl">
      <h1 className="text-2xl font-bold">{isEditMode ? 'Edit Niyaz Event' : 'Create Niyaz Event'}</h1>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Miqaat Details */}
        <div className="card space-y-4">
          <h2 className="text-lg font-semibold">Miqaat Details</h2>

          <div>
            <label className="block text-sm font-medium mb-1">Miqaat Name *</label>
            <input className="input" {...register('miqaatName')} placeholder="e.g., Urus Mubarak, Syedna Taher Saifuddin RA" />
            {errors.miqaatName && <p className="text-red-500 text-sm mt-1">{errors.miqaatName.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Description</label>
            <textarea className="input" rows={3} {...register('description')} placeholder="Optional description" />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Miqaat Date *</label>
              <input type="date" className="input" {...register('eventDate')} />
              {errors.eventDate && <p className="text-red-500 text-sm mt-1">{errors.eventDate.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Miqaat Start Time</label>
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

        {/* Niyaz Hosts Selection */}
        <div className="card space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-lg font-semibold">Niyaz Khidmat</h2>
              <p className="text-sm text-gray-500">Select one or more persons performing this Niyaz khidmat</p>
            </div>
            {selectedHosts.length > 0 && (
              <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                {selectedHosts.length} selected
              </span>
            )}
          </div>

          {/* Selected Hosts */}
          {selectedHosts.length > 0 && (
            <div className="border rounded-lg overflow-hidden">
              <div className="bg-green-50 px-4 py-2 border-b">
                <h3 className="text-sm font-semibold text-green-900">Selected Khidmatguzars</h3>
              </div>
              <div className="divide-y divide-gray-100">
                {selectedHosts.map((hostId, idx) => {
                  const person = persons?.find((p) => p.id === hostId);
                  return (
                    <div key={hostId} className="flex items-center justify-between px-4 py-3 hover:bg-gray-50">
                      <div className="flex items-center gap-3">
                        <span className="flex items-center justify-center w-6 h-6 bg-green-100 text-green-700 rounded-full text-xs font-bold">
                          {idx + 1}
                        </span>
                        <div>
                          <span className="font-medium text-gray-900">{person?.firstName} {person?.lastName}</span>
                          <span className="text-gray-500 text-sm ml-2">({person?.itsNumber})</span>
                        </div>
                      </div>
                      <button
                        type="button"
                        onClick={() => removeHost(hostId)}
                        className="text-red-500 hover:text-red-700 hover:bg-red-50 px-2 py-1 rounded text-sm transition-colors"
                      >
                        Remove
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Search and Available Persons */}
          <div className="border rounded-lg overflow-hidden">
            <div className="bg-gray-50 px-4 py-2 border-b">
              <h3 className="text-sm font-semibold text-gray-700">Available Members</h3>
            </div>

            {/* Search */}
            <div className="p-3 border-b bg-white">
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg className="h-4 w-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </div>
                <input
                  type="text"
                  className="input pl-9 py-2 text-sm"
                  placeholder="Search by name, ITS number, or email..."
                  value={hostSearch}
                  onChange={(e) => setHostSearch(e.target.value)}
                />
                {hostSearch && (
                  <button
                    type="button"
                    className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
                    onClick={() => setHostSearch('')}
                  >
                    <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                )}
              </div>
            </div>

            {/* Person List */}
            <div className="max-h-64 overflow-y-auto">
              {unselectedPersons.length === 0 ? (
                <div className="px-4 py-8 text-center text-gray-500 text-sm">
                  {hostSearch ? (
                    <>No members match "{hostSearch}"</>
                  ) : persons?.length === 0 ? (
                    <>No members available.</>
                  ) : (
                    <>All members have been selected</>
                  )}
                </div>
              ) : (
                <div className="divide-y divide-gray-100">
                  {unselectedPersons.map((person) => (
                    <button
                      key={person.id}
                      type="button"
                      onClick={() => addHost(person.id)}
                      className="w-full text-left px-4 py-3 hover:bg-green-50 flex items-center justify-between group transition-colors"
                    >
                      <div>
                        <span className="text-gray-700 group-hover:text-green-700">{person.firstName} {person.lastName}</span>
                        <span className="text-gray-400 text-sm ml-2">({person.itsNumber})</span>
                      </div>
                      <span className="text-green-600 opacity-0 group-hover:opacity-100 text-sm font-medium transition-opacity">
                        + Add
                      </span>
                    </button>
                  ))}
                </div>
              )}
            </div>

            {/* Footer */}
            {persons && persons.length > 0 && (
              <div className="px-4 py-2 bg-gray-50 border-t text-xs text-gray-500">
                {hostSearch ? (
                  <>Showing {unselectedPersons.length} of {persons.length - selectedHosts.length} available members</>
                ) : (
                  <>{persons.length - selectedHosts.length} members available</>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Status (Edit Mode Only) */}
        {isEditMode && (
          <div className="card space-y-4">
            <h2 className="text-lg font-semibold">Event Status</h2>
            <div>
              <label className="block text-sm font-medium mb-1">Status</label>
              <select className="input" {...register('status')}>
                <option value="DRAFT">Draft</option>
                <option value="PUBLISHED">Published</option>
                <option value="CANCELLED">Cancelled</option>
              </select>
            </div>
          </div>
        )}

        {/* Submit */}
        <div className="flex gap-3">
          <button
            type="submit"
            className="btn"
            disabled={isSubmitting || createMutation.isPending || updateMutation.isPending}
          >
            {isSubmitting || createMutation.isPending || updateMutation.isPending
              ? (isEditMode ? 'Saving...' : 'Creating...')
              : (isEditMode ? 'Save Changes' : 'Create Event')}
          </button>
          <button type="button" className="btn bg-gray-500" onClick={() => navigate('/admin/events')}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
