import {NextResponse} from 'next/server';
import bcrypt from 'bcryptjs';
import {z} from 'zod';
import {prisma} from '@/lib/prisma';
const schema=z.object({email:z.string().email().max(254),password:z.string().min(8).max(72),name:z.string().max(80).optional()});
export async function POST(request:Request){if(process.env.NEXT_PUBLIC_PORTFOLIO_DEMO==='true')return Response.json({error:'Recurso disponível somente no modo completo com PostgreSQL.'},{status:503});try{const input=schema.parse(await request.json());const email=input.email.toLowerCase().trim();const exists=await prisma.user.findUnique({where:{email}});if(exists)return NextResponse.json({error:'E-mail já cadastrado.'},{status:409});await prisma.user.create({data:{email,name:input.name||email.split('@')[0],passwordHash:await bcrypt.hash(input.password,12),profile:{create:{}}}});return NextResponse.json({ok:true},{status:201});}catch(e){if(e instanceof z.ZodError)return NextResponse.json({error:'Dados inválidos: senha mínima de 8 caracteres.'},{status:400});return NextResponse.json({error:'Não foi possível criar a conta.'},{status:500})}}
