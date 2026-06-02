-- ─── ALLOW COACHES TO APPROVE / REJECT BOOKINGS ─────────────────────────────
create policy "Coaches can update their bookings"
  on public.bookings for update using (
    exists (
      select 1 from public.coaches
      where id = bookings.coach_id
      and profile_id = auth.uid()
    )
  );

-- ─── ALLOW AUTHENTICATED USERS TO INSERT NOTIFICATIONS (for trigger) ─────────
-- The trigger below runs as SECURITY DEFINER so it can bypass RLS, but
-- we also allow direct insert for testing / edge-function parity.
create policy "Auth users can insert notifications for themselves"
  on public.notifications for insert with check (auth.uid() = user_id);

-- ─── TRIGGER: auto-notify coach on new booking ───────────────────────────────
create or replace function public.notify_on_booking_change()
returns trigger language plpgsql security definer as $$
declare
  v_coach_profile_id uuid;
  v_customer_name    text;
  v_slot_start       timestamptz;
  v_service_title    text;
begin
  -- Resolve coach's profile_id
  select profile_id into v_coach_profile_id
    from public.coaches where id = new.coach_id;

  -- Customer name
  select full_name into v_customer_name
    from public.profiles where id = new.customer_id;

  -- Slot start time
  select starts_at into v_slot_start
    from public.time_slots where id = new.slot_id;

  -- Service title
  select title into v_service_title
    from public.services where id = new.service_id;

  -- ── New booking created ──────────────────────────────────────────────────
  if tg_op = 'INSERT' then
    -- Notify coach
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

  -- ── Booking confirmed → notify customer ─────────────────────────────────
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

  -- ── Booking cancelled → notify the other party ──────────────────────────
  if tg_op = 'UPDATE' and old.status != 'cancelled' and new.status = 'cancelled' then
    -- Notify customer (if coach cancelled)
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
    -- Notify coach (if customer cancelled)
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
