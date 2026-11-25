# Checklist antes de considerar a base pronta para produção

## Conferir seeds no SQL Editor

```sql
select count(*) from public.categories; -- 12
select count(*) from public.themes; -- 12
select count(*) from public.templates; -- 6
select count(*) from public.badges; -- 10
select count(*) from public.quizzes where status='published'; -- 6
select count(*) from public.questions; -- 60
select count(*) from public.options; -- 240
select count(*) from public.answer_keys; -- 60
select q.title, count(x.id) as perguntas from public.quizzes q
join public.questions x on x.quiz_id=q.id group by q.id,q.title order by q.title;
```

## Cenários de autorização a testar numa instância Supabase

1. Usuário A cria e edita rascunho; B não o lê.
2. Usuário B não altera quiz, questão nem alternativa de A.
3. Anônimo lê quiz público, mas não lê `answer_keys`.
4. `publish_quiz()` não aceita perguntas incompletas.
5. Após publicar, o editor não altera perguntas nem alternativas já publicadas.
6. Convidado começa tentativa com token aleatório e não acessa tentativa de outro token.
7. Usuário não escreve score, XP e `is_correct` diretamente.
8. Dois envios simultâneos para a mesma pergunta não criam respostas duplicadas.
9. Um usuário só pode fazer upload no próprio prefixo do Storage.
10. Repetir o seed não duplica quizzes ou alternativas.

**Status:** validação estática do conteúdo e geração do seed realizada. O SQL **não foi executado em um Supabase real** nesta sessão; permissões, triggers e RPCs ainda exigem testes de integração antes do deploy.
