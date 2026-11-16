# Spot Duel — online 1v1 Spot the Difference

A working MVP source project for **Netlify + Supabase**, no VPS and no persistent Node server required.

## Features

* Two-player private rooms with a 6-character invitation code/link
* Anonymous login (no email needed)
* Ready-up phase with 3-second countdown
* Both players click the same two puzzle images
* Five private answer coordinates checked in PostgreSQL
* First player to claim a difference earns 20 points
* 90-second timed match, winner/draw screen
* Supabase realtime room updates plus 2-second polling fallback
* Responsive desktop / mobile UI

## 1\. Create Supabase backend

1. Go to https://supabase.com and create a project.
2. Open **Authentication → Providers → Anonymous Sign-Ins** and enable it.
3. Open **SQL Editor**, paste the entire `supabase/schema.sql` file, and run it.
4. In **Project Settings → API** (or the current project's API Keys screen), get the Project URL and a **publishable/anon** key. **Never use a service\_role / secret key in Vite.**

## 2\. Run locally

Requirements: Node.js 20.19+ recommended.

```bash
npm install
cp .env.example .env
```

On Windows PowerShell instead of `cp` use `Copy-Item .env.example .env`.
Edit `.env`:

```dotenv
VITE\_SUPABASE\_URL=https://your-project.supabase.co
VITE\_SUPABASE\_ANON\_KEY=your-publishable-key
```

```bash
npm run dev
```

Open the local URL. Open a second browser in private/incognito mode (separate Supabase anonymous session), then create a room and join using the code. Both players press Ready and find differences.

## 3\. Publish on Netlify

* Push this folder to a GitHub repo.
* Netlify → Add new project → Import existing project → Select repo.
* Build command: `npm run build`; publish directory: `dist`.
* Under environment variables, add `VITE\_SUPABASE\_URL` and `VITE\_SUPABASE\_ANON\_KEY` with the same **public** values as your `.env`.
* Deploy. The `netlify.toml` file supplies settings and SPA fallback.

## Gameplay / anti-cheat notes

* The differences are server-side in `duel\_answers` (RLS enabled, no SELECT grants).
* The `duel\_pick` RPC validates player membership, clock state, clicked point, and prevents already-claimed differences from scoring again, all in a row-locked transaction.
* The player receives verified scores and the **already found** locations only.
* A determined attacker can still inspect public SVG artwork, automate mouse events, or brute-force clicks. Add input rate limiting, CAPTCHA and abuse monitoring before a broad public launch. The current MVP is intended for small-scale friend matches.
* Anonymous sign-in persists locally in each browser. Clearing browser data resets identity; rooms are not resumable with a new anonymous identity.
* This is **one round / one puzzle** with five differences. Add rounds/puzzles and player moderation later.

## Troubleshooting

* Can't connect: verify the URL, publishable key, and that Anonymous Sign-Ins is enabled.
* SQL editor: run `schema.sql` on a new Supabase project; policies are not idempotent if re-run in full.
* Rooms not updating: check Supabase Realtime publication. The UI also polls every two seconds.
* Two players in one browser profile are the same anonymous account; use an incognito session or another device.
* After changing `VITE\_` variables on Netlify, trigger a new build.





dFzIsdtPFEs03r1F

