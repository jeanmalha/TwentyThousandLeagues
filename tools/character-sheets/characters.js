// Character design data for Twenty Thousand Leagues.
// Source: Jules Verne, Vingt mille lieues sous les mers (Hetzel), French original only:
// docs/source/verne/fr-verne-5097.txt. Chapter refs: "I-4" = Part 1, chapter IV.
// Quotes are verbatim from the French public-domain text.

window.CAST = [
  {
    id: "aronnax",
    name: "Pierre Aronnax",
    title: "Professeur-suppléant au Muséum d'histoire naturelle de Paris",
    tier: "playable",
    acts: [1, 2, 3, 4],
    concept: "The narrator and the game's main lens: a scholar who is half prisoner and half delighted guest, and can't decide which.",
    stats: { age: "40", height: "Medium (not stated)", origin: "Paris, France", firstSeen: "I-2 « Le pour et le contre »" },
    verb: { name: "Recall", note: "Pulls a fact from his journal; opens new topics with Nemo." },
    verne: [
      { q: "En ma qualité de professeur-suppléant au Muséum d'histoire naturelle de Paris, le gouvernement français m'avait joint à cette expédition.", ref: "I-2", en: "As assistant professor at the Natural History Museum in Paris, I had been attached to the expedition by the French government." },
      { q: "Qu'on m'excuse de dire ainsi que j'avais quarante ans.", ref: "I-3", en: "Forgive me for putting it that way: I was forty." },
      { q: "J'avais publié en France un ouvrage in-quarto en deux volumes intitulé : Les Mystères des grands fonds sous-marins.", ref: "I-2", en: "In France I had published a two-volume quarto entitled The Mysteries of the Great Ocean Depths." }
    ],
    personality: ["Curious to the point of forgetting he is a prisoner", "Courteous, a little vain about his book", "Torn between admiring Nemo and condemning him", "Protective of his two companions"],
    wants: "To see and understand the sea floor; later, to bring his notes home.",
    fears: "Losing the manuscript, and becoming complicit in Nemo's violence.",
    arc: "From enthralled guest to reluctant witness: after the Hecatomb he is the one who decides they must leave.",
    voice: {
      register: "Learned, precise, slightly formal, with long sentences; he narrates.",
      tics: ["Latin and taxonomic names", "Counts and measures everything", "Says « Monsieur » to Nemo, « mon brave Ned » to Ned"],
      lines: []
    },
    visual: {
      build: "Verne gives almost no physical description, so the design is ours. Suggest a medium build and the posture of a man who spends his days at a desk.",
      face: "Ours to invent. Suggest a trimmed beard and spectacles, which would make his portrait read 'scholar' at a glance.",
      costume: "A travelling naturalist of the 1860s: frock coat, waistcoat, a notebook always in hand. Later, Nautilus-issue clothes made of the ship's sea-fibre cloth.",
      props: ["Journal and pencil (the game's journal is his)", "Magnifying glass"],
      silhouette: "The tallest hat-less outline of the three, with a notebook held at the chest. He must read differently from Ned's bulk and Conseil's neat, compact shape."
    },
    portrait: {
      expressions: ["Neutral, attentive", "Wonder (wide eyes, lips parted)", "Scholarly delight", "Unease", "Moral horror (Hecatomb)", "Resolve"],
      idle: "Slow blink; glances down at his notebook now and then.",
      special: "Recall pose: eyes up and to the side, pencil touching his lip."
    },
    palette: ["#2b3a4a", "#55697a", "#c9b48a", "#e8dcc2", "#7a4b2a"],
    notes: ["He's the narrator, so the journal's text is in his voice.", "His POV variant of a location picks out specimens, instruments and books."],
    open: ["Beard or clean-shaven?", "Does he keep his frock coat after the shipwreck in Act 1?"]
  },
  {
    id: "conseil",
    name: "Conseil",
    title: "Domestique du professeur Aronnax",
    tier: "playable",
    acts: [1, 2, 3, 4],
    concept: "A loyal, phlegmatic Flemish servant who classifies the whole ocean and addresses his master only in the third person.",
    stats: { age: "30", height: "Medium; solid", origin: "Flanders (Belgium)", firstSeen: "I-3 « Comme il plaira à monsieur »" },
    verb: { name: "Catalogue", note: "Identifies a creature or object and writes it to the journal." },
    verne: [
      { q: "Un garçon dévoué qui m'accompagnait dans tous mes voyages ; un brave Flamand que j'aimais et qui me le rendait bien, un être phlegmatique par nature, régulier par principe, zélé par habitude.", ref: "I-3", en: "A devoted lad who came with me on all my travels; a good Fleming whom I was fond of and who returned the feeling, phlegmatic by nature, orderly on principle, zealous by habit." },
      { q: "Classer, c'était sa vie, et il n'en savait pas davantage.", ref: "I-3", en: "Classifying was his life, and he knew nothing beyond it." },
      { q: "Il n'eût pas distingué, je crois, un cachalot d'une baleine !", ref: "I-3", en: "I doubt he could have told a sperm whale from a baleen whale!" },
      { q: "Des muscles solides, mais pas de nerfs, pas l'apparence de nerfs.", ref: "I-3", en: "Solid muscles, but no nerves: not a sign of nerves." },
      { q: "Formaliste enragé il ne me parlait jamais qu'à la troisième personne -- au point d'en être agaçant.", ref: "I-3", en: "A rabid stickler for form, he never addressed me except in the third person, to the point of being exasperating." }
    ],
    personality: ["Unflappable", "Devoted without being servile", "Pedantic about classification and weak on practice", "Deadpan: his comedy comes from calm in the middle of chaos"],
    wants: "To follow Monsieur wherever he goes, and to complete the classification.",
    fears: "Very little, and that's the joke. He is only shaken when Aronnax is in danger.",
    arc: "Steady throughout. Under the ice, he and Ned give Aronnax the last of the air (II-16 « Faute d'air »): the emotional peak of his character.",
    voice: {
      register: "Polite, formal and always in the third person (« Monsieur veut-il… »), with precise taxonomic jargon.",
      tics: ["Third person for his master", "Lists of class, order, family and genus", "Never offers advice unless asked"],
      lines: [{ q: "Comme il plaira à monsieur.", ref: "I-3", en: "As Monsieur pleases." }]
    },
    visual: {
      build: "Solid and healthy-looking, with steady, economical poses. He's never off balance.",
      face: "Calm, regular features; an expression of neutral attentiveness. Clean and tidy.",
      costume: "A servant's neat dark suit, buttoned up even underwater, with a collar that is always straight.",
      props: ["A small specimen box or labels", "A pencil behind the ear (pairs with Aronnax's notebook)"],
      silhouette: "Compact and upright, with symmetrical posture. Neatness is the readable trait."
    },
    portrait: {
      expressions: ["Neutral (his default for 80% of lines)", "A faint satisfaction when classifying", "Mild surprise (barely visible: that's the joke)", "Concern for Monsieur", "Quiet resolve"],
      idle: "Almost motionless; a single, precise blink.",
      special: "Catalogue pose: one finger raised, eyes closed, as he recites the taxonomy."
    },
    palette: ["#1f2a30", "#3d4f56", "#d8cfbf", "#9aa6a0", "#b08d57"],
    notes: ["The third person must work in English too (« Would Monsieur care to… »).", "His POV picks out creatures and anything that can be classified."],
    open: ["Hair colour (Verne doesn't say); fair would suit 'Flemish'.", "Does he have a running count of catalogue entries as a gag?"]
  },
  {
    id: "ned",
    name: "Ned Land",
    title: "Harponneur canadien",
    tier: "playable",
    acts: [1, 2, 3, 4],
    concept: "A French-Canadian master harpooner: blunt, physically formidable, and treating the whole voyage as a prison sentence.",
    stats: { age: "About 40", height: "Over 6 English feet", origin: "Québec, Canada (French-speaking family)", firstSeen: "I-4 « Ned Land »" },
    verb: { name: "Force", note: "Pries, lifts, throws or breaks what the others can't." },
    verne: [
      { q: "Ned Land était un Canadien, d'une habileté de main peu commune, et qui ne connaissait pas d'égal dans son périlleux métier.", ref: "I-4", en: "Ned Land was a Canadian of uncommon skill with his hands, and he had no equal in his dangerous trade." },
      { q: "C'était un homme de grande taille -- plus de six pieds anglais -- vigoureusement bâti, l'air grave, peu communicatif, violent parfois, et très rageur quand on le contrariait.", ref: "I-4", en: "He was a tall man, over six English feet, powerfully built, grave-looking, not very talkative, sometimes violent, and quick to anger when crossed." },
      { q: "Sa personne provoquait l'attention, et surtout la puissance de son regard qui accentuait singulièrement sa physionomie.", ref: "I-4", en: "He drew attention, above all through the power of his gaze, which gave his face a singular force." },
      { q: "Je ne saurais le mieux comparer qu'à un télescope puissant qui serait en même temps un canon toujours prêt à partir.", ref: "I-4", en: "The best I can compare him to is a powerful telescope that was also a cannon, always ready to fire." }
    ],
    personality: ["Impatient and quick to anger", "Practical, a sharp observer (exceptional eyesight)", "Warm once he trusts you; tells his stories like an epic", "Hates being confined"],
    wants: "Freedom, land under his feet, and a proper meal of meat.",
    fears: "Dying a prisoner far from the open air.",
    arc: "Drives every escape attempt, and his patience runs out gradually until the Maelstrom. Yet under the ice he gives his own air to Aronnax, with Conseil (II-16): « C'étaient Ned et Conseil, mes deux braves amis, qui se sacrifiaient pour me sauver. »",
    voice: {
      register: "Plain-spoken Québécois French: earthy, short sentences, oaths. Verne calls it « cette vieille langue de Rabelais ».",
      tics: ["« Mille diables ! »", "Food and hunting metaphors", "Calls Aronnax « monsieur le professeur »"],
      lines: [{ q: "Eh ! mille diables ! … ouvrez donc, navigateurs peu hospitaliers !", ref: "I-7", en: "Hell and damnation! … Open up, you inhospitable sailors!" }]
    },
    visual: {
      build: "The biggest of the three by far: broad, heavy shoulders, big hands.",
      face: "Grave and weathered; the intensity of his gaze is the key feature (Verne insists on it). Heavy brows.",
      costume: "A whaler's working clothes: a thick jersey or pea jacket, rolled sleeves, boots.",
      props: ["Harpoon (Act 1; confiscated, then missed)", "Knife"],
      silhouette: "The widest outline: a broad wedge of shoulders, arms often crossed. The harpoon makes it unmistakable in Act 1."
    },
    portrait: {
      expressions: ["Grave neutral", "Anger (jaw set, brows down)", "Scorn for the Nautilus", "Hunter's focus (narrowed eyes)", "Rare warm grin", "Despair"],
      idle: "A restless shift of weight; his eyes scan the edges of the frame.",
      special: "Force pose: shoulders squared, a close-up of the hands."
    },
    palette: ["#2a2420", "#5a3d2b", "#8c5a3c", "#c79a6b", "#3f5a4a"],
    notes: ["His POV picks out exits, weak points, weapons and food.", "His eyesight rivals Nemo's, which is a possible puzzle hook."],
    open: ["Beard?", "How much Québécois dialect goes into the French lines, and how is it rendered in English?"]
  },
  {
    id: "nemo",
    name: "Capitaine Nemo",
    title: "Commandant du Nautilus",
    tier: "npc-major",
    acts: [2, 3, 4],
    concept: "A brilliant, wounded man who has broken with all of society. Courteous, magnetic and capable of terrible violence. He stays ambiguous to the end.",
    stats: { age: "Unclear: « trente-cinq ou cinquante ans »", height: "Tall", origin: "Deliberately unplaceable (Aronnax can't tell)", firstSeen: "I-8 « Mobilis in mobile »" },
    verb: { name: "None (not playable)", note: "Dialogue hub; his replies change with what has been Recalled." },
    verne: [
      { q: "Ce personnage avait-il trente-cinq ou cinquante ans, je n'aurais pu le préciser. Sa taille était haute, son front large, son nez droit, sa bouche nettement dessinée, ses dents magnifiques, ses mains fines, allongées.", ref: "I-8", en: "Was the man thirty-five or fifty? I could not have said. He was tall, with a broad forehead, a straight nose, a clearly drawn mouth, magnificent teeth, and fine, long hands." },
      { q: "Ses yeux noirs regardaient avec une froide assurance … sa peau, pâle plutôt que colorée, annonçait la tranquillité du sang.", ref: "I-8", en: "His black eyes looked out with cold assurance … his skin, pale rather than ruddy, spoke of calm blood." },
      { q: "Ses yeux, un peu écartés l'un de l'autre, pouvaient embrasser simultanément près d'un quart de l'horizon.", ref: "I-8", en: "His eyes, set a little wide apart, could take in nearly a quarter of the horizon at once." },
      { q: "Les deux inconnus, coiffés de bérets faits d'une fourrure de loutre marine, et chaussés de bottes de mer en peau de phoque.", ref: "I-8", en: "The two strangers wore berets of sea-otter fur and sea boots of sealskin." },
      { q: "Je ne suis pas ce que vous appelez un homme civilisé ! J'ai rompu avec la société tout entière pour des raisons que moi seul j'ai le droit d'apprécier.", ref: "I-10", en: "I am not what you call a civilised man! I have broken with the whole of society, for reasons that I alone have the right to judge." },
      { q: "Cet Indien, monsieur le professeur, c'est un habitant du pays des opprimés, et je suis encore, et, jusqu'à mon dernier souffle, je serai de ce pays-là !", ref: "II-3", en: "That Indian, Professor, is a native of the land of the oppressed, and I am still, and until my last breath I shall remain, of that land!" },
      { q: "Je suis le droit, je suis la justice ! … Je suis l'opprimé, et voilà l'oppresseur !", ref: "II-21", en: "I am the law, I am justice! … I am the oppressed, and there is the oppressor!" },
      { q: "Ce terrible justicier, véritable archange de la haine, regardait toujours.", ref: "II-21", en: "That terrible avenger, a very archangel of hatred, was still watching." }
    ],
    personality: ["Courteous and cultivated (art, science, music)", "Proud and self-contained", "Generous to the oppressed, merciless to his enemies", "Grieving: the portrait of a wife and two children (II-21)"],
    wants: "Freedom from all nations; justice, or vengeance, against the power that destroyed his family.",
    fears: "Never stated. The game never tells the player.",
    arc: "Host → enigma → protector (the pearl diver) → avenger (the Hecatomb) → broken man: « Dieu tout puissant ! assez ! assez ! » (II-22).",
    voice: {
      register: "Measured, elegant and economical, with long silences. He never explains himself.",
      tics: ["Answers questions with questions", "« Monsieur le professeur »", "Speaks to his crew in an unknown language"],
      lines: [
        { q: "Dieu tout puissant ! assez ! assez !", ref: "II-22", en: "Almighty God! Enough! Enough!" }
      ]
    },
    visual: {
      build: "Tall and upright, with a noble carriage: « sa tête se dégageait noblement sur l'arc formé par la ligne de ses épaules ».",
      face: "Broad forehead, straight nose, a clearly drawn mouth, dark eyes set slightly wide apart, pale skin. When he looks closely, his brows knit and his eyelids narrow: this is a key portrait expression.",
      costume: "The sea-otter fur beret, sealskin sea boots and close-fitting clothes of the ship's own cloth (I-8). His own look, drawn from the text alone, never from the 1954 film.",
      props: ["The organ (salon)", "Telescope or sextant on the platform", "His cabin's portraits"],
      silhouette: "A tall, still vertical: the calmest outline in the game. Stillness is the design."
    },
    portrait: {
      expressions: ["Composed neutral", "The narrowed 'seeing' gaze (I-8)", "Courteous half-smile", "Cold anger (« un éclair de colère et de dédain »)", "Absorbed at the organ (« plongé dans une extase »)", "Grief (II-21)", "Torment (II-22)"],
      idle: "Near-total stillness; breathing only. Silences are written as beats in the script.",
      special: "At the organ: shown in profile with his hands on the keys, an anchor image for the music theme."
    },
    palette: ["#0e1a24", "#1d3a4a", "#3b6b78", "#c9a24a", "#e9e2d0"],
    notes: ["Verne leaves his origin open on purpose (I-8: « espagnols, turcs, arabes ou indiens, c'est ce que leur type physique ne me permet pas de décider »). Keep it unplaceable; avoid exotic stereotypes. This is tied to the Nemo's-past decision (TTLUTS-4).", "Rights: no 1954 Disney Nemo (no uniform with insignia, no film likeness)."],
    open: ["How much of his past is revealed (TTLUTS-4)?", "Beard? Verne doesn't mention one."]
  },
  {
    id: "second",
    name: "Le second",
    title: "Second du Nautilus",
    tier: "npc-minor",
    acts: [2, 3, 4],
    concept: "The ship's first officer: short, vigorous and expressive, and he only ever speaks the crew's unknown language.",
    stats: { age: "Not stated", height: "Short", origin: "Unknown (Aronnax thinks « méridional »)", firstSeen: "I-8" },
    verb: { name: "None", note: "Can't be talked to in any language the trio understands; communicates by gesture." },
    verne: [
      { q: "L'un était de petite taille, vigoureusement musclé, large d'épaules, robuste de membres, la tête forte, la chevelure abondante et noire, la moustache épaisse, le regard vif et pénétrant.", ref: "I-8", en: "One was short, powerfully muscled, broad in the shoulder and sturdy of limb, with a strong head, thick black hair, a heavy moustache, and a quick, piercing gaze." },
      { q: "Il employa toujours devant moi un idiome singulier et absolument incompréhensible.", ref: "I-8", en: "In front of me he always used a strange and utterly incomprehensible language." }
    ],
    personality: ["Lively and expressive", "Loyal to Nemo", "Opaque to the trio"],
    wants: "Unknown.",
    fears: "Unknown.",
    arc: "A constant presence; his daily phrase on the platform is a ritual the player learns to recognise.",
    voice: {
      register: "The unknown language only, with lots of gesture. Don't translate it.",
      tics: ["The same daily report on the platform"],
      lines: [{ q: "Nautron respoc lorni virch.", ref: "I-15", en: "(Untranslated: the crew's unknown language. Never translate it.)" }]
    },
    visual: {
      build: "Short, broad-shouldered and very muscular.",
      face: "A strong head, thick black hair, a thick moustache and a lively gaze.",
      costume: "Crew clothes of the ship's cloth, fur beret, sealskin boots.",
      props: ["Telescope (the morning report)"],
      silhouette: "Short and wide: the opposite of Nemo's tall vertical when they stand side by side."
    },
    portrait: {
      expressions: ["Lively neutral", "Emphatic gesture", "Alarm"],
      idle: "Restless; his hands move as he talks.",
      special: "None."
    },
    palette: ["#1a2630", "#2f4756", "#141414", "#a37b4f", "#d9cbb0"],
    notes: ["His unknown language could become a small puzzle (learning a few words over the acts)."],
    open: ["Should the player ever learn what « Nautron respoc lorni virch » means?"]
  },
  {
    id: "stewart",
    name: "Le stewart",
    title: "Steward du Nautilus",
    tier: "npc-minor",
    acts: [2],
    concept: "The silent steward who brings the prisoners' meals; Ned half-strangles him in a fit of rage.",
    stats: { age: "Not stated", height: "Not stated", origin: "Crew", firstSeen: "I-8" },
    verb: { name: "None", note: "Doesn't speak." },
    verne: [
      { q: "Le stewart muet, sourd peut-être avait disposé la table.", ref: "I-8", en: "The steward, mute and perhaps deaf, had laid the table." },
      { q: "Le stewart étouffait sous sa main puissante.", ref: "I-9", en: "The steward was choking under his powerful hand." }
    ],
    personality: ["Silent and impassive"],
    wants: "—", fears: "—",
    arc: "Ned's attack on him (I-9) is what makes Nemo show himself (I-10): a possible early story beat.",
    voice: { register: "Mute.", tics: [], lines: [] },
    visual: {
      build: "Ordinary crew build; generic but consistent.",
      face: "Impassive.",
      costume: "Crew clothes; he carries trays.",
      props: ["Meal tray"],
      silhouette: "Generic crew."
    },
    portrait: { expressions: ["Impassive", "Choking (I-9)"], idle: "Static.", special: "None." },
    palette: ["#1a2630", "#2f4756", "#cfc4ad"],
    notes: ["A cheap NPC: he can share a base sprite with the generic crew."],
    open: []
  },
  {
    id: "crew",
    name: "L'équipage et le blessé",
    title: "Crew of the Nautilus, and the wounded sailor",
    tier: "npc-minor",
    acts: [2, 3, 4],
    concept: "A wordless crew loyal to Nemo. One sailor, struck by a broken engine lever, is examined by Aronnax, dies, and is buried in the coral cemetery.",
    stats: { age: "Various", height: "Various", origin: "Many nations (unknown)", firstSeen: "I-8; the wounded sailor in I-24" },
    verb: { name: "None", note: "—" },
    verne: [
      { q: "« Cet homme sera mort dans deux heures. -- Rien ne peut le sauver ? -- Rien. »", ref: "I-24", en: "This man will be dead within two hours. — Can nothing save him? — Nothing." },
      { q: "Je compris tout ! Cette clairière c'était un cimetière.", ref: "I-24", en: "I understood everything! The clearing was a cemetery." }
    ],
    personality: ["Silent, disciplined and loyal"],
    wants: "—", fears: "—",
    arc: "The funeral in the coral cemetery is a 'wonder' and mourning beat that humanises Nemo before Act 3.",
    voice: { register: "Unknown language only.", tics: [], lines: [] },
    visual: {
      build: "Varied builds and features: they come from many places.",
      face: "Varied.",
      costume: "Ship's cloth, fur berets, diving suits during the funeral.",
      props: ["Lamps", "Coral cross (the funeral)"],
      silhouette: "Silhouettes in diving suits for the funeral procession."
    },
    portrait: { expressions: ["Neutral"], idle: "Static.", special: "The wounded sailor: one bedside portrait (I-24)." },
    palette: ["#1a2630", "#2f4756", "#4d6b72", "#cfc4ad"],
    notes: ["Funeral procession: a key Act 2 illustration (TTLUTS-18 cutscene)."],
    open: []
  },
  {
    id: "farragut",
    name: "Commandant Farragut",
    title: "Commandant de la frégate Abraham-Lincoln",
    tier: "npc-minor",
    acts: [1],
    concept: "The frigate's commander, a good sailor who is sure the 'monster' exists and determined to kill it.",
    stats: { age: "Not stated", height: "Not stated", origin: "United States", firstSeen: "I-3" },
    verb: { name: "None", note: "Talk target for the Act 1 puzzle (change the course)." },
    verne: [
      { q: "Le commandant Farragut était un bon marin, digne de la frégate qu'il commandait.", ref: "I-4", en: "Commander Farragut was a good seaman, worthy of the frigate he commanded." },
      { q: "Ou le commandant Farragut tuerait le narwal, ou le narwal tuerait le commandant Farragut. Pas de milieu.", ref: "I-4", en: "Either Commander Farragut would kill the narwhal, or the narwhal would kill Commander Farragut. There was no middle way." }
    ],
    personality: ["Determined", "A believer: he has no doubt about the monster", "Stubborn"],
    wants: "To kill the 'narwhal'.",
    fears: "Returning empty-handed.",
    arc: "Only in Act 1; he's the obstacle the signature puzzle has to get past.",
    voice: { register: "A naval commander: brisk orders, in English on his ship.", tics: [], lines: [{ q: "Go ahead", ref: "I-3 (in English in Verne's text)", en: "(In English in Verne's text.)" }] },
    visual: {
      build: "An upright military bearing.",
      face: "Weathered and resolute.",
      costume: "US Navy commander's uniform of the 1860s (from period references; there is no 1954-film equivalent for this character).",
      props: ["Telescope", "Speaking trumpet"],
      silhouette: "Uniform and cap: the only 'official' silhouette in the game."
    },
    portrait: { expressions: ["Resolute", "Impatient", "Triumphant"], idle: "Hands behind his back.", special: "None." },
    palette: ["#1b2236", "#2e3b5c", "#c9a24a", "#e8e2d4"],
    notes: ["The only character seen in daylight on an open deck, so his palette sits apart from the Nautilus interiors."],
    open: []
  },
  {
    id: "pearl-diver",
    name: "Le pêcheur de perles",
    title: "Pearl diver at the Manaar bank, Ceylon",
    tier: "npc-minor",
    acts: [3],
    concept: "A poor pearl diver whom Nemo saves from a shark and secretly gives a pouch of pearls. It's the clearest window onto Nemo's sympathies.",
    stats: { age: "Not stated", height: "Not stated", origin: "Ceylon (Sri Lanka)", firstSeen: "II-3 « Une perle de dix millions »" },
    verb: { name: "None", note: "Central to the Act 3 signature puzzle (the rescue)." },
    verne: [
      { q: "C'était un homme, un homme vivant … un pêcheur, un pauvre diable, sans doute, qui venait glaner avant la récolte.", ref: "II-3", en: "It was a man, a living man … a fisherman, some poor soul no doubt, come to glean before the harvest." }
    ],
    personality: ["Courageous: he dives alone with a stone and a rope"],
    wants: "To feed his family before the official harvest.",
    fears: "Sharks, and the pearl merchants.",
    arc: "Saved by Nemo; his rescue sets a consequence flag (TTLUTS-3).",
    voice: { register: "Few or no words; seen mostly underwater.", tics: [], lines: [] },
    visual: {
      build: "Lean; a free-diver's build.",
      face: "To be designed with care and dignity.",
      costume: "A loincloth, a diving stone and a rope, as described in the scene.",
      props: ["Diving stone", "Net bag", "Boat seen from below"],
      silhouette: "A small figure against the light of the surface."
    },
    portrait: { expressions: ["Fear (the shark)", "Bewilderment (Nemo's gift)"], idle: "—", special: "Seen from below through the diving helmet's porthole." },
    palette: ["#0f3a4a", "#2c6e7a", "#8a5a3b", "#e6d6b0"],
    notes: ["Sensitivity: Verne's text uses 19th-century racial labels in this passage. The game should depict him with dignity and without caricature, and avoid repeating those labels in its own lines."],
    open: ["Give him a name in the game?"]
  },
  {
    id: "gueboroar",
    name: "Les habitants de Gueboroar",
    title: "Islanders of Gueboroar, Torres Strait",
    tier: "npc-group",
    acts: [2],
    concept: "The islanders who drive off the trio's shore excursion and then try to board the Nautilus; Nemo repels them with the electrified handrail.",
    stats: { age: "—", height: "—", origin: "Gueboroar Island, near New Guinea", firstSeen: "I-20 to I-22" },
    verb: { name: "None", note: "—" },
    verne: [],
    personality: ["Defending their island from intruders"],
    wants: "To keep strangers off their shore.",
    fears: "—",
    arc: "Part of the first escape attempt (Act 2): the attempt fails, never because of a game over.",
    voice: { register: "—", tics: [], lines: [] },
    visual: {
      build: "—", face: "—", costume: "—", props: ["—"],
      silhouette: "Seen at a distance: on the beach, in canoes, on the platform's handrail."
    },
    portrait: { expressions: [], idle: "—", special: "No close-up portraits recommended." },
    palette: ["#2f4a2a", "#6b8a3e", "#c9a76b"],
    notes: ["Sensitivity, high priority: Verne's chapters depict them in colonial, dehumanising terms (« sauvages »). Don't reproduce that framing. Present them as people defending their land, seen from a distance, without mockery or caricature.", "This needs a dedicated design decision before Act 2 production."],
    open: ["Keep this episode, rework it, or cut it?"]
  },
  {
    id: "lofoten-fisherman",
    name: "Le pêcheur des Lofoten",
    title: "Fisherman of the Lofoten Islands",
    tier: "npc-cameo",
    acts: [4],
    concept: "In whose hut Aronnax wakes up after the Maelstrom. The game's last face.",
    stats: { age: "—", height: "—", origin: "Lofoten, Norway", firstSeen: "II-23 « Conclusion »" },
    verb: { name: "None", note: "Epilogue only." },
    verne: [
      { q: "… cabane d'un pêcheur des îles Loffoden.", ref: "II-23", en: "… a fisherman's hut in the Lofoten Islands." }
    ],
    personality: ["Hospitable"],
    wants: "—", fears: "—",
    arc: "Epilogue cameo.",
    voice: { register: "Norwegian; can stay offscreen or speak a single line.", tics: [], lines: [] },
    visual: { build: "—", face: "Weathered.", costume: "Northern fisherman's wool.", props: ["Lamp", "Nets"], silhouette: "Seen against a lit doorway." },
    portrait: { expressions: ["Kindly"], idle: "—", special: "—" },
    palette: ["#3a3530", "#7a6a55", "#d9c9a8"],
    notes: ["Verne spells it « Loffoden »."],
    open: []
  },
  {
    id: "nicolas",
    name: "Nicolas, du cap Matapan",
    title: "Plongeur des Cyclades, surnommé « le Pesce »",
    tier: "npc-cameo",
    acts: [3],
    concept: "A diver who appears at the salon window in the Greek archipelago; Nemo then sends out a chest of gold ingots. Aronnax connects it with the Cretan uprising. Optional, if Act 3 keeps the Mediterranean.",
    stats: { age: "—", height: "—", origin: "Cape Matapan, Greece", firstSeen: "II-6 « L'archipel grec »" },
    verb: { name: "None", note: "—" },
    verne: [
      { q: "Ne vous inquiétez pas, me dit le capitaine. C'est Nicolas, du cap Matapan, surnommé le Pesce. Il est bien connu dans toutes les Cyclades.", ref: "II-6", en: "Don't worry, said the captain. It's Nicolas, from Cape Matapan, known as the Fish. He's well known all over the Cyclades." }
    ],
    personality: ["Fearless swimmer"],
    wants: "—", fears: "—",
    arc: "Reveals Nemo funding a revolt: a strong clue for the Nemo's-past thread.",
    voice: { register: "None (seen through glass).", tics: [], lines: [] },
    visual: { build: "Swimmer.", face: "—", costume: "—", props: ["Gold, the chest of ingots"], silhouette: "A swimmer's face pressed to the salon window." },
    portrait: { expressions: [], idle: "—", special: "A single illustration at the salon panel." },
    palette: ["#0f3a4a", "#2c6e7a", "#c9a24a"],
    notes: ["Act 3 is labelled cut-first; he goes if the Mediterranean goes."],
    open: ["Keep him as a Nemo's-past clue even if the archipelago location is cut?"]
  }
];
