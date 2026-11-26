/**
 * Clipboard helpers that also work where the modern clipboard API does not:
 * plain-HTTP sites (QA), and Safari, which refuses a copy that happens after
 * a network call unless the copy was started inside the click itself.
 */

/** Copies text right now. Call this directly from a click. */
export async function copyText(text: string): Promise<boolean> {
  try {
    if (window.isSecureContext && navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text);
      return true;
    }
  } catch {
    // fall through to the older method
  }
  try {
    const area = document.createElement('textarea');
    area.value = text;
    area.setAttribute('readonly', '');
    area.style.position = 'fixed';
    area.style.opacity = '0';
    document.body.appendChild(area);
    area.select();
    const copied = document.execCommand('copy');
    document.body.removeChild(area);
    return copied;
  } catch {
    return false;
  }
}

/**
 * Copies text that is still being fetched. Call this directly from a click, before
 * awaiting anything: the browser ties the copy to that click and fills in the text
 * when the promise resolves. Resolves to false when the browser cannot do it, in
 * which case fall back to copyText once the text has arrived.
 */
export function copyTextWhenReady(text: Promise<string>): Promise<boolean> {
  try {
    if (window.isSecureContext && navigator.clipboard?.write && typeof ClipboardItem !== 'undefined') {
      const item = new ClipboardItem({
        'text/plain': text.then((t) => new Blob([t], { type: 'text/plain' })),
      });
      return navigator.clipboard.write([item]).then(() => true, () => false);
    }
  } catch {
    // fall through
  }
  return Promise.resolve(false);
}
