# Spot Duel V4 — مين المختلفة؟

Real-time 1v1 browser game with photorealistic product images and independent scoring.

## Included
- 36 locally hosted photorealistic product images (6 categories × 6).
- 120 prebuilt odd-one-out puzzles (each includes 4 selectable products, a category-based question and an explanation).
- 20 different puzzles per match; no repeated puzzle IDs within the same match.
- Same puzzles for both players in each room, answered independently.
- Correct = 1 point, incorrect = 0. No speed bonuses.
- Supabase database RPC validates answers; correct choices are never included in the puzzle payload.
- Netlify/Vite deployment configuration.

## Upgrading an existing V3 Supabase project
1. Back up your Supabase database. Finish/abandon active game rooms.
2. SQL Editor: run **supabase/upgrade-v4.sql** after V1 schema, V2 and V3 upgrades. The migration is designed to be rerunnable, but finish any active matches before applying it.
3. Upload/commit all files here, including `public/products/` (36 .webp files).
4. Netlify → Environment variables:
   - `VITE_SUPABASE_URL`: your Supabase Project URL
   - `VITE_SUPABASE_ANON_KEY`: your publishable (`sb_publishable_...`) key
   NEVER expose a service_role or secret key.
5. Deploy GitHub branch `main`, build command `npm run build`, publish directory `dist`.
6. Test from 2 separate browsers or private windows. One room = 2 distinct anonymous Supabase sessions.

## Local
```bash
npm install
cp .env.example .env  # on Windows: copy .env.example .env
npm run dev
```

## Verification & caveats
- Source package prepared; live Supabase/Netlify integration is NOT tested by the generator.
- Product images are generated photorealistic product illustrations, not actual brand catalog photography.
- The 120 puzzles reuse the 36 product assets in different combinations. Puzzle content deliberately uses category distinctions; some levels are easier than others.
- The API keeps right answers server-side, but there is no captcha, rate-limiting, competitive anti-collusion or public matchmaking. Anonymous sign-ins can be abused on an unprotected public launch. Consider Supabase CAPTCHA / rate limits.
- Match time is 5 minutes after a 3 second countdown. Realtime subscriptions poll every 2 seconds as fallback.
- This schema assumes existing V3 `duel_odd_attempts` constraint names from the provided V3 SQL.
