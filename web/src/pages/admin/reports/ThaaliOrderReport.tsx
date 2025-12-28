import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

type Event = {
  id: number;
  type: string;
  title: string;
  eventDate: string;
  status: string;
};

type MenuItemCount = {
  menuItemId: number;
  dishName: string;
  largeCount: number;
  smallCount: number;
  barakatiCount: number;
};

type DetailedReport = {
  totals: {
    large: number;
    small: number;
    barakati: number;
    totalQuarts: number;
  };
  byMenuItem: MenuItemCount[];
};

type ShoppingItem = {
  ingredientId: number;
  ingredientName: string;
  unit: string;
  requiredQty: number;
  defaultStore: string | null;
  category: string | null;
};

type DishShoppingList = {
  dishId: number;
  dishName: string;
  totalQuarts: number;
  ingredients: ShoppingItem[];
};

type PerDishShoppingList = {
  dishes: DishShoppingList[];
};

type ShoppingViewMode = 'byStore' | 'byDish';

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
  // Sort items within each group by name
  for (const store in grouped) {
    grouped[store].sort((a, b) => a.ingredientName.localeCompare(b.ingredientName));
  }
  // Sort stores (put "Other" at the end)
  const sortedStores = Object.keys(grouped).sort((a, b) => {
    if (a === 'Other') return 1;
    if (b === 'Other') return -1;
    return a.localeCompare(b);
  });
  const sortedGrouped: Record<string, ShoppingItem[]> = {};
  for (const store of sortedStores) {
    sortedGrouped[store] = grouped[store];
  }
  return sortedGrouped;
}

// Calculate quarts for a dish based on order counts
function calculateDishQuarts(item: MenuItemCount): number {
  return item.largeCount * 1.0 + item.smallCount * 0.5 + item.barakatiCount * 0.25;
}

export default function ThaaliOrderReport() {
  const { eventId } = useParams<{ eventId: string }>();
  const [shoppingViewMode, setShoppingViewMode] = useState<ShoppingViewMode>('byStore');

  const { data: event, isLoading: eventLoading } = useQuery<Event>({
    queryKey: ['event', eventId],
    queryFn: async () => (await api.get(`/events/${eventId}`)).data,
    enabled: !!eventId,
  });

  const { data: detailedReport, isLoading: reportLoading } = useQuery<DetailedReport>({
    queryKey: ['thaali-detailed-report', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/detailed-report`)).data,
    enabled: !!eventId,
  });

  const { data: shoppingList, isLoading: shoppingLoading } = useQuery<ShoppingItem[]>({
    queryKey: ['thaali-shopping', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/shopping-list`)).data,
    enabled: !!eventId && shoppingViewMode === 'byStore',
  });

  const { data: perDishShopping, isLoading: perDishLoading } = useQuery<PerDishShoppingList>({
    queryKey: ['thaali-shopping-per-dish', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/shopping-list-per-dish`)).data,
    enabled: !!eventId && shoppingViewMode === 'byDish',
  });

  if (eventLoading || reportLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  const counts = detailedReport?.totals;

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

  // Export shopping list to PDF using jsPDF
  const exportShoppingListToPDF = () => {
    if (!shoppingList || shoppingList.length === 0) {
      alert('No shopping list data to export');
      return;
    }

    const doc = new jsPDF();
    const groupedItems = groupByStore(shoppingList);
    const date = new Date().toLocaleDateString();
    let yPos = 20;

    // Title
    doc.setFontSize(20);
    doc.setFont('helvetica', 'bold');
    doc.text('Shopping List', 14, yPos);
    yPos += 10;

    // Event info
    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(100);
    doc.text(`${event.title} - ${event.eventDate}`, 14, yPos);
    yPos += 6;
    doc.text(`Generated: ${date}`, 14, yPos);
    yPos += 6;

    // Order summary
    doc.setTextColor(60);
    doc.text(`Orders: ${counts?.large || 0} Large + ${counts?.small || 0} Small + ${counts?.barakati || 0} Barakati = ${counts?.totalQuarts?.toFixed(2) || '0'} Quarts`, 14, yPos);
    yPos += 6;
    doc.text(`Total Ingredients: ${shoppingList.length}`, 14, yPos);
    yPos += 12;

    // Shopping list by store
    for (const [store, items] of Object.entries(groupedItems)) {
      // Check if we need a new page
      if (yPos > 250) {
        doc.addPage();
        yPos = 20;
      }

      // Store header
      doc.setFillColor(37, 99, 235); // Blue-600
      doc.rect(14, yPos - 5, 182, 8, 'F');
      doc.setFontSize(11);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(255);
      doc.text(`${store} (${items.length} items)`, 16, yPos);
      yPos += 6;

      // Table for this store
      autoTable(doc, {
        startY: yPos,
        head: [['Ingredient', 'Category', 'Qty', 'Unit']],
        body: items.map(item => [
          item.ingredientName,
          item.category || '-',
          typeof item.requiredQty === 'number' ? item.requiredQty.toFixed(2) : String(item.requiredQty),
          item.unit
        ]),
        theme: 'striped',
        headStyles: {
          fillColor: [243, 244, 246], // Gray-100
          textColor: [75, 85, 99], // Gray-600
          fontStyle: 'bold',
          fontSize: 9,
        },
        bodyStyles: {
          fontSize: 10,
          textColor: [31, 41, 55], // Gray-800
        },
        columnStyles: {
          0: { cellWidth: 70 },
          1: { cellWidth: 50 },
          2: { cellWidth: 25, halign: 'right', fontStyle: 'bold', textColor: [37, 99, 235] },
          3: { cellWidth: 30 },
        },
        margin: { left: 14, right: 14 },
        tableWidth: 'auto',
      });

      // Get the final Y position after the table
      yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 10;
    }

    // Add summary at the end
    if (yPos > 240) {
      doc.addPage();
      yPos = 20;
    }

    doc.setFillColor(249, 250, 251); // Gray-50
    doc.rect(14, yPos - 2, 182, 30, 'F');
    doc.setDrawColor(229, 231, 235); // Gray-200
    doc.rect(14, yPos - 2, 182, 30, 'S');

    doc.setFontSize(11);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(31, 41, 55);
    doc.text('Order Summary', 18, yPos + 5);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.text(`Large (1 qt): ${counts?.large || 0}`, 18, yPos + 12);
    doc.text(`Small (1/2 qt): ${counts?.small || 0}`, 70, yPos + 12);
    doc.text(`Barakati (1/4 qt): ${counts?.barakati || 0}`, 122, yPos + 12);
    doc.setFont('helvetica', 'bold');
    doc.text(`Total Quarts: ${counts?.totalQuarts?.toFixed(2) || '0'}`, 18, yPos + 20);

    // Save the PDF
    const fileName = `shopping-list-${event.title.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
  };

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
      <div className="card overflow-hidden p-0">
        <div className="bg-blue-600 px-6 py-4">
          <h2 className="text-lg font-semibold text-white">Order Summary</h2>
        </div>
        <div className="p-6">
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
      </div>

      {/* Dish Summary - Quarts per Dish */}
      {detailedReport?.byMenuItem && detailedReport.byMenuItem.length > 0 && (
        <div className="card overflow-hidden p-0">
          <div className="bg-blue-600 px-6 py-4">
            <h2 className="text-lg font-semibold text-white">Quarts per Dish</h2>
            <p className="text-sm text-blue-200">How many quarts to cook for each dish</p>
          </div>
          <div className="p-0">
            <table className="w-full">
              <thead>
                <tr className="bg-gray-50 border-b">
                  <th className="py-3 px-6 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Dish</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-20">Large</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-20">Small</th>
                  <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-20">Barakati</th>
                  <th className="py-3 px-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider w-28">Total Quarts</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {detailedReport.byMenuItem.map((item, idx) => (
                  <tr key={item.menuItemId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    <td className="py-3 px-6 font-medium text-gray-900">{item.dishName}</td>
                    <td className="py-3 px-4 text-center text-purple-600 font-medium">{item.largeCount}</td>
                    <td className="py-3 px-4 text-center text-blue-600 font-medium">{item.smallCount}</td>
                    <td className="py-3 px-4 text-center text-green-600 font-medium">{item.barakatiCount}</td>
                    <td className="py-3 px-4 text-right text-lg font-bold text-orange-600">
                      {calculateDishQuarts(item).toFixed(2)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Shopping List */}
      <div className="card overflow-hidden p-0">
        <div className="bg-blue-600 px-6 py-4 flex items-center justify-between">
          <div>
            <h2 className="text-lg font-semibold text-white">Shopping List</h2>
            <p className="text-sm text-blue-200">Ingredients needed based on orders</p>
          </div>
          <div className="flex items-center gap-3">
            {shoppingViewMode === 'byStore' && shoppingList && shoppingList.length > 0 && (
              <button
                onClick={exportShoppingListToPDF}
                className="px-3 py-1.5 text-sm font-medium rounded-md bg-white text-blue-700 hover:bg-blue-50 transition-colors"
              >
                Export to PDF
              </button>
            )}
            <div className="flex gap-1 bg-blue-700 rounded-lg p-1">
            <button
              onClick={() => setShoppingViewMode('byStore')}
              className={`px-3 py-1.5 text-sm font-medium rounded-md transition-colors ${
                shoppingViewMode === 'byStore'
                  ? 'bg-white text-blue-700'
                  : 'text-blue-200 hover:text-white'
              }`}
            >
              By Store
            </button>
            <button
              onClick={() => setShoppingViewMode('byDish')}
              className={`px-3 py-1.5 text-sm font-medium rounded-md transition-colors ${
                shoppingViewMode === 'byDish'
                  ? 'bg-white text-blue-700'
                  : 'text-blue-200 hover:text-white'
              }`}
            >
              By Dish
            </button>
            </div>
          </div>
        </div>
        <div className="p-6">
          {/* By Store View */}
          {shoppingViewMode === 'byStore' && (
            <>
              {shoppingLoading ? (
                <p className="text-gray-500">Loading shopping list...</p>
              ) : !shoppingList || shoppingList.length === 0 ? (
                <p className="text-gray-500">No ingredients calculated. Make sure the event has a menu with dishes that have ingredients.</p>
              ) : (
                <div className="space-y-6">
                  {Object.entries(groupByStore(shoppingList)).map(([store, items]) => (
                    <div key={store} className="border rounded-lg overflow-hidden">
                      <div className="bg-blue-50 px-4 py-3 border-b flex items-center justify-between">
                        <h3 className="text-md font-semibold text-blue-900">{store}</h3>
                        <span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-sm font-medium">
                          {items.length} items
                        </span>
                      </div>
                      <table className="w-full text-left">
                        <thead>
                          <tr className="border-b bg-gray-50">
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Ingredient</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Category</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600 text-right">Qty</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Unit</th>
                          </tr>
                        </thead>
                        <tbody>
                          {items.map((item) => (
                            <tr key={item.ingredientId} className="border-b last:border-0 hover:bg-gray-50">
                              <td className="py-2 px-4 font-medium">{item.ingredientName}</td>
                              <td className="py-2 px-4 text-gray-500 text-sm">{item.category || '-'}</td>
                              <td className="py-2 px-4 text-right text-lg font-semibold text-blue-600">
                                {typeof item.requiredQty === 'number'
                                  ? item.requiredQty.toFixed(2)
                                  : item.requiredQty}
                              </td>
                              <td className="py-2 px-4 text-gray-600">{item.unit}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}

          {/* By Dish View */}
          {shoppingViewMode === 'byDish' && (
            <>
              {perDishLoading ? (
                <p className="text-gray-500">Loading shopping list...</p>
              ) : !perDishShopping || perDishShopping.dishes.length === 0 ? (
                <p className="text-gray-500">No ingredients calculated. Make sure the event has a menu with dishes that have ingredients.</p>
              ) : (
                <div className="space-y-6">
                  {perDishShopping.dishes.map((dish) => (
                    <div key={dish.dishId} className="border rounded-lg overflow-hidden">
                      <div className="bg-blue-50 px-4 py-3 border-b flex items-center justify-between">
                        <h3 className="text-md font-semibold text-blue-900">{dish.dishName}</h3>
                        <span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-sm font-medium">
                          {dish.totalQuarts?.toFixed(2)} quarts
                        </span>
                      </div>
                      <table className="w-full text-left">
                        <thead>
                          <tr className="border-b bg-gray-50">
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Ingredient</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Store</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600 text-right">Qty</th>
                            <th className="py-2 px-4 font-medium text-sm text-gray-600">Unit</th>
                          </tr>
                        </thead>
                        <tbody>
                          {dish.ingredients.map((item) => (
                            <tr key={item.ingredientId} className="border-b last:border-0 hover:bg-gray-50">
                              <td className="py-2 px-4 font-medium">{item.ingredientName}</td>
                              <td className="py-2 px-4 text-gray-500 text-sm">{item.defaultStore || '-'}</td>
                              <td className="py-2 px-4 text-right text-lg font-semibold text-blue-600">
                                {typeof item.requiredQty === 'number'
                                  ? item.requiredQty.toFixed(2)
                                  : item.requiredQty}
                              </td>
                              <td className="py-2 px-4 text-gray-600">{item.unit}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Print Button */}
      <div className="flex gap-3">
        <button onClick={() => window.print()} className="btn bg-blue-600 hover:bg-blue-700">
          Print Report
        </button>
      </div>
    </div>
  );
}
