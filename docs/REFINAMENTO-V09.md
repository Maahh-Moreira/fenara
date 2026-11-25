# FENARA — Revisão de produto e interface v0.9

## Direção de arte

A versão mantém a paleta institucional, botões com sombra sólida, contornos arredondados e as poses originais da Fenara. A composição foi reorganizada para evitar repetições de mascotes na mesma navegação e priorizar texto legível, ilustração em escala adequada e equilíbrio de cores.

### Imagens e ilustrações

- As seis capas principais são **artes SVG originais**, criadas para este projeto em `public/assets/capas/` (`space.svg`, `science.svg`, `movies.svg`, `history.svg`, `earth.svg`, `technology.svg`). Não são mais recortes ampliados do mockup.
- As categorias adicionais usam composições vetoriais renderizadas com ícones Lucide, sem dependência de emojis.
- As imagens dos mascotes mantêm seus arquivos PNG transparentes. O componente recebe agora a proporção intrínseca correta para evitar redução e distorção em caixas quadradas.
- A Fenara aparece em papéis diferentes: leitura na home, corrida em Explorar, criação no seletor de modelos, campeonato no perfil, reflexão durante o jogo e comemoração no resultado.

## Comportamentos corrigidos

- Sidebar simplificado: uma entrada por destino, sem a marca repetida.
- Footer mais discreto e sem emoji decorativo.
- Perfil: XP, histórico, sequência diária e conquistas derivadas dos dados locais; itens pendentes sinalizados como tal.
- Editor: valida título, enunciados, alternativas e gabaritos antes de salvar/publicar; atalhos de editor levam a seções reais, sem abas fictícias.
- Modo claro e escuro recebem tratamentos específicos para banners, textos, ações e painéis.
- Capas dos quizzes de demonstração não dependem de capturas de tela redimensionadas.

## Validação / limites

- A verificação de sintaxe TSX/TS e de análise de CSS foi realizada; funções auxiliares de validação e streak foram executadas em testes diretos.
- Os testes automatizados Vitest foram adicionados para `profile.ts` e `quiz-validation.ts`.
- **Build real de Next.js, testes end-to-end e conferência pixel a pixel na Vercel ainda dependem de `npm install`** em ambiente com acesso às dependências.
- A versão de portfólio mantém persistência local. PostgreSQL, autenticação real e publicação multiusuário continuam arquitetura de desenvolvimento, não recursos comprovados como prontos para uso público.
