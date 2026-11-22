#!/usr/bin/env python3
"""Turn a chosen generated image into a game asset (TTLUTS-21 pipeline).

    python3 tools/art-pipeline/install.py out/nemo3-flux-1868-64d5.png portrait_nemo
    python3 tools/art-pipeline/install.py out/salon3-flux-1868-bc17.png ch05_salon

The target id decides size and folder (the game renders at 640×360):
    chNN_place     → art/locations/chNN_place.png  640×288 (the play view)
    chNN_<scene>   → art/scenes/chNN_<scene>.png   640×240 (story cards), if listed as a scene in locations.json
    portrait_<who> → art/portraits/<who>.png        192×240
    title          → art/title/title.png            640×360

The generated original is copied to art/source/ (committed), so assets can
be rebuilt at any size without generating again:
    python3 tools/art-pipeline/install.py --all     # rebuild every asset in art/SOURCES.md
Colours are reduced to the master palette, at most 32 per image, with
ordered dithering (lighter on portraits). Records the source in
art/SOURCES.md so every asset can be traced back to its prompt and seed.
"""
import json
import shutil
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
        return ROOT / "art/title/title.png", "640x360", "0.4"
    if item_id.startswith("portrait_"):
        return ROOT / f"art/portraits/{item_id[9:]}.png", "192x240", "0.25"
    if kind == "scene":
        return ROOT / f"art/scenes/{item_id}.png", "640x240", "0.4"
    return ROOT / f"art/locations/{item_id}.png", "640x288", "0.4"


def asset_id(rel: str) -> str:
    """art/locations/ch05_salon.png → ch05_salon; art/portraits/nemo.png → portrait_nemo."""
    p = Path(rel)
    if p.parent.name == "portraits":
        return "portrait_" + p.stem
    if p.parent.name == "title":
        return "title"
    return p.stem


def main() -> None:
    if sys.argv[1:] == ["--all"]:
        rows = [l.split("|") for l in (ROOT / "art/SOURCES.md").read_text().splitlines() if l.startswith("| art/")]
        for r in rows:
            rel, src_name = r[1].strip(), r[2].strip()
            kept = ROOT / "art/source" / src_name
            original = kept if kept.exists() else HERE / "out" / src_name
            install(original, asset_id(rel))
        return
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src = Path(sys.argv[1])
    if not src.is_absolute():
        src = (HERE / src) if (HERE / src).exists() else Path.cwd() / src
    install(src, sys.argv[2])


def install(src: Path, item_id: str) -> None:
    if not src.exists():
        sys.exit(f"Missing original: {src}")
    # Keep the generated original in the repo so the asset never needs regenerating.
    kept = ROOT / "art/source" / src.name
    kept.parent.mkdir(parents=True, exist_ok=True)
    if not kept.exists():
        shutil.copy2(src, kept)
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
