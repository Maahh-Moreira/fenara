import {PrismaClient} from '@prisma/client';
import {quizzes,categories,templates} from '../src/lib/data';
const prisma=new PrismaClient();
const slug=(value:string)=>value.normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'');
async function main(){
for(const c of categories)await prisma.category.upsert({where:{name:c.name},update:{},create:{name:c.name,slug:slug(c.name),emoji:c.emoji,tone:c.tone}});
for(const t of templates)await prisma.quizTemplate.upsert({where:{name:t.name},update:{},create:{name:t.name,description:t.desc,category:t.category}});
for(const c of categories)await prisma.theme.upsert({where:{name:c.name},update:{},create:{name:c.name,palette:{primary:'#FF5A00',background:'#FFF6E8',tone:c.tone}}});
const names=[['primeiro-quiz','Primeiro Quiz'],['sequencia-7-dias','Sequência de 7 dias'],['cem-por-cento','100% de acerto'],['criador','Criador'],['velocista','Velocista'],['mestre-combo','Mestre do Combo'],['explorador','Explorador'],['campeao','Campeão'],['estudioso','Estudioso'],['maratonista','Maratonista']];
for(const [key,name] of names)await prisma.badge.upsert({where:{slug:key},update:{},create:{slug:key,name,description:'Conquistas da Fenara'}});
for(const quiz of quizzes.slice(0,6)){
 const key='demo-'+quiz.id;const existing=await prisma.quiz.findUnique({where:{slug:key}});if(existing)continue;
 const category=await prisma.category.findUnique({where:{name:quiz.category}});
 await prisma.quiz.create({data:{slug:key,title:quiz.title,description:quiz.description,difficulty:quiz.difficulty,cover:quiz.cover,categoryId:category?.id,status:'published',visibility:'public',questions:{create:quiz.questions.map((q,position)=>({position,text:q.text,seconds:q.seconds,explanation:q.explanation,options:{create:q.options.map((label,i)=>({position:i,label,correct:i===q.answer}))}}))}}});
}
console.log('FENARA: 12 categorias, 12 temas, 6 modelos, 10 medalhas e seis quizzes de dez questões.');}
main().finally(()=>prisma.$disconnect());
