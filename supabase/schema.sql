-- Luvia Colombia · esquema para ejecutar en Supabase SQL Editor
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'customer' check (role in ('customer','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  category text not null,
  price integer not null check (price >= 0),
  old_price integer check (old_price is null or old_price >= 0),
  tag text,
  image text,
  gallery text[] not null default '{}',
  colors text[] not null default '{}',
  sizes text[] not null default '{}',
  stock integer not null default 0 check (stock >= 0),
  description text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique not null,
  customer_name text not null,
  email text not null,
  phone text not null,
  address text not null,
  city text not null,
  payment_method text not null default 'contraentrega',
  shipping_carrier text not null default 'Interrapidísimo',
  subtotal integer not null default 0,
  shipping integer not null default 0,
  total integer not null default 0,
  status text not null default 'new' check (status in ('new','confirmed','preparing','shipped','delivered','cancelled')),
  tracking_number text,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  price integer not null default 0,
  quantity integer not null default 1 check (quantity > 0),
  color text,
  size text,
  image text
);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

grant execute on function public.is_admin() to anon, authenticated;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name) values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "profiles own read" on public.profiles;
create policy "profiles own read" on public.profiles for select to authenticated using (id = auth.uid() or public.is_admin());
drop policy if exists "profiles own update" on public.profiles;
create policy "profiles own update" on public.profiles for update to authenticated using (id = auth.uid() or public.is_admin()) with check (id = auth.uid() or public.is_admin());

drop policy if exists "products public read active" on public.products;
create policy "products public read active" on public.products for select to anon, authenticated using (active = true or public.is_admin());

drop policy if exists "products admin insert" on public.products;
create policy "products admin insert" on public.products for insert to authenticated with check (public.is_admin());
drop policy if exists "products admin update" on public.products;
create policy "products admin update" on public.products for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "products admin delete" on public.products;
create policy "products admin delete" on public.products for delete to authenticated using (public.is_admin());

drop policy if exists "orders public insert" on public.orders;
create policy "orders public insert" on public.orders for insert to anon, authenticated with check (true);
drop policy if exists "orders admin read" on public.orders;
create policy "orders admin read" on public.orders for select to authenticated using (public.is_admin());
drop policy if exists "orders admin update" on public.orders;
create policy "orders admin update" on public.orders for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "order items public insert" on public.order_items;
create policy "order items public insert" on public.order_items for insert to anon, authenticated with check (true);
drop policy if exists "order items admin read" on public.order_items;
create policy "order items admin read" on public.order_items for select to authenticated using (public.is_admin());

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = true;

drop policy if exists "product image public read" on storage.objects;
create policy "product image public read" on storage.objects for select using (bucket_id = 'product-images');
drop policy if exists "product image admin upload" on storage.objects;
create policy "product image admin upload" on storage.objects for insert to authenticated with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "product image admin update" on storage.objects;
create policy "product image admin update" on storage.objects for update to authenticated using (bucket_id = 'product-images' and public.is_admin()) with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "product image admin delete" on storage.objects;
create policy "product image admin delete" on storage.objects for delete to authenticated using (bucket_id = 'product-images' and public.is_admin());

-- Después de crear tu cuenta en el panel, promuévela manualmente una sola vez:
-- update public.profiles set role = 'admin' where id = (select id from auth.users where email = 'tu-correo@ejemplo.com');
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

-- Permisos explícitos para que el checkout público pueda insertar pedidos.
grant insert on table public.orders to anon, authenticated;
grant insert on table public.order_items to anon, authenticated;

-- Compatibilidad para proyectos que ya tenían la tabla orders creada.
alter table public.orders add column if not exists payment_method text not null default 'contraentrega';
alter table public.orders add column if not exists shipping_carrier text not null default 'Interrapidísimo';

-- Bandejas públicas para contacto y newsletter.
create extension if not exists pgcrypto;
create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(), name text not null, email text not null,
  subject text, message text not null, status text not null default 'new' check (status in ('new','read','replied','archived')),
  created_at timestamptz not null default now()
);
create table if not exists public.newsletter_subscribers (
  id uuid primary key default gen_random_uuid(), email text not null unique, source text default 'footer',
  status text not null default 'active' check (status in ('active','unsubscribed')), created_at timestamptz not null default now()
);
alter table public.contact_messages enable row level security;
alter table public.newsletter_subscribers enable row level security;
drop policy if exists "contact public insert" on public.contact_messages;
create policy "contact public insert" on public.contact_messages for insert to anon, authenticated with check (true);
drop policy if exists "contact admin read" on public.contact_messages;
create policy "contact admin read" on public.contact_messages for select to authenticated using (public.is_admin());
drop policy if exists "contact admin update" on public.contact_messages;
create policy "contact admin update" on public.contact_messages for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "newsletter public insert" on public.newsletter_subscribers;
create policy "newsletter public insert" on public.newsletter_subscribers for insert to anon, authenticated with check (true);
drop policy if exists "newsletter admin read" on public.newsletter_subscribers;
create policy "newsletter admin read" on public.newsletter_subscribers for select to authenticated using (public.is_admin());
drop policy if exists "newsletter admin update" on public.newsletter_subscribers;
create policy "newsletter admin update" on public.newsletter_subscribers for update to authenticated using (public.is_admin()) with check (public.is_admin());
grant insert on table public.contact_messages to anon, authenticated;
grant select, update on table public.contact_messages to authenticated;
grant insert on table public.newsletter_subscribers to anon, authenticated;
grant select, update on table public.newsletter_subscribers to authenticated;


-- Consulta pública limitada al estado, transportadora y guía, sin exponer datos personales.
create or replace function public.track_order(p_order_number text)
returns table(order_number text, status text, tracking_number text, shipping_carrier text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select o.order_number, o.status, o.tracking_number, o.shipping_carrier, o.created_at
  from public.orders o where upper(o.order_number)=upper(trim(p_order_number)) limit 1;
$$;
grant execute on function public.track_order(text) to anon, authenticated;
