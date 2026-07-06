-- Femorra Product Manager — run once in Supabase → SQL Editor → Run
-- Project: pemslcyrbyapcicaekfp  (same project as before, new table)

create table if not exists public.femorra_products (
  id               uuid primary key default gen_random_uuid(),
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  -- internal
  category         text,
  subcategory      text,
  meesho_url       text,
  meesho_id        text,
  -- basic
  title            text not null,
  vendor           text,
  brand            text,
  product_type     text,
  tags             text,
  description      text,
  -- pricing
  price            numeric,
  compare_at       numeric,
  cost             numeric,
  -- inventory
  sku              text,
  barcode          text,
  inventory_qty    integer default 0,
  track_inventory  boolean default true,
  continue_selling boolean default false,
  -- variants
  sizes            text,
  colors           text,
  material         text,
  -- shipping
  weight           numeric,
  weight_unit      text default 'g',
  -- seo
  seo_title        text,
  seo_description  text,
  handle           text,
  -- media + status
  image_urls       jsonb default '[]'::jsonb,
  status           text default 'Active'
);

alter table public.femorra_products enable row level security;

drop policy if exists "fem select" on public.femorra_products;
drop policy if exists "fem insert" on public.femorra_products;
drop policy if exists "fem update" on public.femorra_products;
drop policy if exists "fem delete" on public.femorra_products;
create policy "fem select" on public.femorra_products for select to anon, authenticated using (true);
create policy "fem insert" on public.femorra_products for insert to anon, authenticated with check (true);
create policy "fem update" on public.femorra_products for update to anon, authenticated using (true) with check (true);
create policy "fem delete" on public.femorra_products for delete to anon, authenticated using (true);

-- storage bucket (reused; safe to re-run)
insert into storage.buckets (id, name, public) values ('product-media', 'product-media', true)
  on conflict (id) do nothing;
drop policy if exists "media upload" on storage.objects;
drop policy if exists "media read"   on storage.objects;
create policy "media upload" on storage.objects for insert to anon, authenticated with check (bucket_id = 'product-media');
create policy "media read"   on storage.objects for select to anon, authenticated using (bucket_id = 'product-media');
