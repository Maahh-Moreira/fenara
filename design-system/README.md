# FENARA — Engenharia reversa visual do mockup aprovado

## Fonte de verdade

Imagem de referência: `docs/mockup-aprovado.png` (1672 × 941). Trata-se de uma composição conceitual, **não** de uma especificação de pixel perfeito. O código interpreta a arte para resoluções reais e navegação interativa.

### Anatomia observada

1. **Desktop / Home**, topo esquerdo: navbar branca com logo à esquerda, navegação no centro e notificações/avatar à direita; hero creme com headline laranja/marrom e mascote grande; duas CTAs; seis cartões coloridos para categorias; três cards de quiz com capa, assunto, quantidade de questões e botão de jogar.
2. **Jogo**, topo centro: fundo púrpura/laranja, barra de progresso, pontuação, cronômetro circular, enunciado creme, alternativas A/B/C/D com formas geométricas e mascote pensando.
3. **Resultado**, topo direito: fundo roxo e confetes, mascote comemorando, três estrelas, painel de métricas e CTAs de revisão e replay.
4. **Editor**, meio: navegação lateral, status de salvamento, abas, lista de perguntas, formulário, alternativas editáveis, explicação e publicação.
5. **Perfil**, inferior esquerdo: avatar circular, progresso de XP, indicador de sequência, métricas e medalhas.
6. **Dark**, inferior centro: home com fundo azul-noite/roxo e preservação da linguagem laranja.
7. **404**, inferior centro/direita: deserto creme/laranja e mascote com expressão gentil.
8. **Mobile**, extremo direito: menu superior compacto, hero empilhado, cards horizontais e barra de navegação inferior.

### Tokens adotados

| Uso | Cor |
|---|---|
| Primária | `#FF5A00` |
| Secundária | `#FFB95A` |
| Apoio | `#FFD98A` |
| Fundo creme | `#FFF6E8` |
| Ferrugem/outline | `#8A2200` |
| Texto | `#0B1220` |
| Alternativa B | `#0E7C86` |
| Alternativa C | `#FFB000` |
| Alternativa D | `#3B3FA8` |

Tipografia: Nunito (Google Fonts) com pesos 700–1000. Cantos arredondados 12–28 px. Botões possuem sombra sólida inferior e deslocamento no clique. Cards têm borda espessa e sombra curta.

### Arquitetura de apresentação

- `src/app/page.tsx`: rotas de experiência client-side do protótipo visual, navegação, editor e modo solo.
- `src/app/globals.css`: tokens, layouts, componentes, estados, responsividade e motion reduction.
- `src/lib/data.ts`: 6 quizzes de demonstração com 10 perguntas cada, categorias e modelos.
- `src/lib/assets.ts`: referência única de assets.
- `public/assets/mascote`: arquivos PNG do pacote do mascote recortados da prancha, sem alterar seus desenhos.

### Estados e interações já demonstráveis

Busca, filtros, favoritos, navegação, seleção de modelos, criação/edição de perguntas, autosave em localStorage, pré-visualização, execução de quiz com timer, combos, feedback, resultado, revisão, estatísticas e tema escuro.

### Limites desta etapa

O protótipo é **visual e local**. O banco SQL já está no pacote, mas o Next.js ainda não se conecta ao Supabase. Login com e-mail/Google, multiplayer, QR/PIN real, social sharing com URLs roteadas, áudio e PWA instalável requerem implementação/integracão posterior. O editor local suporta múltipla escolha; os demais tipos fazem parte da etapa funcional futura. Os sprites provenientes de prancha podem exibir margens brancas e deverão ser substituídos por arquivos finais independentes.
