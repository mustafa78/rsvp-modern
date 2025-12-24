import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../api/client';
import type { NiyazRsvp } from '../types/models';

type Props = {
  eventId: number;
};

export default function NiyazRsvpForm({ eventId }: Props) {
  const queryClient = useQueryClient();
  const [adults, setAdults] = useState(1);
  const [kids, setKids] = useState(0);
  const [error, setError] = useState<string | null>(null);

  // Fetch user's existing RSVP
  const { data: existingRsvp } = useQuery<NiyazRsvp | null>({
    queryKey: ['my-niyaz-rsvp', eventId],
    queryFn: async () => {
      try {
        const res = await api.get(`/niyaz/${eventId}/rsvp/my`);
        return res.data;
      } catch {
        return null;
      }
    },
  });

  // Initialize form with existing RSVP
  useEffect(() => {
    if (existingRsvp) {
      setAdults(existingRsvp.adults);
      setKids(existingRsvp.kids);
    }
  }, [existingRsvp]);

  const submitMutation = useMutation({
    mutationFn: async (data: { adults: number; kids: number }) => {
      return api.post(`/niyaz/${eventId}/rsvp`, data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-niyaz-rsvp', eventId] });
      setError(null);
      alert('Your RSVP has been saved!');
    },
    onError: (err: Error) => {
      setError(err.message || 'Failed to save RSVP');
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (adults < 0 || kids < 0) {
      setError('Counts cannot be negative');
      return;
    }

    if (adults === 0 && kids === 0) {
      setError('Please indicate at least one attendee');
      return;
    }

    submitMutation.mutate({ adults, kids });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {error && (
        <div className="bg-red-100 text-red-700 px-4 py-2 rounded">{error}</div>
      )}

      <div className="card">
        <h3 className="text-lg font-semibold mb-4">How many will attend?</h3>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Adults</label>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setAdults((a) => Math.max(0, a - 1))}
                className="w-10 h-10 rounded-full border border-gray-300 hover:bg-gray-100 text-lg"
              >
                -
              </button>
              <input
                type="number"
                className="input w-20 text-center"
                value={adults}
                onChange={(e) => setAdults(Math.max(0, parseInt(e.target.value) || 0))}
                min={0}
              />
              <button
                type="button"
                onClick={() => setAdults((a) => a + 1)}
                className="w-10 h-10 rounded-full border border-gray-300 hover:bg-gray-100 text-lg"
              >
                +
              </button>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Kids</label>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setKids((k) => Math.max(0, k - 1))}
                className="w-10 h-10 rounded-full border border-gray-300 hover:bg-gray-100 text-lg"
              >
                -
              </button>
              <input
                type="number"
                className="input w-20 text-center"
                value={kids}
                onChange={(e) => setKids(Math.max(0, parseInt(e.target.value) || 0))}
                min={0}
              />
              <button
                type="button"
                onClick={() => setKids((k) => k + 1)}
                className="w-10 h-10 rounded-full border border-gray-300 hover:bg-gray-100 text-lg"
              >
                +
              </button>
            </div>
          </div>
        </div>

        <div className="mt-4 text-sm text-gray-600">
          Total attending: <span className="font-medium">{adults + kids}</span>
        </div>
      </div>

      <button
        type="submit"
        className="btn w-full"
        disabled={submitMutation.isPending}
      >
        {submitMutation.isPending
          ? 'Saving...'
          : existingRsvp
          ? 'Update RSVP'
          : 'Submit RSVP'}
      </button>
    </form>
  );
}
