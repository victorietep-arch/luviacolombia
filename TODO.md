# Resultados de Luvia Colombia

- La página de inicio presenta navegación clara, hero de nueva colección, beneficios de compra, categorías Hombre, Mujer, Chaquetas, Camisetas, Pantalones y Accesorios, favoritos o más vendidos, bloque de marca y footer.
- La identidad visual usa gradientes pastel lila, rosa, azul y blanco, superficies translúcidas, bordes suaves, titulares serif y UI sans-serif.
- El catálogo es responsive y permite ver productos de Hombre, Mujer, Chaquetas, Camisetas, Pantalones y Accesorios.
- La búsqueda filtra productos y los filtros por categoría y ordenamiento actualizan el catálogo.
- La vista de detalle permite galería, precio en COP, talla, color, cantidad y añadir al carrito.
- El carrito permite editar cantidades, eliminar artículos, ver subtotal y recibir información de envío.
- El checkout simulado solicita datos de entrega, muestra resumen del pedido y confirma la orden sin procesar pagos reales ni pedir tarjeta.
- La experiencia funciona en móvil, tableta y escritorio, con navegación consistente, estados visibles y accesibilidad básica.

- El sitio usa un acabado Liquid Glass visible con transparencias, desenfoque, bordes luminosos, profundidad, reflejos sutiles y halos iridiscentes.
- Los enlaces de Nosotros, Contacto, Envíos y entregas, Cambios y devoluciones, Preguntas frecuentes y Términos y condiciones abren páginas propias y no regresan al inicio.
- La página de Contacto permite enviar un mensaje y muestra una confirmación visual.

- La tienda lee los productos activos desde Supabase y registra cada pedido con número de orden, datos del cliente, totales y líneas de producto.
- `/admin` requiere autenticación de Supabase y rol `admin`; permite crear, editar y eliminar productos, subir imágenes, controlar inventario y actualizar estados de pedidos.
- `supabase/schema.sql` contiene el esquema, las políticas RLS y la configuración de almacenamiento de imágenes.
- El editor del panel permite modificar todas las páginas informativas, no solo la portada: Nosotros, Contacto, Envíos, Cambios, Preguntas frecuentes y Términos, con textos, bloques, preguntas/respuestas e imágenes.
