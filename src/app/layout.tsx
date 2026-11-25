import Providers from './providers';
import type {Metadata} from 'next';
import './globals.css';
export const metadata:Metadata={
 title:'FENARA | Quizzes para mentes curiosas',
 description:'Jogue, crie e explore quizzes gamificados com a Fenara, a raposinha do deserto.',
 applicationName:'FENARA',
 metadataBase:new URL(process.env.NEXT_PUBLIC_SITE_URL || (process.env.VERCEL_URL ? 'https://'+process.env.VERCEL_URL : 'http://localhost:3000')),
 openGraph:{title:'FENARA — Aprenda brincando',description:'Um universo de quizzes gamificados e criatividade.',type:'website',images:['/assets/mascote/fenara-hero.png']},
 robots:{index:true,follow:true}
};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="pt-BR"><body><Providers>{children}</Providers></body></html>}
