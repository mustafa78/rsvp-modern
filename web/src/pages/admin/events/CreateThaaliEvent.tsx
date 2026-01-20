import { useState, useMemo, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useNavigate, useParams } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { api } from '../../../api/client';

type Chef = { id: number; name: string; type: string; active: boolean };
type Dish = { id: number; name: string; description: string; defaultQuartsPerThaaliUnit: number; active: boolean };

type ThaaliEventData = {
  id: number;
  title: string;
  description: string | null;
  eventDate: string;
  startTime: string | null;
  registrationOpenAt: string;
  registrationCloseAt: string;
  status: string;
  chefIds: number[];
  menu: { id: number; dishId: number; position: number; quartsPerThaaliUnit: number | null }[];
};

const schema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().optional(),
  eventDate: z.string().min(1, 'Event date is required'),
  startTime: z.string().optional(),
  registrationOpenAt: z.string().min(1, 'Registration open date is required'),
  registrationCloseAt: z.string().min(1, 'Registration close date is required'),
  status: z.string().optional(),
});

type FormValues = z.infer<typeof schema>;

type MenuItemSelection = {
  dishId: number;
  quartsPerThaaliUnit: number | null;
  position: number;
};

export default function CreateThaaliEvent() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { id } = useParams<{ id: string }>();
  const isEditMode = !!id;

  const [selectedChefs, setSelectedChefs] = useState<number[]>([]);
  const [menuItems, setMenuItems] = useState<MenuItemSelection[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [dishSearch, setDishSearch] = useState('');

  const { data: chefs } = useQuery<Chef[]>({
    queryKey: ['chefs'],
    queryFn: async () => (await api.get('/chefs')).data,
  });

  const { data: dishes } = useQuery<Dish[]>({
    queryKey: ['dishes'],
    queryFn: async () => (await api.get('/dishes')).data,
  });

  // Fetch existing event data in edit mode
  const { data: existingEvent, isLoading: isLoadingEvent } = useQuery<ThaaliEventData>({
    queryKey: ['thaali-event', id],
    queryFn: async () => (await api.get(`/thaali/${id}`)).data,
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
      title: '',
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
        title: existingEvent.title || '',
        description: existingEvent.description || '',
        eventDate: existingEvent.eventDate || '',
        startTime: existingEvent.startTime?.slice(0, 5) || '',
        registrationOpenAt: existingEvent.registrationOpenAt?.split('T')[0] || '',
        registrationCloseAt: existingEvent.registrationCloseAt?.split('T')[0] || '',
        status: existingEvent.status || 'DRAFT',
      });
      setSelectedChefs(existingEvent.chefIds || []);
      // Map menu items
      if (existingEvent.menu) {
        setMenuItems(existingEvent.menu.map(m => ({
          dishId: m.dishId,
          quartsPerThaaliUnit: m.quartsPerThaaliUnit,
          position: m.position,
        })));
      }
    }
  }, [existingEvent, reset]);

  const createMutation = useMutation({
    mutationFn: async (data: any) => {
      return await api.post('/events/thaali', data);
    },
    onSuccess: () => {
      // Invalidate announcements in case auto-announcements were created
      queryClient.invalidateQueries({ queryKey: ['announcements'] });
      queryClient.invalidateQueries({ queryKey: ['announcements-unread-count'] });
      navigate('/admin/events');
    },
    onError: (err: any) => {
      setError(err.message || 'Failed to create event');
    },
  });

  const updateMutation = useMutation({
    mutationFn: async (data: any) => {
      return await api.put(`/events/thaali/${id}`, data);
    },
    onSuccess: () => {
      // Invalidate announcements in case auto-announcements were created
      queryClient.invalidateQueries({ queryKey: ['announcements'] });
      queryClient.invalidateQueries({ queryKey: ['announcements-unread-count'] });
      navigate('/admin/events');
    },
    onError: (err: any) => {
      setError(err.message || 'Failed to update event');
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
      status: isEditMode ? values.status : 'DRAFT',
      chefIds: selectedChefs,
      menu: menuItems.map((item, idx) => ({
        dishId: item.dishId,
        quartsPerThaaliUnit: item.quartsPerThaaliUnit,
        position: idx + 1,
      })),
    };

    if (isEditMode) {
      updateMutation.mutate(payload);
    } else {
      createMutation.mutate(payload);
    }
  };

  const addDishToMenu = (dishId: number) => {
    if (menuItems.some((m) => m.dishId === dishId)) return;
    const dish = dishes?.find((d) => d.id === dishId);
    setMenuItems([
      ...menuItems,
      {
        dishId,
        quartsPerThaaliUnit: dish?.defaultQuartsPerThaaliUnit || null,
        position: menuItems.length + 1,
      },
    ]);
  };

  const removeDishFromMenu = (dishId: number) => {
    setMenuItems(menuItems.filter((m) => m.dishId !== dishId));
  };

  const toggleChef = (chefId: number) => {
    if (selectedChefs.includes(chefId)) {
      setSelectedChefs(selectedChefs.filter((id) => id !== chefId));
    } else {
      setSelectedChefs([...selectedChefs, chefId]);
    }
  };

  const activeChefs = chefs?.filter((c) => c.active) || [];
  const activeDishes = dishes?.filter((d) => d.active) || [];

  // Filter dishes based on search - must be before any conditional returns
  const filteredDishes = useMemo(() => {
    if (!dishSearch.trim()) return activeDishes;
    const query = dishSearch.toLowerCase();
    return activeDishes.filter(d => d.name.toLowerCase().includes(query));
  }, [activeDishes, dishSearch]);

  // Separate selected and unselected dishes
  const selectedDishIds = new Set(menuItems.map(m => m.dishId));
  const unselectedDishes = filteredDishes.filter(d => !selectedDishIds.has(d.id));

  if (isEditMode && isLoadingEvent) {
    return <div className="text-gray-500">Loading event...</div>;
  }

  return (
    <div className="space-y-6 max-w-3xl">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">{isEditMode ? 'Edit Thaali Event' : 'Create Thaali Event'}</h1>
        <span className="px-3 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">
          Thaali
        </span>
      </div>

      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="card overflow-hidden p-0">
          <div className="bg-blue-600 px-6 py-4">
            <h2 className="text-lg font-semibold text-white">Thaali Details</h2>
          </div>
          <div className="p-6 space-y-4">

          <div>
            <label className="block text-sm font-medium mb-1">Title *</label>
            <input className="input" {...register('title')} placeholder="e.g., Wednesday Thaali" />
            {errors.title && <p className="text-red-500 text-sm mt-1">{errors.title.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Description</label>
            <textarea className="input" rows={3} {...register('description')} placeholder="Optional description" />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Thaali Date *</label>
              <input type="date" className="input" {...register('eventDate')} />
              {errors.eventDate && <p className="text-red-500 text-sm mt-1">{errors.eventDate.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Pickup Time</label>
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
        </div>

        {/* Menu Selection */}
        <div className="card overflow-hidden p-0">
          <div className="bg-blue-600 px-6 py-4 flex items-center justify-between">
            <div>
              <h2 className="text-lg font-semibold text-white">Menu</h2>
              <p className="text-sm text-blue-200">Select dishes for this event's menu</p>
            </div>
            {menuItems.length > 0 && (
              <span className="px-3 py-1 bg-white/20 text-white rounded-full text-sm font-medium">
                {menuItems.length} selected
              </span>
            )}
          </div>

          <div className="p-6 space-y-4">
          {/* Selected Menu Items */}
          {menuItems.length > 0 && (
            <div className="border border-blue-200 rounded-lg overflow-hidden">
              <div className="bg-blue-50 px-4 py-2 border-b border-blue-200">
                <h3 className="text-sm font-semibold text-blue-900">Selected Menu Items</h3>
              </div>
              <div className="divide-y divide-gray-100">
                {menuItems.map((item, idx) => {
                  const dish = dishes?.find((d) => d.id === item.dishId);
                  return (
                    <div key={item.dishId} className="flex items-center justify-between px-4 py-3 hover:bg-blue-50">
                      <div className="flex items-center gap-3">
                        <span className="flex items-center justify-center w-6 h-6 bg-blue-100 text-blue-700 rounded-full text-xs font-bold">
                          {idx + 1}
                        </span>
                        <span className="font-medium text-gray-900">{dish?.name}</span>
                      </div>
                      <button
                        type="button"
                        onClick={() => removeDishFromMenu(item.dishId)}
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

          {/* Search and Available Dishes */}
          <div className="border rounded-lg overflow-hidden">
            <div className="bg-gray-50 px-4 py-2 border-b">
              <h3 className="text-sm font-semibold text-gray-700">Available Dishes</h3>
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
                  className="input !pl-10 py-2 text-sm"
                  placeholder="Search dishes..."
                  value={dishSearch}
                  onChange={(e) => setDishSearch(e.target.value)}
                />
                {dishSearch && (
                  <button
                    type="button"
                    className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
                    onClick={() => setDishSearch('')}
                  >
                    <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                )}
              </div>
            </div>

            {/* Dish List */}
            <div className="max-h-64 overflow-y-auto">
              {unselectedDishes.length === 0 ? (
                <div className="px-4 py-8 text-center text-gray-500 text-sm">
                  {dishSearch ? (
                    <>No dishes match "{dishSearch}"</>
                  ) : activeDishes.length === 0 ? (
                    <>No dishes available. Create dishes in the Catalog first.</>
                  ) : (
                    <>All dishes have been selected</>
                  )}
                </div>
              ) : (
                <div className="divide-y divide-gray-100">
                  {unselectedDishes.map((dish) => (
                    <button
                      key={dish.id}
                      type="button"
                      onClick={() => addDishToMenu(dish.id)}
                      className="w-full text-left px-4 py-3 hover:bg-blue-50 flex items-center justify-between group transition-colors"
                    >
                      <span className="text-gray-700 group-hover:text-blue-700">{dish.name}</span>
                      <span className="text-blue-600 opacity-0 group-hover:opacity-100 text-sm font-medium transition-opacity">
                        + Add
                      </span>
                    </button>
                  ))}
                </div>
              )}
            </div>

            {/* Footer */}
            {activeDishes.length > 0 && (
              <div className="px-4 py-2 bg-gray-50 border-t text-xs text-gray-500">
                {dishSearch ? (
                  <>Showing {unselectedDishes.length} of {activeDishes.length - menuItems.length} available dishes</>
                ) : (
                  <>{activeDishes.length - menuItems.length} dishes available</>
                )}
              </div>
            )}
          </div>
          </div>
        </div>

        {/* Chef Selection */}
        <div className="card overflow-hidden p-0">
          <div className="bg-blue-600 px-6 py-4">
            <h2 className="text-lg font-semibold text-white">Chefs / Cooking Groups</h2>
            <p className="text-sm text-blue-200">Select who will be cooking for this event</p>
          </div>
          <div className="p-6">
          <div className="flex gap-2 flex-wrap">
            {activeChefs.map((chef) => {
              const isSelected = selectedChefs.includes(chef.id);
              return (
                <button
                  key={chef.id}
                  type="button"
                  onClick={() => toggleChef(chef.id)}
                  className={`px-3 py-1.5 rounded-full text-sm border transition-colors ${
                    isSelected
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-700 border-gray-300 hover:border-blue-400 hover:bg-blue-50'
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
        </div>

        {/* Status (Edit Mode Only) */}
        {isEditMode && (
          <div className="card overflow-hidden p-0">
            <div className="bg-blue-600 px-6 py-4">
              <h2 className="text-lg font-semibold text-white">Thaali Status</h2>
            </div>
            <div className="p-6">
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
            className="px-5 py-2.5 bg-gradient-to-r from-blue-600 to-blue-700 text-white font-medium rounded-lg hover:from-blue-700 hover:to-blue-800 transition-all shadow-sm hover:shadow-md disabled:opacity-50"
            disabled={isSubmitting || createMutation.isPending || updateMutation.isPending}
          >
            {isSubmitting || createMutation.isPending || updateMutation.isPending
              ? (isEditMode ? 'Saving...' : 'Creating...')
              : (isEditMode ? 'Save Changes' : 'Create Event')}
          </button>
          <button type="button" className="px-5 py-2.5 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors" onClick={() => navigate('/admin/events')}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
