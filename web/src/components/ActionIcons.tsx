import { ReactNode } from 'react';

// Small action icons for the Actions columns in the admin screens. Each button that uses one
// carries a tooltip and an aria-label, because the icon alone does not say what it does.

const TONE = {
  blue: 'text-blue-700 hover:bg-blue-50 focus-visible:outline-blue-600',
  red: 'text-red-600 hover:bg-red-50 focus-visible:outline-red-600',
  green: 'text-green-700 hover:bg-green-50 focus-visible:outline-green-600',
  amber: 'text-amber-600 hover:bg-amber-50 focus-visible:outline-amber-600',
  purple: 'text-purple-700 hover:bg-purple-50 focus-visible:outline-purple-600',
  gray: 'text-gray-600 hover:bg-gray-100 focus-visible:outline-gray-500',
};

/** Classes for an icon-only button or link. */
export function iconAction(tone: keyof typeof TONE = 'blue') {
  return `inline-flex rounded-md p-1.5 focus-visible:outline focus-visible:outline-2 disabled:cursor-not-allowed disabled:opacity-50 ${TONE[tone]}`;
}

function Icon({ children, spin }: { children: ReactNode; spin?: boolean }) {
  return (
    <svg className={`h-5 w-5${spin ? ' animate-spin' : ''}`} viewBox="0 0 24 24" fill="none" stroke="currentColor"
      strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      {children}
    </svg>
  );
}

export const SpinnerIcon = () => (
  <Icon spin>
    <circle cx="12" cy="12" r="9" opacity="0.25" />
    <path d="M21 12a9 9 0 0 0-9-9" />
  </Icon>
);

export const CopyIcon = () => (
  <Icon>
    <rect x="9" y="9" width="11" height="11" rx="2" />
    <path d="M5 15V6a2 2 0 0 1 2-2h9" />
  </Icon>
);

export const TrashIcon = () => (
  <Icon>
    <path d="M4 7h16" />
    <path d="M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
    <path d="M6 7l1 12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-12" />
    <path d="M10 11v6M14 11v6" />
  </Icon>
);

export const EditIcon = () => (
  <Icon>
    <path d="M4 20h4L19 9a2.1 2.1 0 0 0-3-3L5 17v3z" />
    <path d="M14.5 7.5l3 3" />
  </Icon>
);

export const PeopleIcon = () => (
  <Icon>
    <circle cx="9" cy="8" r="3.2" />
    <path d="M3 20a6 6 0 0 1 12 0" />
    <path d="M16 5.2a3.2 3.2 0 0 1 0 5.6" />
    <path d="M17.5 14.3A6 6 0 0 1 21 20" />
  </Icon>
);

export const MailIcon = () => (
  <Icon>
    <rect x="3" y="5" width="18" height="14" rx="2" />
    <path d="M3.5 7l8.5 6 8.5-6" />
  </Icon>
);

export const ReportIcon = () => (
  <Icon>
    <path d="M4 20h16" />
    <path d="M7 20v-7M12 20V5M17 20v-10" />
  </Icon>
);

export const EyeIcon = () => (
  <Icon>
    <path d="M2.5 12S6 5.5 12 5.5 21.5 12 21.5 12 18 18.5 12 18.5 2.5 12 2.5 12z" />
    <circle cx="12" cy="12" r="2.8" />
  </Icon>
);

export const PublishIcon = () => (
  <Icon>
    <path d="M12 16V4" />
    <path d="M7 9l5-5 5 5" />
    <path d="M4 15v3a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-3" />
  </Icon>
);

export const ListIcon = () => (
  <Icon>
    <rect x="5" y="4" width="14" height="17" rx="2" />
    <path d="M9 3h6v3H9z" />
    <path d="M9 11h6M9 15h6" />
  </Icon>
);

export const CheckCircleIcon = () => (
  <Icon>
    <circle cx="12" cy="12" r="9" />
    <path d="M8 12.5l2.8 2.8L16 9.5" />
  </Icon>
);

export const BanIcon = () => (
  <Icon>
    <circle cx="12" cy="12" r="9" />
    <path d="M5.7 5.7l12.6 12.6" />
  </Icon>
);

export const XCircleIcon = () => (
  <Icon>
    <circle cx="12" cy="12" r="9" />
    <path d="M9 9l6 6M15 9l-6 6" />
  </Icon>
);
