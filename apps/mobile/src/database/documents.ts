import { Q } from '@nozbe/watermelondb';
import { database } from './index';
import { LocalDocument } from './models';

export async function readDocument<T>(key: string): Promise<T | null> {
  const rows = await database.get<LocalDocument>('local_documents').query(Q.where('key', key)).fetch();
  return rows[0] ? JSON.parse(rows[0].payload) as T : null;
}
export async function writeDocument(key: string, value: unknown): Promise<void> {
  await database.write(async () => {
    const collection = database.get<LocalDocument>('local_documents');
    const rows = await collection.query(Q.where('key', key)).fetch();
    if (value === null) { if (rows[0]) await rows[0].markAsDeleted(); return; }
    if (rows[0]) await rows[0].update((r) => { r.payload = JSON.stringify(value); });
    else await collection.create((r) => { r.key = key; r.payload = JSON.stringify(value); });
  });
}
