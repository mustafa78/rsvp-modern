/**
 * Hijri Date Conversion for Dawoodi Bohra Misri Calendar
 *
 * Adapted from mumineen_calendar_js by Murtaza Gulamali
 * https://github.com/mygulamali/mumineen_calendar_js
 *
 * This implements the Fatimid/Misri calendar calculation used by Dawoodi Bohra Muslims,
 * which follows a fixed 30-year cycle rather than moon sighting.
 */

// Hijri year remainders for determining Kabisa (leap) years
const KABISA_YEAR_REMAINDERS = [2, 5, 8, 10, 13, 16, 19, 21, 24, 27, 29];

// Cumulative number of days in a Hijri year per month (0-indexed months)
const DAYS_IN_YEAR = [30, 59, 89, 118, 148, 177, 207, 236, 266, 295, 325];

// Cumulative number of days in 30-year cycles per Hijri year
const DAYS_IN_30_YEARS = [
  354, 708, 1063, 1417, 1771, 2126, 2480, 2834, 3189, 3543,
  3898, 4252, 4606, 4961, 5315, 5669, 6024, 6378, 6732, 7087,
  7441, 7796, 8150, 8504, 8859, 9213, 9567, 9922, 10276, 10631
];

// Month names in English
const MONTH_NAMES = {
  long: [
    "Moharram al-Haraam",
    "Safar al-Muzaffar",
    "Rabi al-Awwal",
    "Rabi al-Aakhar",
    "Jumada al-Ula",
    "Jumada al-Ukhra",
    "Rajab al-Asab",
    "Shabaan al-Karim",
    "Ramadaan al-Moazzam",
    "Shawwal al-Mukarram",
    "Zilqadah al-Haraam",
    "Zilhaj al-Haraam"
  ],
  short: [
    "Moharram",
    "Safar",
    "Rabi I",
    "Rabi II",
    "Jumada I",
    "Jumada II",
    "Rajab",
    "Shabaan",
    "Ramadaan",
    "Shawwal",
    "Zilqadah",
    "Zilhaj"
  ]
};

// Arabic-Indic numerals (٠-٩)
const ARABIC_NUMERALS = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

export interface HijriDateInfo {
  year: number;
  month: number; // 0-indexed (0 = Moharram)
  day: number;
}

/**
 * Check if a Gregorian date is a Julian calendar date (before Oct 15, 1582)
 */
function isJulian(date: Date): boolean {
  const year = date.getFullYear();
  const month = date.getMonth();
  const day = date.getDate();

  if (year < 1582) return true;
  if (year === 1582) {
    if (month < 9) return true;
    if (month === 9 && day < 5) return true;
  }
  return false;
}

/**
 * Convert Gregorian Date to Astronomical Julian Date (AJD)
 */
function gregorianToAJD(date: Date): number {
  let year = date.getFullYear();
  let month = date.getMonth() + 1;
  const day = date.getDate()
    + date.getHours() / 24
    + date.getMinutes() / 1440
    + date.getSeconds() / 86400
    + date.getMilliseconds() / 86400000;

  if (month < 3) {
    year--;
    month += 12;
  }

  let b: number;
  if (isJulian(date)) {
    b = 0;
  } else {
    const a = Math.floor(year / 100);
    b = 2 - a + Math.floor(a / 4);
  }

  return Math.floor(365.25 * (year + 4716)) + Math.floor(30.6001 * (month + 1)) + day + b - 1524.5;
}

/**
 * Check if a Hijri year is a Kabisa (leap) year
 */
function isKabisa(year: number): boolean {
  return KABISA_YEAR_REMAINDERS.includes(year % 30);
}

/**
 * Get the number of days in a specific Hijri month
 */
export function getDaysInHijriMonth(year: number, month: number): number {
  // Month 11 (Zilhaj) has 30 days in Kabisa years, otherwise alternating 30/29
  return ((month === 11) && isKabisa(year)) || (month % 2 === 0) ? 30 : 29;
}

/**
 * Convert Astronomical Julian Date to Hijri Date
 */
function ajdToHijri(ajd: number): HijriDateInfo {
  let i = 0;
  let left = Math.floor(ajd - 1948083.5);
  const y30 = Math.floor(left / 10631.0);

  left -= y30 * 10631;
  while (left > DAYS_IN_30_YEARS[i]) {
    i += 1;
  }

  const year = Math.round(y30 * 30.0 + i);
  if (i > 0) {
    left -= DAYS_IN_30_YEARS[i - 1];
  }

  i = 0;
  while (left > DAYS_IN_YEAR[i]) {
    i += 1;
  }

  const month = Math.round(i);
  const day = i > 0 ? Math.round(left - DAYS_IN_YEAR[i - 1]) : Math.round(left);

  return { year, month, day };
}

/**
 * Convert a Gregorian Date to Hijri Date (Dawoodi Bohra Misri Calendar)
 */
export function gregorianToHijri(date: Date): HijriDateInfo {
  return ajdToHijri(gregorianToAJD(date));
}

/**
 * Get the long month name in English
 */
export function getHijriMonthName(month: number): string {
  return MONTH_NAMES.long[month] || '';
}

/**
 * Get the short month name in English
 */
export function getHijriShortMonthName(month: number): string {
  return MONTH_NAMES.short[month] || '';
}

/**
 * Convert a number to Arabic-Indic numerals
 */
export function toArabicNumerals(num: number): string {
  return Math.floor(num)
    .toString()
    .split('')
    .map(digit => ARABIC_NUMERALS[parseInt(digit, 10)])
    .join('');
}

/**
 * Format a Hijri date as a string
 * @param hijri - The Hijri date info
 * @param format - 'short' for "21 Shawwal", 'long' for "21 Shawwal al-Mukarram 1447", 'arabic' for "٢١ شوال"
 */
export function formatHijriDate(hijri: HijriDateInfo, format: 'short' | 'long' | 'arabic' | 'day-only' = 'short'): string {
  switch (format) {
    case 'long':
      return `${hijri.day} ${getHijriMonthName(hijri.month)} ${hijri.year}`;
    case 'arabic':
      return `${toArabicNumerals(hijri.day)} ${getHijriShortMonthName(hijri.month)}`;
    case 'day-only':
      return `${hijri.day}`;
    case 'short':
    default:
      return `${hijri.day} ${getHijriShortMonthName(hijri.month)}`;
  }
}

/**
 * Get both Gregorian and Hijri info for a date
 */
export function getDateInfo(date: Date): {
  gregorian: { year: number; month: number; day: number };
  hijri: HijriDateInfo;
} {
  return {
    gregorian: {
      year: date.getFullYear(),
      month: date.getMonth(),
      day: date.getDate()
    },
    hijri: gregorianToHijri(date)
  };
}
