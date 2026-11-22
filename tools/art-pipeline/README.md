# Art pipeline: local generation and pixelization

A concept-art and portrait-base pipeline running locally on Apple silicon. It produces **starting points** for hand cleanup in Aseprite or Pixelorama, not final assets.

## Setup (once)

```sh
uv tool install --python 3.12 mflux   # MLX image models; Apple silicon only
```

The first generation downloads the model to `~/.cache/huggingface` (Z-Image Turbo is several GB).

## Model

**Z-Image Turbo** (Tongyi-MAI, Apache 2.0, not gated) through `mflux-generate-z-image-turbo`.

FLUX.1 schnell (also Apache 2.0) is gated on Hugging Face. To use it, accept its terms at huggingface.co/black-forest-labs/FLUX.1-schnell, run `hf auth login`, and use `mflux-generate --model schnell`.

## Generate

```sh
cd tools/art-pipeline && source prompts.sh
mflux-generate-z-image-turbo --quantize 8 --steps 9 --width 768 --height 1024 \
  --seed 1868 --prompt "$NEMO, $STYLE" --output out/nemo.png
```

- Prompts in `prompts.sh` come from `tools/character-sheets/characters.js`. Describe things in words only: never use film, studio, game or artist names (see the rights notes in the GDD).
- Keep the `--seed` to reproduce an image, and change it to get variations.

## Pixelize

```sh
uv run pixelize.py out/nemo.png --size 144x192 --colors 32 --dither bayer --strength 0.4
uv run pixelize.py out/salon.png --size 320x144 --palette master.gpl --dither bayer
```

It crops to the target aspect, downscales, reduces colours to the master palette (`--palette`, a `.gpl` or hex list) or to N adaptive colours, applies ordered (`bayer`) or `fs` dithering, and writes an enlarged nearest-neighbour preview.

## Review, grade and rerun

```sh
python3 tools/art-pipeline/review/server.py    # then open http://localhost:8686
```

- Browse every image, switching between the original and the game-size version, or select several to compare side by side.
- Grade with 1–5 stars, a verdict (Keep, Maybe or Reject), a checklist and notes, all saved to `out/reviews.json`.
- **Rerun** opens the image's settings (model, prompt, style, seed, size, number of images) to edit and queue. **Same on other model** reruns it on the other model with the same seed.
- Jobs run one at a time, and wait if a generation started from the terminal is still running. New images are converted to game size automatically and recorded in `out/manifest.json`.

| Model | Portrait 576×768 | View 960×540 | Notes |
|---|---|---|---|
| FLUX.1 schnell 4-bit | ~1.5 min | ~2 min | Follows prompts closely (got the beret right); renders photorealistically |
| Z-Image Turbo | 13–15 min* | 15 min* | Painterly 90s look; ignores some details (keeps drawing a fur cap) |

\* Those Z-Image runs were swapping at 8-bit precision; the review tool runs it at 4-bit with low-RAM mode.

## Rules

- Generated images are bases. Every shipped asset gets substantial hand work, for consistency, palette discipline and authorship (pure AI output generally can't be copyrighted).
- Record AI use for the Steam content disclosure.
- `out/` is scratch output; keep only chosen images, under `art/`.
