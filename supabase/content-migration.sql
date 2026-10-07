-- Ejecuta este bloque si ya habías ejecutado el schema.sql anterior.
create table if not exists public.site_content (
  id integer primary key check (id = 1),
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.site_content enable row level security;

drop policy if exists "site content public read" on public.site_content;
create policy "site content public read" on public.site_content for select to anon, authenticated using (true);

drop policy if exists "site content admin insert" on public.site_content;
create policy "site content admin insert" on public.site_content for insert to authenticated with check (public.is_admin());

drop policy if exists "site content admin update" on public.site_content;
create policy "site content admin update" on public.site_content for update to authenticated using (public.is_admin()) with check (public.is_admin());

insert into public.site_content (id, content)
values (1, '{}'::jsonb)
on conflict (id) do nothing;
