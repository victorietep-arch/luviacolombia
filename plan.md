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

La sección de contenido del panel también administra las páginas informativas Nosotros, Contacto, Envíos y entregas, Cambios y devoluciones, Preguntas frecuentes y Términos y condiciones, incluyendo sus textos, bloques, preguntas, respuestas e imágenes.

## SEO, rendimiento y tráfico
La publicación se prepara como frontend estático con build reproducible y CDN: HTML inicial con contenido público por ruta, metadatos title/description/Open Graph/Twitter/canonical, JSON-LD, robots.txt, sitemap.xml, manifest web, enlaces rastreables, WebP para el hero, `loading="lazy"` y `decoding="async"` para imágenes no críticas, además de caché inmutable para `/assets/*`. Admin y checkout quedan fuera del índice.

## Legal, privacidad y HTTPS
Se agregan Política de privacidad, Política de cookies, Términos y condiciones enlazados desde el sitio, aviso de consentimiento de cookies y política de cambios con plazo de 12 días. La Preview y la publicación Webdev usan HTTPS; el certificado TLS es gestionado por la plataforma. El contenido legal es una base editable que conviene revisar con asesoría jurídica antes de operar comercialmente.

## Contacto, newsletter y panel modular
Los formularios de contacto y newsletter guardan datos en Supabase mediante inserción pública restringida por RLS. El panel administrativo consulta esas bandejas únicamente para usuarios admin y se divide en pestañas de Productos, Pedidos, Contenido, Mensajes y Suscriptores; los mensajes permiten cambiar estado.

## Redes sociales editables
El editor de Contenido incluye URLs de Instagram, Facebook, TikTok y YouTube. El footer las convierte en enlaces externos con `target=_blank` y rel="noopener".

## Organización operativa
La pestaña Pedidos incluye filtros Todos, Nuevos, Confirmados, Preparando, Enviados, Entregados y Cancelados con contadores. La pestaña Mensajes muestra un aviso accionable si la migración de Supabase aún no está aplicada.

La bandeja de mensajes ahora se organiza con filtros Todos, Nuevos, Leídos, Respondidos y Archivados, cada uno con contador.

El selector de estado de mensajes usa `change`, persiste el estado en Supabase y refresca la bandeja tras guardar.

## Mobile y estados operativos
En pantallas móviles, los paneles Liquid Glass elevan opacidad y contraste tipográfico sin perder el desenfoque. Los selectores de estado de pedidos y mensajes se deshabilitan solo durante la petición, conservan la selección y revierten con un error visible si Supabase rechaza la actualización; no se reconstruye la pantalla al guardar.

## Ajuste visual móvil final
El footer móvil usa un gradiente Liquid Glass azul-lila con tipografía oscura y enlaces de redes contrastados. La sección Edición especial separa imagen y contenido con fondo claro, texto oscuro y puntos destacados legibles.

## Cuenta Luvia y móvil
Se crea la ruta Cuenta Luvia con inicio de sesión y registro usando Supabase Auth, además de una vista de cuenta activa. En móvil se usan colores más saturados y tipografía más contrastada; el buscador mantiene 16px para evitar el zoom automático de iOS.

## Acceso alternable y banner vivo
Cuenta Luvia muestra una sola vista a la vez: inicio de sesión o registro, con un botón para alternar. La franja superior repite sus beneficios en un carrusel horizontal continuo y pulsa con un brillo suave.

## Banner y sugerencia de búsqueda
El banner usa cuatro grupos idénticos y se desplaza un cuarto de su ancho total para mantener cobertura continua también en escritorio. La sugerencia inline se oculta inmediatamente mediante estado visual al escribir cualquier carácter.

## Footer editable
El bloque Contáctanos del footer se administra desde Contenido con frase de marca, teléfono, correo y ubicación persistidos en `site_content` de Supabase.

## Pedidos, sincronización y seguimiento
La carga administrativa conserva los datos previos cuando una consulta auxiliar falla y se inicializa automáticamente al entrar en `/admin`. La nueva ruta `/seguimiento` consulta de forma pública y limitada el estado, transportadora y número de guía mediante la función segura `track_order`. El panel permite cambiar estado y guardar la guía.

## Cuenta y favoritos
Mi cuenta permite actualizar el nombre en el perfil de Supabase. Favoritos abre una página con las tarjetas reales guardadas, permite quitar prendas y conserva el estado local del navegador.

## Cuenta con historial visible
La cuenta muestra primero nombre, correo e historial de pedidos; la edición se abre únicamente mediante “Editar mi información”. Los pedidos se consultan por el correo autenticado, con estado, artículos, total y guía.
