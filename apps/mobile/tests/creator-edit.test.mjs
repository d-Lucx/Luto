import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
import ts from 'typescript';

// Exercise the real mapper without loading native React/Watermelon modules.
const source = fs.readFileSync(new URL('../app/recipes/new.tsx', import.meta.url), 'utf8');
const ast = ts.createSourceFile('new.tsx', source, ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
const mapper = ast.statements.find((node) => ts.isFunctionDeclaration(node) && node.name?.text === 'createEditDraft');
assert.ok(mapper);
const compiled = ts.transpileModule(mapper.getText(ast).replace('export ', ''), { compilerOptions: { target: ts.ScriptTarget.ES2022 } }).outputText;
const createEditDraft = vm.runInNewContext(compiled + '\ncreateEditDraft');
const plain = (value) => JSON.parse(JSON.stringify(value));

test('edit hydration reads getter fields and preserves media and exact timer seconds', () => {
  class Requirement {
    get ingredientId() { return 'onion'; } get amount() { return 2; } get unit() { return 'piece'; }
    get isOptional() { return false; } get tier() { return 1; }
  }
  const steps = [
    { stepNumber: 3, instruction: 'Finish', timerDurationSeconds: 0, mediaUrl: null, localMediaUri: null },
    { stepNumber: 1, instruction: 'Cook', timerDurationSeconds: 90, mediaUrl: 'https://example.com/step.mp4', localMediaUri: 'file:///step.mp4' },
  ];
  const draft = plain(createEditDraft({ title: 'Onions', description: 'Cook onions', servings: 2 }, [new Requirement()], steps,
    [{ id: 'onion', displayName: 'Onions' }], [{ id: 'pan', canonicalName: 'pan' }],
    { prepTimeMinutes: 5, cookTimeMinutes: 8, category: 'Sides', difficulty: 'medium', cuisineTags: ['Filipino'], equipment: [{ canonicalName: 'pan', name: 'Pan' }] }));
  assert.deepEqual(draft.selectedIngredients, [{ ingredientId: 'onion', name: 'Onions', amount: '2', unit: 'piece', isOptional: false, tier: 1 }]);
  assert.equal(draft.recipeSteps[0].instruction, 'Cook');
  assert.equal(draft.recipeSteps[0].originalTimerSeconds, 90);
  assert.equal(draft.recipeSteps[0].timerMinutes, '2');
  assert.equal(draft.recipeSteps[0].mediaUrl, steps[1].mediaUrl);
  assert.equal(draft.recipeSteps[0].localMediaUri, steps[1].localMediaUri);
  assert.equal(steps[0].stepNumber, 3);
  assert.deepEqual(draft.selectedEquipmentIds, ['pan']);
  assert.equal(draft.category, 'Sides');
  assert.equal(draft.cuisine, 'Filipino');
});

test('legacy local recipes receive editable metadata defaults', () => {
  const draft = plain(createEditDraft({ title: 'Legacy', description: '', servings: 4 }, [], [], [], [], {}));
  assert.equal(draft.prepMinutes, '0');
  assert.equal(draft.cookMinutes, '0');
  assert.equal(draft.category, 'Main course');
  assert.equal(draft.difficulty, 'easy');
  assert.deepEqual(draft.selectedEquipmentIds, []);
});
