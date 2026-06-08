-- Session location & equipment on services; relaxed review rules after session ends.

alter table public.services
  add column if not exists location text,
  add column if not exists location_mn text,
  add column if not exists required_equipment text,
  add column if not exists required_equipment_mn text;

create unique index if not exists reviews_one_per_booking
  on public.reviews (booking_id);

drop policy if exists "Customers can create reviews for completed bookings" on public.reviews;
create policy "Customers can create reviews after session"
  on public.reviews for insert with check (
    auth.uid() = customer_id
    and exists (
      select 1
      from public.bookings b
      join public.time_slots ts on ts.id = b.slot_id
      where b.id = reviews.booking_id
        and b.customer_id = auth.uid()
        and b.status in ('confirmed', 'completed')
        and ts.ends_at <= now()
    )
  );
