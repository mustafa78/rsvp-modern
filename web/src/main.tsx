import React from 'react'
import ReactDOM from 'react-dom/client'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import App from './App'
import EventsPage from './pages/EventsPage'
import CalendarPage from './pages/CalendarPage'
import EventDetailPage from './pages/EventDetailPage'
import RsvpPage from './pages/RsvpPage'
import BulkThaaliRegistration from './pages/BulkThaaliRegistration'
import LandingPage from './pages/LandingPage'
import Login from './pages/Login'
import Register from './pages/Register'
import ForgotPassword from './pages/ForgotPassword'
import ResetPassword from './pages/ResetPassword'
import ChangePassword from './pages/ChangePassword'
import ChangePasswordPublic from './pages/ChangePasswordPublic'
// Admin pages
import AdminLayout from './pages/admin/AdminLayout'
import AdminDashboard from './pages/admin/AdminDashboard'
import EventList from './pages/admin/events/EventList'
import CreateThaaliEvent from './pages/admin/events/CreateThaaliEvent'
import CreateNiyazEvent from './pages/admin/events/CreateNiyazEvent'
import EventDetail from './pages/admin/events/EventDetail'
import DishList from './pages/admin/catalog/DishList'
import IngredientList from './pages/admin/catalog/IngredientList'
import ChefList from './pages/admin/catalog/ChefList'
import CategoryList from './pages/admin/catalog/CategoryList'
import StoreList from './pages/admin/catalog/StoreList'
import StorageLocationList from './pages/admin/catalog/StorageLocationList'
import UnitList from './pages/admin/catalog/UnitList'
import UserList from './pages/admin/settings/UserList'
import PickupZoneList from './pages/admin/settings/PickupZoneList'
import RoleManagement from './pages/admin/settings/RoleManagement'
import ThaaliOrderReport from './pages/admin/reports/ThaaliOrderReport'
import NiyazRsvpReport from './pages/admin/reports/NiyazRsvpReport'
import ShoppingListGenerator from './pages/admin/reports/ShoppingListGenerator'
import './styles/index.css'

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    // optional safety net so you don't get a silent blank on errors
    errorElement: <div style={{padding:24}}>Something went wrong. <a href="/">Go home</a></div>,
    children: [
      { index: true, element: <LandingPage /> },
      { path: 'events', element: <EventsPage /> },
      { path: 'calendar', element: <CalendarPage /> },
      { path: 'events/:id', element: <EventDetailPage /> },
      { path: 'events/:id/rsvp', element: <RsvpPage /> },
      { path: 'thaali/quick-register', element: <BulkThaaliRegistration /> },
      {
        path: 'admin',
        element: <AdminLayout />,
        children: [
          { index: true, element: <AdminDashboard /> },
          { path: 'events', element: <EventList /> },
          { path: 'events/new/thaali', element: <CreateThaaliEvent /> },
          { path: 'events/new/niyaz', element: <CreateNiyazEvent /> },
          { path: 'events/edit/thaali/:id', element: <CreateThaaliEvent /> },
          { path: 'events/edit/niyaz/:id', element: <CreateNiyazEvent /> },
          { path: 'events/:id', element: <EventDetail /> },
          { path: 'catalog/dishes', element: <DishList /> },
          { path: 'catalog/ingredients', element: <IngredientList /> },
          { path: 'catalog/chefs', element: <ChefList /> },
          { path: 'catalog/categories', element: <CategoryList /> },
          { path: 'catalog/stores', element: <StoreList /> },
          { path: 'catalog/storage-locations', element: <StorageLocationList /> },
          { path: 'catalog/units', element: <UnitList /> },
          { path: 'settings/users', element: <UserList /> },
          { path: 'settings/roles', element: <RoleManagement /> },
          { path: 'settings/zones', element: <PickupZoneList /> },
          { path: 'reports/orders/:eventId', element: <ThaaliOrderReport /> },
          { path: 'reports/rsvps/:eventId', element: <NiyazRsvpReport /> },
          { path: 'reports/shopping-list', element: <ShoppingListGenerator /> },
        ],
      },
      { path: 'login', element: <Login /> },
      { path: 'register', element: <Register /> },
      { path: 'forgot-password', element: <ForgotPassword /> },
      { path: 'reset-password', element: <ResetPassword /> },
      { path: 'change-password', element: <ChangePassword /> },
      { path: 'change-password-public', element: <ChangePasswordPublic /> },
    ],
  },
])

const qc = new QueryClient()
ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={qc}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  </React.StrictMode>
)