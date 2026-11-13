# WallCal Landing Page

Landing page for [WallCal](https://wallcal.app) — a macOS wallpaper calendar app.

## Stack

- [Astro](https://astro.build) — static site framework
- [Tailwind CSS v4](https://tailwindcss.com) — styling
- [Alpine.js](https://alpinejs.dev) — lightweight interactivity
- [AOS](https://michalsnik.github.io/aos/) — scroll animations

## Pages

- `/` — Main landing page (hero, features, FAQ, download CTAs)
- `/contact-us` — Support contact
- `/acknowledgements` — Open source licenses
- `/expert-calendar-addon` — Addon preview

Each page also exists under `/de/`, `/ja/` and `/zh/`. English stays at the root.

## Content

- UI copy: `src/i18n/{en,de,ja,zh}.ts`. `en.ts` defines the shape; the others must match it (`npx astro check`).
- FAQ: `src/data/faq.ts`, all four languages per entry.
- Support announcements: `src/content/announcements/<locale>/<slug>.md`. See below.

### Announcements (support page status feed)

Copy `src/content/announcements/en/example.md` (a `draft: true` template) to start one.

- **New:** add `en/<slug>.md`, push.
- **Update:** prepend an entry to `updates:`, push.
- **Resolve:** set `resolved: YYYY-MM-DD`, push. It moves to "Past announcements", grouped by month.
- **Hide:** `draft: true`, or delete the file.
- `level`: `info` | `warning` | `outage`.
- **Translations:** same slug under `de/`, `ja/`, `zh/`. Missing ones fall back to English.

Build fails if frontmatter doesn't match the schema in `src/content.config.ts`.

## Setup

```bash
npm install
cp .env.example .env.local  # Add PostHog token (optional)
npm run dev
```

## Deployment

Hosted on Cloudflare Pages. Builds as a fully static site.
