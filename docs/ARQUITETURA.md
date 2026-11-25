# Arquitetura atual — FENARA PostgreSQL local

## Camadas

- **Client:** `src/app/page.tsx`, componentes e `globals.css` mantêm o protótipo aprovado, com tema claro/escuro, editor, modo Solo e feedback inline.
- **HTTP server:** Next.js Route Handlers dentro de `src/app/api`, usados por `src/lib/cloud.ts` no navegador.
- **Identity:** NextAuth com credenciais (bcrypt) e Google OAuth opcional; cookies HTTP-only/JWT, exigência de login em endpoints de edição/publicação.
- **Persistence:** Prisma Client acessa PostgreSQL via `DATABASE_URL` exclusivamente no servidor.
- **Protection:** gabaritos ficam na tabela `options.correct`, acessível apenas pelo processo de backend; a API pública não serializa esse campo. Tentativas têm vínculo com usuário autenticado ou token secreto de convidado (armazenado como hash).

## Fluxo de publicação

1. Usuário cria rascunho local e escolhe publicar.
2. `POST /api/quizzes` exige sessão; Zod valida título, descrição, perguntas, alternativas, resposta e tempo.
3. Prisma cria quiz, perguntas e alternativas numa escrita aninhada (transação).
4. ID UUID é retornado para o compartilhamento `/?quiz=<id>`.
5. Página pública `GET /api/quizzes/<id>` retorna questões, tempo e opções **sem** resposta correta.

## Fluxo de jogo remoto

1. `POST /api/attempts` cria uma tentativa vinculada ao usuário ou token de convidado.
2. A interface apresenta a questão e envia somente ID da questão, ID da alternativa e token de convidado se aplicável.
3. O backend verifica propriedade da tentativa, ordem da pergunta, opção válida e registra resposta com pontuação por tempo e combo.
4. Após registrar, informa o acerto e a explicação da pergunta. O frontend mostra feedback na própria pergunta.
5. Quizzes de exemplo internos ainda têm execução offline no navegador; os quizzes públicos carregados do PostgreSQL têm correção no servidor.

## Próximas integrações

O layout de perfil, favoritos e histórico ainda tem partes locais; conectar todas ao `/api/me` e `/api/favorites`, sincronizar rascunhos, adicionar recuperações de senha, limites de requisição e completar os outros tipos de questão antes de lançar publicamente.
