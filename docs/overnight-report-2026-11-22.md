# Overnight report — 22 November 2026

**The whole game is playable on `dev`, from the title screen to « FIN »: 21 chapters, with location art, portraits, the 1871 engravings and the story told as book pages.** Every chapter is proven finishable with no dead ends, and all 18 tests pass.

## How to play

```sh
cd ~/Documents/Dev/TwentyThousandLeagues
git switch dev && git pull
/Applications/Godot.app/Contents/MacOS/Godot --path .
```

| Control | What it does |
|---|---|
| Verb, then a thing in the scene | Act |
| Portraits, or keys 1 2 3 | Switch character (from chapter 4) |
| Space | Highlight everything clickable |
| J | Journal: objectives, three hints each, catalogue, notes |
| F5 / F9 | Save / load (it also autosaves on every room change) |
| F2 | French ⇄ English |
| Escape | Skip a book page |
| Title → *Chapitres* | Jump to any chapter |

## What changed after your playtest

- **Art first.** Every location in all 21 chapters has art: 35 views at 640×288, about 30 colours each from the 64-colour master palette. The five characters have portraits, and people present in a scene appear as framed medallions.
- **The book.** Story moments are pages of the book: a running head, « CHAPITRE … » headings as in the 1871 Hetzel edition, text set in IM Fell, and the **original engravings by de Neuville and Riou** (public domain, BnF scans via Wikimedia Commons). 49 are used, plus the frontispiece on the title screen.
- **Puzzles are deductions, not busywork.** No more "look, then recall the same thing". Many chapters now replay a deduction Verne gives Aronnax or Nemo, for example:
  - Chapter 1: rule out the theories of the monster at the desk.
  - Chapter 6: the planisphere shows Crespo is a bare rock, so its forests are under the sea.
  - Chapter 7: the coral and the cannons identify La Pérouse's wreck.
  - Chapter 11: Nemo's ringed fish prove there is a tunnel.
  - Chapter 14: the drowned city and the volcano add up to Atlantis.
  - Chapter 19: the shells, the guns and the date identify the *Vengeur*.

  From chapter 4, most chapters need all three characters.
- **Resolution.** You asked for more definition while keeping pixels. All art is now made at twice the size, and the original generated images are kept in `art/source/`, so nothing ever needs regenerating (`install.py --all` rebuilds everything).

## The game, by act

| Act | Chapters | Highlights |
|---|---|---|
| 1 · La Chasse | 1–3 | Aronnax alone; Farragut's three-day deadline; overboard |
| 2 · Les Hôtes du Nautilus | 4–9 | Switching begins in the cell (four languages); the salon; the Crespo dive; Vanikoro; Torres; the coral cemetery and « des requins et des hommes ! » |
| 3 · Les Profondeurs | 10–15 | The shark (Ned saves Nemo); the Arabian Tunnel; the gold for Crete; **the main choice at Vigo** (Ned's escape or Nemo's galleons); Atlantis; the whales |
| 4 · Glace et Retour | 16–21 | The Pole; trapped under the ice (no fail state); the squid (Nemo saves Ned); the *Vengeur*; the hecatomb and the portrait; the Maelstrom; the Lofoten epilogue, which remembers your choices |

**Choices that carry over:** 15 story flags (the consequence model, TTLUTS-3) persist from chapter to chapter, including Vigo, the side taken over the whales, what Aronnax noticed at Torres, and the cry in French. The final journal and window lines change with them. Every combination reaches the end.

## Known rough edges

- **Text font:** Godot's default font (crisp, but not a pixel font) until TTLUTS-8.
- **No music or sound yet:** TTLUTS-39 and TTLUTS-25.
- **Medallions are a stopgap** for showing characters in a scene (TTLUTS-32).
- **Art to redo:**
  - The whales read as orcas (ch15).
  - The warship in ch20 looks too modern.
  - The library has windows (Verne's doesn't).
  - The Pole picture already shows the N flag before it is planted (ch16).
- **Chapter select starts without the earlier story flags.** Endings are richest when played in order.
- **The solver proves each chapter from a fresh start,** not every combination of carried-over flags, but those flags only add lines.
- **Some cut-candidate chapters are short** (11, 12, 15), as planned.
- **English** is our own working translation, not final copy.

## Decisions waiting for you

| Card | Decision |
|---|---|
| TTLUTS-37 | Gueboroar (ch8): option 1 used provisionally (islanders only at a distance, defending their shore). Keep, rework or cut? |
| TTLUTS-4 | How much of Nemo's past to reveal. The clues are planted: his glass (9), the Crete gold (12), the French cry (18), the *Vengeur* (19), the portrait (20) |
| TTLUTS-39 | Music route. My recommendation: compose themes as MIDI and render them through FM/chip |
| TTLUTS-6 / 8 / 32 | Final layout, pixel font, and how characters appear in scenes |
| Staged cards | Accept or reject what's on dev (ac-met, accepted) |

## Overnight PRs (all merged into `dev`)

#6 engine + ch1 · #7 puzzle design · #8 ch2–3 · #9 ch4 (+ flag-name fix) · #10 ch5 (+ leaner solver) · #11 book pages + engravings + ch1 deduction · #12 ch6 · #13–#14, #17–#19 art · #15 ch7 · #16 and #29 resolution (2× art, crisp text) · #20 ch8 · #21 ch9 · #22 ch10 · #23 ch11–12 · #24 ch13 · #25 ch14–15 · #26 ch16–17 · #27 ch18–19 · #28 ch20–21 + ending + story flags.
