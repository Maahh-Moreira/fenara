# FENARA — Protótipo visual navegável

Implementação visual inspirada no mockup aprovado, com componentes interativos e banco Supabase da etapa 2 preservado.

## Como executar

Requer Node.js 20+.

```bash
npm install
npm run dev
```

Acesse http://localhost:3000.

## Funcionalidades disponíveis

Home, explorar, detalhes, favoritos, catálogo de modelos, dashboard de criador, editor de múltipla escolha (autosave local), modo Solo com timer e combo, feedback e explicações, resultado e revisão, perfil com histórico local, medalhas, tema escuro, e configurações.

Os dados locais ficam no `localStorage` do navegador. Quizzes criados em modo demonstração não são publicados no Supabase.

## Banco de dados

`supabase/migrations` e `supabase/seed.sql` da etapa 2 estão incluídos para a integração futura. **Não execute** migrations diretamente em bancos de outros projetos sem revisão. Ver `docs/ARQUITETURA.md`.

## Arquivos visuais

`public/assets/mascote/` contém o mascote anterior e recortes das figuras já geradas. `src/lib/assets.ts` centraliza caminhos. Use arquivos independentes finais para substituir os recortes, mantendo nomes.

## Próximo passo

Conectar os componentes ao Supabase e implementar autenticação real, Storage, tipos adicionais de pergunta, RLS testada, publicação e compartilhamento persistente. Em seguida: acessibilidade WCAG AA e suíte automatizada.

## Limitações

Este é um protótipo front-end com lógica de jogo local, **não** um produto pronto para produção. O botão de login com e-mail não autentica; não há Google OAuth. O QR é uma representação de link e não uma sala PIN real. Não há PWA nem backend conectado. Nenhum dado secreto é necessário para testar o front-end.
