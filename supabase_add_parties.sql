-- Run this once in Supabase SQL Editor to add Parties (for adding saved parties to initiative).
-- Parties have members with name, init bonus (Dex mod), and AC only (no HP tracking).

CREATE TABLE IF NOT EXISTS public.parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.party_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  party_id uuid NOT NULL REFERENCES public.parties(id) ON DELETE CASCADE,
  name text NOT NULL,
  init_bonus int DEFAULT 0,
  ac int,
  order_index int NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_party_members_party_id ON public.party_members(party_id);

-- If party_members already existed with different columns, add any missing ones:
ALTER TABLE public.party_members ADD COLUMN IF NOT EXISTS name text DEFAULT '';
ALTER TABLE public.party_members ADD COLUMN IF NOT EXISTS init_bonus int DEFAULT 0;
ALTER TABLE public.party_members ADD COLUMN IF NOT EXISTS ac int;
ALTER TABLE public.party_members ADD COLUMN IF NOT EXISTS order_index int NOT NULL DEFAULT 0;

-- Allow anon to read/write (same as encounters; tighten with RLS if you add auth)
ALTER TABLE public.parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.party_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all for parties" ON public.parties;
CREATE POLICY "Allow all for parties" ON public.parties FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all for party_members" ON public.party_members;
CREATE POLICY "Allow all for party_members" ON public.party_members FOR ALL USING (true) WITH CHECK (true);
