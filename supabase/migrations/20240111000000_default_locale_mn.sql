-- Default app language: Mongolian
alter table public.profiles
  alter column locale set default 'mn';
