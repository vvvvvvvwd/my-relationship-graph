-- 先在 Supabase 的 Storage 页面新建公开 bucket：avatars
-- 文件大小上限设为 2 MB，只允许 image/jpeg、image/png、image/webp。
-- 公开 bucket 中的头像任何人都能查看；只有已登录管理员能上传和删除。
-- 确认允许公开头像后，再运行本文件。

alter table public.people
  add column if not exists avatar_path text not null default '';

drop policy if exists "Signed-in admins can upload avatars" on storage.objects;
create policy "Signed-in admins can upload avatars"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars');

drop policy if exists "Signed-in admins can delete avatars" on storage.objects;
create policy "Signed-in admins can delete avatars"
  on storage.objects for delete to authenticated
  using (bucket_id = 'avatars');
