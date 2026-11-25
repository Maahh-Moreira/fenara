import type {NextAuthOptions} from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
import GoogleProvider from 'next-auth/providers/google';
import bcrypt from 'bcryptjs';
import {prisma} from './prisma';
const google=process.env.GOOGLE_CLIENT_ID&&process.env.GOOGLE_CLIENT_SECRET ? [GoogleProvider({clientId:process.env.GOOGLE_CLIENT_ID,clientSecret:process.env.GOOGLE_CLIENT_SECRET})] : [];
export const authOptions:NextAuthOptions={
 providers:[CredentialsProvider({name:'E-mail e senha',credentials:{email:{label:'E-mail',type:'email'},password:{label:'Senha',type:'password'}},async authorize(credentials){
  if(!credentials?.email||!credentials.password)return null;
  const user=await prisma.user.findUnique({where:{email:credentials.email.toLowerCase().trim()}});
  if(!user?.passwordHash||!await bcrypt.compare(credentials.password,user.passwordHash))return null;
  return {id:user.id,email:user.email,name:user.name};
 }}),...google],
 session:{strategy:'jwt',maxAge:30*24*60*60},
 pages:{signIn:'/'},
 callbacks:{
  async signIn({user,account}){if(account?.provider!=='google')return true;const email=user.email?.trim().toLowerCase();if(!email)return false;const existing=await prisma.user.findUnique({where:{email}});
   // OAuth email must be verified by Google, and only linked for accounts without a password.
   if(existing?.passwordHash)return false;
   const record=existing??await prisma.user.create({data:{email,name:user.name,profile:{create:{}}}});
   user.id=record.id;return true;},
  async jwt({token,user}){if(user)token.uid=user.id;return token;},
  async session({session,token}){if(session.user){(session.user as typeof session.user & {id:string}).id=String(token.uid??'');}return session;}
 },secret:process.env.NEXTAUTH_SECRET
};
export async function getUserId(session:{user?:{email?:string|null}}|null){
 const email=session?.user?.email;if(!email)return null;const user=await prisma.user.findUnique({where:{email:email.toLowerCase()}});return user?.id??null;
}
