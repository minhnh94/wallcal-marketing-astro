import { getLocale, type Locale } from '../i18n';

// Outbound URLs shared across the site. Keep these stable: they carry affiliate/attribution.
export const links = {
  appStore: 'https://apps.apple.com/app/wallcal-wallpaper-calendar/id1581367286',
  appStoreShort: 'https://apps.apple.com/app/wallcal/id1581367286',
  setapp: 'https://go.setapp.com/stp355?refAppID=541',
  twitter: 'https://twitter.com/WallCalApp',
  supportEmail: 'support@wallcal.app',
};

// App Store storefront per locale. English keeps the country-less URL so Apple picks the visitor's store.
const storefront: Record<Locale, string | null> = { en: null, de: 'de', ja: 'jp', zh: 'cn' };

function withStorefront(url: string, locale: Locale): string {
  const cc = storefront[locale];
  return cc ? url.replace('https://apps.apple.com/', `https://apps.apple.com/${cc}/`) : url;
}

/** `links` with App Store URLs pointed at the current page's storefront. */
export function useLinks(url: URL) {
  const locale = getLocale(url);
  return {
    ...links,
    appStore: withStorefront(links.appStore, locale),
    appStoreShort: withStorefront(links.appStoreShort, locale),
  };
}
