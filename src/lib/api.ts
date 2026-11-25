import {getServerSession} from 'next-auth';
import {authOptions,getUserId} from './auth';
export async function currentUserId(){return getUserId(await getServerSession(authOptions));}
export function jsonError(error:string,status=400){return Response.json({error},{status});}
