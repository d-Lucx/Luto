import { schemaMigrations, createTable } from '@nozbe/watermelondb/Schema/migrations';
import { localStateTables } from './localStateSchema';
export const migrations = schemaMigrations({ migrations: [
  { toVersion: 2, steps: localStateTables.map((table) => createTable(table)) },
] });
