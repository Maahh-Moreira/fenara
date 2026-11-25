# FENARA: GitHub + demonstração pública

## Duas configurações do mesmo código

**Demonstração sem banco** (recomendada primeiro): `NEXT_PUBLIC_PORTFOLIO_DEMO=true`. Os seis quizzes incluídos no aplicativo funcionam com cronômetro, combo, explicação, resultados e revisão de erros. É possível criar rascunhos e editar perguntas. Rascunhos, favoritos e histórico ficam no `localStorage` do navegador, portanto **não são compartilhados entre visitantes**. Não há login real, publicação global nem banco. O botão do editor salva apenas localmente.

**Aplicação com PostgreSQL**: omita `NEXT_PUBLIC_PORTFOLIO_DEMO` ou use `false`; configure `DATABASE_URL`, `NEXTAUTH_SECRET` e `NEXTAUTH_URL` e execute as migrations. Isto libera as rotas completas já implementadas no projeto original; outras funcionalidades continuam em desenvolvimento, conforme README.

## A. Testar o portfólio no computador

```bash
# na pasta fenara-site
cp .env.portfolio.example .env.local
npm install
npm run dev
```

No Windows PowerShell, use `Copy-Item .env.portfolio.example .env.local`. Abra http://localhost:3000. Teste jogar quiz, resultado, criar e editar rascunho, atualizar a página e recuperar o rascunho.

## B. Enviar ao GitHub

Crie um repositório vazio chamado `fenara` na sua conta GitHub. Na pasta fenara-site:

```bash
git init
git add .
git commit -m "feat: FENARA demo interativa para portfolio"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/fenara.git
git push -u origin main
```

O arquivo `.env.local` nunca deve ser enviado; confira `git status` antes do commit. Faça o projeto público apenas após revisar o código, licenças e segredos.

## C. Publicar no Vercel (sem banco)

1. Abra https://vercel.com/new e importe o repositório.
2. Framework Preset: Next.js; Root Directory: raiz do repositório (`fenara-site` se você subiu a pasta externa, ou `.` se subiu o conteúdo dela).
3. Em Environment Variables (Production e Preview), adicione `NEXT_PUBLIC_PORTFOLIO_DEMO=true`.
4. Adicione `NEXTAUTH_SECRET` com um segredo aleatório forte (não use o exemplo).
5. Deploy. A Vercel fornece uma URL `*.vercel.app`.
6. Após a primeira publicação, configure `NEXT_PUBLIC_SITE_URL=https://SEU-PROJETO.vercel.app` e faça novo deploy se desejar OG URLs canônicas.
7. Teste em aba anônima e no celular. Não publique `DATABASE_URL` local.

> NEXT_PUBLIC_* é incorporado no build. Após trocar o modo, faça redeploy.

## D. Migrar para demonstração pública persistente

1. Hospede PostgreSQL online (Neon, Prisma Postgres, Railway ou outro provedor). **Não conecte a Vercel ao PostgreSQL do seu computador.**
2. Defina `NEXT_PUBLIC_PORTFOLIO_DEMO=false`, `DATABASE_URL`, `NEXTAUTH_SECRET` e `NEXTAUTH_URL` na Vercel, apenas como Environment Variables, nunca no GitHub.
3. Aplique `npx prisma migrate deploy` à instância online num ambiente seguro, antes de usar o app, e execute `npm run db:seed` se desejar os quizzes no banco.
4. Teste o cadastro, login, publicação, proteção de dados e fluxo de respostas. Configure Google OAuth somente se precisar.
5. Antes de aceitar usuários públicos, implemente rate limiting, fluxo de recuperação de conta, verificações de autorização e testes de integração.

## E. Manutenção

```bash
git add .
git commit -m "feat: melhorias na experiencia de quiz"
git push
```

A Vercel atualiza o site depois do push na branch configurada.

## Checklist da demonstração

- [ ] Home e imagens carregam
- [ ] Modo Solo: conta 3-2-1, tempo e correção sem tela separada
- [ ] Resultado e revisão dos erros
- [ ] Criar quiz, editar e recuperar rascunho após F5
- [ ] Favoritos e histórico persistem no mesmo navegador
- [ ] Tema escuro, menu mobile e teclado
- [ ] Aviso claro de que a demo salva dados apenas neste dispositivo
- [ ] Nenhuma senha, URL de banco local ou secret foi enviado ao GitHub
