import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api } from '../../../api/client';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

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

  // Export to PDF using jsPDF
  const exportToPDF = () => {
    if (cumulativeShoppingList.length === 0) {
      alert('No shopping list data to export');
      return;
    }

    const doc = new jsPDF();
    const date = new Date().toLocaleDateString();
    const groupedCumulative = groupByStore(cumulativeShoppingList);
    let yPos = 20;

    // Title
    doc.setFontSize(20);
    doc.setFont('helvetica', 'bold');
    doc.text('Shopping List', 14, yPos);
    yPos += 10;

    // Meta info
    doc.setFontSize(10);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(100);
    doc.text(`Generated: ${date}`, 14, yPos);
    yPos += 5;
    doc.text(`Dishes: ${selectedDishes.map(d => `${d.name} (${d.quarts} qt)`).join(', ')}`, 14, yPos, { maxWidth: 180 });
    yPos += 5;
    doc.text(`Total Quarts: ${totalQuarts.toFixed(1)} | Total Ingredients: ${totalIngredients}`, 14, yPos);
    yPos += 10;

    // Section title
    doc.setFontSize(14);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(31, 41, 55);
    doc.text('Cumulative Shopping List (by Store)', 14, yPos);
    yPos += 8;

    // Shopping list by store
    for (const [store, items] of Object.entries(groupedCumulative)) {
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
          item.name,
          item.category || '-',
          item.totalQty.toFixed(2),
          item.unit
        ]),
        theme: 'striped',
        headStyles: {
          fillColor: [243, 244, 246],
          textColor: [75, 85, 99],
          fontStyle: 'bold',
          fontSize: 9,
        },
        bodyStyles: {
          fontSize: 10,
          textColor: [31, 41, 55],
        },
        columnStyles: {
          0: { cellWidth: 70 },
          1: { cellWidth: 50 },
          2: { cellWidth: 25, halign: 'right', fontStyle: 'bold', textColor: [37, 99, 235] },
          3: { cellWidth: 30 },
        },
        margin: { left: 14, right: 14 },
      });

      yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 10;
    }

    // Per-Dish Breakdown on new page
    doc.addPage();
    yPos = 20;

    doc.setFontSize(14);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(31, 41, 55);
    doc.text('Per-Dish Breakdown', 14, yPos);
    yPos += 10;

    for (const dishData of perDishShoppingList) {
      if (yPos > 240) {
        doc.addPage();
        yPos = 20;
      }

      // Dish header
      doc.setFillColor(37, 99, 235); // Blue-600
      doc.rect(14, yPos - 5, 182, 10, 'F');
      doc.setFontSize(12);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(255);
      doc.text(`${dishData.dishName} (${dishData.quarts} quarts)`, 16, yPos + 1);
      yPos += 8;

      const grouped = groupByStore(dishData.ingredients);

      for (const [store, items] of Object.entries(grouped)) {
        if (yPos > 250) {
          doc.addPage();
          yPos = 20;
        }

        // Sub-store header
        doc.setFillColor(243, 244, 246);
        doc.rect(14, yPos - 4, 182, 7, 'F');
        doc.setFontSize(10);
        doc.setFont('helvetica', 'bold');
        doc.setTextColor(55, 65, 81);
        doc.text(`${store} (${items.length})`, 16, yPos);
        yPos += 5;

        autoTable(doc, {
          startY: yPos,
          head: [['Ingredient', 'Category', 'Qty', 'Unit']],
          body: items.map(item => [
            item.name,
            item.category || '-',
            item.totalQty.toFixed(2),
            item.unit
          ]),
          theme: 'striped',
          headStyles: {
            fillColor: [249, 250, 251],
            textColor: [107, 114, 128],
            fontStyle: 'bold',
            fontSize: 8,
          },
          bodyStyles: {
            fontSize: 9,
            textColor: [31, 41, 55],
          },
          columnStyles: {
            0: { cellWidth: 70 },
            1: { cellWidth: 50 },
            2: { cellWidth: 25, halign: 'right', fontStyle: 'bold', textColor: [37, 99, 235] },
            3: { cellWidth: 30 },
          },
          margin: { left: 14, right: 14 },
        });

        yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 6;
      }

      yPos += 6;
    }

    // Summary
    if (yPos > 240) {
      doc.addPage();
      yPos = 20;
    }

    doc.setFillColor(249, 250, 251);
    doc.rect(14, yPos - 2, 182, 28, 'F');
    doc.setDrawColor(229, 231, 235);
    doc.rect(14, yPos - 2, 182, 28, 'S');

    doc.setFontSize(11);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(31, 41, 55);
    doc.text('Summary', 18, yPos + 5);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    const dishList = selectedDishes.map(d => `${d.name} (${d.quarts} qt)`).join(', ');
    doc.text(`Dishes: ${dishList}`, 18, yPos + 12, { maxWidth: 170 });
    doc.text(`Total Quarts: ${totalQuarts.toFixed(1)} | Total Ingredients: ${totalIngredients}`, 18, yPos + 19);

    // Save the PDF
    const fileName = `shopping-list-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
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
        <div className="card">
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
