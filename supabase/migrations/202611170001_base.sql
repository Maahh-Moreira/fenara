-- FENARA / Etapa 2. Execute num projeto Supabase novo via Supabase CLI.
create extension if not exists pgcrypto;
create extension if not exists unaccent;

create type public.quiz_visibility as enum ('private','unlisted','public');
create type public.quiz_status as enum ('draft','published','archived');
create type public.question_kind as enum ('multiple_choice','true_false','typed','ordering');
create type public.attempt_status as enum ('in_progress','completed','abandoned');
create type public.live_status as enum ('waiting','running','finished');

create table public.users (
 id uuid primary key references auth.users(id) on delete cascade,
 created_at timestamptz not null default now()
);
create table public.profiles (
 user_id uuid primary key references public.users(id) on delete cascade,
 handle text unique not null check(handle ~ '^[a-z0-9_]{3,24}$'),
 display_name text not null check(length(display_name) between 1 and 60),
 avatar_url text, xp bigint not null default 0 check(xp >= 0),
 streak_days int not null default 0 check(streak_days >= 0),
 last_activity_on date, locale text not null default 'pt-BR',
 settings jsonb not null default '{"sound":true,"theme":"system"}'::jsonb,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.categories (
 id uuid primary key default gen_random_uuid(), slug text unique not null,
 title text not null, icon_key text not null, sort_order int not null default 0
);
create table public.themes (
 id uuid primary key default gen_random_uuid(), slug text unique not null,
 title text not null, primary_color text not null check(primary_color ~ '^#[0-9A-Fa-f]{6}$'),
 pattern_key text not null, mascot_key text not null,
 created_at timestamptz not null default now()
);
create table public.templates (
 id uuid primary key default gen_random_uuid(), slug text unique not null,
 title text not null, description text not null, content jsonb not null default '{}'::jsonb,
 category_id uuid references public.categories(id) on delete set null,
 theme_id uuid references public.themes(id) on delete set null
);
create table public.quizzes (
 id uuid primary key default gen_random_uuid(), author_id uuid references public.users(id) on delete set null,
 category_id uuid references public.categories(id) on delete set null,
 theme_id uuid references public.themes(id) on delete set null,
 template_id uuid references public.templates(id) on delete set null,
 slug text not null, title text not null check(length(title) between 3 and 120),
 description text not null default '', cover_url text, difficulty smallint not null default 2 check(difficulty between 1 and 3),
 visibility public.quiz_visibility not null default 'private',
 status public.quiz_status not null default 'draft',
 version integer not null default 1 check(version >= 1),
 published_at timestamptz, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(author_id,slug),
 check(status <> 'published' or published_at is not null)
);
create table public.questions (
 id uuid primary key default gen_random_uuid(), quiz_id uuid not null references public.quizzes(id) on delete cascade,
 kind public.question_kind not null, position int not null check(position >= 0),
 prompt text not null check(length(prompt) between 3 and 2000), image_url text,
 time_limit_seconds int not null default 20 check(time_limit_seconds between 5 and 120),
 base_points int not null default 1000 check(base_points between 100 and 2000),
 explanation text not null default '',
 created_at timestamptz not null default now(), unique(quiz_id,position), unique(id,quiz_id)
);
create table public.options (
 id uuid primary key default gen_random_uuid(), question_id uuid not null references public.questions(id) on delete cascade,
 position smallint not null check(position between 0 and 9), label text not null check(length(label) between 1 and 500),
 unique(question_id,position), unique(id,question_id)
);
-- Chaves de correção ficam fora de 'options'; nunca há SELECT do cliente nesta tabela.
create table public.answer_keys (
 question_id uuid primary key references public.questions(id) on delete cascade,
 correct_option_id uuid, accepted_text text[], ordered_option_ids uuid[],
 foreign key (correct_option_id,question_id) references public.options(id,question_id) deferrable initially deferred
);
create table public.attempts (
 id uuid primary key default gen_random_uuid(), quiz_id uuid not null references public.quizzes(id),
 user_id uuid references public.users(id) on delete set null,
 guest_token_hash text, status public.attempt_status not null default 'in_progress',
 started_at timestamptz not null default now(), completed_at timestamptz,
 score int not null default 0 check(score>=0), correct_count int not null default 0 check(correct_count>=0),
 current_combo int not null default 0 check(current_combo>=0),
 max_combo int not null default 0 check(max_combo>=0),
 check(user_id is not null or guest_token_hash is not null)
);
create table public.attempt_answers (
 id uuid primary key default gen_random_uuid(), attempt_id uuid not null references public.attempts(id) on delete cascade,
 question_id uuid not null references public.questions(id),
 selected_option_id uuid references public.options(id), typed_answer text, ordered_option_ids uuid[],
 is_correct boolean not null, points_awarded int not null default 0 check(points_awarded>=0),
 elapsed_ms int not null check(elapsed_ms>=0), answered_at timestamptz not null default now(),
 unique(attempt_id,question_id)
);
create table public.badges (
 id uuid primary key default gen_random_uuid(), slug text unique not null, title text not null,
 description text not null, icon_key text not null, rule_key text not null
);
create table public.user_badges (
 user_id uuid not null references public.users(id) on delete cascade,
 badge_id uuid not null references public.badges(id) on delete cascade,
 earned_at timestamptz not null default now(), primary key(user_id,badge_id)
);
create table public.favorites (
 user_id uuid not null references public.users(id) on delete cascade,
 quiz_id uuid not null references public.quizzes(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(user_id,quiz_id)
);
-- Fase 2: apenas persistência, sem API de ingresso ou publicação para clientes.
create table public.live_sessions (
 id uuid primary key default gen_random_uuid(), quiz_id uuid not null references public.quizzes(id),
 host_id uuid not null references public.users(id), pin char(6) unique not null check(pin ~ '^[0-9]{6}$'),
 status public.live_status not null default 'waiting', created_at timestamptz not null default now(), ended_at timestamptz
);
create table public.live_players (
 id uuid primary key default gen_random_uuid(), session_id uuid not null references public.live_sessions(id) on delete cascade,
 user_id uuid references public.users(id), nickname text not null check(length(nickname) between 2 and 32),
 score int not null default 0, joined_at timestamptz not null default now(), unique(session_id,nickname)
);

create index quizzes_discover_idx on public.quizzes(status,visibility,published_at desc) where status='published' and visibility='public';
create index quizzes_author_idx on public.quizzes(author_id,updated_at desc);
create index quizzes_category_idx on public.quizzes(category_id,difficulty);
create index questions_quiz_idx on public.questions(quiz_id,position);
create index options_question_idx on public.options(question_id,position);
create index attempts_user_idx on public.attempts(user_id,started_at desc);
create index attempts_quiz_idx on public.attempts(quiz_id,started_at desc);
create index attempts_status_idx on public.attempts(status) where status='in_progress';
create index answers_attempt_idx on public.attempt_answers(attempt_id);
create index favorites_quiz_idx on public.favorites(quiz_id);
create index badges_user_idx on public.user_badges(user_id,earned_at desc);
create index live_players_session_idx on public.live_players(session_id,score desc);

create or replace function public.handle_new_auth_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
 insert into public.users(id) values(new.id);
 insert into public.profiles(user_id,handle,display_name)
 values(new.id,'user_'||substr(replace(new.id::text,'-',''),1,16),
 left(coalesce(nullif(new.raw_user_meta_data->>'full_name',''),nullif(split_part(new.email,'@',1),''),'Jogador'),60));
 return new;
end $$;
create trigger on_auth_user_created after insert on auth.users
for each row execute function public.handle_new_auth_user();

create or replace function public.touch_updated_at() returns trigger language plpgsql
set search_path = '' as $$begin new.updated_at=now(); return new; end$$;
create trigger touch_profiles before update on public.profiles for each row execute function public.touch_updated_at();
create trigger touch_quizzes before update on public.quizzes for each row execute function public.touch_updated_at();

create or replace function public.can_read_quiz(q public.quizzes) returns boolean
language sql stable security invoker set search_path = '' as $$
 select (q.status='published' and q.visibility in ('public','unlisted'))
 or (q.author_id = (select auth.uid()));
$$;

-- Bloqueia mudança de propriedade e manipulação de métricas em updates diretos.
create or replace function public.protect_profile_metrics() returns trigger language plpgsql set search_path = '' as $$
begin
 if current_user in ('authenticated','anon') and
 (new.user_id<>old.user_id or new.xp<>old.xp or new.streak_days<>old.streak_days or new.last_activity_on is distinct from old.last_activity_on) then
 raise exception 'Métricas são alteradas apenas pelo servidor';
 end if;
 return new;
end$$;
create trigger guard_profile before update on public.profiles for each row execute function public.protect_profile_metrics();
create or replace function public.protect_quiz_owner() returns trigger language plpgsql set search_path = '' as $$
begin
 if new.author_id is distinct from old.author_id then raise exception 'Autor imutável'; end if;
 if current_user in ('authenticated','anon') and
 (new.status='published' and old.status<>'published' or new.version<>old.version) then
 raise exception 'Publicação e versionamento requerem fluxo de servidor';
 end if;
 return new;
end$$;
create trigger guard_quiz before update on public.quizzes for each row execute function public.protect_quiz_owner();

-- RLS: tabelas sem políticas permanecem fechadas mesmo se grants forem alterados.
do $$ declare t text; begin
 foreach t in array array['users','profiles','categories','themes','templates','quizzes','questions','options','answer_keys','attempts','attempt_answers','badges','user_badges','favorites','live_sessions','live_players'] loop
 execute format('alter table public.%I enable row level security',t);
 end loop;
end$$;

create policy users_self_read on public.users for select to authenticated using(id=(select auth.uid()));
create policy profiles_read on public.profiles for select to anon,authenticated using(true);
create policy profiles_update on public.profiles for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy categories_read on public.categories for select to anon,authenticated using(true);
create policy themes_read on public.themes for select to anon,authenticated using(true);
create policy templates_read on public.templates for select to anon,authenticated using(true);
create policy quizzes_read on public.quizzes for select to anon,authenticated using(public.can_read_quiz(quizzes));
create policy quizzes_create on public.quizzes for insert to authenticated with check(author_id=(select auth.uid()) and status='draft' and visibility='private');
create policy quizzes_update on public.quizzes for update to authenticated using(author_id=(select auth.uid()) and status='draft') with check(author_id=(select auth.uid()) and status='draft');
create policy quizzes_delete on public.quizzes for delete to authenticated using(author_id=(select auth.uid()) and status='draft');
create policy questions_read on public.questions for select to anon,authenticated using(exists(select 1 from public.quizzes q where q.id=quiz_id and public.can_read_quiz(q)));
create policy questions_insert on public.questions for insert to authenticated with check(exists(select 1 from public.quizzes q where q.id=quiz_id and q.author_id=(select auth.uid()) and q.status='draft'));
create policy questions_update on public.questions for update to authenticated using(exists(select 1 from public.quizzes q where q.id=quiz_id and q.author_id=(select auth.uid()) and q.status='draft')) with check(exists(select 1 from public.quizzes q where q.id=quiz_id and q.author_id=(select auth.uid()) and q.status='draft'));
create policy questions_delete on public.questions for delete to authenticated using(exists(select 1 from public.quizzes q where q.id=quiz_id and q.author_id=(select auth.uid()) and q.status='draft'));
create policy options_read on public.options for select to anon,authenticated using(exists(select 1 from public.questions x join public.quizzes q on q.id=x.quiz_id where x.id=question_id and public.can_read_quiz(q)));
create policy options_insert on public.options for insert to authenticated with check(exists(select 1 from public.questions x join public.quizzes q on q.id=x.quiz_id where x.id=question_id and q.author_id=(select auth.uid()) and q.status='draft'));
create policy options_update on public.options for update to authenticated using(exists(select 1 from public.questions x join public.quizzes q on q.id=x.quiz_id where x.id=question_id and q.author_id=(select auth.uid()) and q.status='draft')) with check(exists(select 1 from public.questions x join public.quizzes q on q.id=x.quiz_id where x.id=question_id and q.author_id=(select auth.uid()) and q.status='draft'));
create policy options_delete on public.options for delete to authenticated using(exists(select 1 from public.questions x join public.quizzes q on q.id=x.quiz_id where x.id=question_id and q.author_id=(select auth.uid()) and q.status='draft'));
-- answer_keys: gravar via editor somente no servidor privilegiado; sem SELECT público.
create policy attempts_own_read on public.attempts for select to authenticated using(user_id=(select auth.uid()));
create policy attempt_answers_own_read on public.attempt_answers for select to authenticated using(exists(select 1 from public.attempts a where a.id=attempt_id and a.user_id=(select auth.uid())));
create policy badges_read on public.badges for select to anon,authenticated using(true);
create policy user_badges_read on public.user_badges for select to anon,authenticated using(true);
create policy favorites_read on public.favorites for select to authenticated using(user_id=(select auth.uid()));
create policy favorites_insert on public.favorites for insert to authenticated with check(user_id=(select auth.uid()) and exists(select 1 from public.quizzes q where q.id=quiz_id and public.can_read_quiz(q)));
create policy favorites_delete on public.favorites for delete to authenticated using(user_id=(select auth.uid()));

-- Exposição mínima: sem SELECT do answer_keys e sem alterações em scores diretamente.
revoke all on public.answer_keys,public.attempts,public.attempt_answers,public.live_sessions,public.live_players from anon,authenticated;
grant select on public.attempts,public.attempt_answers to authenticated;
revoke all on public.users from anon,authenticated;
grant select on public.users to authenticated;
revoke insert,update,delete on public.users,public.badges,public.user_badges,public.categories,public.themes,public.templates from anon,authenticated;
revoke insert,update,delete on public.live_sessions,public.live_players from anon,authenticated;
-- Restringir alterações no perfil a campos editáveis.
revoke update on public.profiles from authenticated;
grant update(display_name,avatar_url,locale,settings,handle) on public.profiles to authenticated;
-- Ausência de autorização sobre answer_keys é intencional.

-- Armazenamento: capas e imagens de perguntas públicas; editor faz upload em prefixo do próprio UID.
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('fenara-media','fenara-media',true,5242880,array['image/png','image/jpeg','image/webp','image/svg+xml'])
on conflict (id) do nothing;
create policy fenara_media_read on storage.objects for select to anon,authenticated using(bucket_id='fenara-media');
create policy fenara_media_upload on storage.objects for insert to authenticated
with check(bucket_id='fenara-media' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy fenara_media_update on storage.objects for update to authenticated
using(bucket_id='fenara-media' and (storage.foldername(name))[1]=(select auth.uid())::text)
with check(bucket_id='fenara-media' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy fenara_media_delete on storage.objects for delete to authenticated
using(bucket_id='fenara-media' and (storage.foldername(name))[1]=(select auth.uid())::text);
