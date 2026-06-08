-- Customers create bookings, but update_slot_booked_count() updates time_slots.
-- Without SECURITY DEFINER the trigger runs as the customer and RLS blocks the update.

create or replace function public.update_slot_booked_count()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_max_participants integer;
  v_booked_count integer;
  v_old_active boolean;
  v_new_active boolean;
begin
  v_old_active := tg_op = 'UPDATE' and old.status in ('confirmed', 'pending');
  v_new_active := new.status in ('confirmed', 'pending');

  if tg_op = 'UPDATE' and v_old_active and (not v_new_active or old.slot_id is distinct from new.slot_id) then
    update public.time_slots
    set booked_count = greatest(0, booked_count - 1)
    where id = old.slot_id;
  end if;

  if v_new_active and (tg_op = 'INSERT' or not v_old_active or old.slot_id is distinct from new.slot_id) then
    select coalesce(s.max_participants, 1), coalesce(ts.booked_count, 0)
      into v_max_participants, v_booked_count
    from public.time_slots ts
    left join public.services s on s.id = coalesce(new.service_id, ts.service_id)
    where ts.id = new.slot_id
      and ts.is_cancelled = false
    for update;

    if not found then
      raise exception 'Time slot not found'
        using errcode = 'P0001';
    end if;

    if v_booked_count >= coalesce(v_max_participants, 1) then
      raise exception 'Not enough available places for this time slot'
        using errcode = 'P0001';
    end if;

    update public.time_slots
    set booked_count = booked_count + 1
    where id = new.slot_id;
  end if;

  return new;
end;
$$;

-- Notification trigger: explicit search_path for security definer hygiene
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
        'Дасгалжуулагчийн захиалга цуцлагдлаа.',
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
