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

## Setup

```bash
npm install
cp .env.example .env.local  # Add PostHog token (optional)
npm run dev
```

## Deployment

Hosted on Cloudflare Pages. Builds as a fully static site.
