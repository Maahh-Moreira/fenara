<div align="center">

<img src="public/assets/mascote/fenara-original.png" alt="Fenara — mascote original" width="170" />

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

### Identidade visual

| Cor | Hex | Aplicação |
|:--|:--|:--|
| Laranja Fenara | `#FF5A00` | CTAs e destaques |
| Âmbar | `#FFB95A` | Ilustrações e apoio |
| Creme | `#FFF6E8` | Fundos claros |
| Marrom-ferrugem | `#8A2200` | Contornos e sombras sólidas |
| Azul-noite | `#0B1220` | Textos e modo escuro |

**Mascote:** fennec de orelhas amplas, pelagem laranja, interior das orelhas creme, olhos expressivos e cel-shading. Os PNGs do projeto possuem transparência para permitir o uso sobre fundos claros e escuros.

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

## Como executar

### 1. Demonstração local (sem banco de dados)

Tenha Node.js e npm instalados. Clone o repositório:

```bash
git clone https://github.com/Maahh-Moreira/fenara.git
cd fenara
npm install
```

Crie o `.env.local` a partir de `.env.portfolio.example` e habilite o modo demo:

```env
NEXT_PUBLIC_PORTFOLIO_DEMO=true
```

No Windows PowerShell, você pode copiar o arquivo com:

```powershell
Copy-Item .env.portfolio.example .env.local
```

Execute:

```bash
npm run dev
```

Abra **http://localhost:3000**.

### 2. Ambiente com PostgreSQL

1. Crie um banco PostgreSQL (você pode administrá-lo com o pgAdmin).
2. Preencha `.env` / `.env.local` usando `.env.example`, com `DATABASE_URL` e segredo de sessão.
3. Desative `NEXT_PUBLIC_PORTFOLIO_DEMO`.
4. Prepare o banco e execute:

```bash
npm install
npx prisma migrate deploy
npm run db:seed
npm run dev
```

**Não envie arquivos `.env` ou senhas para o GitHub.** Consulte `docs/PUBLICAR-PORTFOLIO.md` para publicar na Vercel.

## Estrutura do projeto

```text
fenara/
├── public/assets/mascote/   # PNGs da Fenara com transparência
├── src/app/                 # Interface e rotas da aplicação
│   ├── page.tsx             # Telas e fluxos do protótipo
│   ├── globals.css          # Design e responsividade
│   └── api/                 # Backend no modo PostgreSQL
├── src/lib/                 # Assets, dados, jogo, APIs e autenticação
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

*Desafie sua curiosidade.* 🦊

</div>
