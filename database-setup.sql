-- 在 Supabase 的 SQL Editor 里运行一次，建立人物和关系表。
create extension if not exists pgcrypto;

create table if not exists public.people (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text not null default '',
  avatar_path text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.relationships (
  id uuid primary key default gen_random_uuid(),
  from_id uuid not null references public.people(id) on delete cascade,
  to_id uuid not null references public.people(id) on delete cascade,
  label_from text not null,
  label_to text not null default '',
  created_at timestamptz not null default now(),
  constraint relationships_people_must_differ check (from_id <> to_id)
);

alter table public.people enable row level security;
alter table public.relationships enable row level security;

revoke all on table public.people from anon, authenticated;
revoke all on table public.relationships from anon, authenticated;
grant select on table public.people to anon, authenticated;
grant select on table public.relationships to anon, authenticated;
grant insert, update, delete on table public.people to authenticated;
grant insert, update, delete on table public.relationships to authenticated;

drop policy if exists "Everyone can view people" on public.people;
create policy "Everyone can view people"
  on public.people for select to anon, authenticated using (true);

drop policy if exists "Signed-in admin can add people" on public.people;
create policy "Signed-in admin can add people"
  on public.people for insert to authenticated with check (true);

drop policy if exists "Signed-in admin can edit people" on public.people;
create policy "Signed-in admin can edit people"
  on public.people for update to authenticated using (true) with check (true);

drop policy if exists "Signed-in admin can delete people" on public.people;
create policy "Signed-in admin can delete people"
  on public.people for delete to authenticated using (true);

drop policy if exists "Everyone can view relationships" on public.relationships;
create policy "Everyone can view relationships"
  on public.relationships for select to anon, authenticated using (true);

drop policy if exists "Signed-in admin can add relationships" on public.relationships;
create policy "Signed-in admin can add relationships"
  on public.relationships for insert to authenticated with check (true);

drop policy if exists "Signed-in admin can edit relationships" on public.relationships;
create policy "Signed-in admin can edit relationships"
  on public.relationships for update to authenticated using (true) with check (true);

drop policy if exists "Signed-in admin can delete relationships" on public.relationships;
create policy "Signed-in admin can delete relationships"
  on public.relationships for delete to authenticated using (true);
