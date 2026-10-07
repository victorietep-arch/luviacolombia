-- Añade los datos de entrega y pago sin borrar pedidos existentes.
alter table public.orders
  add column if not exists payment_method text not null default 'contraentrega';

alter table public.orders
  add column if not exists shipping_carrier text not null default 'Interrapidísimo';
