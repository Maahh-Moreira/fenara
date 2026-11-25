import {describe,expect,it} from 'vitest';
import {calculateStreak} from '../profile';
import {validateQuizDraft} from '../quiz-validation';

describe('progresso do perfil', () => {
  it('não inventa streak para jogador novo', () => {
    expect(calculateStreak([], new Date('2026-11-25T12:00:00'))).toBe(0);
  });
  it('mantém streak se a última partida foi ontem', () => {
    const now = new Date(2026, 10, 25, 12);
    const history = [1, 2, 3].map(day => ({id:'demo',accuracy:90,score:1000,date:new Date(2026,10,25-day,12).toISOString()}));
    expect(calculateStreak(history, now)).toBe(3);
  });
});

describe('validação de quiz', () => {
  const good = {title:'Teste',questions:[{text:'Quanto é 2+2?',options:['2','4'],answer:1}]};
  it('permite um quiz com opções completas', () => expect(validateQuizDraft(good).valid).toBe(true));
  it('rejeita resposta em branco', () => expect(validateQuizDraft({...good,questions:[{...good.questions[0],options:['2','']}]}).valid).toBe(false));
  it('rejeita quiz sem título', () => expect(validateQuizDraft({...good,title:'   '}).valid).toBe(false));
});
