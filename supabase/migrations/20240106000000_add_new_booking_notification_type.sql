-- Live databases may have notifications.type backed by notification_type enum.
-- The booking trigger inserts 'new_booking', so make that enum value valid.
do $$
begin
  if to_regtype('public.notification_type') is not null then
    execute 'alter type public.notification_type add value if not exists ''new_booking''';
  end if;
end $$;
