#!/usr/bin/env python3
"""Turn a chosen generated image into a game asset (TTLUTS-21 pipeline).

    python3 tools/art-pipeline/install.py out/nemo3-flux-1868-64d5.png portrait_nemo
    python3 tools/art-pipeline/install.py out/salon3-flux-1868-bc17.png ch05_salon

The target id decides size and folder:
    chNN_place     → art/locations/chNN_place.png  320×144 (the play view)
    chNN_<scene>   → art/scenes/chNN_<scene>.png   320×120 (story cards), if listed as a scene in locations.json
    portrait_<who> → art/portraits/<who>.png        96×120
    title          → art/title/title.png            320×180
Colours are reduced to the master palette, at most 32 per image, with
ordered dithering (lighter on portraits). Records the source in
art/SOURCES.md so every asset can be traced back to its prompt and seed.
"""
import json
import subprocess
import sys
from datetime import date
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PALETTE = ROOT / "art/palette/master-64.gpl"


def target(item_id: str) -> tuple[Path, str, str]:
    spec = json.loads((HERE / "locations.json").read_text())["items"]
    kind = spec.get(item_id, {}).get("kind", "location")
    if item_id == "title":
        return ROOT / "art/title/title.png", "320x180", "0.5"
    if item_id.startswith("portrait_"):
        return ROOT / f"art/portraits/{item_id[9:]}.png", "96x120", "0.3"
    if kind == "scene":
        return ROOT / f"art/scenes/{item_id}.png", "320x120", "0.5"
    return ROOT / f"art/locations/{item_id}.png", "320x144", "0.5"


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src = Path(sys.argv[1])
    if not src.is_absolute():
        src = (HERE / src) if (HERE / src).exists() else Path.cwd() / src
    item_id = sys.argv[2]
    dest, size, strength = target(item_id)
    dest.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(["uv", "run", str(HERE / "pixelize.py"), str(src), "--size", size,
                    "--palette", str(PALETTE), "--max-colors", "32", "--dither", "bayer",
                    "--strength", strength, "--preview-scale", "1", "--out", str(dest)],
                   check=True, capture_output=True)
    preview = dest.with_name(dest.stem + "-x1.png")
    if preview.exists():
        preview.unlink()
    # Trace the asset back to its prompt and seed.
    manifest = json.loads((HERE / "out/manifest.json").read_text()) if (HERE / "out/manifest.json").exists() else {}
    meta = manifest.get(src.name, {})
    log = ROOT / "art/SOURCES.md"
    if not log.exists():
        log.write_text("# Art sources\n\nEvery game image, the generated image it came from, its model and seed. Prompts are in tools/art-pipeline/locations.json and prompts.sh.\n\n| Asset | Source | Model | Seed | Installed |\n|---|---|---|---|---|\n")
    rel = dest.relative_to(ROOT)
    lines = [l for l in log.read_text().splitlines() if not l.startswith(f"| {rel} |")]
    lines.append(f"| {rel} | {src.name} | {meta.get('model', '?')} | {meta.get('seed', '?')} | {date.today()} |")
    log.write_text("\n".join(lines) + "\n")
    print(f"{item_id} → {rel} ({size})")


if __name__ == "__main__":
    main()
