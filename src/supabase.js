import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
export const isSupabaseConfigured = Boolean(url && anonKey);
export const supabase = isSupabaseConfigured ? createClient(url, anonKey, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
}) : null;

export const mapProduct = (row) => ({
  id: row.id,
  slug: row.slug,
  name: row.name,
  category: row.category,
  price: Number(row.price || 0),
  oldPrice: row.old_price ? Number(row.old_price) : null,
  tag: row.tag || '',
  image: row.image || '',
  gallery: row.gallery?.length ? row.gallery : [row.image].filter(Boolean),
  colors: row.colors?.length ? row.colors : ['Único'],
  sizes: row.sizes?.length ? row.sizes : ['Única'],
  stock: Number(row.stock || 0),
  description: row.description || ''
});

export const mapProductPayload = (form, imageUrl) => ({
  slug: form.slug.trim().toLowerCase().replace(/[^a-z0-9-]+/g, '-'),
  name: form.name.trim(),
  category: form.category,
  price: Number(form.price || 0),
  old_price: form.old_price ? Number(form.old_price) : null,
  tag: form.tag?.trim() || null,
  image: imageUrl || form.image?.trim() || null,
  gallery: imageUrl || form.image?.trim() ? [imageUrl || form.image.trim()] : [],
  colors: form.colors.split(',').map((value) => value.trim()).filter(Boolean),
  sizes: form.sizes.split(',').map((value) => value.trim()).filter(Boolean),
  stock: Number(form.stock || 0),
  description: form.description?.trim() || null,
  active: true
});

export async function uploadProductImage(file) {
  if (!supabase || !file) return null;
  const safeName = file.name.toLowerCase().replace(/[^a-z0-9.]+/g, '-');
  const path = `${crypto.randomUUID()}-${safeName}`;
  const { error } = await supabase.storage.from('product-images').upload(path, file, { upsert: false, cacheControl: '31536000' });
  if (error) throw error;
  return supabase.storage.from('product-images').getPublicUrl(path).data.publicUrl;
}
