import en from './en';
import de from './de';
import ja from './ja';
import zh from './zh';

// English lives at the site root so existing URLs stay unchanged; the rest get a path prefix.
export const locales = ['en', 'de', 'ja', 'zh'] as const;
export type Locale = (typeof locales)[number];
export const defaultLocale: Locale = 'en';
export const prefixedLocales = locales.filter((l) => l !== defaultLocale);

export const localeMeta: Record<Locale, { label: string; htmlLang: string; ogLocale: string }> = {
  en: { label: 'English', htmlLang: 'en', ogLocale: 'en_US' },
  de: { label: 'Deutsch', htmlLang: 'de', ogLocale: 'de_DE' },
  ja: { label: '日本語', htmlLang: 'ja', ogLocale: 'ja_JP' },
  zh: { label: '简体中文', htmlLang: 'zh-Hans', ogLocale: 'zh_CN' },
};

const dictionaries = { en, de, ja, zh };

export function getLocale(url: URL): Locale {
  const segment = url.pathname.split('/')[1];
  return (prefixedLocales as readonly string[]).includes(segment) ? (segment as Locale) : defaultLocale;
}

export function useTranslations(url: URL) {
  return dictionaries[getLocale(url)];
}

/** Drop the locale prefix: '/de/support/' -> '/support/'. */
export function stripLocale(pathname: string): string {
  const locale = getLocale(new URL(pathname, 'https://x'));
  return locale === defaultLocale ? pathname : pathname.slice(locale.length + 1) || '/';
}

/** Point a root-relative site path at a locale: ('/#faq', 'de') -> '/de/#faq'. */
export function localizePath(path: string, locale: Locale): string {
  return locale === defaultLocale ? path : `/${locale}${path}`;
}

/** Bind localizePath to the current page's locale. */
export function useLocalizePath(url: URL) {
  const locale = getLocale(url);
  return (path: string) => localizePath(path, locale);
}

export function localeStaticPaths() {
  return prefixedLocales.map((lang) => ({ params: { lang } }));
}
