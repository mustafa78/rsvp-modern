import { useState, useMemo, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api } from '../../../api/client';

type DishIngredient = {
  ingredientId: number;
  ingredientName: string;
  unit: string;
  qtyPerQuart: number;
};

type Dish = {
  id: number;
  name: string;
  description: string | null;
  defaultQuartsPerThaaliUnit: number;
  active: boolean;
  ingredients: DishIngredient[];
};

type Ingredient = {
  id: number;
  name: string;
  unit: string;
  category: string | null;
  defaultStore: string | null;
  storageLocation: string | null;
  notes: string | null;
};

type SelectedDish = {
  dishId: number;
  name: string;
  quarts: string;
};

type CalculatedIngredient = {
  ingredientId: number;
  name: string;
  unit: string;
  totalQty: number;
  defaultStore: string | null;
  category: string | null;
};

type ViewMode = 'cumulative' | 'per-dish';

export default function ShoppingListGenerator() {
  const [selectedDishes, setSelectedDishes] = useState<SelectedDish[]>([]);
  const [dishSearch, setDishSearch] = useState('');
  const [showDropdown, setShowDropdown] = useState(false);
  const [showResults, setShowResults] = useState(false);
  const [viewMode, setViewMode] = useState<ViewMode>('cumulative');
  const printRef = useRef<HTMLDivElement>(null);

  const { data: dishes, isLoading: dishesLoading } = useQuery<Dish[]>({
    queryKey: ['dishes'],
    queryFn: async () => (await api.get('/dishes')).data,
  });

  const { data: ingredients } = useQuery<Ingredient[]>({
    queryKey: ['ingredients'],
    queryFn: async () => (await api.get('/ingredients')).data,
  });

  // Create a map of ingredient metadata (for store/category info)
  const ingredientMap = useMemo(() => {
    if (!ingredients) return new Map<number, Ingredient>();
    return new Map(ingredients.map(i => [i.id, i]));
  }, [ingredients]);

  // Filter dishes for dropdown
  const filteredDishes = useMemo(() => {
    if (!dishes) return [];
    const selectedIds = new Set(selectedDishes.map(s => s.dishId));
    return dishes
      .filter(d => d.active && !selectedIds.has(d.id))
      .filter(d => d.name.toLowerCase().includes(dishSearch.toLowerCase()))
      .slice(0, 10);
  }, [dishes, selectedDishes, dishSearch]);

  const addDish = (dish: Dish) => {
    setSelectedDishes(prev => [
      ...prev,
      { dishId: dish.id, name: dish.name, quarts: '1' }
    ]);
    setDishSearch('');
    setShowDropdown(false);
  };

  const removeDish = (dishId: number) => {
    setSelectedDishes(prev => prev.filter(d => d.dishId !== dishId));
  };

  const updateDishQuarts = (dishId: number, quarts: string) => {
    setSelectedDishes(prev =>
      prev.map(d => d.dishId === dishId ? { ...d, quarts } : d)
    );
  };

  // Calculate shopping list per dish
  const perDishShoppingList = useMemo(() => {
    if (!dishes) return [];

    return selectedDishes.map(selected => {
      const dish = dishes.find(d => d.id === selected.dishId);
      if (!dish) return null;

      const quarts = parseFloat(selected.quarts) || 0;
      const ingredients: CalculatedIngredient[] = dish.ingredients.map(di => {
        const meta = ingredientMap.get(di.ingredientId);
        return {
          ingredientId: di.ingredientId,
          name: di.ingredientName,
          unit: di.unit,
          totalQty: di.qtyPerQuart * quarts,
          defaultStore: meta?.defaultStore || null,
          category: meta?.category || null,
        };
      });

      return {
        dishId: selected.dishId,
        dishName: dish.name,
        quarts,
        ingredients,
      };
    }).filter(Boolean) as { dishId: number; dishName: string; quarts: number; ingredients: CalculatedIngredient[] }[];
  }, [dishes, selectedDishes, ingredientMap]);

  // Calculate cumulative shopping list
  const cumulativeShoppingList = useMemo((): CalculatedIngredient[] => {
    const ingredientTotals = new Map<number, CalculatedIngredient>();

    for (const dishData of perDishShoppingList) {
      for (const ing of dishData.ingredients) {
        const existing = ingredientTotals.get(ing.ingredientId);
        if (existing) {
          existing.totalQty += ing.totalQty;
        } else {
          ingredientTotals.set(ing.ingredientId, { ...ing });
        }
      }
    }

    return Array.from(ingredientTotals.values());
  }, [perDishShoppingList]);

  // Group by store
  const groupByStore = (items: CalculatedIngredient[]) => {
    const grouped: Record<string, CalculatedIngredient[]> = {};
    for (const item of items) {
      const store = item.defaultStore || 'Other';
      if (!grouped[store]) grouped[store] = [];
      grouped[store].push(item);
    }
    // Sort items within each group by name
    for (const store in grouped) {
      grouped[store].sort((a, b) => a.name.localeCompare(b.name));
    }
    // Sort stores (put "Other" at the end)
    const sortedStores = Object.keys(grouped).sort((a, b) => {
      if (a === 'Other') return 1;
      if (b === 'Other') return -1;
      return a.localeCompare(b);
    });
    const sortedGrouped: Record<string, CalculatedIngredient[]> = {};
    for (const store of sortedStores) {
      sortedGrouped[store] = grouped[store];
    }
    return sortedGrouped;
  };

  const totalIngredients = cumulativeShoppingList.length;
  const totalQuarts = selectedDishes.reduce((sum, d) => sum + (parseFloat(d.quarts) || 0), 0);

  // Export to PDF
  const exportToPDF = () => {
    const printWindow = window.open('', '_blank');
    if (!printWindow) {
      alert('Please allow popups to export PDF');
      return;
    }

    const content = generatePrintContent();
    printWindow.document.write(content);
    printWindow.document.close();
    printWindow.onload = () => {
      printWindow.print();
    };
  };

  const generatePrintContent = () => {
    const date = new Date().toLocaleDateString();
    const groupedCumulative = groupByStore(cumulativeShoppingList);

    let html = `
      <!DOCTYPE html>
      <html>
      <head>
        <title>Shopping List - ${date}</title>
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; font-size: 11px; color: #333; }
          h1 { font-size: 20px; margin-bottom: 5px; color: #111; }
          .meta { color: #666; margin-bottom: 15px; }
          .store-section { margin-bottom: 20px; border: 1px solid #ddd; border-radius: 6px; overflow: hidden; }
          .store-header { background: #374151; color: white; padding: 8px 12px; font-size: 13px; font-weight: 600; }
          .store-header span { color: #9ca3af; font-weight: normal; }
          .dish-section { margin-bottom: 20px; border: 1px solid #ddd; border-radius: 6px; overflow: hidden; }
          .dish-header { background: #2563eb; color: white; padding: 10px 12px; font-size: 14px; font-weight: 600; }
          .dish-header span { color: #bfdbfe; font-weight: normal; }
          .sub-store { background: #f3f4f6; padding: 6px 12px; font-size: 11px; font-weight: 600; color: #374151; border-bottom: 1px solid #e5e7eb; }
          table { width: 100%; border-collapse: collapse; }
          th { background: #f9fafb; padding: 6px 12px; text-align: left; font-size: 10px; text-transform: uppercase; letter-spacing: 0.5px; color: #6b7280; font-weight: 600; border-bottom: 1px solid #e5e7eb; }
          th.qty { text-align: right; }
          td { padding: 8px 12px; border-bottom: 1px solid #f3f4f6; }
          tr:nth-child(even) { background: #f9fafb; }
          .ingredient { font-weight: 500; color: #111; width: 45%; }
          .category { color: #6b7280; text-transform: capitalize; width: 25%; }
          .qty { text-align: right; font-weight: 700; color: #111; width: 15%; }
          .unit { color: #6b7280; width: 15%; }
          .summary { margin-top: 25px; padding: 12px; background: #f9fafb; border-radius: 6px; border: 1px solid #e5e7eb; }
          .summary h3 { margin: 0 0 8px 0; font-size: 13px; }
          .summary p { margin: 3px 0; color: #374151; }
          .page-break { page-break-before: always; }
          h2 { font-size: 16px; margin: 25px 0 15px 0; padding-bottom: 8px; border-bottom: 2px solid #e5e7eb; color: #111; }
          @media print {
            body { margin: 10px; }
            .store-section, .dish-section { break-inside: avoid; }
          }
        </style>
      </head>
      <body>
        <h1>Shopping List</h1>
        <div class="meta">
          <p>Generated: ${date}</p>
          <p><strong>Dishes:</strong> ${selectedDishes.map(d => `${d.name} (${d.quarts} qt)`).join(', ')}</p>
          <p><strong>Total Quarts:</strong> ${totalQuarts.toFixed(1)} | <strong>Total Ingredients:</strong> ${totalIngredients}</p>
        </div>
    `;

    // Cumulative by Store
    html += `<h2>Cumulative Shopping List (by Store)</h2>`;
    for (const [store, items] of Object.entries(groupedCumulative)) {
      html += `
        <div class="store-section">
          <div class="store-header">${store} <span>(${items.length} items)</span></div>
          <table>
            <thead><tr><th class="ingredient">Ingredient</th><th class="category">Category</th><th class="qty">Qty</th><th class="unit">Unit</th></tr></thead>
            <tbody>
              ${items.map(item => `
                <tr>
                  <td class="ingredient">${item.name}</td>
                  <td class="category">${item.category || '-'}</td>
                  <td class="qty">${item.totalQty.toFixed(2)}</td>
                  <td class="unit">${item.unit}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    }

    // Per-Dish Breakdown
    html += `<div class="page-break"></div>`;
    html += `<h2>Per-Dish Breakdown</h2>`;
    for (const dishData of perDishShoppingList) {
      const grouped = groupByStore(dishData.ingredients);
      html += `<div class="dish-section">`;
      html += `<div class="dish-header">${dishData.dishName} <span>(${dishData.quarts} quarts)</span></div>`;
      for (const [store, items] of Object.entries(grouped)) {
        html += `
          <div class="sub-store">${store} (${items.length})</div>
          <table>
            <thead><tr><th class="ingredient">Ingredient</th><th class="category">Category</th><th class="qty">Qty</th><th class="unit">Unit</th></tr></thead>
            <tbody>
              ${items.map(item => `
                <tr>
                  <td class="ingredient">${item.name}</td>
                  <td class="category">${item.category || '-'}</td>
                  <td class="qty">${item.totalQty.toFixed(2)}</td>
                  <td class="unit">${item.unit}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        `;
      }
      html += `</div>`;
    }

    // Summary
    html += `
      <div class="summary">
        <h3>Summary</h3>
        <p><strong>Dishes:</strong> ${selectedDishes.map(d => `${d.name} (${d.quarts} qt)`).join(', ')}</p>
        <p><strong>Total Quarts:</strong> ${totalQuarts.toFixed(1)}</p>
        <p><strong>Total Ingredients:</strong> ${totalIngredients}</p>
      </div>
    `;

    html += `</body></html>`;
    return html;
  };

  if (dishesLoading) {
    return <div className="text-gray-500">Loading...</div>;
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Shopping List Generator</h1>
        <p className="text-gray-500">Select dishes and quantities to generate a shopping list</p>
      </div>

      {/* Dish Selection */}
      <div className="card">
        <h2 className="text-lg font-semibold mb-4">Select Dishes</h2>

        {/* Search */}
        <div className="relative mb-4">
          <input
            type="text"
            className="input"
            placeholder="Search dishes to add..."
            value={dishSearch}
            onChange={(e) => {
              setDishSearch(e.target.value);
              setShowDropdown(true);
            }}
            onFocus={() => setShowDropdown(true)}
            onBlur={() => setTimeout(() => setShowDropdown(false), 200)}
          />
          {showDropdown && dishSearch && filteredDishes.length > 0 && (
            <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-md shadow-lg max-h-60 overflow-auto">
              {filteredDishes.map((dish) => (
                <button
                  key={dish.id}
                  type="button"
                  className="w-full text-left px-3 py-2 hover:bg-gray-100 flex justify-between items-center"
                  onMouseDown={() => addDish(dish)}
                >
                  <span>{dish.name}</span>
                  <span className="text-gray-400 text-sm">{dish.ingredients.length} ingredients</span>
                </button>
              ))}
            </div>
          )}
          {showDropdown && dishSearch && filteredDishes.length === 0 && (
            <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-md shadow-lg p-3 text-gray-500 text-sm">
              No matching dishes found
            </div>
          )}
        </div>

        {/* Selected Dishes */}
        {selectedDishes.length > 0 ? (
          <div className="border rounded-md divide-y">
            {selectedDishes.map((dish) => (
              <div key={dish.dishId} className="flex items-center gap-3 p-3">
                <div className="flex-1 font-medium">{dish.name}</div>
                <div className="flex items-center gap-2">
                  <label className="text-sm text-gray-500">Quarts:</label>
                  <input
                    type="number"
                    step="0.5"
                    min="0"
                    className="input w-24 text-right"
                    value={dish.quarts}
                    onChange={(e) => updateDishQuarts(dish.dishId, e.target.value)}
                  />
                </div>
                <button
                  type="button"
                  className="text-red-500 hover:text-red-700 px-2 text-xl"
                  onClick={() => removeDish(dish.dishId)}
                  title="Remove dish"
                >
                  &times;
                </button>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-gray-400 text-sm">No dishes selected. Search above to add dishes.</p>
        )}

        {/* Generate Button */}
        {selectedDishes.length > 0 && (
          <div className="mt-4 flex items-center gap-4">
            <button
              className="btn"
              onClick={() => setShowResults(true)}
            >
              Generate Shopping List
            </button>
            <span className="text-sm text-gray-500">
              {selectedDishes.length} dish{selectedDishes.length !== 1 ? 'es' : ''}, {totalQuarts.toFixed(1)} total quarts
            </span>
          </div>
        )}
      </div>

      {/* Shopping List Results */}
      {showResults && selectedDishes.length > 0 && (
        <div className="card" ref={printRef}>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold">
              Shopping List ({totalIngredients} ingredients)
            </h2>
            <div className="flex gap-2">
              <button
                onClick={exportToPDF}
                className="btn"
              >
                Export PDF
              </button>
            </div>
          </div>

          {/* View Mode Toggle */}
          <div className="flex gap-2 mb-4 border-b pb-4">
            <button
              className={`px-4 py-2 rounded-lg text-sm font-medium ${
                viewMode === 'cumulative'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
              onClick={() => setViewMode('cumulative')}
            >
              Cumulative (by Store)
            </button>
            <button
              className={`px-4 py-2 rounded-lg text-sm font-medium ${
                viewMode === 'per-dish'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
              onClick={() => setViewMode('per-dish')}
            >
              Per Dish
            </button>
          </div>

          {totalIngredients === 0 ? (
            <p className="text-gray-500">
              No ingredients found. Make sure the selected dishes have ingredients assigned.
            </p>
          ) : viewMode === 'cumulative' ? (
            /* Cumulative View */
            <div className="space-y-6">
              {Object.entries(groupByStore(cumulativeShoppingList)).map(([store, items]) => (
                <div key={store} className="border rounded-lg overflow-hidden">
                  <h3 className="text-md font-semibold text-white bg-gray-700 px-4 py-2">
                    {store} <span className="text-gray-300 font-normal">({items.length} items)</span>
                  </h3>
                  <table className="w-full text-left table-fixed">
                    <thead>
                      <tr className="bg-gray-50 border-b">
                        <th className="py-2 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[45%]">Ingredient</th>
                        <th className="py-2 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[25%]">Category</th>
                        <th className="py-2 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider text-right w-[15%]">Qty</th>
                        <th className="py-2 px-4 font-semibold text-xs text-gray-500 uppercase tracking-wider w-[15%]">Unit</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {items.map((item, idx) => (
                        <tr key={item.ingredientId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                          <td className="py-2.5 px-4 font-medium text-gray-900">{item.name}</td>
                          <td className="py-2.5 px-4 text-gray-500 text-sm capitalize">{item.category || '-'}</td>
                          <td className="py-2.5 px-4 text-right text-lg font-bold text-gray-900">
                            {item.totalQty.toFixed(2)}
                          </td>
                          <td className="py-2.5 px-4 text-gray-600">{item.unit}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ))}
            </div>
          ) : (
            /* Per-Dish View */
            <div className="space-y-6">
              {perDishShoppingList.map((dishData) => (
                <div key={dishData.dishId} className="border rounded-lg overflow-hidden shadow-sm">
                  <div className="bg-blue-600 px-4 py-3">
                    <h3 className="font-semibold text-white text-lg">
                      {dishData.dishName}
                      <span className="text-blue-200 font-normal ml-2 text-base">({dishData.quarts} quarts)</span>
                    </h3>
                  </div>
                  <div className="divide-y divide-gray-200">
                    {Object.entries(groupByStore(dishData.ingredients)).map(([store, items]) => (
                      <div key={store}>
                        <h4 className="text-sm font-semibold text-gray-700 bg-gray-100 px-4 py-2 border-b">
                          {store} <span className="text-gray-400 font-normal">({items.length})</span>
                        </h4>
                        <table className="w-full text-left table-fixed">
                          <thead>
                            <tr className="bg-gray-50 border-b">
                              <th className="py-1.5 px-4 font-semibold text-xs text-gray-400 uppercase tracking-wider w-[45%]">Ingredient</th>
                              <th className="py-1.5 px-4 font-semibold text-xs text-gray-400 uppercase tracking-wider w-[25%]">Category</th>
                              <th className="py-1.5 px-4 font-semibold text-xs text-gray-400 uppercase tracking-wider text-right w-[15%]">Qty</th>
                              <th className="py-1.5 px-4 font-semibold text-xs text-gray-400 uppercase tracking-wider w-[15%]">Unit</th>
                            </tr>
                          </thead>
                          <tbody className="divide-y divide-gray-100">
                            {items.map((item, idx) => (
                              <tr key={item.ingredientId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                                <td className="py-2 px-4 text-gray-900">{item.name}</td>
                                <td className="py-2 px-4 text-gray-500 text-sm capitalize">{item.category || '-'}</td>
                                <td className="py-2 px-4 text-right font-bold text-gray-900">{item.totalQty.toFixed(2)}</td>
                                <td className="py-2 px-4 text-gray-600">{item.unit}</td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* Summary */}
          <div className="mt-6 pt-4 border-t">
            <h3 className="font-semibold mb-2">Summary</h3>
            <div className="text-sm text-gray-600 space-y-1">
              <p><strong>Dishes:</strong> {selectedDishes.map(d => `${d.name} (${d.quarts} qt)`).join(', ')}</p>
              <p><strong>Total Quarts:</strong> {totalQuarts.toFixed(1)}</p>
              <p><strong>Total Ingredients:</strong> {totalIngredients}</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
