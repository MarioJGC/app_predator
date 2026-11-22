-- =====================================================================
-- Fix: "infinite recursion detected in policy for relation zones".
--
-- The INSERT policies of zones (parent check) and zone_points read the
-- zones table, which re-applies the zones policies. A SECURITY DEFINER
-- helper does that check without going through RLS again.
-- =====================================================================

create or replace function public.is_own_zone(zone uuid)
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select exists (
    select 1 from public.zones z
    where z.id = zone and z.owner_id = (select auth.uid())
  );
$$;

revoke execute on function public.is_own_zone(uuid) from public, anon;
grant execute on function public.is_own_zone(uuid) to authenticated;

drop policy "create own zones" on public.zones;
create policy "create own zones" on public.zones
  for insert to authenticated with check (
    owner_id = (select auth.uid())
    and (parent_id is null or public.is_own_zone(parent_id))
  );

drop policy "create points in own zones" on public.zone_points;
create policy "create points in own zones" on public.zone_points
  for insert to authenticated with check (
    owner_id = (select auth.uid())
    and public.is_own_zone(zone_id)
  );
