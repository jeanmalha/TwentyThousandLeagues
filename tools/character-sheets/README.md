# Character sheets

A local viewer for the cast's design sheets. It works offline and has no dependencies.

```sh
python3 -m http.server 8000 -d tools/character-sheets
# then open http://localhost:8000
```

Opening `index.html` directly in a browser also works.

- **Data:** `characters.js`, one entry per character. Every quote is verbatim from the French original (`docs/source/verne/fr-verne-5097.txt`); `node tools/character-sheets/check-quotes.mjs` checks them against the text.
- **Art:** drop a portrait at `art/<id>.png` (for example `art/nemo.png`) and it replaces the placeholder silhouette.
- **References:** `I-8` means Part 1, chapter VIII.
