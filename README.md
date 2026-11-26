<div align="center">

<img src="public/assets/mascote/fenara-criadora.png" alt="Fenara — mascote original" width="170" />

# FENARA

### Aprenda, crie, desafie e evolua no seu ritmo.

Uma plataforma de **quizzes gamificados** criada para transformar curiosidade em aprendizado. Explore temas, enfrente perguntas contra o tempo, crie desafios e acompanhe suas conquistas — com a companhia da Fenara, nossa raposa-do-deserto.

[![Next.js](https://img.shields.io/badge/Next.js-0B1220?style=for-the-badge&logo=nextdotjs&logoColor=white)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=for-the-badge&logo=prisma&logoColor=white)](https://www.prisma.io/)

**[Repositório](https://github.com/Maahh-Moreira/fenara)** · **[Como executar](#como-executar)** · **[Estrutura](#estrutura-do-projeto)**

</div>

---

## Conheça a FENARA

A FENARA é uma experiência de quiz que une **diversão, criação e evolução**. Seu design é inspirado em jogos de perguntas e respostas, mas tem identidade própria: cores quentes, botões com profundidade, ilustrações vetoriais e um mascote expressivo com orelhas gigantes.

<div align="center">
  <img src="docs/mockup-aprovado.png" alt="Visão geral das telas da Fenara: início, partida, resultado, editor, perfil e mobile" width="100%" />
  <sub>Direção de arte do projeto — composição de referência das telas.</sub>
</div>

### O que você pode fazer

| Explore e jogue | Crie e personalize | Evolua e acompanhe |
|:--|:--|:--|
| Quizzes de vários assuntos | Editor de perguntas | Pontuação por velocidade |
| Busca e filtros por categoria | Modelos para começar | Combos de acertos |
| Cronômetro e feedback imediato | Rascunhos salvos automaticamente | Resultados e revisão |
| Interface responsiva | Capas, temas e explicações | Histórico, favoritos e XP locais |

### Experiência de jogo

- **Cronômetro e progresso**: perguntas com tempo limitado e progresso visível.
- **Respostas acessíveis**: alternativas identificadas por letra, cor e forma, não apenas cor.
- **Feedback sem interrupção**: acertos e erros aparecem na própria pergunta, com explicação curta.
- **Combo e velocidade**: acertos em sequência aumentam a pontuação.
- **Resultado**: confira desempenho, acertos, tempo médio e reveja as respostas.

### Direção visual e identidade

| Cor | Hex | Aplicação |
|:--|:--|:--|
| Laranja Fenara | `#FF5A00` | CTAs e destaques |
| Âmbar | `#FFB95A` | Ilustrações e apoio |
| Creme | `#FFF6E8` | Fundos claros |
| Marrom-ferrugem | `#8A2200` | Contornos e sombras sólidas |
| Azul-noite | `#0B1220` | Textos e modo escuro |

**Mascote:** uma raposa-do-deserto de orelhas enormes, pelagem laranja, rosto expressivo e cel-shading. As diferentes poses dão personalidade à jornada sem repetir a mesma ilustração em todas as telas.

**Capas dos quizzes:** o projeto traz artes SVG próprias e nítidas para Espaço/Cultura Geral, Ciências, Filmes e Séries, História, Geografia e Tecnologia. As outras categorias utilizam composições vetoriais escaláveis. Não há necessidade de ampliar recortes de baixa resolução do mockup.

**Modos claro e escuro:** ambos preservam os contrastes, as cores de feedback e a legibilidade dos banners, cards e formulários.

Para os detalhes da revisão de interface, veja [`docs/REFINAMENTO-V09.md`](docs/REFINAMENTO-V09.md).

---

## Demonstração e versão completa

O projeto foi estruturado para **dois ambientes**:

**Modo demonstração (portfólio):** não exige PostgreSQL. Os quizzes de exemplo funcionam no navegador; edição de rascunhos, favoritos, histórico e progresso são armazenados localmente. É ideal para conhecer a experiência. Os quizzes de exemplo podem ser compartilhados por link.

**Modo PostgreSQL:** usa Prisma, autenticação e APIs no servidor para contas, quizzes publicados e correção de tentativas. Algumas funcionalidades avançadas ainda precisam de integração e testes antes do uso público em produção.

> A demonstração não compartilha dados pessoais, rascunhos ou progresso entre dispositivos. A imagem acima é um mockup de referência, não uma captura de todas as funcionalidades já finalizadas.

## Tecnologias

**Interface:** Next.js (App Router), React, TypeScript, Tailwind CSS e Framer Motion.

**Dados e backend:** PostgreSQL, Prisma, API Routes do Next.js, NextAuth e Zod.

**Outros recursos:** Zustand, QR Code, Vitest e layout adaptável para celular e desktop.

## Estrutura do projeto

```text
fenara/
├── public/assets/mascote/   # PNGs da Fenara com transparência
├── public/assets/capas/     # Ilustrações SVG originais para quizzes
├── src/app/                 # Interface e rotas da aplicação
│   ├── page.tsx             # Telas e fluxos do protótipo
│   ├── globals.css          # Base do design system
│   ├── premium.css          # Refinamento visual e responsividade v0.9
│   └── api/                 # Backend no modo PostgreSQL
├── src/lib/                 # Assets, dados, jogo, APIs, autenticação e regras de validação
├── prisma/                  # Schema, migrations e seed
├── design-system/           # Guia de identidade visual
├── docs/                    # Mockup e publicação
└── .github/workflows/       # Verificações automáticas
```

## Roadmap

- [x] Identidade visual original e mascote Fenara
- [x] Home, exploração, editor e modo Solo para demonstração
- [x] Feedback direto na pergunta e tela de resultados
- [x] Modo portfólio sem banco de dados
- [ ] Validar integralmente os fluxos de autenticação e publicação do modo PostgreSQL
- [ ] Persistir conquistas e progresso compartilhados no backend
- [ ] Suportar todos os formatos de pergunta no editor
- [ ] Salas ao vivo, equipes e ranking em tempo real

---

<div align="center">

**FENARA** · Um projeto autoral de tecnologia, criatividade e aprendizado.

*Desafie sua curiosidade.*

</div>
