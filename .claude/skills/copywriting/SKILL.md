---
name: copywriting
description: Hook-first landing-page copy in an Eminem-bars, Apple-keynote voice that converts short-attention skimmers. Use when writing, rewriting, or auditing marketing copy for a product landing page.
---

# Landing-page copywriting

**Goal:** turn a cold, scrolling visitor into the page's one conversion: sign-up, download, or purchase. Assume Shorts/TikTok-trained attention: they glance, they don't read. Each screen gets about three seconds to earn the next scroll.

## Ground truth first

Pull these from the project (its docs, `AGENTS.md`, the app, the code) before writing a line:

- **The conversion:** the one action the page exists for, and the button that takes it.
- **The buyer:** who decides and pays, and the pain they already feel. Often a different person from the end user.
- **The core promise:** the one reason to switch.
- **The claims boundary:** what ships today, from the project's source of truth (feature list, changelog, code).
- **The proof:** demo, screenshots, real customers, real numbers.
- **The rendering:** how the layout sets copy (line splits, accent styling, truncation, phone wrapping). Write to it.

## The bar

Copy is done when a stranger glancing at any screen of the page, on a phone, can say in one breath what the product is, why they'd want it, and what to tap, and at least one line sticks in their head. Check every screen, not just the hero.

## How to get there

You choose the words, structure, rhyme schemes, and angles. The principles say what converts; the samples set the register, so write fresh lines for this product.

- **Hook.** Treat every heading like the first second of a short: lead with the buyer's payoff, in words a skimmer gets on the first pass. Most visitors read only headings and buttons, so those carry the page on their own.
- **Name it first.** The hero headline says literally what the product is; the clever line sits right under it. The plainest strong line often already exists in the page title, the social card, or a video caption: promote it.
- **Clarity wins ties.** Wordplay earns its place when it reads as fast as the plain version. Every beat carries meaning; a beat that exists only for the rhyme is filler. Read each key word the way a skimmer might take it first (_windows_ on a Mac page can read as Windows).
- **Write for the first-timer.** Every line describes what the product is and does today, for someone who never saw an earlier version. Release news ("now free", "redesigned with…") belongs in the changelog.
- **Pain in the headings.** The buyer's pain ("Meetings slip. Deadlines creep.") is a hook: put it where skimmers read, in a heading or the line beside it at full weight.
- **One point per screen.** The core promise drums through the whole page. Within one screen, each line adds something new. Each payoff phrase ("Your call", "forget it's there") appears once per page, and adjacent punchlines take different shapes.
- **One-line bodies.** Card and feature body text runs about 12 words: the heading carries the point, the body adds one concrete fact.
- **Show, then tell.** Demos, mocks, and screenshots are the proof. Copy points at them and stays short enough that the visual remains the hero.
- **Proof at the button.** Real ratings with their counts, per store or source, sit right beside the main button.
- **Buttons say the deal:** a verb, the outcome, and the cost when it's free.
- **Small print removes risk.** The line under the main button answers the last doubts before the tap: free, no account, works with what they already use. Upsells and terms the page hasn't explained yet go further down.
- **Caveats once.** Lead with what works today; state required caveats once, plainly.
- **FAQ order:** the questions people ask before buying (price, compatibility, trial) first; support and troubleshooting last.

## Voice: bars, keynote-clean

- **Bars (Eminem):** short beats, triads, internal rhyme, repetition with a twist, punchline last.
- **Keynote (Apple):** confident declaratives and fragments, one idea per sentence, concrete nouns and numbers in place of adjectives, the product as hero, understatement over hype.
- **Register samples** (a comment-widget page): "No rent. No renewal. Solo is $69. Once." · "Paste once. Every page. Its own thread." · "Your readers have something to say. Let 'em."
- **Localized pages** get the same punch through the language's own devices (Japanese: short `。` beats, 体言止め). Rhyme is optional there; meaning and structure match the source. Reuse the phrasing the localized assets already use (video captions, social cards), so each language says its headline one way.

## Guardrails

- Claims stay inside what ships. Carry the product's own qualifiers: optional features, limits, prelaunch status.
- Social proof is real: real customers, real numbers. Illustrative personas in mockups stay in the mockups.

## Auditing

Walk the page as the skimmer: screen by screen at phone width, mark where the glance stalls (a line that needs decoding, a point repeated on the same screen, no obvious next tap). Check every language's headline breaks at phone width too; long compounds (German) split lines differently. Rank findings by conversion impact and propose replacement lines in the voice.

Report blockers that copy alone can't fix as layout findings. Check each of these every audit:

- **Product above the fold:** the product is visible on the first screen at laptop height (about 1440×900).
- **Video plays itself:** muted, looped, captioned, about 10 s, starting on load; sound and the full cut on tap.
- **Thumb-reach button:** phones keep a download or sign-up button on screen after the hero scrolls away.
- **Platform mismatch:** a desktop-only product seen on a phone needs a send-it-to-my-computer path (the share sheet).

## This repo (WallCal)

- Every copy change lands in all four languages (`src/i18n/{en,de,ja,zh}.ts`, `src/data/faq.ts`), each carrying the rhythm in its own language.
- The Expert add-on price stays off the page by the owner's choice.
