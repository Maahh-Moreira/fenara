export function comboMultiplier(combo:number):1|1.2|1.5|2 {
 if(combo>=8)return 2;
 if(combo>=5)return 1.5;
 if(combo>=3)return 1.2;
 return 1;
}
export function scoreAnswer(params:{correct:boolean;remaining:number;duration:number;combo:number;base?:number}):number{
 const {correct,remaining,duration,combo,base=1000}=params;
 if(!correct||duration<=0)return 0;
 const timeRatio=Math.min(1,Math.max(0,remaining/duration));
 return Math.floor(base*(0.5+0.5*timeRatio)*comboMultiplier(combo));
}
