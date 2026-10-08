import { createClient } from '@supabase/supabase-js';
import { writeFile } from 'node:fs/promises';

const origin = 'https://luviacolombia.vercel.app';
const url = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL;
const key = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY;
const publicPages = [
  ['', 'daily', '1.0'], ['tienda', 'daily', '0.9'], ['nosotros', 'monthly', '0.6'],
  ['contacto', 'monthly', '0.6'], ['envios', 'monthly', '0.7'], ['cambios', 'monthly', '0.7'],
  ['faq', 'monthly', '0.7'], ['terminos', 'yearly', '0.3'], ['privacidad', 'yearly', '0.4'],
  ['cookies', 'yearly', '0.3'], ['seguimiento', 'weekly', '0.5']
];

let products = [];
if (url && key) {
  const supabase = createClient(url, key);
  const result = await supabase.from('products').select('slug,id').eq('active', true).order('created_at', { ascending: true });
  if (result.error) throw result.error;
  products = result.data || [];
} else {
  console.warn('Supabase no está configurado durante el build; se generará el sitemap sin productos.');
}

const esc = value => String(value).replace(/[&<>"']/g, char => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&apos;' }[char]));
const rows = ['<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'];
for (const [path, changefreq, priority] of publicPages) rows.push(`  <url><loc>${origin}/${path}</loc><changefreq>${changefreq}</changefreq><priority>${priority}</priority></url>`);
for (const product of products) {
  const slug = product.slug || product.id;
  rows.push(`  <url><loc>${origin}/producto/${encodeURIComponent(slug)}</loc><changefreq>weekly</changefreq><priority>0.8</priority></url>`);
}
rows.push('</urlset>');
await writeFile('public/sitemap.xml', rows.join('\n') + '\n');
console.log(`Sitemap generado: ${publicPages.length} páginas públicas y ${products.length} productos activos.`);
