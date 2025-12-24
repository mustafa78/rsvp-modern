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
  defaultStore: string | null;
  category: string | null;
};

// Group shopping items by store
function groupByStore(items: ShoppingItem[]): Record<string, ShoppingItem[]> {
  const grouped: Record<string, ShoppingItem[]> = {};
  for (const item of items) {
    const store = item.defaultStore || 'Other';
    if (!grouped[store]) {
      grouped[store] = [];
    }
    grouped[store].push(item);
  }
  return grouped;
}

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
          <div className="space-y-6">
            {Object.entries(groupByStore(shoppingList)).map(([store, items]) => (
              <div key={store}>
                <h3 className="text-md font-semibold text-gray-700 bg-gray-100 px-3 py-2 rounded-t border-b">
                  {store} <span className="text-gray-400 font-normal">({items.length} items)</span>
                </h3>
                <table className="w-full text-left">
                  <thead>
                    <tr className="border-b bg-gray-50">
                      <th className="py-2 px-3 font-medium text-sm text-gray-600">Ingredient</th>
                      <th className="py-2 px-3 font-medium text-sm text-gray-600">Category</th>
                      <th className="py-2 px-3 font-medium text-sm text-gray-600 text-right">Qty</th>
                      <th className="py-2 px-3 font-medium text-sm text-gray-600">Unit</th>
                    </tr>
                  </thead>
                  <tbody>
                    {items.map((item) => (
                      <tr key={item.ingredientId} className="border-b last:border-0 hover:bg-gray-50">
                        <td className="py-2 px-3 font-medium">{item.ingredientName}</td>
                        <td className="py-2 px-3 text-gray-500 text-sm">{item.category || '-'}</td>
                        <td className="py-2 px-3 text-right text-lg font-semibold">
                          {typeof item.requiredQty === 'number'
                            ? item.requiredQty.toFixed(2)
                            : item.requiredQty}
                        </td>
                        <td className="py-2 px-3 text-gray-600">{item.unit}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ))}
          </div>
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
