-- 在 Supabase 的 SQL Editor 里运行一次，为现有关系表加入情谊类型。
-- 旧记录会自动标记为“其他”，原来的双方称呼会保留。
alter table public.relationships
  add column if not exists kind text not null default '其他';
