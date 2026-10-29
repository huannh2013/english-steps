-- English Steps MVP — Supabase schema
-- Run this entire file in Supabase Dashboard > SQL Editor.
-- Row Level Security ensures each signed-in user can only access their own content.

create table if not exists public.lessons (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  source text default '',
  study_date date,
  description text default '',
  created_at timestamptz default now()
);

create table if not exists public.words (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id text not null,
  word text not null,
  meaning text default '',
  emoji text default '🖼️',
  image_url text default '',
  audio_url text default '',
  example text default '',
  created_at timestamptz default now()
);

create table if not exists public.sentences (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id text not null,
  text text not null,
  meaning text default '',
  audio_url text default '',
  created_at timestamptz default now()
);

alter table public.lessons enable row level security;
alter table public.words enable row level security;
alter table public.sentences enable row level security;

drop policy if exists "Users manage own lessons" on public.lessons;
create policy "Users manage own lessons" on public.lessons
for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users manage own words" on public.words;
create policy "Users manage own words" on public.words
for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users manage own sentences" on public.sentences;
create policy "Users manage own sentences" on public.sentences
for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create index if not exists lessons_user_date_idx on public.lessons(user_id, study_date);
create index if not exists words_user_lesson_idx on public.words(user_id, lesson_id);
create index if not exists sentences_user_lesson_idx on public.sentences(user_id, lesson_id);
