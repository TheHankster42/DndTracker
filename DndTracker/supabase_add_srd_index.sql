-- Run this once in Supabase SQL Editor to support SRD stat blocks when loading saved encounters.
ALTER TABLE public.encounter_combatants
  ADD COLUMN IF NOT EXISTS srd_index text;
