-- Ejecuta este bloque si ya habías ejecutado el esquema anterior.
alter table public.orders add column if not exists tracking_number text;
alter table public.orders add column if not exists updated_at timestamptz not null default now();
create or replace function public.track_order(p_order_number text)
returns table(order_number text, status text, tracking_number text, shipping_carrier text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select o.order_number, o.status, o.tracking_number, o.shipping_carrier, o.created_at
  from public.orders o where upper(o.order_number)=upper(trim(p_order_number)) limit 1;
$$;
grant execute on function public.track_order(text) to anon, authenticated;
