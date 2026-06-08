-- Merge duplicate active slots (same coach + service + start), then block new duplicates.

with ranked as (
  select
    id,
    first_value(id) over (
      partition by coach_id, service_id, starts_at
      order by booked_count desc, created_at asc
    ) as keeper_id,
    row_number() over (
      partition by coach_id, service_id, starts_at
      order by booked_count desc, created_at asc
    ) as rn
  from public.time_slots
  where not is_cancelled
    and service_id is not null
)
update public.bookings b
set slot_id = r.keeper_id
from ranked r
where b.slot_id = r.id
  and r.rn > 1;

with ranked as (
  select
    id,
    row_number() over (
      partition by coach_id, service_id, starts_at
      order by booked_count desc, created_at asc
    ) as rn
  from public.time_slots
  where not is_cancelled
    and service_id is not null
)
update public.time_slots ts
set is_cancelled = true
from ranked r
where ts.id = r.id
  and r.rn > 1;

update public.time_slots ts
set booked_count = coalesce((
  select count(*)::integer
  from public.bookings b
  where b.slot_id = ts.id
    and b.status in ('pending', 'confirmed')
), 0)
where not ts.is_cancelled;

create unique index if not exists time_slots_coach_service_start_unique
  on public.time_slots (coach_id, service_id, starts_at)
  where (not is_cancelled and service_id is not null);
