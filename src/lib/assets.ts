// Catálogo de paths; importável pelo Next.js quando o aplicativo for implementado.
export const ASSETS = {
  mascot: {
    hero: '/assets/mascote/fenara-hero.png',
    thinking: '/assets/mascote/fenara-pensando.png',
    correct: '/assets/mascote/fenara-feliz-acerto.png',
    wrong: '/assets/mascote/fenara-ops-erro.png',
    champion: '/assets/mascote/fenara-campea.png',
    reading: '/assets/mascote/fenara-lendo.png',
    creator: '/assets/mascote/fenara-criadora.png',
    sleeping: '/assets/mascote/fenara-dormindo.png',
    running: '/assets/mascote/fenara-correndo.png',
    sad: '/assets/mascote/fenara-triste-leve.png',
    avatar: '/assets/mascote/fenara-avatar.png',
    horizontalLogo: '/assets/mascote/fenara-logo-horizontal.png',
  },
  backgrounds: {
    light: '/assets/fundos/fundo-claro-creme.png',
    dark: '/assets/fundos/fundo-escuro-azul-noite.png',
    stage: '/assets/fundos/palco-podio.png',
  },
  theme: (slug: string) => `/assets/temas/${slug}.png`,
  categoryIcon: (slug: string) => `/assets/icones/${slug}.svg`,
  badge: (slug: string) => `/assets/badges/${slug}.png`,
  fx: (name: string) => `/assets/fx/${name}.png`,
  placeholder: (name: string) => `/assets/placeholders/${name}.svg`,
} as const;
