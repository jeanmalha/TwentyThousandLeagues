# Working on Twenty Thousand Leagues

Read this before changing anything. It's for people and AI agents working from the kagen board **TTLUTS**.

The game is a 16-bit-style, first-person adventure adapted from Jules Verne's *Vingt mille lieues sous les mers*, built with **Godot 4.6.2** (GDScript, Compatibility renderer).

## Commands

| What | Command |
|---|---|
| Run the unit tests (headless) | `./scripts/test.sh` |
| Run one test file | `./scripts/test.sh -gtest=res://tests/unit/test_display_settings.gd` |
| Open the editor | `godot --path . -e` (macOS: `/Applications/Godot.app/Contents/MacOS/Godot --path . -e`) |
| Run the game | `godot --path .` |
| Re-import assets after a fresh clone | `godot --headless --path . --import` (the test script does this for you) |

`scripts/test.sh` finds Godot on `PATH` as `godot`, then in `/Applications/Godot.app`. Set `GODOT=/path/to/godot` to override. It exits non-zero when any test fails. Run it before every push.

### Checking pixel crispness

The game renders at 320×180 and scales up by whole numbers only. To check that a change hasn't introduced blur or uneven pixels, capture a real window and check it:

```sh
godot --path . --resolution 1280x720 -s res://tests/visual/capture.gd -- /tmp/x4.png
godot --path . -s res://tests/visual/capture.gd -- /tmp/x6.png 1920x1080   # borderless, for ×6 on a 1080p screen
uv run --no-project --with pillow python tests/visual/check_pixels.py /tmp/x4.png /tmp/x6.png
```

`check_pixels.py` reports `mixed pixels: 0` when every 320×180 pixel became a uniform N×N block. These checks open a window, so they're not part of `scripts/test.sh`.

## Where things live

| Path | What |
|---|---|
| `project.godot` | Engine settings. Display rules: 320×180 viewport, `canvas_items` stretch, `integer` scale mode, nearest-neighbour filtering, 2D pixel snapping. `tests/unit/test_display_settings.gd` guards them |
| `main/` | Start scene. It's a placeholder test card for now |
| `rooms/` | First-person location views, hotspots and exits |
| `characters/` | Character portraits and per-character data |
| `data/` | Game data: puzzles, flags, item definitions |
| `dialogue/` | Dialogue and text, French and English |
| `ui/` | Interface: verbs, dialogue box, journal, menus |
| `art/`, `audio/` | Final, game-ready assets only |
| `tests/unit/` | GUT tests, run headless by `scripts/test.sh` |
| `tests/visual/` | Window captures and the pixel checker |
| `addons/gut/` | GUT 9.6.1 (MIT), vendored unchanged from github.com/bitwes/Gut tag v9.6.1. Don't edit it; upgrade by replacing the folder |
| `docs/` | Design doc, source texts and these instructions |
| `tools/` | Offline tools: character sheets and the art pipeline. Generated images in `tools/art-pipeline/out/` are not committed |

## Conventions

- **GDScript:** static typing everywhere (`var x: int`, `func f() -> void`), tabs for indentation, `snake_case` files and functions, `PascalCase` classes and nodes. Commit the `.uid` files Godot creates next to scripts.
- **Pixels:** draw and place everything on whole pixels in the 320×180 space. Import textures with filtering off. Don't add smooth scaling, rotation or sub-pixel motion to pixel art.
- **Tests:** files are `tests/unit/test_<thing>.gd`, extending `GutTest`, with functions named `test_<behaviour>`. A card that adds behaviour adds a test for it.
- **Text:** write the French lines from Verne's original, and write the English lines ourselves. Never paste sentences from a copyrighted translation (for example F. P. Walter's). Base Nautilus and creature designs on Verne's descriptions, not on Disney's 1954 film.

## Branches, pull requests and review

- `main` is the release branch and `dev` is the integration branch.
- Branch from `dev` as `<card-id>-<slug>` (e.g. `TTLUTS-12-save-load`). Put the card id at the start of each commit message and in the PR title, and open the PR into `dev`.
- Post the PR link on the card and move it to Review.
- Agents don't merge. The PO reviews and merges.
- No CI or deployment yet: run `./scripts/test.sh` locally and paste the result in the PR.
