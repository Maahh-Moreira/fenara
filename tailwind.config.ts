import type { Config } from 'tailwindcss';
const config: Config = {content:['./src/**/*.{js,ts,jsx,tsx,mdx}'],theme:{extend:{colors:{fenara:{orange:'#FF5A00',amber:'#FFB95A',butter:'#FFD98A',cream:'#FFF6E8',rust:'#8A2200',night:'#0B1220'}},borderRadius:{fenara:'24px'},fontFamily:{sans:['Nunito','Arial','sans-serif']}}},plugins:[]};
export default config;
