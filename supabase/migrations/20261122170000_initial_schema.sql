-- =====================================================================
-- Initial schema: profiles, zones (with subzones), zone points, captures.
-- Mirrors the phone's local database (Drift, schema v3) so the sync
-- engine can copy rows both ways with the same ids (UUIDs from the phone).
--
-- Security: Row Level Security on every table. For now each user only
-- sees their own rows; groups and sharing will widen the SELECT policies.
-- =====================================================================

create extension if not exists postgis with schema extensions;

-- ---------- Helpers ----------

-- updated_at always comes from the server clock, so "give me what changed
-- since X" works even if the phone's clock is wrong.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ---------- Profiles ----------
-- The phone number lives in auth.users and is never exposed to other users.

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null default '' check (char_length(display_name) <= 60),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;

-- Every new user gets an (empty) profile right away, so their zones can
-- reference it. The app fills display_name after the first login.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id) values (new.id) on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create policy "read own profile" on public.profiles
  for select to authenticated using (id = (select auth.uid()));
create policy "create own profile" on public.profiles
  for insert to authenticated with check (id = (select auth.uid()));
create policy "update own profile" on public.profiles
  for update to authenticated using (id = (select auth.uid()));

-- ---------- Zones (areas, routes, subzones) ----------

create table public.zones (
  id uuid primary key,                           -- generated on the phone
  owner_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  parent_id uuid references public.zones (id) on delete cascade,  -- subzone of...
  name text not null check (char_length(name) between 1 and 120),
  description text,
  kind text not null check (kind in ('area', 'route')),
  geometry jsonb not null,                       -- [[lng, lat], ...] as on the phone
  geom extensions.geometry(Geometry, 4326),     -- filled by trigger, for map queries
  species text[] not null default '{}',
  modality text,
  features jsonb not null default '{}',          -- animals, food & water, danger, bedding
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz                         -- soft delete, synced to other phones
);

create index zones_owner_updated on public.zones (owner_id, updated_at);
create index zones_parent on public.zones (parent_id);
create index zones_geom on public.zones using gist (geom);

-- Builds the PostGIS shape from the phone's coordinate list.
create or replace function public.zones_set_geom()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  coords jsonb := new.geometry;
begin
  if jsonb_typeof(coords) <> 'array' or jsonb_array_length(coords) < 2 then
    new.geom := null;
  elsif new.kind = 'area' and jsonb_array_length(coords) >= 3 then
    if coords -> 0 <> coords -> -1 then
      coords := coords || jsonb_build_array(coords -> 0);   -- close the ring
    end if;
    new.geom := extensions.st_setsrid(extensions.st_geomfromgeojson(
      jsonb_build_object('type', 'Polygon', 'coordinates', jsonb_build_array(coords))::text), 4326);
  else
    new.geom := extensions.st_setsrid(extensions.st_geomfromgeojson(
      jsonb_build_object('type', 'LineString', 'coordinates', coords)::text), 4326);
  end if;
  return new;
end;
$$;

create trigger zones_geom
  before insert or update of geometry, kind on public.zones
  for each row execute function public.zones_set_geom();

create trigger zones_updated_at
  before update on public.zones
  for each row execute function public.set_updated_at();

alter table public.zones enable row level security;

create policy "read own zones" on public.zones
  for select to authenticated using (owner_id = (select auth.uid()));
create policy "create own zones" on public.zones
  for insert to authenticated with check (
    owner_id = (select auth.uid())
    and (parent_id is null or exists (
      select 1 from public.zones p where p.id = parent_id and p.owner_id = (select auth.uid())
    ))
  );
create policy "update own zones" on public.zones
  for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));
create policy "delete own zones" on public.zones
  for delete to authenticated using (owner_id = (select auth.uid()));

-- ---------- Zone points (stand, parking, feeder...) ----------

create table public.zone_points (
  id uuid primary key,
  zone_id uuid not null references public.zones (id) on delete cascade,
  owner_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  kind text not null check (kind in ('stand', 'parking', 'feeder', 'danger', 'other')),
  name text,
  latitude double precision not null check (latitude between -90 and 90),
  longitude double precision not null check (longitude between -180 and 180),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index zone_points_zone on public.zone_points (zone_id);
create index zone_points_owner_updated on public.zone_points (owner_id, updated_at);

create trigger zone_points_updated_at
  before update on public.zone_points
  for each row execute function public.set_updated_at();

alter table public.zone_points enable row level security;

create policy "read own points" on public.zone_points
  for select to authenticated using (owner_id = (select auth.uid()));
create policy "create points in own zones" on public.zone_points
  for insert to authenticated with check (
    owner_id = (select auth.uid())
    and exists (select 1 from public.zones z where z.id = zone_id and z.owner_id = (select auth.uid()))
  );
create policy "update own points" on public.zone_points
  for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));
create policy "delete own points" on public.zone_points
  for delete to authenticated using (owner_id = (select auth.uid()));

-- ---------- Captures ----------

create table public.captures (
  id uuid primary key,
  owner_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  species text not null,
  count integer not null default 1 check (count between 1 and 999),
  photo_path text,                     -- path in the "capture-photos" bucket
  latitude double precision check (latitude between -90 and 90),
  longitude double precision check (longitude between -180 and 180),
  notes text,
  taken_at timestamptz not null,
  hunt_id uuid,                        -- FK added when hunts exist
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index captures_owner_updated on public.captures (owner_id, updated_at);

create trigger captures_updated_at
  before update on public.captures
  for each row execute function public.set_updated_at();

alter table public.captures enable row level security;

create policy "read own captures" on public.captures
  for select to authenticated using (owner_id = (select auth.uid()));
create policy "create own captures" on public.captures
  for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "update own captures" on public.captures
  for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));
create policy "delete own captures" on public.captures
  for delete to authenticated using (owner_id = (select auth.uid()));

-- ---------- Capture photos (private bucket) ----------
-- Path: {user id}/{capture id}.jpg  → each user only touches their folder.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('capture-photos', 'capture-photos', false, 2097152, array['image/jpeg'])
on conflict (id) do nothing;

create policy "read own photos" on storage.objects
  for select to authenticated
  using (bucket_id = 'capture-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "upload own photos" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'capture-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "replace own photos" on storage.objects
  for update to authenticated
  using (bucket_id = 'capture-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "delete own photos" on storage.objects
  for delete to authenticated
  using (bucket_id = 'capture-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);

-- Anonymous users get nothing: every policy above is "to authenticated".
revoke all on public.profiles, public.zones, public.zone_points, public.captures from anon;
