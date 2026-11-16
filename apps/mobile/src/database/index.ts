import { Database } from '@nozbe/watermelondb';
import SQLiteAdapter from '@nozbe/watermelondb/adapters/sqlite';
import { schema } from './schema';
import { modelClasses } from './models';
import { migrations } from './migrations';

export const database = new Database({
  adapter: new SQLiteAdapter({
    schema,
    migrations,
    dbName: 'luto',
    jsi: true,
    onSetUpError: (error: Error) => { console.error('Luto database setup failed', error); },
  }),
  modelClasses,
});
