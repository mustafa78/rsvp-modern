import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Link } from 'react-router-dom';
import { api } from '../api/client';

type AnnouncementType = 'MANUAL' | 'EVENT_UPDATE';

type Announcement = {
  id: number;
  title: string | null;
  content: string;
  type: AnnouncementType;
  eventId: number | null;
  eventTitle: string | null;
  createdByName: string | null;
  createdAt: string;
  expiresAt: string | null;
  active: boolean;
  isRead: boolean;
};

export default function AnnouncementBanner() {
  const queryClient = useQueryClient();

  const { data: announcements } = useQuery<Announcement[]>({
    queryKey: ['announcements'],
    queryFn: async () => (await api.get('/announcements')).data,
    staleTime: 1000 * 60, // 1 minute
  });

  const markReadMutation = useMutation({
    mutationFn: async (id: number) => api.post(`/announcements/${id}/read`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['announcements'] });
      queryClient.invalidateQueries({ queryKey: ['announcements-unread-count'] });
    },
  });

  // Get the latest unread announcement
  const latestUnread = announcements?.find(a => !a.isRead);

  const formatRelativeTime = (dateStr: string) => {
    const date = new Date(dateStr);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  if (!latestUnread) {
    return null;
  }

  const unreadCount = announcements?.filter(a => !a.isRead).length || 0;

  return (
    <div className="relative overflow-hidden bg-gradient-to-r from-amber-500 via-orange-500 to-rose-500 rounded-xl shadow-lg">
      {/* Decorative background pattern */}
      <div className="absolute inset-0 opacity-10">
        <svg className="absolute right-0 top-0 h-full w-1/3" viewBox="0 0 100 100" preserveAspectRatio="none">
          <circle cx="80" cy="20" r="40" fill="white" />
          <circle cx="100" cy="80" r="30" fill="white" />
        </svg>
      </div>

      <div className="relative px-5 py-4">
        <div className="flex items-start justify-between gap-4">
          <div className="flex items-start gap-4 flex-1 min-w-0">
            {/* Megaphone icon */}
            <div className="flex-shrink-0 w-12 h-12 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center shadow-inner">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" />
              </svg>
            </div>

            {/* Content */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1">
                <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-bold bg-white/20 text-white uppercase tracking-wide">
                  New
                </span>
                <span className="text-xs text-white/80">{formatRelativeTime(latestUnread.createdAt)}</span>
              </div>
              {latestUnread.title && (
                <h3 className="font-bold text-white text-lg leading-tight mb-1">{latestUnread.title}</h3>
              )}
              <p className="text-white/90 text-sm line-clamp-2">{latestUnread.content}</p>
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center gap-3 flex-shrink-0">
            <Link
              to="/announcements"
              className="inline-flex items-center gap-1.5 px-4 py-2 bg-white text-orange-600 font-semibold text-sm rounded-lg hover:bg-orange-50 transition-colors shadow-sm"
            >
              {unreadCount > 1 ? `View All (${unreadCount})` : 'View All'}
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </Link>
            <button
              onClick={() => markReadMutation.mutate(latestUnread.id)}
              disabled={markReadMutation.isPending}
              className="p-2 text-white/70 hover:text-white hover:bg-white/20 rounded-lg transition-colors"
              title="Dismiss"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
