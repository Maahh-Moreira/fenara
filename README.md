# 🦊 FENARA — Quizzes gamificados

FENARA é uma plataforma de quizzes com identidade original, mascote fennec, desafios com cronômetro, pontuação por velocidade, combos, editor e histórico. Interface responsiva em português.

![Mockup aprovado da FENARA](docs/mockup-aprovado.png)

## Experimente a demonstração

Acesse a demonstração online depois de publicar na Vercel (adicione seu link aqui).

### Executar sem banco (portfólio)

```bash
cp .env.portfolio.example .env.local
npm install
npm run dev
```

Windows PowerShell: `Copy-Item .env.portfolio.example .env.local`. Abra `http://localhost:3000`.

**Na demonstração**: jogar quizzes, criar e editar rascunhos, favoritos e histórico são locais; dados persistem no navegador, não entre aparelhos. Login real e publicação compartilhada não estão disponíveis nesse modo.

### Executar com PostgreSQL

Copie `.env.example` para `.env` e `.env.local`, ajuste `DATABASE_URL`, crie um banco `fenara` no PostgreSQL (administrável via pgAdmin) e execute:

```bash
npm install
npx prisma migrate deploy
npm run db:seed
npm run dev
```

`NEXT_PUBLIC_PORTFOLIO_DEMO` deve estar ausente ou como `false` nesse caso.

## Stack

Next.js App Router · TypeScript · Tailwind CSS · Framer Motion · Zustand · Prisma · PostgreSQL · NextAuth · Zod · Vitest

## Estrutura

- `src/app/page.tsx`: home, exploração, editor, jogo, perfil e telas da aplicação
- `src/app/api`: backend HTTP (somente modo com banco)
- `src/lib/data.ts`: seis quizzes de demonstração
- `src/lib/assets.ts`: catálogo de imagens
- `public/assets`: imagens da mascote e placeholders
- `prisma`: schema, migrations e seed PostgreSQL
- `design-system`: guia visual
- `docs/PUBLICAR-PORTFOLIO.md`: publicação GitHub + Vercel, sem banco e com banco
- `.github/workflows/ci.yml`: verificação de tipo e testes em cada push

## Limitações e roadmap

O modo demonstração é intencionalmente isolado para não exigir um banco pago. O modo PostgreSQL tem cadastro, sessões, publicação e tentativas no servidor, mas ainda precisa de testes de integração completos, sincronização de alguns dados de perfil, demais tipos de pergunta e proteção operacional antes de uso público com contas reais.

### Próximos passos

1. Testes automatizados de fluxos e acessibilidade; corrigir possíveis erros de build.
2. Completar persistência de perfil, conquistas, favoritos e editor no PostgreSQL.
3. Adicionar recuperação de senha, moderação e limites de abuso.
4. Modo ao vivo e equipes (fase 2).

## Identidade visual

Laranja `#FF5A00` · Âmbar `#FFB95A` · Creme `#FFF6E8` · Marrom `#8A2200` · Azul-noite `#0B1220`. O mascote representa uma raposa-do-deserto original com orelhas gigantes.

> Projeto demonstrativo e autoral. Personalize os links e screenshots depois de publicar.
