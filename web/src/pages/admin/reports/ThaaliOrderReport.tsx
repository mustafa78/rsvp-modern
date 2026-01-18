import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useParams, Link } from 'react-router-dom';
import { api } from '../../../api/client';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import * as XLSX from 'xlsx';

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

type IndividualOrderItem = {
  menuItemId: number;
  dishName: string;
  size: 'LARGE' | 'SMALL' | 'BARAKATI';
};

type IndividualOrder = {
  orderId: number;
  personId: number;
  personName: string;
  personPhone: string;
  pickupZoneId: number | null;
  pickupZoneName: string;
  items: IndividualOrderItem[];
};

type MenuItemInfo = {
  menuItemId: number;
  dishName: string;
};

type IndividualOrdersReport = {
  menuItems: MenuItemInfo[];
  orders: IndividualOrder[];
};

type ReportTab = 'summary' | 'individual' | 'shopping';
type ShoppingViewMode = 'byStore' | 'byDish';
type SortColumn = 'name' | 'pickupZone';
type SortDirection = 'asc' | 'desc';

type PersonBasic = {
  id: number;
  itsNumber: string;
  firstName: string;
  lastName: string;
  phone: string | null;
};

type PickupZone = {
  id: number;
  name: string;
};

type MealSize = 'LARGE' | 'SMALL' | 'BARAKATI';

type OrderFormData = {
  personId: number | null;
  pickupZoneId: number | null;
  notes: string;
  items: { menuItemId: number; size: MealSize }[];
};

type User = {
  personId: number;
  roles: string[];
};

// Check if event date is in the past
function isEventPast(eventDate: string): boolean {
  const [year, month, day] = eventDate.split('-').map(Number);
  const eventDateObj = new Date(year, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return eventDateObj < today;
}

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
  for (const store in grouped) {
    grouped[store].sort((a, b) => a.ingredientName.localeCompare(b.ingredientName));
  }
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

function calculateDishQuarts(item: MenuItemCount): number {
  return item.largeCount * 1.0 + item.smallCount * 0.5 + item.barakatiCount * 0.25;
}

export default function ThaaliOrderReport() {
  const { eventId } = useParams<{ eventId: string }>();
  const queryClient = useQueryClient();

  // Get current user to check roles
  const { data: currentUser } = useQuery<User>({
    queryKey: ['me'],
    queryFn: () => api.me() as Promise<User>,
    staleTime: 1000 * 60 * 5,
  });

  // Check if user can see Individual Registrations tab (SHOPPING_COORDINATOR cannot)
  const canSeeIndividualRegistrations = !currentUser?.roles?.includes('SHOPPING_COORDINATOR');

  const [activeTab, setActiveTab] = useState<ReportTab>('summary');
  const [shoppingViewMode, setShoppingViewMode] = useState<ShoppingViewMode>('byStore');
  const [sortColumn, setSortColumn] = useState<SortColumn>('name');
  const [sortDirection, setSortDirection] = useState<SortDirection>('asc');

  // Modal state
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<IndividualOrder | null>(null);
  const [formData, setFormData] = useState<OrderFormData>({
    personId: null,
    pickupZoneId: null,
    notes: '',
    items: [],
  });
  const [formError, setFormError] = useState<string | null>(null);

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
    enabled: !!eventId && activeTab === 'shopping' && shoppingViewMode === 'byStore',
  });

  const { data: perDishShopping, isLoading: perDishLoading } = useQuery<PerDishShoppingList>({
    queryKey: ['thaali-shopping-per-dish', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/shopping-list-per-dish`)).data,
    enabled: !!eventId && activeTab === 'shopping' && shoppingViewMode === 'byDish',
  });

  const { data: individualOrders, isLoading: individualLoading } = useQuery<IndividualOrdersReport>({
    queryKey: ['thaali-individual-orders', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/individual-orders`)).data,
    enabled: !!eventId && activeTab === 'individual',
  });

  // Additional queries for admin order management
  const { data: usersWithoutOrders } = useQuery<PersonBasic[]>({
    queryKey: ['thaali-users-without-orders', eventId],
    queryFn: async () => (await api.get(`/thaali/${eventId}/orders/users-without-orders`)).data,
    enabled: !!eventId && showAddModal,
  });

  // Always fetch pickup zones when on individual tab (needed for edit modal)
  const { data: pickupZones } = useQuery<PickupZone[]>({
    queryKey: ['pickup-zones'],
    queryFn: async () => (await api.get('/pickup-zones')).data,
    enabled: activeTab === 'individual',
  });

  // Use menu items from individualOrders (already loaded with the report)
  // This contains the menuItemId and dishName for each dish in the event
  const menuItemsForForm = individualOrders?.menuItems;

  // Mutations for admin order management
  const createOrderMutation = useMutation({
    mutationFn: async (data: { personId: number; pickupZoneId: number; notes: string; items: { menuItemId: number; size: MealSize }[] }) =>
      api.post(`/thaali/${eventId}/orders/admin`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['thaali-individual-orders', eventId] });
      queryClient.invalidateQueries({ queryKey: ['thaali-detailed-report', eventId] });
      queryClient.invalidateQueries({ queryKey: ['thaali-users-without-orders', eventId] });
      setShowAddModal(false);
      resetForm();
    },
    onError: (err: any) => setFormError(err.message),
  });

  const updateOrderMutation = useMutation({
    mutationFn: async ({ orderId, data }: { orderId: number; data: { personId: number; pickupZoneId: number; notes: string; items: { menuItemId: number; size: MealSize }[] } }) =>
      api.put(`/thaali/${eventId}/orders/admin/${orderId}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['thaali-individual-orders', eventId] });
      queryClient.invalidateQueries({ queryKey: ['thaali-detailed-report', eventId] });
      setShowEditModal(false);
      resetForm();
    },
    onError: (err: any) => setFormError(err.message),
  });

  const deleteOrderMutation = useMutation({
    mutationFn: async (orderId: number) => api.delete(`/thaali/${eventId}/orders/admin/${orderId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['thaali-individual-orders', eventId] });
      queryClient.invalidateQueries({ queryKey: ['thaali-detailed-report', eventId] });
      queryClient.invalidateQueries({ queryKey: ['thaali-users-without-orders', eventId] });
      setShowDeleteModal(false);
      setSelectedOrder(null);
    },
    onError: (err: any) => setFormError(err.message),
  });

  // Form helpers
  const resetForm = () => {
    setFormData({ personId: null, pickupZoneId: null, notes: '', items: [] });
    setFormError(null);
    setSelectedOrder(null);
  };

  const openAddModal = () => {
    resetForm();
    setShowAddModal(true);
  };

  const openEditModal = (order: IndividualOrder) => {
    setSelectedOrder(order);
    setFormData({
      personId: order.personId,
      pickupZoneId: order.pickupZoneId,
      notes: '',
      items: order.items.map(item => ({
        menuItemId: item.menuItemId,
        size: item.size,
      })),
    });
    setFormError(null);
    setShowEditModal(true);
  };

  const openDeleteModal = (order: IndividualOrder) => {
    setSelectedOrder(order);
    setShowDeleteModal(true);
  };

  const handleFormItemChange = (menuItemId: number, size: MealSize | null) => {
    setFormData(prev => {
      const filtered = prev.items.filter(i => i.menuItemId !== menuItemId);
      if (size) {
        return { ...prev, items: [...filtered, { menuItemId, size }] };
      }
      return { ...prev, items: filtered };
    });
  };

  const handleSubmitAdd = () => {
    if (!formData.personId || !formData.pickupZoneId || formData.items.length === 0) {
      setFormError('Please select a person, pickup zone, and at least one dish.');
      return;
    }
    createOrderMutation.mutate({
      personId: formData.personId,
      pickupZoneId: formData.pickupZoneId,
      notes: formData.notes,
      items: formData.items,
    });
  };

  const handleSubmitEdit = () => {
    if (!selectedOrder || !formData.pickupZoneId || formData.items.length === 0) {
      setFormError('Please select a pickup zone and at least one dish.');
      return;
    }
    updateOrderMutation.mutate({
      orderId: selectedOrder.orderId,
      data: {
        personId: selectedOrder.personId,
        pickupZoneId: formData.pickupZoneId,
        notes: formData.notes,
        items: formData.items,
      },
    });
  };

  const handleConfirmDelete = () => {
    if (selectedOrder) {
      deleteOrderMutation.mutate(selectedOrder.orderId);
    }
  };

  // Sort handler
  const handleSort = (column: SortColumn) => {
    if (sortColumn === column) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortColumn(column);
      setSortDirection('asc');
    }
  };

  // Sort icon component
  const SortIcon = ({ column }: { column: SortColumn }) => {
    if (sortColumn !== column) {
      return (
        <svg className="w-4 h-4 text-gray-400 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
        </svg>
      );
    }
    return sortDirection === 'asc' ? (
      <svg className="w-4 h-4 text-blue-600 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
      </svg>
    ) : (
      <svg className="w-4 h-4 text-blue-600 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
      </svg>
    );
  };

  // Sorted orders
  const sortedOrders = individualOrders?.orders ? [...individualOrders.orders].sort((a, b) => {
    let comparison = 0;
    if (sortColumn === 'name') {
      comparison = a.personName.localeCompare(b.personName);
    } else if (sortColumn === 'pickupZone') {
      comparison = (a.pickupZoneName || '').localeCompare(b.pickupZoneName || '');
    }
    return sortDirection === 'asc' ? comparison : -comparison;
  }) : [];

  // Generate Avery 5136 labels PDF (1" x 2-5/8", 30 labels per sheet, 3 columns x 10 rows)
  const generateLabels = () => {
    if (!individualOrders || individualOrders.orders.length === 0) {
      alert('No orders to generate labels for');
      return;
    }

    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'in',
      format: 'letter', // 8.5" x 11"
    });

    // Avery 5136 specifications
    const labelWidth = 2.625;
    const labelHeight = 1.0;
    const columns = 3;
    const rows = 10;
    const topMargin = 0.5;
    const leftMargin = 0.1875; // (8.5 - 3*2.625 - 2*0.125) / 2 ≈ 0.1875
    const horizontalGap = 0.125;
    const verticalGap = 0;

    // Collect labels (one per person with all their dishes)
    type LabelData = { name: string; dishLines: string[]; zoneAndDate: string };
    const labels: LabelData[] = [];

    for (const order of sortedOrders) {
      // Format each dish on its own line with full size name
      const dishLines = order.items.map(item => {
        const sizeName = item.size === 'LARGE' ? 'Large' : item.size === 'SMALL' ? 'Small' : 'Barakati';
        return `${sizeName} ${item.dishName || 'Unknown'}`;
      });

      labels.push({
        name: order.personName,
        dishLines,
        zoneAndDate: `${order.pickupZoneName || 'N/A'} (${event?.eventDate || ''})`,
      });
    }

    let labelIndex = 0;
    const labelsPerPage = columns * rows;

    while (labelIndex < labels.length) {
      if (labelIndex > 0 && labelIndex % labelsPerPage === 0) {
        doc.addPage();
      }

      const pageIndex = labelIndex % labelsPerPage;
      const col = pageIndex % columns;
      const row = Math.floor(pageIndex / columns);

      const x = leftMargin + col * (labelWidth + horizontalGap);
      const y = topMargin + row * (labelHeight + verticalGap);

      const label = labels[labelIndex];

      // Padding inside label
      const padding = 0.06;
      const contentX = x + padding;
      const contentWidth = labelWidth - 2 * padding;

      // Calculate font size for name based on length (auto-shrink for long names)
      let nameFontSize = 10;
      if (label.name.length > 25) {
        nameFontSize = 8;
      } else if (label.name.length > 20) {
        nameFontSize = 9;
      }

      // Person name (bold)
      doc.setFontSize(nameFontSize);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(0);
      const nameY = y + 0.14;
      doc.text(label.name, contentX, nameY, { maxWidth: contentWidth });

      // Dishes - each on its own line
      doc.setFontSize(7);
      doc.setFont('helvetica', 'normal');
      doc.setTextColor(0);
      const lineHeight = 0.11;
      const maxDishLines = 4; // Max dishes that fit
      const startDishY = nameY + 0.14;

      label.dishLines.slice(0, maxDishLines).forEach((dish, i) => {
        // Truncate long dish names to fit
        let displayDish = dish;
        if (dish.length > 35) {
          displayDish = dish.substring(0, 32) + '...';
        }
        doc.text(displayDish, contentX, startDishY + (i * lineHeight));
      });

      // Zone (Date) at bottom
      doc.setFontSize(7);
      doc.setTextColor(100);
      doc.text(label.zoneAndDate, contentX, y + labelHeight - 0.08, { maxWidth: contentWidth });
      doc.setTextColor(0);

      labelIndex++;
    }

    // Generate filename and save
    const fileName = `thaali-labels-${event?.title.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
  };

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
  const isPast = isEventPast(event.eventDate);

  // Export individual orders to Excel
  const exportToExcel = () => {
    if (!individualOrders || individualOrders.orders.length === 0) {
      alert('No orders to export');
      return;
    }

    // Build header row
    const headers = ['#', 'Name', 'Phone', 'Pickup Zone', ...individualOrders.menuItems.map(mi => mi.dishName)];

    // Build data rows
    const rows = individualOrders.orders.map((order, idx) => {
      const row: (string | number)[] = [
        idx + 1,
        order.personName,
        order.personPhone || '',
        order.pickupZoneName || '',
      ];

      // Add size for each menu item
      for (const menuItem of individualOrders.menuItems) {
        const orderItem = order.items.find(i => i.menuItemId === menuItem.menuItemId);
        if (orderItem) {
          row.push(orderItem.size === 'LARGE' ? 'L' : orderItem.size === 'SMALL' ? 'S' : 'B');
        } else {
          row.push('-');
        }
      }

      return row;
    });

    // Create worksheet
    const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);

    // Set column widths
    ws['!cols'] = [
      { wch: 5 },  // #
      { wch: 25 }, // Name
      { wch: 15 }, // Phone
      { wch: 20 }, // Pickup Zone
      ...individualOrders.menuItems.map(() => ({ wch: 12 })),
    ];

    // Create workbook
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Orders');

    // Add summary sheet
    const summaryData = [
      ['Thaali Orders Report'],
      [event.title],
      [event.eventDate],
      [''],
      ['Thaali Summary'],
      ['Large (1 qt)', counts?.large || 0],
      ['Small (½ qt)', counts?.small || 0],
      ['Barakati (¼ qt)', counts?.barakati || 0],
      ['Total Registrations', totalOrders],
      ['Total Quarts', counts?.totalQuarts?.toFixed(2) || '0.00'],
    ];
    const summaryWs = XLSX.utils.aoa_to_sheet(summaryData);
    summaryWs['!cols'] = [{ wch: 20 }, { wch: 15 }];
    XLSX.utils.book_append_sheet(wb, summaryWs, 'Summary');

    // Download
    const fileName = `thaali-orders-${event.title.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.xlsx`;
    XLSX.writeFile(wb, fileName);
  };

  // Export summary to PDF
  const exportSummaryToPDF = () => {
    if (!detailedReport) {
      alert('No report data to export');
      return;
    }

    const doc = new jsPDF();
    const date = new Date().toLocaleDateString();
    let yPos = 20;

    // Title
    doc.setFontSize(20);
    doc.setFont('helvetica', 'bold');
    doc.text('Thaali Registration Summary', 14, yPos);
    yPos += 10;

    // Event info
    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(100);
    doc.text(`${event?.title} - ${event?.eventDate}`, 14, yPos);
    yPos += 6;
    doc.text(`Generated: ${date}`, 14, yPos);
    yPos += 12;

    // Summary section
    doc.setFillColor(37, 99, 235);
    doc.rect(14, yPos - 5, 182, 8, 'F');
    doc.setFontSize(12);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(255);
    doc.text('Thaali Summary', 16, yPos);
    yPos += 10;

    doc.setTextColor(0);
    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');

    const summaryData = [
      ['Large (1 qt)', String(counts?.large || 0)],
      ['Small (½ qt)', String(counts?.small || 0)],
      ['Barakati (¼ qt)', String(counts?.barakati || 0)],
      ['Total Registrations', String(totalOrders)],
      ['Total Quarts', counts?.totalQuarts?.toFixed(2) || '0.00'],
    ];

    autoTable(doc, {
      startY: yPos,
      head: [['Category', 'Count']],
      body: summaryData,
      theme: 'striped',
      headStyles: {
        fillColor: [243, 244, 246],
        textColor: [75, 85, 99],
        fontStyle: 'bold',
        fontSize: 10,
      },
      bodyStyles: {
        fontSize: 10,
        textColor: [31, 41, 55],
      },
      columnStyles: {
        0: { cellWidth: 100 },
        1: { cellWidth: 50, halign: 'right', fontStyle: 'bold' },
      },
      margin: { left: 14, right: 14 },
    });

    yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 15;

    // Quarts per Dish section
    if (detailedReport.byMenuItem && detailedReport.byMenuItem.length > 0) {
      doc.setFillColor(37, 99, 235);
      doc.rect(14, yPos - 5, 182, 8, 'F');
      doc.setFontSize(12);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(255);
      doc.text('Quarts per Dish', 16, yPos);
      yPos += 10;

      const dishData = detailedReport.byMenuItem.map(item => [
        item.dishName,
        String(item.largeCount),
        String(item.smallCount),
        String(item.barakatiCount),
        calculateDishQuarts(item).toFixed(2),
      ]);

      autoTable(doc, {
        startY: yPos,
        head: [['Dish', 'Large', 'Small', 'Barakati', 'Total Quarts']],
        body: dishData,
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
          1: { cellWidth: 25, halign: 'center' },
          2: { cellWidth: 25, halign: 'center' },
          3: { cellWidth: 25, halign: 'center' },
          4: { cellWidth: 35, halign: 'right', fontStyle: 'bold', textColor: [234, 88, 12] },
        },
        margin: { left: 14, right: 14 },
      });
    }

    const fileName = `thaali-summary-${event?.title.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
  };

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

    doc.setFontSize(20);
    doc.setFont('helvetica', 'bold');
    doc.text('Shopping List', 14, yPos);
    yPos += 10;

    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(100);
    doc.text(`${event.title} - ${event.eventDate}`, 14, yPos);
    yPos += 6;
    doc.text(`Generated: ${date}`, 14, yPos);
    yPos += 6;

    doc.setTextColor(60);
    doc.text(`Orders: ${counts?.large || 0} Large + ${counts?.small || 0} Small + ${counts?.barakati || 0} Barakati = ${counts?.totalQuarts?.toFixed(2) || '0'} Quarts`, 14, yPos);
    yPos += 6;
    doc.text(`Total Ingredients: ${shoppingList.length}`, 14, yPos);
    yPos += 12;

    for (const [store, items] of Object.entries(groupedItems)) {
      if (yPos > 250) {
        doc.addPage();
        yPos = 20;
      }

      doc.setFillColor(37, 99, 235);
      doc.rect(14, yPos - 5, 182, 8, 'F');
      doc.setFontSize(11);
      doc.setFont('helvetica', 'bold');
      doc.setTextColor(255);
      doc.text(`${store} (${items.length} items)`, 16, yPos);
      yPos += 6;

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
        tableWidth: 'auto',
      });

      yPos = (doc as jsPDF & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 10;
    }

    if (yPos > 240) {
      doc.addPage();
      yPos = 20;
    }

    doc.setFillColor(249, 250, 251);
    doc.rect(14, yPos - 2, 182, 30, 'F');
    doc.setDrawColor(229, 231, 235);
    doc.rect(14, yPos - 2, 182, 30, 'S');

    doc.setFontSize(11);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(31, 41, 55);
    doc.text('Thaali Summary', 18, yPos + 5);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.text(`Large (1 qt): ${counts?.large || 0}`, 18, yPos + 12);
    doc.text(`Small (1/2 qt): ${counts?.small || 0}`, 70, yPos + 12);
    doc.text(`Barakati (1/4 qt): ${counts?.barakati || 0}`, 122, yPos + 12);
    doc.setFont('helvetica', 'bold');
    doc.text(`Total Quarts: ${counts?.totalQuarts?.toFixed(2) || '0'}`, 18, yPos + 20);

    const fileName = `shopping-list-${event.title.replace(/[^a-z0-9]/gi, '-').toLowerCase()}-${new Date().toISOString().split('T')[0]}.pdf`;
    doc.save(fileName);
  };

  // Get size badge styling
  const getSizeBadge = (size: string) => {
    switch (size) {
      case 'LARGE':
        return { label: 'L', className: 'bg-purple-100 text-purple-700' };
      case 'SMALL':
        return { label: 'S', className: 'bg-blue-100 text-blue-700' };
      case 'BARAKATI':
        return { label: 'B', className: 'bg-green-100 text-green-700' };
      default:
        return { label: '-', className: 'bg-gray-100 text-gray-400' };
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Thaali Registration Report</h1>
          <p className="text-gray-500">{event.title} - {event.eventDate}</p>
        </div>
        <Link to="/admin/events" className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors">
          ← Back to Events
        </Link>
      </div>

      {/* Tab Navigation */}
      <div className="border-b border-gray-200">
        <nav className="flex gap-8">
          <button
            onClick={() => setActiveTab('summary')}
            className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
              activeTab === 'summary'
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }`}
          >
            Summary
          </button>
          {canSeeIndividualRegistrations && (
            <button
              onClick={() => setActiveTab('individual')}
              className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
                activeTab === 'individual'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Individual Registrations
            </button>
          )}
          <button
            onClick={() => setActiveTab('shopping')}
            className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
              activeTab === 'shopping'
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }`}
          >
            Shopping List
          </button>
        </nav>
      </div>

      {/* Summary Tab */}
      {activeTab === 'summary' && (
        <div className="space-y-6">
          {/* Order Counts */}
          <div className="card overflow-hidden p-0">
            <div className="bg-blue-600 px-6 py-4">
              <h2 className="text-lg font-semibold text-white">Summary</h2>
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
                  <div className="text-sm text-gray-600">Total Registration</div>
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

          {/* Dish Summary */}
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

          <div className="flex gap-3">
            <button onClick={exportSummaryToPDF} className="px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white font-medium rounded-lg hover:from-blue-700 hover:to-blue-800 transition-all shadow-sm hover:shadow-md">
              Export to PDF
            </button>
            <button onClick={() => window.print()} className="px-4 py-2 bg-gray-500 text-white font-medium rounded-lg hover:bg-gray-600 transition-colors">
              Print Report
            </button>
          </div>
        </div>
      )}

      {/* Individual Orders Tab */}
      {activeTab === 'individual' && canSeeIndividualRegistrations && (
        <div className="space-y-6">
          <div className="card overflow-hidden p-0">
            <div className={`${isPast ? 'bg-gray-600' : 'bg-blue-600'} px-6 py-4 flex items-center justify-between`}>
              <div>
                <h2 className="text-lg font-semibold text-white">Individual Registrations</h2>
                <p className={`text-sm ${isPast ? 'text-gray-300' : 'text-blue-200'}`}>Who registered what dish and size</p>
              </div>
              <div className="flex items-center gap-2">
                {!isPast && (
                  <button
                    onClick={openAddModal}
                    className="px-4 py-2 text-sm font-medium rounded-md bg-green-500 text-white hover:bg-green-600 transition-colors flex items-center gap-2"
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                    </svg>
                    Add Thaali
                  </button>
                )}
                {individualOrders && individualOrders.orders.length > 0 && (
                  <>
                    <button
                      onClick={generateLabels}
                      className="px-4 py-2 text-sm font-medium rounded-md bg-orange-500 text-white hover:bg-orange-600 transition-colors flex items-center gap-2"
                      title="Print Avery 5136 Labels"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                      </svg>
                      Print
                    </button>
                    <button
                      onClick={exportToExcel}
                      className="px-4 py-2 text-sm font-medium rounded-md bg-white text-blue-700 hover:bg-blue-50 transition-colors flex items-center gap-2"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      Excel
                    </button>
                  </>
                )}
              </div>
            </div>

            {individualLoading ? (
              <div className="p-6 text-gray-500">Loading orders...</div>
            ) : !individualOrders || individualOrders.orders.length === 0 ? (
              <div className="p-6 text-gray-500">No orders found for this event.</div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="bg-gray-50 border-b">
                      <th className="py-3 px-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider w-10">#</th>
                      <th
                        className="py-3 px-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider min-w-[180px] cursor-pointer hover:bg-gray-100 select-none"
                        onClick={() => handleSort('name')}
                      >
                        <div className="flex items-center">
                          Name
                          <SortIcon column="name" />
                        </div>
                      </th>
                      <th className="py-3 px-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider min-w-[120px]">Phone</th>
                      <th
                        className="py-3 px-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider min-w-[140px] cursor-pointer hover:bg-gray-100 select-none"
                        onClick={() => handleSort('pickupZone')}
                      >
                        <div className="flex items-center">
                          Pickup Zone
                          <SortIcon column="pickupZone" />
                        </div>
                      </th>
                      {individualOrders.menuItems.map((mi) => (
                        <th key={mi.menuItemId} className="py-3 px-3 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider min-w-[80px]">
                          {mi.dishName}
                        </th>
                      ))}
                      {!isPast && (
                        <th className="py-3 px-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider min-w-[100px]">Actions</th>
                      )}
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {sortedOrders.map((order, idx) => (
                      <tr key={order.orderId} className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                        <td className="py-3 px-4 text-gray-500">{idx + 1}</td>
                        <td className="py-3 px-4 font-medium text-gray-900">{order.personName}</td>
                        <td className="py-3 px-4 text-gray-600">{order.personPhone || '-'}</td>
                        <td className="py-3 px-4 text-gray-600">{order.pickupZoneName || '-'}</td>
                        {individualOrders.menuItems.map((mi) => {
                          const orderItem = order.items.find(i => i.menuItemId === mi.menuItemId);
                          const badge = orderItem ? getSizeBadge(orderItem.size) : getSizeBadge('');
                          return (
                            <td key={mi.menuItemId} className="py-3 px-3 text-center">
                              <span className={`inline-flex items-center justify-center w-7 h-7 rounded-md text-xs font-bold ${badge.className}`}>
                                {badge.label}
                              </span>
                            </td>
                          );
                        })}
                        {!isPast && (
                          <td className="py-3 px-4 text-center">
                            <div className="flex items-center justify-center gap-2">
                              <button
                                onClick={() => openEditModal(order)}
                                className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                                title="Edit order"
                              >
                                Edit
                              </button>
                              <button
                                onClick={() => openDeleteModal(order)}
                                className="text-red-600 hover:text-red-800 text-sm font-medium"
                                title="Delete order"
                              >
                                Delete
                              </button>
                            </div>
                          </td>
                        )}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          {/* Legend */}
          {individualOrders && individualOrders.orders.length > 0 && (
            <div className="flex items-center gap-6 text-sm text-gray-600">
              <span className="font-medium">Legend:</span>
              <div className="flex items-center gap-2">
                <span className="inline-flex items-center justify-center w-6 h-6 rounded bg-purple-100 text-purple-700 text-xs font-bold">L</span>
                <span>Large (1 qt)</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="inline-flex items-center justify-center w-6 h-6 rounded bg-blue-100 text-blue-700 text-xs font-bold">S</span>
                <span>Small (½ qt)</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="inline-flex items-center justify-center w-6 h-6 rounded bg-green-100 text-green-700 text-xs font-bold">B</span>
                <span>Barakati (¼ qt)</span>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Shopping List Tab */}
      {activeTab === 'shopping' && (
        <div className="space-y-6">
          <div className="card overflow-hidden p-0">
            <div className="bg-blue-600 px-6 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div className="min-w-0">
                <h2 className="text-lg font-semibold text-white">Shopping List</h2>
                <p className="text-sm text-blue-200">Ingredients needed based on registrations</p>
              </div>
              <div className="flex items-center gap-3 flex-shrink-0">
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
        </div>
      )}

      {/* Add Thaali Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-lg mx-4 max-h-[90vh] overflow-y-auto">
            <div className="bg-blue-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Add Thaali</h3>
              <p className="text-sm text-blue-200">Register a thaali for a user who hasn't registered yet</p>
            </div>
            <div className="p-6 space-y-4">
              {formError && (
                <div className="bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}

              {/* Person Select */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Select Person *</label>
                <select
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  value={formData.personId || ''}
                  onChange={(e) => setFormData({ ...formData, personId: e.target.value ? Number(e.target.value) : null })}
                >
                  <option value="">Select a person...</option>
                  {usersWithoutOrders?.map((person) => (
                    <option key={person.id} value={person.id}>
                      {person.firstName} {person.lastName} ({person.itsNumber})
                    </option>
                  ))}
                </select>
                {usersWithoutOrders?.length === 0 && (
                  <p className="text-sm text-gray-500 mt-1">All users have already registered for this event.</p>
                )}
              </div>

              {/* Pickup Zone Select */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Pickup Zone *</label>
                <select
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  value={formData.pickupZoneId || ''}
                  onChange={(e) => setFormData({ ...formData, pickupZoneId: e.target.value ? Number(e.target.value) : null })}
                >
                  <option value="">Select pickup zone...</option>
                  {pickupZones?.map((zone) => (
                    <option key={zone.id} value={zone.id}>{zone.name}</option>
                  ))}
                </select>
              </div>

              {/* Menu Items */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Dishes *</label>
                <div className="space-y-2">
                  {menuItemsForForm?.map((mi) => {
                    const currentItem = formData.items.find(i => i.menuItemId === mi.menuItemId);
                    return (
                      <div key={mi.menuItemId} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="flex-1 text-sm font-medium">{mi.dishName || 'Unknown'}</span>
                        <div className="flex gap-1">
                          {(['LARGE', 'SMALL', 'BARAKATI'] as MealSize[]).map((size) => (
                            <button
                              key={size}
                              type="button"
                              onClick={() => handleFormItemChange(mi.menuItemId, currentItem?.size === size ? null : size)}
                              className={`px-3 py-1 text-xs font-bold rounded ${
                                currentItem?.size === size
                                  ? size === 'LARGE' ? 'bg-purple-600 text-white' :
                                    size === 'SMALL' ? 'bg-blue-600 text-white' :
                                    'bg-green-600 text-white'
                                  : 'bg-gray-200 text-gray-600 hover:bg-gray-300'
                              }`}
                            >
                              {size === 'LARGE' ? 'L' : size === 'SMALL' ? 'S' : 'B'}
                            </button>
                          ))}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Notes */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Notes (optional)</label>
                <textarea
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  rows={2}
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  placeholder="Optional notes..."
                />
              </div>
            </div>

            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowAddModal(false); resetForm(); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitAdd}
                disabled={createOrderMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50"
              >
                {createOrderMutation.isPending ? 'Creating...' : 'Add Thaali'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Thaali Modal */}
      {showEditModal && selectedOrder && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-lg mx-4 max-h-[90vh] overflow-y-auto">
            <div className="bg-blue-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Edit Thaali</h3>
              <p className="text-sm text-blue-200">Editing thaali for {selectedOrder.personName}</p>
            </div>
            <div className="p-6 space-y-4">
              {formError && (
                <div className="bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}

              {/* Person (readonly) */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Person</label>
                <div className="w-full rounded-md border border-gray-200 bg-gray-100 px-3 py-2 text-sm text-gray-600">
                  {selectedOrder.personName}
                </div>
              </div>

              {/* Pickup Zone Select */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Pickup Zone *</label>
                <select
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  value={formData.pickupZoneId || ''}
                  onChange={(e) => setFormData({ ...formData, pickupZoneId: e.target.value ? Number(e.target.value) : null })}
                >
                  <option value="">Select pickup zone...</option>
                  {pickupZones?.map((zone) => (
                    <option key={zone.id} value={zone.id}>{zone.name}</option>
                  ))}
                </select>
              </div>

              {/* Menu Items */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Dishes *</label>
                <div className="space-y-2">
                  {menuItemsForForm?.map((mi) => {
                    const currentItem = formData.items.find(i => i.menuItemId === mi.menuItemId);
                    return (
                      <div key={mi.menuItemId} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="flex-1 text-sm font-medium">{mi.dishName || 'Unknown'}</span>
                        <div className="flex gap-1">
                          {(['LARGE', 'SMALL', 'BARAKATI'] as MealSize[]).map((size) => (
                            <button
                              key={size}
                              type="button"
                              onClick={() => handleFormItemChange(mi.menuItemId, currentItem?.size === size ? null : size)}
                              className={`px-3 py-1 text-xs font-bold rounded ${
                                currentItem?.size === size
                                  ? size === 'LARGE' ? 'bg-purple-600 text-white' :
                                    size === 'SMALL' ? 'bg-blue-600 text-white' :
                                    'bg-green-600 text-white'
                                  : 'bg-gray-200 text-gray-600 hover:bg-gray-300'
                              }`}
                            >
                              {size === 'LARGE' ? 'L' : size === 'SMALL' ? 'S' : 'B'}
                            </button>
                          ))}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Notes */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Notes (optional)</label>
                <textarea
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  rows={2}
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  placeholder="Optional notes..."
                />
              </div>
            </div>

            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowEditModal(false); resetForm(); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitEdit}
                disabled={updateOrderMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50"
              >
                {updateOrderMutation.isPending ? 'Saving...' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteModal && selectedOrder && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
            <div className="bg-red-600 px-6 py-4 rounded-t-lg">
              <h3 className="text-lg font-semibold text-white">Delete Thaali</h3>
            </div>
            <div className="p-6">
              <p className="text-gray-600">
                Are you sure you want to delete the thaali registration for <strong>{selectedOrder.personName}</strong>?
                This action cannot be undone.
              </p>
              {formError && (
                <div className="mt-4 bg-red-100 text-red-700 px-4 py-2 rounded text-sm">{formError}</div>
              )}
            </div>
            <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3 rounded-b-lg">
              <button
                onClick={() => { setShowDeleteModal(false); setSelectedOrder(null); setFormError(null); }}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleConfirmDelete}
                disabled={deleteOrderMutation.isPending}
                className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 disabled:opacity-50"
              >
                {deleteOrderMutation.isPending ? 'Deleting...' : 'Delete Thaali'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
