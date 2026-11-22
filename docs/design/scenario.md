# Scenario: from Verne's 47 chapters to the game's chapters

**Status:** first draft for review (TTLUTS-34). **Source:** the French original only, `docs/source/verne/fr-verne-5097.txt`. References like `I-8` mean Part 1, chapter VIII; `II-21` means Part 2, chapter XXI. Every plot point below was checked against the text.

**Quotes:** French original first, then *our own English translation* in italics. The translations are written for this project from the French and are never taken from a published translation (F. P. Walter's is under copyright; Mercier Lewis's is unreliable). They are working translations for the script, not final dialogue.

**Constraints this draft follows:**
- Four acts, as in the GDD.
- First-person presentation with portraits (TTLUTS-32).
- Three playable characters: Aronnax recalls, Conseil catalogues, Ned forces.
- No death and no dead ends.
- Nemo stays ambiguous until the last scene.

Decisions still open are marked **⚑** with the card that owns them.

---

## 1. The game in 21 chapters

Each game chapter is one sitting of about 15 to 40 minutes, with one main objective and a clear ending beat. Chapters marked *core* carry the story and the signature puzzles. Chapters marked *cut-candidate* can shrink to a cutscene and a journal entry if scope demands (the GDD rule: cut Act 3 locations before polish on Acts 1 and 2).

| # | Game chapter | Novel | Main locations | Mode | Scope |
|---|---|---|---|---|---|
| **Act 1: La Chasse** *(The Hunt)* |||||
| 1 | Le monstre *(The Monster)* | I-1 – I-3 | New York: hotel room, the quay | Short playable prologue | core |
| 2 | L'*Abraham-Lincoln* | I-4 – I-6 | Frigate: deck, crow's nest, wardroom | Playable | **core** (Act 1 signature puzzle) |
| 3 | Par-dessus bord *(Overboard)* | I-7 | Night sea, the back of the "monster" | Cutscene + short playable | core |
| **Act 2: Les Hôtes du Nautilus** *(Guests of the Nautilus)* |||||
| 4 | Prisonniers *(Prisoners)* | I-8 – I-10 | The cell | Playable | core |
| 5 | Le *Nautilus* | I-11 – I-14 | Salon, library, engine room, the platform | Playable | **core** (vertical slice) |
| 6 | La forêt de Crespo *(The Crespo Forest)* | I-15 – I-17 | Sea-floor plain, underwater forest (panorama) | Playable dive | **core** (Act 2 signature puzzle) |
| 7 | Vanikoro | I-18 – I-19 | A sunken ship, the reefs of Vanikoro | Playable, short | core |
| 8 | Le détroit de Torrès *(The Torres Strait)* | I-20 – I-22 | Reef in the strait, the forest of Gueboroar, the platform | Playable | core ⚑ sensitivity |
| 9 | Le royaume du corail *(The Coral Kingdom)* | I-23 – I-24 | Locked cabin, sickbay, coral cemetery | Playable + funeral cutscene | core |
| **Act 3: Les Profondeurs** *(The Deep)* |||||
| 10 | Une perle de dix millions *(A Ten-Million Pearl)* | II-1 – II-3 | Indian Ocean, Manaar pearl bank (Ceylon) | Playable dive | **core** (Act 3 signature puzzle) |
| 11 | L'Arabian-Tunnel | II-4 – II-5 | Red Sea, the tunnel under the isthmus | Cutscene + short playable | cut-candidate |
| 12 | L'archipel grec *(The Greek Archipelago)* | II-6 – II-7 | Salon window, volcanic sea off Santorini | Short playable | cut-candidate |
| 13 | La baie de Vigo *(Vigo Bay)* | II-8 | Cabins at night, the galleons on the sea floor | Playable | **core** (escape vs trust) |
| 14 | L'Atlantide *(Atlantis)* | II-9 – II-10 | Night dive across ruins, volcanic crater, coal mines | Playable dive | **core** (Recall + Catalogue puzzle) |
| 15 | Cachalots et baleines *(Sperm Whales and Baleen Whales)* | II-11 – II-12 | Sargasso Sea, whale grounds | Playable, short | cut-candidate |
| **Act 4: Glace et Retour** *(Ice and Return)* |||||
| 16 | Le pôle Sud *(The South Pole)* | II-13 – II-14 | Ice pack, the South Pole | Playable | core |
| 17 | Faute d'air *(Short of Air)* | II-15 – II-16 | Trapped under the ice | Playable, timed with no fail state | **core** (Act 4 signature puzzle) |
| 18 | Les poulpes *(The Squid)* | II-17 – II-18 | Cape Horn to the Antilles; attack on the platform | Playable + action cutscene | core |
| 19 | Le Gulf-Stream | II-19 – II-20 | Storm at the surface; the wreck of the *Vengeur* | Playable, short | cut-candidate |
| 20 | Une hécatombe *(A Hecatomb)* | II-21 | Salon, Nemo's room, the warship | Mostly cutscene, one choice | **core** |
| 21 | Le Maelstrom | II-22 – II-23 | Cabins at night, the skiff, the Maelstrom, a Lofoten hut | Playable finale + epilogue | **core** |

Fifteen core chapters and six cut-candidates. If all six are cut to cutscenes, the game keeps every signature puzzle and the full Nemo arc.

---

## 2. Chapter by chapter

Each entry gives: what happens in Verne, what the player does, the wonder moment, the Nemo beat, the puzzle hook (who is needed), and flags. Flags are proposals for TTLUTS-3, which turns them into the consequence model (named flags, no meter).

### Act 1: La Chasse *(The Hunt)*

Switching between characters is locked in this act (⚑ TTLUTS-5). The player is Aronnax, and the act teaches the verbs and the journal.

**1. Le monstre** (I-1 – I-3)
- **Verne:** in 1866 ships report a huge, fast « écueil fuyant » *(a moving reef)*, and the *Scotia* is holed. Aronnax, back from the badlands of Nebraska, is in New York, where his book *Les Mystères des grands fonds sous-marins* *(The Mysteries of the Great Ocean Depths)* makes him the expert. He argues it is a giant narwhal and is invited aboard the frigate *Abraham-Lincoln*. Conseil packs without a question: « Comme il plaira à monsieur. » *(As Monsieur pleases.)*
- **Player:** read the press cuttings (Look), Recall his own book to answer the invitation, get Conseil packed and onto the quay before the frigate sails. Teaches Look, Use, Talk and Recall; Conseil is present but not playable.
- **Wonder:** small on purpose: the "monster" as the newspapers draw it.
- **Flags:** none.

**2. L'*Abraham-Lincoln*** (I-4 – I-6)
- **Verne:** Commander Farragut believes absolutely: « Ou le commandant Farragut tuerait le narwal, ou le narwal tuerait le commandant Farragut. Pas de milieu. » *(Either Commander Farragut would kill the narwhal, or the narwhal would kill Commander Farragut. There was no middle way.)* Ned Land, the Canadian harpooner, doesn't believe a word. After months of fruitless search the crew are close to mutiny, and Farragut asks for « trois jours de patience » *(three days' patience)*, after which the frigate will turn for home. Just before the deadline Ned cries: « Ohé ! la chose en question, sous le vent, par le travers à nous ! » *(Ahoy! There's the thing, to leeward, abeam of us!)* A chase follows through the day and night.
- **Player:** Act 1 signature puzzle: **the three-day deadline**. Keep the frigate searching long enough for Ned's sighting. Aronnax Recalls the reports to find the pattern, works the chart, and wins Ned's knowledge of whale behaviour through dialogue, then makes the case to Farragut.
- **Wonder:** the creature's glow on the water at night.
- **Puzzle hook:** one character played, two minds needed: Aronnax (Recall, Talk) and Ned as the source.
- **Flags:** `ned_trusts_aronnax` (whether Aronnax backed Ned in front of Farragut). It costs nothing and colours Ned's later lines.

**3. Par-dessus bord** (I-7)
- **Verne:** the harpoon rings on metal; the collision throws Aronnax overboard, crying « A moi ! à moi ! » *(Help! Help me!)*. Conseil dives in after his master. They find Ned on the creature's back, which is plated steel.
- **Player:** a cutscene, then a short night sequence: stay afloat, find Conseil's voice in the dark, reach Ned on the hull. No drowning; time passes through dialogue instead.
- **Wonder:** standing on a steel giant in the open ocean at dawn.
- **Ends with:** the hatch opening and hands pulling them inside.

### Act 2: Les Hôtes du Nautilus *(Guests of the Nautilus)*

Switching unlocks in chapter 4, once all three are free to move in the cell.

**4. Prisonniers** (I-8 – I-10)
- **Verne:** a dark cell. Two men, Nemo and his second, speak an unknown language; the trio try French, English, German and even Latin without a word of reply. A mute steward brings food. Ned loses his temper and half-strangles the steward, and Nemo appears, speaking perfect French: « je ne suis pas ce que vous appelez un homme civilisé ! » *(I am not what you call a civilised man!)*. His terms: free aboard but sometimes confined, and never to leave.
- **Player:** the first three-character puzzle, in one room. Conseil Catalogues the captors' clothes (sea-otter fur, sealskin, the ship's cloth), Aronnax Recalls languages to try, and Ned is pushed to Force the door. That pressure leads to the steward incident (a story beat), which brings Nemo to the cell.
- **Nemo beat:** first meeting; courtesy and menace together.
- **Flags:** `steward_attacked_by_ned` (always true; it's Verne's beat, and it sets Nemo's early coldness towards Ned).

**5. Le *Nautilus*** (I-11 – I-14): **vertical slice**
- **Verne:** Nemo's tour: the salon with its paintings, specimen cases and « un pianoorgue de grand modèle » *(a large piano-organ)*; the library; « Tout par l'électricité » *(everything by electricity)*; the ship's figures. Then, in the Kuroshio current, the iron panels of the salon slide open onto the sea.
- **Player:** the vertical-slice chain (TTLUTS-20), across the salon, the arms locker and a corridor. Conseil's catalogue earns Nemo's interest, Aronnax's Recall opens a Nemo topic, and Ned learns the ship's layout and its weapons. The skiff becomes the goal (⚑ TTLUTS-5).
- **Wonder:** **the salon panels opening onto the sea.** The image of the game.
- **Nemo beat:** the organ, heard before he is seen.
- **Flags:** `skiff_located`.

**6. La forêt de Crespo** (I-15 – I-17)
- **Verne:** a written invitation to hunt in the forests of Crespo Island, which turn out to be underwater. Rouquayrol diving suits, Ruhmkorff lamps, air rifles with electric bullets. A walk across the sea-floor plain, then the forest; Nemo shoots a sea otter, and on the way back he makes them lie flat while a pair of sharks passes overhead.
- **Player:** Act 2 signature puzzle: hunt with the air rifles while mapping the hull from outside, where the skiff sits. First dive with the helmet frame (TTLUTS-32).
- **Wonder:** walking upright on the sea floor into a forest of seaweed.
- **Nemo beat:** he protects them from the sharks without a word.
- **Puzzle hook:** Ned (Force, the rifles), Conseil (Catalogue the forest), Aronnax (Recall the hull plans).
- **Flags:** `hull_mapped` (feeds the escape route).

**7. Vanikoro** (I-18 – I-19)
- **Verne:** crossing the Pacific, a sunken ship with its dead still aboard, among them a young woman holding a child: « Cette femme était jeune. » *(The woman was young.)* Then Vanikoro, where La Pérouse's expedition was lost; Nemo knows the wreck and its relics.
- **Player:** short. Catalogue the wreck site with care, and find out what Nemo knows about La Pérouse (Recall, Talk).
- **Wonder:** the reefs of Vanikoro. The drowned woman is a quiet, sombre beat, never shock horror.
- **Nemo beat:** grief for drowned sailors; the first crack in his armour.

**8. Le détroit de Torrès** (I-20 – I-22) ⚑ sensitivity
- **Verne:** the Nautilus runs aground in the Torres Strait. Nemo allows a few days ashore on Gueboroar. Ned hunts (pigeons, a wild pig, kangaroos), but the islanders drive them back to the ship and try to board her. Nemo plays the organ, unconcerned, then the electrified handrail repels the boarders, and the rising tide floats the ship off.
- **Player:** the **first escape attempt**. Ned wants to stay ashore and run; the attempt fails as a story beat, never as a game over.
- **⚑ Gueboroar:** Verne's framing of the islanders is colonial and dehumanising. The game shows people defending their land, from a distance, without caricature or mockery. Keep, rework or cut this episode before production.
- **Nemo beat:** « La foudre du capitaine Nemo » *(Captain Nemo's thunderbolt)*: protective, cold and a little frightening.
- **Flags:** `first_escape_failed` (always true; it hardens Ned).

**9. Le royaume du corail** (I-23 – I-24)
- **Verne:** Nemo sees something through his glass, and the trio are locked in and drugged (« Ægri somnia », Latin for *a sick man's dreams*). Then Aronnax is called as a doctor: a broken engine lever has crushed a crewman's skull. « Cet homme sera mort dans deux heures. -- Rien ne peut le sauver ? -- Rien. » *(This man will be dead within two hours. — Can nothing save him? — Nothing.)* Next day, a funeral procession in diving suits to a coral cemetery, and Nemo grieves.
- **Player:** before the drug takes hold, a short window to notice what Nemo saw (Recall later becomes a Nemo's-past clue). Then the examination, which is Aronnax's moment, and the funeral, which ends Act 2.
- **Wonder:** the procession to the coral cemetery.
- **Nemo beat:** mourning; the crew are his family.
- **Flags:** `saw_what_nemo_saw` (optional; feeds TTLUTS-4).

### Act 3: Les Profondeurs *(The Deep)*

The three start to disagree about leaving. Most consequence flags are set in this act (TTLUTS-3).

**10. Une perle de dix millions** (II-1 – II-3)
- **Verne:** the Indian Ocean. Nemo proposes a visit to the Manaar pearl bank off Ceylon. There a lone pearl diver is attacked by a shark; Nemo fights it with a dagger and Ned finishes it with his harpoon. Nemo saves the diver and secretly leaves him a pouch of pearls: « Cet Indien, monsieur le professeur, c'est un habitant du pays des opprimés, et je suis encore, et, jusqu'à mon dernier souffle, je serai de ce pays-là ! » *(That Indian, Professor, is a native of the land of the oppressed, and I am still, and until my last breath I shall remain, of that land!)*
- **Player:** Act 3 signature puzzle: rescue the diver without breaking Nemo's rules: Ned's harpoon, Conseil identifying the shark's weak point, Aronnax handling Nemo.
- **Wonder:** the giant pearl in its oyster.
- **Nemo beat:** the clearest statement of his sympathies.
- **Script note:** in the game's own lines, the diver is not referred to by Verne's racial labels (see the character sheet); Nemo's line above may be adapted in the script.
- **Flags:** `pearl_diver_saved_together` (whether Ned and Nemo acted together; it changes their relationship later).

**11. L'Arabian-Tunnel** (II-4 – II-5), cut-candidate
- **Verne:** the Red Sea; Nemo reveals a secret tunnel under the isthmus of Suez and steers through it himself.
- **Player:** the pilot-house passage, with Aronnax at Nemo's side. A cutscene if cut.
- **Wonder:** the run through the tunnel.

**12. L'archipel grec** (II-6 – II-7), cut-candidate
- **Verne:** a diver appears at the salon window: « C'est Nicolas, du cap Matapan, surnommé le Pesce. » *(It's Nicolas, from Cape Matapan, known as the Fish.)* Nemo sends out a chest of gold ingots, which Aronnax connects with the uprising on Crete. The sea boils near Santorini's volcanic islands. Then the Mediterranean in forty-eight hours, at speed and submerged: no chance to escape.
- **Player:** watch the gold exchange (a Recall clue to Nemo's cause). Ned's frustration grows.
- **Flags:** `saw_gold_for_crete` (a Nemo's-past clue, ⚑ TTLUTS-4).

**13. La baie de Vigo** (II-8)
- **Verne:** off Portugal, Ned sets their escape for that night. At the same hour Nemo invites Aronnax outside to Vigo Bay, where his crew are salvaging the treasure of the sunken Spanish galleons, the source of the wealth he gives away.
- **Player:** **the main fork.** That night the player chooses where to be: helping Ned ready the skiff (`skiff_provisioned`), or with Nemo among the galleons (`vigo_truth`). Either path completes the chapter, but not both. This is the GDD's "earn trust or prepare the escape, but not both" (⚑ TTLUTS-3).
- **Wonder:** divers among the galleons' gold.

**14. L'Atlantide** (II-9 – II-10)
- **Verne:** a night dive with Nemo alone, across a lit sea floor to the ruins of a drowned city. On a rock Nemo writes one word: ATLANTIDE. Then a volcanic crater used as a harbour, with coal mines under the sea.
- **Player:** **Recall + Catalogue puzzle**: decode the ruins with Aronnax's classical knowledge and the classifications Conseil has recorded in the journal. Only Aronnax dives; Conseil's earlier work is what makes the puzzle solvable.
- **Wonder:** **Atlantis by the light of an underwater volcano.** The second image of the game.
- **Nemo beat:** he shares something he has shown no one else.
- **Flags:** `atlantis_shared`.

**15. Cachalots et baleines** (II-11 – II-12), cut-candidate
- **Verne:** the Sargasso Sea, then the whales. Ned begs to hunt the baleen whales and Nemo refuses: killing them would be pointless. Then Nemo massacres a pack of sperm whales attacking the baleen whales.
- **Player:** a moral beat with no right answer: side with Ned or with Nemo in the argument, then witness the slaughter.
- **Flags:** `took_side_in_whale_argument` (Ned, Nemo or neither). It tints dialogue only.

### Act 4: Glace et Retour *(Ice and Return)*

**16. Le pôle Sud** (II-13 – II-14)
- **Verne:** the ice pack. The Nautilus passes under it and reaches the South Pole on 21 March 1868. Nemo plants a black flag bearing a gold N.
- **Player:** confirm the position at noon on 21 March, an instrument puzzle: Aronnax Recalls the method, Conseil reads the figures, Ned holds the instrument steady.
- **Wonder:** the pole, the black flag, the silence.
- **Nemo beat:** his pride, and his claim on a place that belongs to no nation.

**17. Faute d'air** (II-15 – II-16)
- **Verne:** an iceberg overturns and seals the ship beneath the ice. The crew dig in shifts while the air runs out. At the end Ned and Conseil give Aronnax the last of it: « C'étaient Ned et Conseil, mes deux braves amis, qui se sacrifiaient pour me sauver. » *(It was Ned and Conseil, my two good friends, sacrificing themselves to save me.)* The Nautilus rams its way out.
- **Player:** Act 4 signature puzzle: free the ship while the air runs down. **No fail state**: the timer drives scene changes and dialogue, never a game over.
- **Emotional peak:** the companions' sacrifice, scripted whatever the flags. When they reach the surface, Conseil: « Que monsieur ne craigne pas de respirer. Il y en a pour tout le monde. » *(Monsieur need not be afraid to breathe. There's enough for everyone.)*

**18. Les poulpes** (II-17 – II-18)
- **Verne:** north past Cape Horn towards the Antilles. Giant squid attack; a crewman is seized and cries out in French, « A moi ! à moi ! » *(Help! Help me!)*, and Aronnax realises a man of this crew speaks his language. The crew fight with axes. A squid's beak closes over Ned; Nemo strikes first and saves him: « Je me devais cette revanche ! » *(I owed myself that revenge!)* « Ned s'inclina sans lui répondre. » *(Ned bowed without answering.)* Afterwards Nemo weeps.
- **Player:** the attack as a staged action scene (a cutscene with choices of where to help), then the aftermath. Recall the cry in French: a clue to who the crew are.
- **Nemo beat:** he saves Ned, then weeps for his man.
- **Flags:** `heard_french_cry`.

**19. Le Gulf-Stream** (II-19 – II-20), cut-candidate
- **Verne:** Nemo withdraws; Aronnax understands that Nemo will never give them their freedom. Off the Saint Lawrence, Ned is desperate: « c'est mon fleuve à moi le fleuve de Québec » *(it's my own river, the river of Québec)*. A storm at the surface. At 47°24' N, 17°28' W Nemo stops over the wreck of the *Vengeur*, a French warship that went down fighting.
- **Player:** Ned's breaking point; Nemo's homage over the wreck.
- **Flags:** `vengeur_understood` (whether Aronnax Recalls the *Vengeur*'s story).

**20. Une hécatombe** (II-21)
- **Verne:** a warship attacks. Nemo: « Je suis le droit, je suis la justice ! … Je suis l'opprimé, et voilà l'oppresseur ! » *(I am the law, I am justice! … I am the oppressed, and there is the oppressor!)* The Nautilus rams and sinks her. Aronnax then sees Nemo kneel and sob before the portrait of a young woman and two small children.
- **Player:** mostly a cutscene with **one choice**: stay in the salon and watch, or leave. Either way the player sees the portrait. Nothing tells the player what to think.
- **Nemo beat:** « véritable archange de la haine » *(a very archangel of hatred)*, and a grieving father. The peak of his ambiguity.

**21. Le Maelstrom** (II-22 – II-23)
- **Verne:** through the wall, Nemo's last words: « Dieu tout puissant ! assez ! assez ! » *(Almighty God! Enough! Enough!)*. The trio take the skiff that night; the Nautilus is drawn into the Maelstrom, the skiff is torn loose, and Aronnax wakes in a fisherman's hut on the Lofoten Islands. Nobody knows whether Nemo lived.
- **Player:** the escape, with the earlier flags deciding what is ready (provisions, the route, who is where). Every combination escapes (no dead ends); flags change who boards together, the last exchange with Nemo and Aronnax's closing journal (⚑ TTLUTS-4).
- **Epilogue:** the Lofoten hut. The game's last page is Aronnax's journal.

---

## 3. All 47 chapters

English titles are our own translations. Verdicts: **scene** (playable), **cutscene**, **journal** (told only in Aronnax's journal), **merged** (folded into a neighbouring chapter), **cut**.

| Novel | French title *(our English)* | What happens | Game ch. | Verdict |
|---|---|---|---|---|
| I-1 | Un écueil fuyant *(A Moving Reef)* | Ships report the "moving reef"; the *Scotia* is holed | 1 | journal (press cuttings) |
| I-2 | Le pour et le contre *(For and Against)* | Aronnax in New York; his narwhal theory | 1 | scene |
| I-3 | Comme il plaira à monsieur *(As Monsieur Pleases)* | Invitation; Conseil introduced; boarding | 1 | scene |
| I-4 | Ned Land | Farragut and Ned introduced | 2 | scene |
| I-5 | À l'aventure ! *(Off We Go!)* | Months of search; three days' patience; Ned's cry | 2 | scene |
| I-6 | À toute vapeur *(Full Steam)* | The chase | 2 | scene |
| I-7 | Une baleine d'espèce inconnue *(A Whale of Unknown Species)* | Collision; overboard; the metal back | 3 | cutscene + scene |
| I-8 | *Mobilis in mobile* (Latin: *moving in the moving element*) | The cell; Nemo and his second; the unknown language | 4 | scene |
| I-9 | Les colères de Ned Land *(Ned Land's Rages)* | Ned attacks the steward | 4 | scene |
| I-10 | L'homme des eaux *(The Man of the Seas)* | Nemo speaks; the terms of captivity | 4 | scene |
| I-11 | Le *Nautilus* *(The Nautilus)* | Salon, library, organ | 5 | scene |
| I-12 | Tout par l'électricité *(Everything by Electricity)* | Electricity aboard | 5 | merged (a Nemo topic) |
| I-13 | Quelques chiffres *(A Few Figures)* | The ship's figures | 5 | journal |
| I-14 | Le Fleuve-Noir *(The Black River)* | The Kuroshio; the salon panels open onto the sea | 5 | scene (wonder) |
| I-15 | Une invitation par lettre *(An Invitation by Letter)* | Hunting invitation; diving suits | 6 | scene |
| I-16 | Promenade en plaine *(A Walk on the Plain)* | The walk on the sea floor | 6 | scene |
| I-17 | Une forêt sous-marine *(An Underwater Forest)* | The forest; sea otter; sharks | 6 | scene |
| I-18 | Quatre mille lieues sous le Pacifique *(Four Thousand Leagues under the Pacific)* | The sunken ship and the drowned woman | 7 | scene |
| I-19 | Vanikoro | La Pérouse's wreck | 7 | scene |
| I-20 | Le détroit de Torrès *(The Torres Strait)* | Aground in the strait | 8 | scene |
| I-21 | Quelques jours à terre *(A Few Days Ashore)* | Ashore on Gueboroar; Ned hunts | 8 | scene ⚑ |
| I-22 | La foudre du capitaine Nemo *(Captain Nemo's Thunderbolt)* | The islanders; the electrified rail | 8 | scene ⚑ |
| I-23 | *Ægri somnia* (Latin: *a sick man's dreams*) | Confined and drugged | 9 | scene |
| I-24 | Le royaume du corail *(The Coral Kingdom)* | The wounded man; the coral cemetery | 9 | scene + cutscene |
| II-1 | L'océan Indien *(The Indian Ocean)* | Crossing the Indian Ocean | 10 | merged |
| II-2 | Une nouvelle proposition du capitaine Nemo *(A New Proposal from Captain Nemo)* | The pearl-bank invitation | 10 | scene |
| II-3 | Une perle de dix millions *(A Ten-Million Pearl)* | The diver, the shark, the pearls | 10 | scene |
| II-4 | La mer Rouge *(The Red Sea)* | The Red Sea; the tunnel revealed | 11 | cutscene |
| II-5 | Arabian-Tunnel | The passage under the isthmus | 11 | scene or cutscene |
| II-6 | L'archipel grec *(The Greek Archipelago)* | Nicolas; the gold; Santorini | 12 | scene |
| II-7 | La Méditerranée en quarante-huit heures *(The Mediterranean in Forty-Eight Hours)* | The Mediterranean at speed | 12 | journal |
| II-8 | La baie de Vigo *(Vigo Bay)* | Ned's plan vs Nemo's galleons | 13 | scene (main fork) |
| II-9 | Un continent disparu *(A Vanished Continent)* | Atlantis | 14 | scene (wonder) |
| II-10 | Les houillères sous-marines *(The Undersea Coal Mines)* | Volcanic harbour; coal mines | 14 | scene |
| II-11 | La mer de Sargasses *(The Sargasso Sea)* | The Sargasso Sea | 15 | journal |
| II-12 | Cachalots et baleines *(Sperm Whales and Baleen Whales)* | The whale argument; the massacre | 15 | scene |
| II-13 | La banquise *(The Ice Pack)* | Under the ice | 16 | scene |
| II-14 | Le pôle Sud *(The South Pole)* | The pole; the black flag | 16 | scene |
| II-15 | Accident ou incident ? *(Accident or Incident?)* | The iceberg overturns | 17 | cutscene |
| II-16 | Faute d'air *(Short of Air)* | Trapped; the sacrifice; ramming free | 17 | scene |
| II-17 | Du cap Horn à l'Amazone *(From Cape Horn to the Amazon)* | Air again; heading north | 18 | merged |
| II-18 | Les poulpes *(The Squid)* | Squid attack; Nemo saves Ned; Nemo weeps | 18 | scene + cutscene |
| II-19 | Le Gulf-Stream *(The Gulf Stream)* | Nemo withdraws; Ned's despair; storm | 19 | scene |
| II-20 | Par 47°24' de latitude et de 17°28' de longitude *(At Latitude 47°24', Longitude 17°28')* | The *Vengeur* | 19 | scene |
| II-21 | Une hécatombe *(A Hecatomb)* | The warship; the portrait | 20 | cutscene + choice |
| II-22 | Les dernières paroles du capitaine Nemo *(Captain Nemo's Last Words)* | Last words; the skiff; the Maelstrom | 21 | scene |
| II-23 | Conclusion | The Lofoten hut | 21 | epilogue |

Nothing is cut outright. The trims are I-13, II-7 and II-11 becoming journal entries, and I-12, II-1 and II-17 being merged into their neighbours.

A note on « poulpes »: in Verne's French the word is used loosely (the text also calls them « calmars »), and the animals behave like giant squid. The game draws them from his description, not from any film.

---

## 4. Voices, with references

Fuller notes are in the character sheets (`tools/character-sheets/`).

- **Aronnax:** learned, measured, curious; the narrator, so the journal is in his voice. He addresses Nemo as « monsieur » or « capitaine », and Ned as « mon brave Ned » *(my good Ned)*.
- **Conseil:** always the third person: « Comme il plaira à monsieur » *(As Monsieur pleases)* (I-3); « Que monsieur ne craigne pas de respirer. Il y en a pour tout le monde. » *(Monsieur need not be afraid to breathe. There's enough for everyone.)* (II-17). Calm, classifying, devoted. In English the third person must survive: "Would Monsieur care to…".
- **Ned Land:** Québécois, blunt, with oaths: « Eh ! mille diables ! » *(Hell and damnation!)* (I-7). His homesickness: « c'est mon fleuve à moi le fleuve de Québec » *(it's my own river, the river of Québec)* (II-19).
- **Nemo:** formal and sparing, with silences. His key lines, with our translations, are quoted in chapters 4, 10, 18, 20 and 21 above.

**Translation notes for the script:**
- « mille diables » is literally "a thousand devils"; English needs a period oath of the same weight, not a literal rendering.
- « monsieur » stays as "Monsieur" in Conseil's lines; it is the joke.
- Nemo's « Je me devais cette revanche » is ambiguous (revenge on the squid for his lost man, or settling his account with Ned); keep the ambiguity in English.

---

## 5. Decisions this draft raises

| ⚑ | Decision | Card |
|---|---|---|
| 1 | Act 1 Aronnax-only, switching from chapter 4 | TTLUTS-5 |
| 2 | The skiff: secret location or known (chapter 5 assumes "reach it unseen") | TTLUTS-5 |
| 3 | The consequence flags proposed above, and the main fork in chapter 13 (Vigo) | TTLUTS-3 |
| 4 | How much of Nemo's past is revealed. The clues: what he saw (9), the Cretan gold (12), the French cry (18), the *Vengeur* (19), the portrait (20) | TTLUTS-4 |
| 5 | Keep, rework or cut the Gueboroar episode (8) | new card needed |
| 6 | Which cut-candidates (11, 12, 15, 19) stay playable | TTLUTS-29 / TTLUTS-30 |
