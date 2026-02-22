# WallCal Landing Page

Landing page for [WallCal](https://wallcal.app) — a macOS wallpaper calendar app.

## Stack

- [Astro](https://astro.build) — static site framework
- [Tailwind CSS v4](https://tailwindcss.com) — styling
- [Alpine.js](https://alpinejs.dev) — lightweight interactivity
- [AOS](https://michalsnik.github.io/aos/) — scroll animations
- [Notion API](https://developers.notion.com) — FAQ content (fetched at build time)

## Pages

- `/` — Main landing page (hero, features, FAQ, download CTAs)
- `/contact-us` — Support contact
- `/acknowledgements` — Open source licenses
- `/expert-calendar-addon` — Addon preview

## Setup

```bash
npm install
cp .env.example .env.local  # Add NOTION_API_KEY and NOTION_DATABASE_ID
npm run dev
```

## Deployment

Hosted on Cloudflare Pages. Builds as a fully static site.
