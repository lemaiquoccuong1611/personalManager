-- =====================================================================
--  Flow — Schema Supabase (tasks / notes / goals)
--  Cách dùng: Supabase Dashboard → SQL Editor → New query → dán toàn bộ
--  file này → Run. Chạy lại nhiều lần vẫn an toàn (idempotent).
-- =====================================================================

-- ---------- Bảng TASKS ----------
create table if not exists public.tasks (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title       text not null,
  description text default '',
  date        text not null,           -- 'YYYY-MM-DD'
  time        text not null default '09:00',
  priority    text not null default 'med',   -- high | med | low
  status      text not null default 'todo',  -- todo | inprogress | done
  cat         text not null default 'ppc',   -- ppc | it | tiktok | personal
  created_at  timestamptz not null default now()
);

-- ---------- Bảng NOTES ----------
create table if not exists public.notes (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title       text not null,
  body        text default '',
  date        text not null,
  created_at  timestamptz not null default now()
);

-- ---------- Bảng GOALS ----------
create table if not exists public.goals (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title         text not null,
  current_value numeric not null default 0,
  target_value  numeric not null default 0,
  unit          text default '',
  created_at    timestamptz not null default now()
);

-- ---------- Index để truy vấn theo người dùng nhanh hơn ----------
create index if not exists tasks_user_idx on public.tasks (user_id);
create index if not exists notes_user_idx on public.notes (user_id);
create index if not exists goals_user_idx on public.goals (user_id);

-- =====================================================================
--  ROW LEVEL SECURITY — mỗi người dùng chỉ thấy & sửa dữ liệu của mình
-- =====================================================================
alter table public.tasks enable row level security;
alter table public.notes enable row level security;
alter table public.goals enable row level security;

-- TASKS policies
drop policy if exists "tasks_select_own" on public.tasks;
create policy "tasks_select_own" on public.tasks for select using (auth.uid() = user_id);
drop policy if exists "tasks_insert_own" on public.tasks;
create policy "tasks_insert_own" on public.tasks for insert with check (auth.uid() = user_id);
drop policy if exists "tasks_update_own" on public.tasks;
create policy "tasks_update_own" on public.tasks for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "tasks_delete_own" on public.tasks;
create policy "tasks_delete_own" on public.tasks for delete using (auth.uid() = user_id);

-- NOTES policies
drop policy if exists "notes_select_own" on public.notes;
create policy "notes_select_own" on public.notes for select using (auth.uid() = user_id);
drop policy if exists "notes_insert_own" on public.notes;
create policy "notes_insert_own" on public.notes for insert with check (auth.uid() = user_id);
drop policy if exists "notes_update_own" on public.notes;
create policy "notes_update_own" on public.notes for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "notes_delete_own" on public.notes;
create policy "notes_delete_own" on public.notes for delete using (auth.uid() = user_id);

-- GOALS policies
drop policy if exists "goals_select_own" on public.goals;
create policy "goals_select_own" on public.goals for select using (auth.uid() = user_id);
drop policy if exists "goals_insert_own" on public.goals;
create policy "goals_insert_own" on public.goals for insert with check (auth.uid() = user_id);
drop policy if exists "goals_update_own" on public.goals;
create policy "goals_update_own" on public.goals for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "goals_delete_own" on public.goals;
create policy "goals_delete_own" on public.goals for delete using (auth.uid() = user_id);
