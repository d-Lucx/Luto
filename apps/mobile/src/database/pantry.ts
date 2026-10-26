import { Q } from '@nozbe/watermelondb';
import { database } from './index';
import { Ingredient, UserPantry, type StorageLocation } from './models';
import { LOCAL_GUEST_ID } from './constants';

export { LOCAL_GUEST_ID };

export async function setPantryQuantity(
  ingredient: Ingredient,
  quantity: number,
  storageLocation: StorageLocation,
): Promise<void> {
  if (!Number.isFinite(quantity) || quantity < 0) throw new RangeError('Quantity must be zero or greater');
  await database.write(async () => {
    const collection = database.get<UserPantry>('local_pantry');
    const existing = await collection.query(
      Q.where('user_id', LOCAL_GUEST_ID), Q.where('ingredient_id', ingredient.id),
    ).fetch();
    const item = existing[0];
    if (quantity === 0) {
      if (item) await item.markAsDeleted();
      return;
    }
    const assign = (record: UserPantry) => {
      record.userId = LOCAL_GUEST_ID;
      record.ingredientId = ingredient.id;
      record.quantity = quantity;
      record.unit = ingredient.defaultUnit;
      record.storageLocation = storageLocation;
      record.updatedAt = Date.now();
    };
    if (item) await item.update(assign);
    else await collection.create(assign);
  });
}
