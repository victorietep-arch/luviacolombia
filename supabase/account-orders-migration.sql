-- Ejecuta este bloque si ya habías ejecutado el esquema anterior.
alter table public.orders add column if not exists user_id uuid references auth.users(id) on delete set null;
drop policy if exists "orders own read" on public.orders;
create policy "orders own read" on public.orders
for select to authenticated
using (email = (auth.jwt()->>'email'));
