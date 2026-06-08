-- Bookings are confirmed by payment (or immediately when free), not by coach approval.

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
    ts.coach_id,
    s.title,
    ts.starts_at
  into
    v_max,
    v_booked,
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

  -- Free = confirmed now; paid = pending until Smartpay webhook sets confirmed.
  v_status := case when coalesce(p_amount, 0) <= 0 then 'confirmed' else 'pending' end;

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
        'New Booking',
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
