-- Approval of a pending booking must not consume another place.
-- Pending and confirmed bookings are both active holds on a slot.

do $$
declare
  r record;
begin
  for r in
    select t.tgname
    from pg_trigger t
    join pg_class c on c.oid = t.tgrelid
    join pg_namespace n on n.oid = c.relnamespace
    join pg_proc p on p.oid = t.tgfoid
    where n.nspname = 'public'
      and c.relname = 'bookings'
      and not t.tgisinternal
      and (
        pg_get_functiondef(p.oid) like '%Not enough available places%'
        or pg_get_functiondef(p.oid) like '%Time slot not found%'
      )
  loop
    execute format('drop trigger if exists %I on public.bookings', r.tgname);
  end loop;
end $$;

create or replace function public.update_slot_booked_count()
returns trigger language plpgsql as $$
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

drop trigger if exists trg_update_slot_count on public.bookings;
create trigger trg_update_slot_count
  after insert or update on public.bookings
  for each row execute function public.update_slot_booked_count();
