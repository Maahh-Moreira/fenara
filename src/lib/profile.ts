/** Profile helpers shared by portfolio/demo UI and future persistent backend. */
export type PlayHistoryEntry = {id: string; score: number; accuracy: number; date: string};

function localDayKey(date: Date): string {
  const yyyy = date.getFullYear();
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const dd = String(date.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

/** Count consecutive played days, including a streak continued yesterday. */
export function calculateStreak(entries: PlayHistoryEntry[], now = new Date()): number {
  const days = new Set(entries
    .map(entry => new Date(entry.date))
    .filter(date => !Number.isNaN(date.getTime()))
    .map(localDayKey));
  let count = 0;
  for (let offset = 0; offset < 365; offset++) {
    const day = new Date(now.getFullYear(), now.getMonth(), now.getDate() - offset);
    if (days.has(localDayKey(day))) count++;
    else if (offset === 0) continue;
    else break;
  }
  return count;
}
