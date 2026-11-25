export type EditableQuestion = {text: string; options: string[]; answer: number};
export type EditableQuiz = {title: string; questions: EditableQuestion[]};

/** Validates the currently supported four-option multiple choice editor. */
export function validateQuizDraft(quiz: EditableQuiz): {valid: true}|{valid: false; message: string; questionIndex?: number} {
  if (!quiz.title.trim()) return {valid: false, message: 'Dê um título ao quiz antes de salvar.'};
  if (quiz.questions.length === 0) return {valid: false, message: 'Adicione pelo menos uma pergunta.'};
  for (let index = 0; index < quiz.questions.length; index++) {
    const q = quiz.questions[index];
    if (!q.text.trim() || q.options.length < 2 || q.options.length > 4 || q.options.some(option => !option.trim()) || !Number.isInteger(q.answer) || q.answer < 0 || q.answer >= q.options.length) {
      return {valid: false, questionIndex: index, message: `Revise o enunciado e as alternativas da pergunta ${index + 1}.`};
    }
  }
  return {valid: true};
}
