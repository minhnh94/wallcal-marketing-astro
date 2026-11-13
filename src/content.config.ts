import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Support-page announcements. One Markdown file per announcement per locale:
// src/content/announcements/<locale>/<slug>.md. Non-English locales fall back to en.
const announcements = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/announcements' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    level: z.enum(['info', 'warning', 'outage']).default('info'),
    resolved: z.coerce.date().optional(),
    updates: z
      .array(z.object({ date: z.coerce.date(), text: z.string() }))
      .default([]),
    draft: z.boolean().default(false),
  }),
});

export const collections = { announcements };
