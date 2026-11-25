import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = {title:'FENARA — Aprender nunca foi tão divertido!',description:'Explore, crie e jogue quizzes divertidos na FENARA.'};
export default function RootLayout({children}:{children:React.ReactNode}) {return <html lang="pt-BR"><body>{children}</body></html>}
