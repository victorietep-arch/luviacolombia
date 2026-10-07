-- Reparación de RLS para recibir pedidos desde el checkout público.
-- No borra pedidos ni productos existentes.

grant insert on table public.orders to anon, authenticated;
grant insert on table public.order_items to anon, authenticated;

drop policy if exists "orders public insert" on public.orders;
create policy "orders public insert" on public.orders
for insert to anon, authenticated
with check (true);

drop policy if exists "order items public insert" on public.order_items;
create policy "order items public insert" on public.order_items
for insert to anon, authenticated
with check (true);
