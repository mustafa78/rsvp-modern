import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    // Listens on localhost only. Never expose the dev server to a network:
    // it can be taken over remotely. Shared environments use docker-compose.qa.yml.
    allowedHosts: [
      'localhost',
      'fmbqa.dcjamaat.com',
      '.dcjamaat.com', // Allow all subdomains
    ],
    proxy: {
      '/api': {
        // Use localhost for local dev, Docker service name is resolved inside container
        target: process.env.VITE_API_TARGET || 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
})
