-- Keep live databases compatible with app queries that sort services by creation time.
alter table public.services
  add column if not exists created_at timestamptz default now();
