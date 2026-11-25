# FENARA — arquitetura técnica (Etapa 2)

## Decisões

- **Next.js App Router:** Server Components para páginas públicas de catálogo, Client Components para editor e gameplay; Route Handlers/Server Actions apenas nas mutações necessárias.
- **Supabase SSR:** clientes browser e server separados usando `@supabase/ssr`; proteger dados de usuário verificando `getClaims()`; nunca confiar em `getSession().user` para autorização.
- **Postgres/RLS:** autorização por linha para tabelas acessíveis pelo cliente. `answer_keys` é inacessível por SELECT; funções `SECURITY DEFINER` fazem validação no servidor, em transação.
- **Jogo solo:** cliente controla animação e cronômetro visual; banco calcula tempo efetivo e pontos. Não confiar em `elapsed_ms`, `is_correct` ou `score` vindos do cliente.
- **Convidado:** token aleatório gerado com Web Crypto no navegador, enviado apenas para RPC de tentativa; guardar token apenas localmente durante sessão. **Limite:** sem autenticação o convidado pode perder seu histórico ao limpar o navegador.
- **Arquivos:** `public/assets` com fallback de SVG; Storage `fenara-media` para uploads do usuário. Evitar SVG não confiável de upload em produção; permitir somente tipos raster ou sanitização rigorosa.
- **Idiomas:** textos em namespaces JSON por locale (`pt-BR`), rotas internas estáveis; locale no perfil.
- **Fase 2:** live_sessions e live_players existem, sem acesso direto do cliente; adicionar RPCs/canais privados de Realtime posteriormente.

## Organização sugerida do projeto completo

```text
fenara/
├── public/
│   ├── assets/{mascote,fundos,temas,icones,badges,fx}/
│   └── manifest.webmanifest
├── src/
│   ├── app/
│   │   ├── (marketing)/page.tsx
│   │   ├── (marketing)/explorar/page.tsx
│   │   ├── (marketing)/quiz/[id]/page.tsx
│   │   ├── (auth)/login/page.tsx
│   │   ├── (auth)/cadastro/page.tsx
│   │   ├── (app)/dashboard/page.tsx
│   │   ├── (app)/editor/[id]/page.tsx
│   │   ├── (app)/modelos/page.tsx
│   │   ├── (app)/temas/page.tsx
│   │   ├── (app)/perfil/page.tsx
│   │   ├── (app)/medalhas/page.tsx
│   │   ├── (app)/configuracoes/page.tsx
│   │   ├── jogar/[quizId]/page.tsx
│   │   ├── resultado/[attemptId]/page.tsx
│   │   ├── api/qr/[quizId]/route.ts
│   │   ├── layout.tsx
│   │   ├── not-found.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── ui/{button-3d,card,field,dialog,toast,progress-ring,option-button}.tsx
│   │   ├── mascot/{fenara-image,empty-state}.tsx
│   │   ├── quiz/{quiz-card,quiz-preview,question-editor,question-sortable}.tsx
│   │   └── game/{countdown,answer-grid,feedback,result-summary}.tsx
│   ├── features/{auth,explore,creator,game,profile,achievements}/
│   ├── hooks/
│   ├── lib/{assets,supabase/browser,supabase/server,validation,utils}.ts
│   ├── stores/{editor-store,solo-store}.ts
│   ├── i18n/locales/{pt-BR,en-US}.json
│   └── types/database.types.ts
├── supabase/
│   ├── migrations/
│   ├── seed.sql
│   └── tests/
├── design-system/
│   └── README.md
├── tests/{unit,e2e}/
├── next.config.ts
├── tailwind.config.ts
├── vitest.config.ts
└── playwright.config.ts
```

**Obs.:** a árvore acima é o contrato de estrutura das próximas etapas; não afirma que essas telas já foram implementadas nesta entrega.

## Domínios e relações

- `auth.users` 1:1 `users` 1:1 `profiles`
- `users` 1:N `quizzes`; `quizzes` N:1 `categories` e `themes`
- `quizzes` 1:N `questions`; `questions` 1:N `options` e 1:1 `answer_keys`
- `quizzes` 1:N `attempts`; `attempts` 1:N `attempt_answers`
- `users` N:N `quizzes` via `favorites`
- `users` N:N `badges` via `user_badges`
- `quizzes` 1:N `live_sessions`; `live_sessions` 1:N `live_players` (**Fase 2**)

## Fluxo de publicação

1. Usuário autenticado cria quiz privado e em rascunho.
2. Editor grava perguntas e alternativas; grava gabaritos por `set_answer_key()`.
3. O servidor executa `publish_quiz()`, que valida existência de perguntas, alternativas e gabaritos.
4. O quiz fica publicado e suas questões não podem ser modificadas via políticas RLS. Para revisão, criar uma nova versão / duplicar (etapa de UI).
5. A listagem de exploração mostra apenas quizzes públicos publicados; `unlisted` acessível por link direto.

## Fluxo solo

1. Página lê quiz e questões publicadas; `answer_keys` nunca retorna ao navegador.
2. `start_solo_attempt(quiz_id, guest_token?)` cria tentativa com identidade autenticada ou token aleatório.
3. `submit_solo_answer(...)` serializa a tentativa por bloqueio de linha, verifica sequência e prazo, corrige e devolve feedback com explicação.
4. A pontuação usa multiplicadores 1; 1,2; 1,5; 2 e velocidade baseada no cronômetro do servidor.
5. A última resposta marca a tentativa como `completed`.

## Contratos que serão completados na etapa 4

- Autossave com debouncing, indicação visual de sincronização e prevenção de conflito entre abas.
- Cálculo persistido de XP, sequência diária e distribuição de badges por conclusão, via funções auditáveis no banco.
- Recurso para duplicar quizzes publicados e criar versões; arquivar com validação de propriedade.
- Proteção antiabuso de RPCs de convidados (rate limiting fora do banco), limites de tamanho e verificação de arquivos, URLs e URLs de capa.
- Exposição do resultado de convidado via token, com função protegida; consulta `attempts` direta só para usuários autenticados.
- Entrada nos quizzes por PIN de seis dígitos será implementada na Fase 2 para salas ao vivo; no MVP, compartilhar por link e QR.

## Checklist de segurança

- Não incluir service-role key em `NEXT_PUBLIC_*` nem no bundle.
- Auditoria de políticas RLS com usuário A, usuário B, convidado e anônimo.
- Ativar restrições de tamanho/quantidade e validação de conteúdo no upload.
- Não expor gabaritos em objetos de página, cache, logs ou JSON de pré-carregamento.
- Políticas de Storage por prefixo de UUID; produção deve separar arquivos privados do editor dos publicados.
- Executar testes E2E de corrida no RPC (dupla submissão e perguntas fora de ordem).

## Fontes técnicas

- https://supabase.com/docs/guides/auth/server-side/creating-a-client?framework=nextjs&queryGroups=framework&router=app
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://supabase.com/docs/guides/realtime/postgres-changes
