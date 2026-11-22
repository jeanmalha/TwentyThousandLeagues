// Checks that every quote in characters.js appears verbatim in the French source text.
// Quotes may skip passages with " … "; each fragment is checked on its own.
// Usage: node tools/character-sheets/check-quotes.mjs
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import vm from "node:vm";

const here = dirname(fileURLToPath(import.meta.url));
const norm = s => s
  .replace(/[«»"“”_]/g, "")
  .replace(/[’]/g, "'")
  .replace(/\s+/g, " ")
  .replace(/ ([!?;:])/g, "$1")
  .trim()
  .toLowerCase();

const source = norm(readFileSync(join(here, "../../docs/source/verne/fr-verne-5097.txt"), "utf8"));
const ctx = { window: {} };
vm.runInNewContext(readFileSync(join(here, "characters.js"), "utf8"), ctx);

let failures = 0, checked = 0;
for (const c of ctx.window.CAST) {
  const quotes = [...(c.verne || []), ...((c.voice && c.voice.lines) || [])];
  for (const { q, ref } of quotes) {
    if (/^[A-Za-z ]+$/.test(q) && !/[éèàç]/.test(q) && q.split(" ").length < 3) continue; // e.g. "Go ahead"
    for (const frag of q.split(/\s*…\s*/).map(norm).map(f => f.replace(/[.,;:!?]+$/, "")).filter(f => f.length > 3)) {
      checked++;
      if (!source.includes(frag)) {
        failures++;
        console.error(`✗ ${c.id} (${ref}): "${frag}"`);
      }
    }
  }
}
console.log(`${checked - failures}/${checked} quote fragments found in the French text.`);
process.exit(failures ? 1 : 0);
