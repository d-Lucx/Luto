import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';
import { mkdir, writeFile } from 'node:fs/promises';
const require = createRequire(import.meta.url);
const Jimp = require('jimp-compact');
const { generateFaviconAsync } = require('@expo/image-utils');
const brand = fileURLToPath(new URL('../assets/brand/', import.meta.url));
const web = fileURLToPath(new URL('../../web/', import.meta.url));
const paper = '#F7F1E7';
const source = await Jimp.read(`${brand}/lu2-symbol-source.png`);
let left = source.bitmap.width, top = source.bitmap.height, right = 0, bottom = 0;
source.scan(0, 0, source.bitmap.width, source.bitmap.height, function (x, y, i) {
  if (this.bitmap.data[i + 3] > 16) {
    left = Math.min(left, x); top = Math.min(top, y);
    right = Math.max(right, x); bottom = Math.max(bottom, y);
  }
});
const symbol = source.clone().crop(left, top, right - left + 1, bottom - top + 1);
function square(size, fraction, background) {
  const mark = symbol.clone().contain(Math.round(size * fraction), Math.round(size * fraction));
  return new Jimp(size, size, background).composite(mark, Math.round((size - mark.bitmap.width) / 2), Math.round((size - mark.bitmap.height) / 2));
}
// Android's central 66/108 circle is the guaranteed adaptive mask safe area.
// A 0.43 square fits its diagonal inside that circle; full-bleed paper is separate.
await square(1024, 0.43, 0x00000000).writeAsync(`${brand}/lu2-adaptive-foreground.png`);
await square(1024, 0.76, paper).writeAsync(`${brand}/lu2-app-icon.png`);
await mkdir(`${web}/assets`, { recursive: true });
for (const size of [32, 192]) await square(size, 0.84, paper).writeAsync(`${web}/assets/lu2-icon-${size}.png`);
await square(180, 0.8, paper).writeAsync(`${web}/assets/apple-touch-icon.png`);
const favicon = await square(256, 0.84, paper).getBufferAsync(Jimp.MIME_PNG);
await writeFile(`${web}/favicon.ico`, await generateFaviconAsync(favicon, [16, 32, 48]));
console.log('Generated square Lu2 favicon, touch icon, legacy launcher and adaptive foreground.');
