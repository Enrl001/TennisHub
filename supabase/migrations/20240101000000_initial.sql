-- Tennis Hub — Initial Schema Migration
-- Run: supabase db push

-- ─── EXTENSIONS ─────────────────────────────────────────────────────────────
-- gen_random_uuid() comes from pgcrypto (Supabase ships this; uuid-ossp is optional).
create extension if not exists "pgcrypto";

-- ─── PROFILES ────────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  role          text not null check (role in ('coach', 'customer')) default 'customer',
  full_name     text,
  avatar_url    text,
  phone         text,
  locale        text default 'mn',
  fcm_token     text,
  created_at    timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "Users can view their own profile"
  on public.profiles for select using (auth.uid() = id);
create policy "Users can update their own profile"
  on public.profiles for update using (auth.uid() = id);
create policy "Users can insert their own profile"
  on public.profiles for insert with check (auth.uid() = id);
-- Coaches visible to all authenticated users
create policy "Authenticated users can view all profiles"
  on public.profiles for select using (auth.role() = 'authenticated');

-- ─── COACHES ─────────────────────────────────────────────────────────────────
create table if not exists public.coaches (
  id                uuid primary key default gen_random_uuid(),
  profile_id        uuid not null references public.profiles(id) on delete cascade,
  bio               text,
  bio_mn            text,
  certifications    text[] default '{}',
  years_experience  integer default 0,
  location          text,
  avg_rating        numeric(3,2) default 0,
  total_reviews     integer default 0,
  is_active         boolean default true,
  created_at        timestamptz default now()
);
alter table public.coaches enable row level security;
create policy "Coaches are viewable by everyone"
  on public.coaches for select using (true);
create policy "Coaches can manage their own record"
  on public.coaches for all using (
    auth.uid() = profile_id
  );

-- ─── SERVICES ────────────────────────────────────────────────────────────────
create table if not exists public.services (
  id               uuid primary key default gen_random_uuid(),
  coach_id         uuid not null references public.coaches(id) on delete cascade,
  type             text not null check (type in ('private_lesson','group_lesson','community_event','virtual_session')),
  title            text not null,
  title_mn         text,
  description      text,
  description_mn   text,
  duration_minutes integer default 60,
  price_amount     numeric(10,2) default 0,
  currency         text default 'USD',
  max_participants integer default 1,
  video_platform   text,
  video_url        text,
  is_active        boolean default true,
  created_at       timestamptz default now()
);
alter table public.services enable row level security;
create policy "Services are viewable by everyone"
  on public.services for select using (true);
create policy "Coaches manage their own services"
  on public.services for all using (
    exists (
      select 1 from public.coaches
      where id = services.coach_id
      and profile_id = auth.uid()
    )
  );

-- ─── TIME SLOTS ──────────────────────────────────────────────────────────────
create table if not exists public.time_slots (
  id            uuid primary key default gen_random_uuid(),
  service_id    uuid references public.services(id) on delete set null,
  coach_id      uuid not null references public.coaches(id) on delete cascade,
  starts_at     timestamptz not null,
  ends_at       timestamptz not null,
  booked_count  integer default 0,
  is_cancelled  boolean default false,
  created_at    timestamptz default now()
);
alter table public.time_slots enable row level security;
create policy "Time slots are viewable by everyone"
  on public.time_slots for select using (true);
create policy "Coaches manage their own time slots"
  on public.time_slots for all using (
    exists (
      select 1 from public.coaches
      where id = time_slots.coach_id
      and profile_id = auth.uid()
    )
  );

-- ─── BOOKINGS ────────────────────────────────────────────────────────────────
create table if not exists public.bookings (
  id             uuid primary key default gen_random_uuid(),
  slot_id        uuid references public.time_slots(id) on delete set null,
  service_id     uuid references public.services(id) on delete set null,
  coach_id       uuid not null references public.coaches(id) on delete cascade,
  customer_id    uuid not null references public.profiles(id) on delete cascade,
  status         text not null check (status in ('pending','confirmed','cancelled','completed')) default 'pending',
  amount_paid    numeric(10,2),
  currency       text default 'USD',
  video_room_id  text,
  video_room_url text,
  created_at     timestamptz default now()
);
alter table public.bookings enable row level security;
create policy "Customers see their own bookings"
  on public.bookings for select using (auth.uid() = customer_id);
create policy "Coaches see bookings for their sessions"
  on public.bookings for select using (
    exists (
      select 1 from public.coaches
      where id = bookings.coach_id
      and profile_id = auth.uid()
    )
  );
create policy "Customers can create bookings"
  on public.bookings for insert with check (auth.uid() = customer_id);
create policy "Customers can cancel their bookings"
  on public.bookings for update using (auth.uid() = customer_id);
-- Service role (edge functions) can update any booking
create policy "Service role full access to bookings"
  on public.bookings for all using (auth.role() = 'service_role');

-- ─── PAYMENTS ────────────────────────────────────────────────────────────────
create table if not exists public.payments (
  id                  uuid primary key default gen_random_uuid(),
  booking_id          uuid not null references public.bookings(id) on delete cascade,
  customer_id         uuid not null references public.profiles(id) on delete cascade,
  coach_id            uuid not null references public.coaches(id) on delete cascade,
  status              text not null check (status in ('pending','paid','refunded','failed')) default 'pending',
  amount              numeric(10,2) not null,
  currency            text default 'USD',
  provider_payment_id text,
  created_at          timestamptz default now()
);
alter table public.payments enable row level security;
create policy "Users see their own payments"
  on public.payments for select using (
    auth.uid() = customer_id
    or exists (select 1 from public.coaches where id = payments.coach_id and profile_id = auth.uid())
  );
create policy "Service role full access to payments"
  on public.payments for all using (auth.role() = 'service_role');
create policy "Customers can insert payments"
  on public.payments for insert with check (auth.uid() = customer_id);

-- ─── NOTIFICATIONS ───────────────────────────────────────────────────────────
create table if not exists public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  type       text,
  title      text,
  title_mn   text,
  body       text,
  body_mn    text,
  data       jsonb default '{}',
  is_read    boolean default false,
  created_at timestamptz default now()
);
alter table public.notifications enable row level security;
create policy "Users see their own notifications"
  on public.notifications for select using (auth.uid() = user_id);
create policy "Users can update their own notifications"
  on public.notifications for update using (auth.uid() = user_id);
create policy "Service role can insert notifications"
  on public.notifications for insert with check (auth.role() = 'service_role');

-- ─── REVIEWS ─────────────────────────────────────────────────────────────────
create table if not exists public.reviews (
  id          uuid primary key default gen_random_uuid(),
  booking_id  uuid not null references public.bookings(id) on delete cascade,
  coach_id    uuid not null references public.coaches(id) on delete cascade,
  customer_id uuid not null references public.profiles(id) on delete cascade,
  rating      integer not null check (rating between 1 and 5),
  comment     text,
  created_at  timestamptz default now()
);
alter table public.reviews enable row level security;
create policy "Reviews are viewable by everyone"
  on public.reviews for select using (true);
create policy "Customers can create reviews for completed bookings"
  on public.reviews for insert with check (
    auth.uid() = customer_id
    and exists (
      select 1 from public.bookings
      where id = reviews.booking_id
      and customer_id = auth.uid()
      and status = 'completed'
    )
  );

-- ─── TRIGGER: update booked_count on booking ─────────────────────────────────
create or replace function public.update_slot_booked_count()
returns trigger language plpgsql as $$
begin
  if new.status in ('confirmed', 'pending') and (tg_op = 'INSERT' or old.status not in ('confirmed', 'pending')) then
    update public.time_slots
    set booked_count = booked_count + 1
    where id = new.slot_id;
  end if;
  if tg_op = 'UPDATE' and old.status in ('confirmed', 'pending') and new.status in ('cancelled', 'completed') then
    update public.time_slots
    set booked_count = greatest(0, booked_count - 1)
    where id = new.slot_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_update_slot_count on public.bookings;
create trigger trg_update_slot_count
  after insert or update on public.bookings
  for each row execute function public.update_slot_booked_count();

-- ─── TRIGGER: update avg_rating on review ────────────────────────────────────
create or replace function public.update_coach_avg_rating()
returns trigger language plpgsql as $$
begin
  update public.coaches
  set
    avg_rating = (select avg(rating)::numeric(3,2) from public.reviews where coach_id = new.coach_id),
    total_reviews = (select count(*) from public.reviews where coach_id = new.coach_id)
  where id = new.coach_id;
  return new;
end;
$$;

drop trigger if exists trg_update_coach_rating on public.reviews;
create trigger trg_update_coach_rating
  after insert on public.reviews
  for each row execute function public.update_coach_avg_rating();

-- ─── TRIGGER: auto-create profile on signup ──────────────────────────────────
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, role)
  values (new.id, 'customer')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists trg_on_auth_user_created on auth.users;
create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── REALTIME ────────────────────────────────────────────────────────────────
alter publication supabase_realtime add table public.notifications;
alter publication supabase_realtime add table public.bookings;
