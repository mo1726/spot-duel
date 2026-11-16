# Spot Duel V3 — مين المختلفة؟

Two-player private room game: find the one different item among four nearly matching illustrated foods.

## Features
- Netlify-hosted Vite/React frontend
- Supabase anonymous authentication and Realtime + polling
- 10 rounds; one choice per player per round
- Both players answer independently; no speed bonus; one point for each correct answer
- 120-second overall timer; highest score wins; draws allowed

## Upgrade from V2
1. Open Supabase SQL Editor in the EXISTING project.
2. Execute `supabase/upgrade-v3.sql` **once**, after V1 and V2 migrations.
3. Create new rooms for V3; don't reuse V1/V2 rooms.
4. Netlify environment variables: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` (publishable key).
5. Git push to your connected Netlify GitHub repo. Build: `npm run build`; publish: `dist`.

## Local dev
```
npm install
cp .env.example .env
npm run dev
```

## Note on fairness
The SQL function checks the logged-in player's membership, ordering and score, and never offers direct read of the answer table. The illustrations and their variant parameters are shipped in browser JavaScript, so a technically experienced player could inspect client code to infer the answers. For public competitive release, render the puzzle variants from non-answer-revealing assets and randomize puzzles server-side. This MVP is intended for friendly matches.
