---
name: copywriting
description: WallCal marketing copy that converts skimmers in seconds, in an Apple-brief, Eminem-cadence voice. Use when writing, rewriting, translating or auditing copy for the landing page, App Store text, announcements or video captions.
---

# WallCal copywriting

The reader is a **skimmer**: thumb-trained by Shorts and TikTok, deciding in seconds. A skimmer reads the **skim layer** only: headlines, buttons, the small print under buttons, images, video captions. Grey body text serves the few who stay. Every page has to sell on the skim layer alone.

## Voice

- **Apple:** short, confident, benefit-first. A headline plus a one-line payoff.
- **Eminem cadence:** internal and multisyllabic rhyme, slant rhyme, wordplay, a little swagger. Examples from this page: CAL-en-dar / WALL-pa-per; "Calendar apps *hide* … keeps your day in *sight*"; German "Fenster kommen und *gehen*. Deine Woche bleibt *stehen*."
- **Style only:** borrow the cadence and write every word fresh, in clean language. Never quote or paraphrase actual lyrics.
- **True:** every claim matches the app; every number comes from the owner.

## Rules

Each rule carries the before → after that taught it.

1. **Clear before clever.** The H1 names the product in plain words; the rhyme rides in the line under it. The clearest line often exists already (title tag, OG card, a promo caption), so promote it.
   "Your windows come and go. *Your week* stays on show." → H1 "Your calendar. *On your wallpaper.*", with "Windows come and go. Your week stays on show." underneath.
2. **Write for first-timers.** Say what a thing is, then what the add-on adds. Release news ("Now free", "Redesigned with Liquid Glass") speaks to existing users and reads as noise to a first-timer. Name a term like "Expert add-on" only after the reader has seen what it is.
   "Now free. The Expert add-on picks the hours and the days." → "Your week, hour by hour. The Expert add-on sets the hours and days."
3. **Proof at the button.** Star rating and review counts sit right under the hero buttons, with real numbers dated in a code comment.
4. **Small print kills the three doubts:** cost, effort, compatibility. "Free · No account · Works with iCloud, Google & Outlook".
5. **Pain in short beats, then the fix.** "Calendar apps hide. Meetings slip. Deadlines creep. WallCal keeps your day in sight." Put the hook in a headline or bold line, where skimmers read.
6. **One line per card**, about 12 words. The headline carries the beat; the body names the concrete action.
   A 50-word "Double-click. Done." body → "Double-click a day to add. Click an event to change it."
7. **Each catchphrase once per page.** "Your call" and "forget it's there" each showed up twice, and the repeat dulled the first. Give neighbouring lines different shapes too: two stacked "Not …" endings blur together.
8. **Pricing says the model:** "Free to start. Pay once for more."
9. **The FAQ sells first:** questions people ask before downloading (subscription, Google/Outlook, free trial) lead, and troubleshooting closes. "Why can't I restore my purchase?" at the top planted doubt right above the last button.

## The first screen

The skimmer decides on the **first screen**, so an audit covers what sits around the words:

- The product is visible above the fold at 1440×900 and on a phone.
- The hero video plays by itself, silent and captioned, with sound one click away (`hero_loop.py` in the `capture-app-media` skill).
- Phones can't install a Mac app, so they get "Send to my Mac" through the share sheet, plus a sticky download bar (`src/components/MobileCTA.astro`).

## Translating

- Carry the rhythm into each language rather than the literal words.
- Match the wording the language's promo captions and OG card already use. German hero "Auf deinem Hintergrundbild" mirrors the video's "Auf Ihrem Hintergrundbild"; the site says *du*.
- Menu and setting names use the app's own localized strings.
- Change all four locales (`src/i18n/{en,de,ja,zh}.ts`, plus `src/data/faq.ts`) in the same edit.

## WallCal facts

- The Expert add-on price stays off the page; that's the owner's decision.
- Store ratings live in `hero.ratingAppStore` / `hero.ratingSetapp` in each locale, dated in a comment in `en.ts`. Fresh numbers come only from the owner.

## Audit and rewrite

1. **Skim test.** Read only the skim layer, top to bottom. Done when each first-screen question has a yes or no: What is it? Can I see it? What does it cost? Can I trust it? What do I do?
2. **Findings.** Rank them, first screen first. Each gets the exact before → after line in the voice, checked against every rule above.
3. **Edit** all four locales after the owner approves, then run `npx astro check`.
4. **Verify rendered.** Screenshot the first screen at 1440×900 and on a 390px phone in every locale. Check that headlines break on phrase boundaries (long German compounds: the emphasized phrase gets its own line) and that rating rows wrap cleanly. Headless Chrome's `--window-size=390,…` on macOS lays the page out wider than 390px and clips the screenshot, so emulate a phone over the DevTools protocol (`Emulation.setDeviceMetricsOverride` with `mobile: true`, plus `Emulation.setTouchEmulationEnabled`). Done when every locale's screenshots answer the five questions.
