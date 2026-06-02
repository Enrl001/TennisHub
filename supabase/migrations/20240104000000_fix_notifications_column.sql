-- Add missing created_at column to notifications table
-- (table was created before this column was added to the schema)
alter table public.notifications
  add column if not exists created_at timestamptz default now();
