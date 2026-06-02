-- MyClub / Tennis Hub — full schema for a fresh Supabase project
-- Run in: Supabase Dashboard → SQL Editor → New query → paste → Run
--
-- Requires Supabase Auth (auth.users). Profiles link to auth.users(id).
-- Alternative: from project root run `supabase db push`

-- ─── EXTENSIONS ─────────────────────────────────────────────────────────────
-- gen_random_uuid() comes from pgcrypto (Supabase default; no uuid-ossp required).
create extension if not exists "pgcrypto";

-- ─── PROFILES ────────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  role          text not null check (role in ('coach', 'customer')) default 'customer',
  full_name     text,
  avatar_url    text,
  phone         text,
  locale        text default 'en',
  fcm_token     text,
  created_at    timestamptz default now()
);
alter table public.profiles enable row level security;
drop policy if exists "Users can view their own profile" on public.profiles;
create policy "Users can view their own profile"
  on public.profiles for select using (auth.uid() = id);
drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
  on public.profiles for update using (auth.uid() = id);
drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile"
  on public.profiles for insert with check (auth.uid() = id);
drop policy if exists "Authenticated users can view all profiles" on public.profiles;
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
drop policy if exists "Coaches are viewable by everyone" on public.coaches;
create policy "Coaches are viewable by everyone"
  on public.coaches for select using (true);
drop policy if exists "Coaches can manage their own record" on public.coaches;
create policy "Coaches can manage their own record"
  on public.coaches for all using (auth.uid() = profile_id);

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
drop policy if exists "Services are viewable by everyone" on public.services;
create policy "Services are viewable by everyone"
  on public.services for select using (true);
drop policy if exists "Coaches manage their own services" on public.services;
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
drop policy if exists "Time slots are viewable by everyone" on public.time_slots;
create policy "Time slots are viewable by everyone"
  on public.time_slots for select using (true);
drop policy if exists "Coaches manage their own time slots" on public.time_slots;
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
drop policy if exists "Customers see their own bookings" on public.bookings;
create policy "Customers see their own bookings"
  on public.bookings for select using (auth.uid() = customer_id);
drop policy if exists "Coaches see bookings for their sessions" on public.bookings;
create policy "Coaches see bookings for their sessions"
  on public.bookings for select using (
    exists (
      select 1 from public.coaches
      where id = bookings.coach_id
      and profile_id = auth.uid()
    )
  );
drop policy if exists "Customers can create bookings" on public.bookings;
create policy "Customers can create bookings"
  on public.bookings for insert with check (auth.uid() = customer_id);
drop policy if exists "Customers can cancel their bookings" on public.bookings;
create policy "Customers can cancel their bookings"
  on public.bookings for update using (auth.uid() = customer_id);
drop policy if exists "Coaches can update their bookings" on public.bookings;
create policy "Coaches can update their bookings"
  on public.bookings for update using (
    exists (
      select 1 from public.coaches
      where id = bookings.coach_id
      and profile_id = auth.uid()
    )
  );
drop policy if exists "Service role full access to bookings" on public.bookings;
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
drop policy if exists "Users see their own payments" on public.payments;
create policy "Users see their own payments"
  on public.payments for select using (
    auth.uid() = customer_id
    or exists (select 1 from public.coaches where id = payments.coach_id and profile_id = auth.uid())
  );
drop policy if exists "Service role full access to payments" on public.payments;
create policy "Service role full access to payments"
  on public.payments for all using (auth.role() = 'service_role');
drop policy if exists "Customers can insert payments" on public.payments;
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
drop policy if exists "Users see their own notifications" on public.notifications;
create policy "Users see their own notifications"
  on public.notifications for select using (auth.uid() = user_id);
drop policy if exists "Users can update their own notifications" on public.notifications;
create policy "Users can update their own notifications"
  on public.notifications for update using (auth.uid() = user_id);
drop policy if exists "Service role can insert notifications" on public.notifications;
create policy "Service role can insert notifications"
  on public.notifications for insert with check (auth.role() = 'service_role');
drop policy if exists "Auth users can insert notifications for themselves" on public.notifications;
create policy "Auth users can insert notifications for themselves"
  on public.notifications for insert with check (auth.uid() = user_id);

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
drop policy if exists "Reviews are viewable by everyone" on public.reviews;
create policy "Reviews are viewable by everyone"
  on public.reviews for select using (true);
drop policy if exists "Customers can create reviews for completed bookings" on public.reviews;
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

-- ─── TRIGGER: slot booked_count (updates only; inserts use RPC) ──────────────
create or replace function public.update_slot_booked_count()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_old_active boolean;
  v_new_active boolean;
begin
  if tg_op <> 'UPDATE' then
    return new;
  end if;

  v_old_active := old.status in ('confirmed', 'pending');
  v_new_active := new.status in ('confirmed', 'pending');

  if v_old_active and (not v_new_active or old.slot_id is distinct from new.slot_id) then
    update public.time_slots
    set booked_count = greatest(0, booked_count - 1)
    where id = old.slot_id;
  end if;

  if v_new_active and (not v_old_active or old.slot_id is distinct from new.slot_id) then
    update public.time_slots
    set booked_count = booked_count + 1
    where id = new.slot_id;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_update_slot_count on public.bookings;
create trigger trg_update_slot_count
  after update on public.bookings
  for each row execute function public.update_slot_booked_count();

-- ─── TRIGGER: coach avg rating ───────────────────────────────────────────────
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

-- ─── TRIGGER: profile on auth signup ─────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
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

-- ─── TRIGGER: booking notifications ──────────────────────────────────────────
create or replace function public.notify_on_booking_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_coach_profile_id uuid;
  v_customer_name    text;
  v_slot_start       timestamptz;
  v_service_title    text;
begin
  select profile_id into v_coach_profile_id
    from public.coaches where id = new.coach_id;

  select full_name into v_customer_name
    from public.profiles where id = new.customer_id;

  select starts_at into v_slot_start
    from public.time_slots where id = new.slot_id;

  select title into v_service_title
    from public.services where id = new.service_id;

  if tg_op = 'INSERT' then
    if v_coach_profile_id is not null then
      insert into public.notifications
        (user_id, type, title, title_mn, body, body_mn, data)
      values (
        v_coach_profile_id,
        'new_booking',
        'New Booking Request',
        'Шинэ захиалга',
        coalesce(v_customer_name, 'A customer') || ' booked ' || coalesce(v_service_title, 'a session'),
        coalesce(v_customer_name, 'Хэрэглэгч') || ' захиалга хийлээ: ' || coalesce(v_service_title, ''),
        jsonb_build_object(
          'booking_id', new.id,
          'customer_id', new.customer_id,
          'slot_start', v_slot_start
        )
      );
    end if;
  end if;

  if tg_op = 'UPDATE' and old.status != 'confirmed' and new.status = 'confirmed' then
    insert into public.notifications
      (user_id, type, title, title_mn, body, body_mn, data)
    values (
      new.customer_id,
      'booking_confirmed',
      'Booking Confirmed!',
      'Захиалга баталгаажлаа!',
      'Your ' || coalesce(v_service_title, 'session') || ' has been confirmed.',
      coalesce(v_service_title, 'Сессийн') || ' захиалга баталгаажлаа.',
      jsonb_build_object('booking_id', new.id)
    );
  end if;

  if tg_op = 'UPDATE' and old.status != 'cancelled' and new.status = 'cancelled' then
    if auth.uid() = v_coach_profile_id then
      insert into public.notifications
        (user_id, type, title, title_mn, body, body_mn, data)
      values (
        new.customer_id,
        'booking_cancelled',
        'Booking Cancelled',
        'Захиалга цуцлагдлаа',
        'Your ' || coalesce(v_service_title, 'session') || ' was cancelled by the coach.',
        'Тренерийн тийн захиалга цуцлагдлаа.',
        jsonb_build_object('booking_id', new.id)
      );
    end if;
    if auth.uid() = new.customer_id and v_coach_profile_id is not null then
      insert into public.notifications
        (user_id, type, title, title_mn, body, body_mn, data)
      values (
        v_coach_profile_id,
        'booking_cancelled',
        'Booking Cancelled',
        'Захиалга цуцлагдлаа',
        coalesce(v_customer_name, 'A customer') || ' cancelled their booking.',
        coalesce(v_customer_name, 'Хэрэглэгч') || ' захиалгаа цуцаллаа.',
        jsonb_build_object('booking_id', new.id)
      );
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_notify_on_booking on public.bookings;
create trigger trg_notify_on_booking
  after insert or update on public.bookings
  for each row execute function public.notify_on_booking_change();

-- ─── RPC: create profile ─────────────────────────────────────────────────────
drop function if exists public.create_profile(uuid, text);
drop function if exists public.create_profile(uuid, text, text);

create or replace function public.create_profile(
  p_user_id uuid,
  p_user_role text,
  p_full_name text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, role, full_name)
  values (p_user_id, p_user_role, p_full_name)
  on conflict (id) do update
    set full_name = coalesce(excluded.full_name, public.profiles.full_name);
end;
$$;

grant execute on function public.create_profile(uuid, text, text) to anon, authenticated;

-- ─── RPC: customer booking (used by the Flutter app) ─────────────────────────
create or replace function public.create_customer_booking(
  p_slot_id uuid,
  p_service_id uuid,
  p_coach_id uuid,
  p_amount numeric default 0,
  p_currency text default 'MNT'
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer_id uuid := auth.uid();
  v_booking_id uuid;
  v_status text;
  v_service_type text;
  v_max integer;
  v_booked integer;
  v_slot_coach_id uuid;
  v_coach_profile_id uuid;
  v_customer_name text;
  v_service_title text;
  v_slot_start timestamptz;
begin
  if v_customer_id is null then
    raise exception 'Not authenticated' using errcode = 'P0001';
  end if;

  insert into public.profiles (id, role)
  values (v_customer_id, 'customer')
  on conflict (id) do nothing;

  select
    coalesce(s.max_participants, 1),
    coalesce(ts.booked_count, 0),
    s.type,
    ts.coach_id,
    s.title,
    ts.starts_at
  into
    v_max,
    v_booked,
    v_service_type,
    v_slot_coach_id,
    v_service_title,
    v_slot_start
  from public.time_slots ts
  inner join public.services s on s.id = p_service_id
  where ts.id = p_slot_id
    and not ts.is_cancelled
  for update of ts;

  if not found then
    raise exception 'Time slot not found' using errcode = 'P0001';
  end if;

  if v_slot_coach_id is distinct from p_coach_id then
    raise exception 'Coach does not match this time slot' using errcode = 'P0001';
  end if;

  if v_booked >= v_max then
    raise exception 'Not enough available places for this time slot' using errcode = 'P0001';
  end if;

  v_status := case when v_service_type = 'group_lesson' then 'confirmed' else 'pending' end;

  insert into public.bookings (
    slot_id,
    service_id,
    coach_id,
    customer_id,
    status,
    amount_paid,
    currency
  )
  values (
    p_slot_id,
    p_service_id,
    p_coach_id,
    v_customer_id,
    v_status,
    p_amount,
    coalesce(p_currency, 'MNT')
  )
  returning id into v_booking_id;

  update public.time_slots
  set booked_count = booked_count + 1
  where id = p_slot_id;

  begin
    select profile_id into v_coach_profile_id
      from public.coaches where id = p_coach_id;

    select full_name into v_customer_name
      from public.profiles where id = v_customer_id;

    if v_coach_profile_id is not null then
      insert into public.notifications (
        user_id, type, title, title_mn, body, body_mn, data
      )
      values (
        v_coach_profile_id,
        'new_booking',
        'New Booking Request',
        'Шинэ захиалга',
        coalesce(v_customer_name, 'A customer') || ' booked ' || coalesce(v_service_title, 'a session'),
        coalesce(v_customer_name, 'Хэрэглэгч') || ' захиалга хийлээ: ' || coalesce(v_service_title, ''),
        jsonb_build_object(
          'booking_id', v_booking_id,
          'customer_id', v_customer_id,
          'slot_start', v_slot_start
        )
      );
    end if;
  exception
    when others then
      raise warning 'create_customer_booking notification skipped: %', sqlerrm;
  end;

  return v_booking_id;
end;
$$;

grant execute on function public.create_customer_booking(uuid, uuid, uuid, numeric, text)
  to authenticated;

-- ─── REALTIME (optional) ─────────────────────────────────────────────────────
do $$
begin
  alter publication supabase_realtime add table public.notifications;
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.bookings;
exception when duplicate_object then null;
end $$;
