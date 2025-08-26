import React from 'react'
import ReactDOM from 'react-dom/client'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import App from './App'
import EventsPage from './pages/EventsPage'
import EventDetailPage from './pages/EventDetailPage'
import RsvpPage from './pages/RsvpPage'
import AdminPage from './pages/AdminPage'
import Login from './pages/Login'
import Register from './pages/Register'
import ForgotPassword from './pages/ForgotPassword'
import ResetPassword from './pages/ResetPassword'
import ChangePassword from './pages/ChangePassword'
import './styles/index.css'

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,             // layout only; no router here
    children: [
      { index: true, element: <EventsPage /> },
      { path: 'events/:id', element: <EventDetailPage /> },
      { path: 'events/:id/rsvp', element: <RsvpPage /> },
      { path: 'admin', element: <AdminPage /> },

      // auth routes live in the same tree
      { path: 'login', element: <Login /> },
      { path: 'register', element: <Register /> },
      { path: 'forgot-password', element: <ForgotPassword /> },
      { path: 'reset-password', element: <ResetPassword /> },
      { path: 'change-password', element: <ChangePassword /> },
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