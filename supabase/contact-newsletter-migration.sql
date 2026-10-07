-- Ejecuta este archivo en Supabase SQL Editor.
-- Crea las bandejas que usa el formulario de contacto y el newsletter.

create extension if not exists pgcrypto;

create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  subject text,
  message text not null,
  status text not null default 'new' check (status in ('new','read','replied','archived')),
  created_at timestamptz not null default now()
);

create table if not exists public.newsletter_subscribers (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  source text default 'footer',
  status text not null default 'active' check (status in ('active','unsubscribed')),
  created_at timestamptz not null default now()
);

alter table public.contact_messages enable row level security;
alter table public.newsletter_subscribers enable row level security;

drop policy if exists "contact public insert" on public.contact_messages;
create policy "contact public insert" on public.contact_messages
  for insert to anon, authenticated with check (true);

drop policy if exists "contact admin read" on public.contact_messages;
create policy "contact admin read" on public.contact_messages
  for select to authenticated using (public.is_admin());

drop policy if exists "contact admin update" on public.contact_messages;
create policy "contact admin update" on public.contact_messages
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "newsletter public insert" on public.newsletter_subscribers;
create policy "newsletter public insert" on public.newsletter_subscribers
  for insert to anon, authenticated with check (true);

drop policy if exists "newsletter admin read" on public.newsletter_subscribers;
create policy "newsletter admin read" on public.newsletter_subscribers
  for select to authenticated using (public.is_admin());

drop policy if exists "newsletter admin update" on public.newsletter_subscribers;
create policy "newsletter admin update" on public.newsletter_subscribers
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

grant insert on table public.contact_messages to anon, authenticated;
grant select, update on table public.contact_messages to authenticated;
grant insert on table public.newsletter_subscribers to anon, authenticated;
grant select, update on table public.newsletter_subscribers to authenticated;
