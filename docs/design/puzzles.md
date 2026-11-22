# Puzzles: the 21 chapters

**Status:** first full pass (TTLUTS-38), built on the scenario (`docs/design/scenario.md`). Each chapter gives: its locations (with the art brief used for the image prompts), the main objective, the step chain (who · verb · what), three hint tiers, and the flags it sets. A chapter is only "done" when its data passes the PuzzleSolver test: finishable from the start, no dead end anywhere.

**Conventions**
- Verbs: Look, Use, Talk for everyone; **Recall** (Aronnax), **Catalogue** (Conseil), **Force** (Ned). "A + B" means both characters must act, usually with an item passed between them.
- Hints go from a nudge, to a clearer hint, to the full answer.
- Flags marked ⚑ are consequence flags (TTLUTS-3); the rest are local to the chapter.
- Location ids are `chNN_place`, and the art lives in `art/locations/chNN_place.png` (320×144).

**Three-character rule:** from chapter 4, every act has at least one step needing two or more characters. The signature puzzles are marked ★.

---

## Act 1 — La Chasse (Aronnax only; switching is locked)

### 1. Le monstre — *playable (data: ch01)*
- **Locations**
  - `ch01_ny_room`: a Fifth Avenue hotel room in 1867, a writing desk with newspapers on the left, a tall window onto the avenue, crates of fossils on the right, a door.
  - `ch01_ny_quay`: the Brooklyn pier, the frigate *Abraham-Lincoln* with two smoking funnels, a gangway with an officer, a crowd.
- **Objective:** give the papers my opinion; get ready to leave; board.
- **Chain:** Look newspapers → Recall newspapers (*not a submarine*) → Recall the book (*narwhal theory*) → Use the desk (article cutscene, letter arrives) → Use the letter → Use the crates (labels them for Paris) → Talk to Conseil, "we leave in an hour" (« Comme il plaira à monsieur ») → exit to the pier → Use the letter on the officer.
- **Hints:** see the data; the third tier spells out the chain.

### 2. L'*Abraham-Lincoln* ★ — three days' patience
- **Locations**
  - `ch02_deck`: the deck of a steam frigate at sea, mast and rigging, the bridge to the right, the bow ahead, the empty Pacific.
  - `ch02_wardroom`: a small wardroom with a chart table, a lamp, a sea chart of the Pacific pinned down, a logbook.
  - `ch02_crow`: the crow's nest view, endless sea, the bowsprit far below.
- **Objective:** keep the frigate searching until the monster shows itself.
- **Chain**
  1. Talk to Farragut: he has promised the crew « trois jours de patience » *(three days' patience)*, then the ship turns home. Objective shown.
  2. Look at the chart in the wardroom; Use the logbook to get the **sightings list**.
  3. Recall the sightings → *they move along a line* (fact `sightings_line`).
  4. Talk to Ned at the bow: he doesn't believe in narwhals, but knows whales. Topic "Where would *you* look?" needs `sightings_line` → Ned: "Down-wind, where the water is warm" (fact `ned_whale_lore`).
  5. Use the chart with the sightings (item) → plot the course (`course_plotted`).
  6. Talk to Farragut with the plotted course: he agrees to steer for that sector (`course_changed`).
  7. Climb to the crow's nest (exit, needs `course_changed`); Look at the sea → night falls, cutscene: Ned's cry « La chose en question, par bâbord derrière ! » → end.
- **Hints:** "Farragut won't change course on a hunch." → "The reports in the logbook, and a harpooner's experience, together make a case." → "Logbook, Recall it, ask Ned where he'd look, Use the sightings on the chart, show Farragut."
- **Flags:** ⚑ `ned_trusts_aronnax` (set if Aronnax tells Farragut the idea came from Ned).

### 3. Par-dessus bord — overboard
- **Locations**
  - `ch03_night_sea`: night sea, a dark wave, the frigate's lights far away.
  - `ch03_hull`: dawn, standing on the back of a long riveted steel hull just above the water, Ned sitting on it, calm sea.
- **Objective:** survive the night, find the others.
- **Chain:** cutscene (the harpoon strikes metal, the collision) → in the water: Look at the frigate (it's gone) → Talk "Conseil!" → Conseil's voice answers (he jumped in after his master) → Use Conseil (hold on to him, he swims) → cutscene, dawn: a voice nearby: it's Ned, sitting on the "whale" → on the hull: Force… no, Ned is not playable yet: Look at the hull (riveted plates: *it's a machine*, fact `its_a_machine`) → Talk to Ned → Use the hull (knock) → the hatch opens, hands pull them inside → end.
- **No fail state:** time passes with dialogue; no drowning.

---

## Act 2 — Les Hôtes du Nautilus (switching unlocks in chapter 4)

### 4. Prisonniers ★ (first three-character puzzle)
- **Location:** `ch04_cell`: a bare steel cell with riveted walls, a single electric light in the ceiling that sometimes goes out, a table, a heavy door.
- **Objective:** make the captors talk to us.
- **Chain**
  1. Two men enter, then leave: the unknown language. **Aronnax** Talk "French" → no answer; **Recall** languages → topic list English / German / Latin unlocks (they try them in turn).
  2. **Conseil** Catalogue their clothes (left on the table: a sea-otter fur beret) → *sea-otter fur, sealskin: men of the sea, not pirates* (fact).
  3. **Ned** Force the door → it won't move; Ned's temper rises (`ned_angry`).
  4. The steward brings the meal; Ned (with `ned_angry`) seizes him → story beat (I-9): the captain appears, in French (`nemo_met`). Talk to the captain: « je ne suis pas ce que vous appelez un homme civilisé ! » and his terms.
  5. End: switching unlocked for good.
- **Three characters:** Aronnax opens the languages, Conseil's catalogue gives Aronnax the topic "You are men of the sea" that calms the captain, Ned's anger triggers his arrival.

### 5. Le *Nautilus* ★ — vertical slice
- **Locations**
  - `ch05_salon`: the grand salon of a 19th-century submarine, wood and brass, a large pipe organ, glass cases of shells and corals, paintings, a great oval window with iron shutters.
  - `ch05_library`: a library lined with books, leather divans, a central table with albums.
  - `ch05_corridor`: a narrow riveted corridor with electric globes and closed doors, a ladder going up to a hatch.
  - `ch05_armory`: a small arms room with racks of strange air-rifles and copper diving suits on stands.
- **Objective:** learn the ship; find where the skiff is kept.
- **Chain**
  1. **Conseil** Catalogue three specimens in the salon cases (a pearl, a nautilus shell, a coral) → the captain notices: invitation to the library (`nemo_interest`).
  2. **Aronnax** in the library: Look at the books (no politics, no history after a certain date: fact `books_stop`) → Talk to the captain: topic "Your library has no newer books" → he speaks of the ship's figures and electricity.
  3. **Ned** in the armory: Look at the rifles → Force the rack? No: **Use** a rifle → he can't fire it (air, not powder); give it to **Aronnax** to Recall (Rouquayrol / Ruhmkorff apparatus) → fact `air_rifles` (used in chapter 6).
  4. **Ned** in the corridor: Look at the ladder → Use the hatch → locked from inside the skiff recess: *the skiff is up there* (`skiff_located`).
  5. Wonder beat: back in the salon, the shutters slide open onto the sea (cutscene) → end.
- **Three characters:** Conseil earns the invitation, Aronnax opens Nemo, Ned finds the skiff; the rifle needs Ned + Aronnax.

### 6. La forêt de Crespo ★
- **Locations**
  - `ch06_seafloor_plain`: walking on a sandy sea floor in diving suits, blue light from above, a few rocks and shells.
  - `ch06_forest`: an underwater forest of tall straight seaweed trunks, dim green-blue light, a sea otter, the hull of the submarine seen far behind.
- **Objective:** hunt with the captain; map the hull from outside.
- **Chain:** read the invitation (Look) → in the armory **Ned** takes a rifle, **Conseil** the lamp → on the plain, **Conseil** Catalogue the shells (path markers) → in the forest, **Ned** Use the rifle on the otter (needs `air_rifles`) → the captain stops them: sharks pass (cutscene, lie flat) → on the way back, **Aronnax** Look at the hull → Recall the corridor ladder → marks where the skiff sits (`hull_mapped`) → end.
- **Three characters:** the rifle (Ned), the lamp and path (Conseil), the hull reading (Aronnax).

### 7. Vanikoro
- **Locations:** `ch07_wreck` (a sunken sailing ship on the sea floor, masts broken, seen through the salon window); `ch07_vanikoro_reef` (coral reefs, wreckage of an old French expedition, cannons covered in coral).
- **Objective:** find out what the captain knows about La Pérouse.
- **Chain:** at the salon window, **Conseil** Catalogue the wreck site (gently; the drowned woman is never shown close) → at Vanikoro, **Aronnax** Recall La Pérouse → Talk to the captain: he shows the box of La Pérouse papers (fact `perouse_box`) → end.

### 8. Le détroit de Torrès (⚑ TTLUTS-37: Gueboroar treatment pending)
- **Locations:** `ch08_reef` (the submarine stranded on a reef at low tide, islands on the horizon); `ch08_island_forest` (a tropical island forest, fruit trees, a beach with the submarine's dinghy); `ch08_platform` (the platform of the submarine, the handrail, the open hatch, the sea).
- **Objective:** a few days ashore… and Ned's first escape.
- **Chain:** the captain allows them ashore → **Ned** hunts (Use rifle) → **Conseil** Catalogue the breadfruit → **Ned** wants to stay: Talk to Aronnax and Conseil (they refuse to run without a boat or provisions) → the islanders appear (seen from a distance, per TTLUTS-37) → back aboard → the electrified handrail (cutscene) → the tide floats the ship → end.
- **Flags:** `first_escape_failed` (always).

### 9. Le royaume du corail
- **Locations:** `ch09_cabin` (a locked cabin, a lamp, a glass of water); `ch09_sickbay` (a narrow sickbay, a wounded sailor with a bandaged head); `ch09_coral_cemetery` (a clearing in a coral forest, a cross of red coral, sailors in diving suits).
- **Objective:** understand what happened in the night.
- **Chain:** before the drug works: **Aronnax** Look at the captain at the glass (fact ⚑ `saw_what_nemo_saw`) → night → morning: the captain asks for a doctor → **Aronnax** Look at the wounded man → Talk: « Cet homme sera mort dans deux heures » → the funeral procession (cutscene) → end.

---

## Act 3 — Les Profondeurs

### 10. Une perle de dix millions ★
- **Locations:** `ch10_pearl_bank` (the Manaar pearl bank off Ceylon, a lone diver above, a boat's hull seen from below, oysters); `ch10_grotto` (an underwater grotto with a giant oyster).
- **Objective:** see the pearl fishery without breaking the captain's rule: no interfering… until the shark.
- **Chain:** **Conseil** Catalogue the oysters → the giant oyster in the grotto (wonder) → the diver is attacked: **Conseil** Catalogue the shark (*weak point: the belly*) → pass it to **Ned** → **Ned** Use the harpoon on the shark while the captain fights → **Aronnax** Talk to the captain about the diver (he leaves pearls) → end.
- **Flags:** ⚑ `pearl_diver_saved_together`.

### 11. L'Arabian-Tunnel (cut-candidate)
- **Location:** `ch11_pilot_house` (the wheelhouse of the submarine, a lens-shaped window, rocky walls lit by a searchlight).
- **Chain:** **Aronnax** Recall the Suez isthmus → Talk to the captain at the wheel → the passage (cutscene) → end.

### 12. L'archipel grec (cut-candidate)
- **Location:** `ch12_salon_window` (the salon window at night, a diver's face pressed against the glass, a chest of gold ingots).
- **Chain:** Look at the diver (Nicolas) → **Conseil** Catalogue the gold ingots → **Aronnax** Recall Crete (fact ⚑ `saw_gold_for_crete`) → the Mediterranean in 48 hours (journal) → end.

### 13. La baie de Vigo — the main fork
- **Locations:** `ch13_cabins` (the trio's cabins at night, a lamp, Ned's packed bag); `ch13_vigo` (a sea floor with sunken Spanish galleons, divers carrying gold, searchlights).
- **Objective:** tonight, Ned's escape; or the captain's invitation. Not both.
- **Chain:** Ned sets the escape → the captain invites Aronnax out. **Choice:** (a) help Ned: **Ned** + **Conseil** ready the skiff (provisions, the hull map) → `skiff_provisioned` ⚑; or (b) go with the captain: the galleons, his wealth and where it goes → `vigo_truth` ⚑. Either path ends the chapter.

### 14. L'Atlantide ★ (Recall + Catalogue)
- **Locations:** `ch14_atlantis` (night, ruins of a drowned city on a mountainside under the sea, columns and walls, a red glow from an underwater volcano); `ch14_volcano_harbour` (a lagoon inside an extinct volcano, coal seams, the submarine moored).
- **Chain:** only Aronnax dives with the captain → **Aronnax** Look at the ruins → Recall Plato → the inscription needs Conseil's journal entries (Catalogue of the shells seen in chapters 5–10: their strata date the ruins) → the captain writes ATLANTIDE on the rock → `atlantis_shared` ⚑ → end.

### 15. Cachalots et baleines (cut-candidate)
- **Location:** `ch15_whales` (the platform at sea, a pod of baleen whales, black sperm whales approaching).
- **Chain:** Ned asks to hunt → side with Ned or the captain (Talk) → ⚑ `took_side_in_whale_argument` → the attack on the sperm whales (cutscene) → end.

---

## Act 4 — Glace et Retour

### 16. Le pôle Sud
- **Locations:** `ch16_ice_pack` (the submarine surfacing among ice floes, grey sky); `ch16_pole` (a rocky shore at the South Pole, seals, a black flag with a gold N).
- **Chain:** at noon on 21 March: **Aronnax** Recall the method (sun on the horizon) → **Conseil** reads the chronometer (Catalogue = precise reading) → **Ned** holds the instrument steady (Use) → the sun cut in half by the horizon: the Pole → the captain plants the flag → end.

### 17. Faute d'air ★
- **Locations:** `ch17_trapped` (inside the submarine, frost on the walls, dim emergency light); `ch17_ice_tunnel` (men in diving suits digging a trench in blue ice with picks).
- **Chain:** the iceberg turns over (cutscene) → the shifts in diving suits: **Ned** Force (pick) the ice, **Conseil** Catalogue the ice (where it's thinner), **Aronnax** Recall (boiling water jets from the reservoirs) → told to the captain → the air is low (no fail state: scene changes) → the sacrifice (cutscene) → the ship rams free → end.

### 18. Les poulpes
- **Locations:** `ch18_platform_squid` (the platform at sea, giant squid tentacles over the rail, sailors with axes).
- **Chain:** the attack (cutscene with choices of where to help) → **Ned** Use harpoon → the captain saves Ned (« Je me devais cette revanche ! ») → **Aronnax** Recall the French cry → ⚑ `heard_french_cry` → end.

### 19. Le Gulf-Stream (cut-candidate)
- **Locations:** `ch19_storm` (the platform in a storm, huge waves); `ch19_vengeur` (a sunken old warship of the line on the sea floor, the captain alone at the window).
- **Chain:** Ned's despair (Talk) → the wreck → **Aronnax** Recall the *Vengeur* → ⚑ `vengeur_understood` → end.

### 20. Une hécatombe
- **Locations:** `ch20_salon_dark` (the salon in darkness, the window full of a warship's hull); `ch20_nemo_room` (the captain's austere room, a portrait of a young woman and two children).
- **Chain:** mostly cutscene; **one choice:** stay at the window or leave (no flag changes the outcome) → the portrait → end.

### 21. Le Maelstrom
- **Locations:** `ch21_cabins_night` (the corridor at night, the ladder to the skiff); `ch21_skiff` (inside a small boat in a raging whirlpool at night); `ch21_lofoten` (a fisherman's hut on a northern island, a fire, nets).
- **Chain:** the last words through the wall (« Dieu tout puissant ! assez ! assez ! ») → the skiff: what's ready depends on ⚑ flags (`skiff_provisioned`, `hull_mapped`, `skiff_located`); whatever is missing is done now, with all three characters → the Maelstrom (cutscene) → the Lofoten hut → Aronnax's journal (text varies with ⚑ flags) → THE END.
