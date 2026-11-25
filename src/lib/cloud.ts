import type {Quiz} from './data';
export type CloudQuestion={id:string;text:string;options:{id:string;label:string}[];seconds:number;explanation:string};
export type CloudQuiz={id:string;title:string;description:string;category:string;difficulty:string;questions:CloudQuestion[]};
async function req<T>(url:string,options?:RequestInit):Promise<T>{const res=await fetch(url,{...options,headers:{'Content-Type':'application/json',...options?.headers}});const body=await res.json().catch(()=>({}));if(!res.ok)throw Error(body.error||'Falha na comunicação com o servidor.');return body as T;}
export async function publishToCloud(quiz:Quiz){const result=await req<{id:string}>('/api/quizzes',{method:'POST',body:JSON.stringify(quiz)});return result.id;}
export async function fetchCloudQuiz(id:string){return req<CloudQuiz>('/api/quizzes/'+encodeURIComponent(id));}
export async function startCloudAttempt(quizId:string){return req<{attemptId:string;guestToken:string|null}>('/api/attempts',{method:'POST',body:JSON.stringify({quizId})});}
export async function submitCloudAnswer(attemptId:string,questionId:string,optionId:string|null,guestToken:string|null){return req<{correct:boolean;points:number;combo:number;explanation:string;correct_answer:string;finished:boolean}>('/api/attempts/'+encodeURIComponent(attemptId)+'/answers',{method:'POST',body:JSON.stringify({questionId,optionId,guestToken})});}
