import {describe,it,expect} from 'vitest';
import {scoreAnswer,comboMultiplier} from '../game';
describe('pontuação do modo Solo',()=>{
 it('não dá pontos por erro',()=>expect(scoreAnswer({correct:false,remaining:15,duration:15,combo:1})).toBe(0));
 it('dá mil pontos para resposta instantânea',()=>expect(scoreAnswer({correct:true,remaining:15,duration:15,combo:1})).toBe(1000));
 it('paga metade da base ao final do cronômetro',()=>expect(scoreAnswer({correct:true,remaining:0,duration:15,combo:1})).toBe(500));
 it('aplica marcos de combo iguais ao SQL',()=>{expect(comboMultiplier(2)).toBe(1);expect(comboMultiplier(3)).toBe(1.2);expect(comboMultiplier(5)).toBe(1.5);expect(comboMultiplier(8)).toBe(2)});
 it('limita tempo restante ao intervalo válido',()=>expect(scoreAnswer({correct:true,remaining:40,duration:15,combo:1})).toBe(1000));
});
