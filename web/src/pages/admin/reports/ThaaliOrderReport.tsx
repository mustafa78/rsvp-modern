import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

type CountReport = {
  large: number;
  small: number;
  barakati: number;
  totalQuarts: number;
};

type ShoppingItem = {
  ingredientId: number;
  ingredientName: string;
  unit: string;
  requiredQty: number;
};

export default function ThaaliOrderReport() {
  const { eventId } = useParams<{ eventId: string }>();

  const { data: event, isLoading: eventLoading } = useQuery<Event>({
    queryKey: ['event', eventId],
    queryFn: async () => (await api.get(`/events/${eventId}`)).data,
    enabled: !!eventId,
  });

  const { data: counts, isLoading: countsLoading } = useQuery<CountReport>({
    queryKey: ['thaali-counts', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/counts`)).data,
    enabled: !!eventId,
  });

  const { data: shoppingList, isLoading: shoppingLoading } = useQuery<ShoppingItem[]>({
    queryKey: ['thaali-shopping', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/shopping-list`)).data,
    enabled: !!eventId,
  });

  if (eventLoading || countsLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  if (!event) {
    return (
      <div className="space-y-4">
        <h1 className="text-2xl font-bold">Event Not Found</h1>
        <Link to="/admin/events" className="text-blue-600 hover:underline">
          ← Back to Events
        </Link>
      </div>
    );
  }

  const totalOrders = (counts?.large || 0) + (counts?.small || 0) + (counts?.barakati || 0);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Thaali Orders Report</h1>
          <p className="text-gray-500">{event.title} - {event.eventDate}</p>
        </div>
        <Link to="/admin/events" className="btn bg-gray-500">
          ← Back to Events
        </Link>
      </div>

      {/* Order Counts */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Order Summary</h2>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
          <div className="bg-purple-50 rounded-lg p-4 text-center">
            <div className="text-3xl font-bold text-purple-600">{counts?.large || 0}</div>
            <div className="text-sm text-gray-600">Large (1 qt)</div>
          </div>
          <div className="bg-blue-50 rounded-lg p-4 text-center">
            <div className="text-3xl font-bold text-blue-600">{counts?.small || 0}</div>
            <div className="text-sm text-gray-600">Small (½ qt)</div>
          </div>
          <div className="bg-green-50 rounded-lg p-4 text-center">
            <div className="text-3xl font-bold text-green-600">{counts?.barakati || 0}</div>
            <div className="text-sm text-gray-600">Barakati (¼ qt)</div>
          </div>
          <div className="bg-gray-50 rounded-lg p-4 text-center">
            <div className="text-3xl font-bold text-gray-700">{totalOrders}</div>
            <div className="text-sm text-gray-600">Total Orders</div>
          </div>
          <div className="bg-orange-50 rounded-lg p-4 text-center">
            <div className="text-3xl font-bold text-orange-600">
              {counts?.totalQuarts?.toFixed(2) || '0.00'}
            </div>
            <div className="text-sm text-gray-600">Total Quarts</div>
          </div>
        </div>
      </div>

      {/* Shopping List */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Shopping List</h2>
        {shoppingLoading ? (
          <p className="text-gray-500">Loading shopping list...</p>
        ) : !shoppingList || shoppingList.length === 0 ? (
          <p className="text-gray-500">No ingredients calculated. Make sure the event has a menu with dishes that have ingredients.</p>
        ) : (
          <table className="w-full text-left">
            <thead>
              <tr className="border-b">
                <th className="pb-2 font-medium">Ingredient</th>
                <th className="pb-2 font-medium text-right">Required Qty</th>
                <th className="pb-2 font-medium">Unit</th>
              </tr>
            </thead>
            <tbody>
              {shoppingList.map((item) => (
                <tr key={item.ingredientId} className="border-b last:border-0">
                  <td className="py-2 font-medium">{item.ingredientName}</td>
                  <td className="py-2 text-right text-lg">
                    {typeof item.requiredQty === 'number'
                      ? item.requiredQty.toFixed(2)
                      : item.requiredQty}
                  </td>
                  <td className="py-2 text-gray-600">{item.unit}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Print Button */}
      <div className="flex gap-3">
        <button onClick={() => window.print()} className="btn">
          Print Report
        </button>
      </div>
    </div>
  );
}
