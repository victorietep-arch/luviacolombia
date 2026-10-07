# Plan — Luvia Colombia

## Alcance
Tienda web responsive de moda colombiana con catálogo navegable, búsqueda, filtros, ordenamiento, detalle de producto, carrito editable y checkout simulado sin cobros reales.

## Dirección de diseño
- **Movimiento:** editorial fashion-tech con glassmorphism suave e iridiscencia pastel.
- **Principios:** lujo accesible, aire y ritmo vertical, confianza visible, interacción cálida.
- **Color:** lila, rosa, azul hielo y blanco para transmitir ligereza, optimismo y una sensación de prendas iluminadas; tinta azul petróleo para legibilidad.
- **Layout:** composición por secciones apiladas tipo revista, con hero amplio, módulos de confianza, rieles horizontales de categorías y tarjetas de producto; no depender de una cuadrícula rígida única.
- **Firma visual:** superficies translúcidas, halos radiales pastel y líneas de contorno perladas.
- **Interacción:** los controles reaccionan con elevación sutil, color y microcopy; el carrito se abre como panel lateral para no romper el recorrido.
- **Animación:** entrada ascendente suave, hover con desplazamiento mínimo, halos flotantes muy lentos y transiciones de 180–260 ms; respetar `prefers-reduced-motion`.
- **Tipografía:** Cormorant Garamond para titulares y marca; Manrope para navegación, precios, filtros y formularios.
- **Esencia:** moda colombiana para personas que visten su ritmo con piezas versátiles y luminosas. Personalidad: serena, expresiva, cercana.
- **Voz:** aspiracional sin distancia. Ejemplos: “Luces increíble, siempre.” / “Tu estilo también merece respirar.”
- **Wordmark:** “Luvia” en serif de alto contraste con una estrella de cuatro puntas como detalle final.
- **Color de marca:** azul lila `#6478d8`, combinado con rosa iridiscente.

## Implementación
- Aplicación estática Vite/JavaScript sin backend para mantener el alcance seguro y portable.
- Estado de catálogo, filtros, favoritos y carrito en memoria/localStorage.
- Checkout en modal dedicado con validación de campos y confirmación de pedido simulado.
- Imágenes de producto remotas de Unsplash como placeholders editoriales; la estructura queda lista para sustituirlas por inventario real.
- Publicación estática con `npm run build`, salida `dist/`.

## Estructura
- `index.html`: shell semántico y puntos de montaje.
- `src/main.js`: catálogo, estado, render, filtros, detalle, carrito y checkout.
- `src/styles.css`: sistema visual responsive y microinteracciones.
- `public/manus-routes.json`: rutas declaradas para Preview.
- `app.config.ts`: metadato de logo del proyecto.
- `TODO.md`: criterios de entrega derivados de la solicitud.


## Actualización de navegación y acabado visual
La iteración final añade una capa Liquid Glass con blur, saturación, bordes perlados, reflejos en movimiento y halos iridiscentes. También incorpora rutas independientes para Nosotros, Contacto, Envíos y entregas, Cambios y devoluciones, Preguntas frecuentes y Términos y condiciones; cada una conserva el header/footer de la tienda y sus propios contenidos. Contacto incluye un formulario funcional con confirmación visual.


## Persistencia y operación con Supabase
La tienda usa las variables protegidas `VITE_SUPABASE_URL` y `VITE_SUPABASE_ANON_KEY`. El archivo `supabase/schema.sql` define perfiles, productos, pedidos, líneas de pedido, RLS y el bucket público de imágenes. El storefront lee el catálogo persistente y registra cada checkout en Supabase. La ruta `/admin` usa Supabase Auth y el rol `admin` de `profiles` para crear, editar y eliminar productos, subir imágenes, revisar inventario y actualizar el estado de las órdenes.
