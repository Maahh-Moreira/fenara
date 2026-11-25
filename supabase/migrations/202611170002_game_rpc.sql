-- As funções abaixo são única porta de acesso às respostas e à pontuação.
-- Execução SECURITY DEFINER com search_path vazio e permissões explícitas.
create or replace function public.set_answer_key(
 p_question_id uuid, p_correct_option uuid default null,
 p_accepted_text text[] default null, p_ordered_option_ids uuid[] default null
) returns void language plpgsql security definer set search_path='' as $$
declare k public.question_kind;
begin
 select x.kind into k from public.questions x join public.quizzes q on q.id=x.quiz_id
 where x.id=p_question_id and q.author_id=auth.uid() and q.status='draft';
 if k is null then raise exception 'Pergunta não editável'; end if;
 if k in ('multiple_choice','true_false') then
   if p_correct_option is null or not exists(select 1 from public.options o where o.id=p_correct_option and o.question_id=p_question_id) then
    raise exception 'Alternativa correta inválida'; end if;
 elsif k='typed' then
   if coalesce(array_length(p_accepted_text,1),0)<1 then raise exception 'Respostas aceitas necessárias'; end if;
 elsif k='ordering' then
   if coalesce(array_length(p_ordered_option_ids,1),0)<2 or
      (select count(*) from public.options o where o.question_id=p_question_id) <> array_length(p_ordered_option_ids,1) or
      (select count(distinct i) from unnest(p_ordered_option_ids) as i join public.options o on o.id=i and o.question_id=p_question_id) <> array_length(p_ordered_option_ids,1)
   then raise exception 'Sequência inválida'; end if;
 end if;
 insert into public.answer_keys(question_id,correct_option_id,accepted_text,ordered_option_ids)
 values(p_question_id,p_correct_option,p_accepted_text,p_ordered_option_ids)
 on conflict(question_id) do update set correct_option_id=excluded.correct_option_id,
 accepted_text=excluded.accepted_text,ordered_option_ids=excluded.ordered_option_ids;
end$$;

create or replace function public.publish_quiz(p_quiz_id uuid) returns void
language plpgsql security definer set search_path='' as $$
declare n integer; bad integer;
begin
 perform 1 from public.quizzes where id=p_quiz_id and author_id=auth.uid() and status='draft' for update;
 if not found then raise exception 'Quiz não editável'; end if;
 select count(*) into n from public.questions where quiz_id=p_quiz_id;
 if n<1 then raise exception 'Quiz sem perguntas'; end if;
 select count(*) into bad from public.questions x
 left join public.answer_keys k on k.question_id=x.id
 where x.quiz_id=p_quiz_id and (
 k.question_id is null or
 (x.kind in ('multiple_choice','true_false') and ((select count(*) from public.options o where o.question_id=x.id) not between 2 and 4 or k.correct_option_id is null)) or
 (x.kind='typed' and coalesce(array_length(k.accepted_text,1),0)<1) or
 (x.kind='ordering' and coalesce(array_length(k.ordered_option_ids,1),0)<2)
 );
 if bad>0 then raise exception 'Perguntas incompletas: %',bad; end if;
 update public.quizzes set status='published', published_at=now() where id=p_quiz_id;
end$$;

create or replace function public.start_solo_attempt(p_quiz_id uuid, p_guest_token text default null)
returns uuid language plpgsql security definer set search_path='' as $$
declare out_id uuid; uid uuid:=auth.uid();
begin
 if not exists(select 1 from public.quizzes where id=p_quiz_id and status='published' and visibility in ('public','unlisted')) then
 raise exception 'Quiz indisponível'; end if;
 if uid is null and (p_guest_token is null or length(p_guest_token)<32) then
 raise exception 'Token de convidado deve ser aleatório e conter 32+ caracteres'; end if;
 insert into public.attempts(quiz_id,user_id,guest_token_hash)
 values(p_quiz_id,uid,case when uid is null then encode(sha256(convert_to(p_guest_token,'UTF8')),'hex') else null end)
 returning id into out_id;
 return out_id;
end$$;

create or replace function public.submit_solo_answer(
 p_attempt_id uuid, p_question_id uuid, p_selected_option uuid default null,
 p_typed_answer text default null, p_ordered_option_ids uuid[] default null,
 p_guest_token text default null
) returns jsonb language plpgsql security definer set search_path='' as $$
declare
 a public.attempts%rowtype; q public.questions%rowtype; k public.answer_keys%rowtype;
 prev_at timestamptz; started_at timestamptz; ms int; correct boolean:=false;
 multiplier numeric; gained int:=0; new_combo int; total_count int; answer_count int;
 display_answer text; normalized text;
begin
 select * into a from public.attempts where id=p_attempt_id for update;
 if not found or a.status<>'in_progress' then raise exception 'Tentativa indisponível'; end if;
 if a.user_id is not null then
  if a.user_id is distinct from auth.uid() then raise exception 'Acesso negado'; end if;
 elsif p_guest_token is null or a.guest_token_hash<>encode(sha256(convert_to(p_guest_token,'UTF8')),'hex') then
  raise exception 'Token inválido';
 end if;
 select * into q from public.questions where id=p_question_id and quiz_id=a.quiz_id;
 if not found then raise exception 'Pergunta inválida'; end if;
 select count(*) into answer_count from public.attempt_answers where attempt_id=p_attempt_id;
 if q.position<>answer_count then raise exception 'Perguntas devem ser respondidas em ordem'; end if;
 select coalesce(max(answered_at),a.started_at) into started_at from public.attempt_answers where attempt_id=p_attempt_id;
 if started_at<a.started_at then started_at:=a.started_at; end if;
 ms:=greatest(0,floor(extract(epoch from (clock_timestamp()-started_at))*1000)::int);
 select * into k from public.answer_keys where question_id=q.id;
 if q.kind in ('multiple_choice','true_false') then
  if p_selected_option is not null and not exists(select 1 from public.options o where o.id=p_selected_option and o.question_id=q.id) then
   raise exception 'Alternativa não pertence à pergunta'; end if;
  correct:=p_selected_option=k.correct_option_id;
  select label into display_answer from public.options where id=k.correct_option_id;
 elsif q.kind='typed' then
  normalized:=lower(trim(coalesce(p_typed_answer,'')));
  correct:=exists(select 1 from unnest(coalesce(k.accepted_text,array[]::text[])) t where lower(trim(t))=normalized and normalized<>'');
  display_answer:=coalesce(k.accepted_text[1],'');
 else
  correct:=p_ordered_option_ids=k.ordered_option_ids;
  select string_agg(o.label,' → ' order by t.ord) into display_answer
  from unnest(k.ordered_option_ids) with ordinality t(id,ord) join public.options o on o.id=t.id;
 end if;
 correct:=coalesce(correct,false) and ms <= q.time_limit_seconds*1000;
 new_combo:=case when correct then a.current_combo+1 else 0 end;
 multiplier:=case when new_combo>=8 then 2.0 when new_combo>=5 then 1.5 when new_combo>=3 then 1.2 else 1.0 end;
 if correct then gained:=floor(q.base_points*(0.5+0.5*greatest(0,1-ms::numeric/(q.time_limit_seconds*1000)))*multiplier)::int; end if;
 insert into public.attempt_answers(attempt_id,question_id,selected_option_id,typed_answer,ordered_option_ids,is_correct,points_awarded,elapsed_ms)
 values(p_attempt_id,p_question_id,p_selected_option,left(p_typed_answer,1000),p_ordered_option_ids,correct,gained,ms);
 update public.attempts set score=score+gained, correct_count=correct_count+(case when correct then 1 else 0 end),
 current_combo=new_combo,max_combo=greatest(max_combo,new_combo) where id=a.id;
 select count(*) into total_count from public.questions where quiz_id=a.quiz_id;
 if answer_count+1>=total_count then
  update public.attempts set status='completed',completed_at=now() where id=a.id;
  -- XP e conquistas calculados por rotina específica de gamificação, nunca no cliente.
 end if;
 return jsonb_build_object('correct',correct,'points',gained,'combo',new_combo,
 'explanation',q.explanation,'correct_answer',display_answer,
 'finished',answer_count+1>=total_count);
end$$;

revoke all on function public.set_answer_key(uuid,uuid,text[],uuid[]) from public;
revoke all on function public.publish_quiz(uuid) from public;
revoke all on function public.start_solo_attempt(uuid,text) from public;
revoke all on function public.submit_solo_answer(uuid,uuid,uuid,text,uuid[],text) from public;
grant execute on function public.set_answer_key(uuid,uuid,text[],uuid[]) to authenticated;
grant execute on function public.publish_quiz(uuid) to authenticated;
grant execute on function public.start_solo_attempt(uuid,text) to anon,authenticated;
grant execute on function public.submit_solo_answer(uuid,uuid,uuid,text,uuid[],text) to anon,authenticated;
