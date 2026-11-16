# Spot Duel V5 — فين كاينة المختلفة؟

## Changes compared with V4
- Darija in Arabic script throughout the game UI, including messages, game instructions and reveal explanations.
- All four pictures in every round come from the SAME product family; no obvious soda mixed with chocolate or other trivial category questions.
- 53 hand-rule-validated question combinations using 36 existing local images. Image combinations may still reuse the same product photographs between rounds.
- One independently submitted answer per player per round. Correct = 1 point, no speed bonus.
- Backend still validates answers in Supabase RPC. Correct choice is withheld until answer submission.

## Update an existing V4 deployment
1. Finish active games first and back up the database.
2. Supabase SQL Editor: run `supabase/upgrade-v5.sql` once **after** `upgrade-v4.sql`.
3. Replace previous frontend files with this V5 source and push to GitHub main.
4. Confirm Netlify environment variables (`VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`) and check successful deployment.
5. Test with two distinct browser sessions. Live integration not tested in this environment.

**Note:** This pack reuses the generated product imagery of V4. The bank is curated by verifiable visual traits, not a new set of 60 unique photographs. Product imagery is AI-generated, not licensed product catalog photography.
