
Routine.run({

	(
		w = Array.new;
		~folder = PathName("/Users/maxlouisraugel/Documents/son/w/");

		~folder.entries.do({
			arg path;
			w = w.add(Buffer.read(s, path.fullPath));
		})
	);

	s.sync;


	(
		~weirds = Array.new;
		~buffers = [
			"/Users/maxlouisraugel/Documents/ /odd warm twist.wav",
			"/Users/maxlouisraugel/Documents/ /twisted1.wav",
			"/Users/maxlouisraugel/Documents/ /twist voix 1.wav",
			"/Users/maxlouisraugel/Documents/ /twist grey hard.wav"
		];

		~buffers.size.do({
			arg index;
			~weirds = ~weirds.add(Buffer.read(s, ~buffers[index]));
		})
	);

	(
		~iterbuf = Array.new;
		~iterbufpaths = [
"/Users/maxlouisraugel/Documents/ /orb§3.wav",
"/Users/maxlouisraugel/Documents/ /resonance 39428.wav"
];

		~iterbufpaths.size.do({
			arg index;
			~iterbuf = ~iterbuf.add(Buffer.read(s, ~iterbufpaths[index]));
		})
	);


	s.sync;

	(
		~sipclick = Array.new;
		~buffers =
			[
"/Users/maxlouisraugel/Documents/ /sipclick2.wav",
"/Users/maxlouisraugel/Documents/ /sipclick.wav"
];

		~buffers.size.do({
			arg index;
			~sipclick = ~sipclick.add(Buffer.read(s, ~buffers[index]));
		})
	);

	s.sync;

	~coupdevent = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /coupdevent2.wav");

	s.sync;

	~subformant2 = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/sub formant 2.wav");

	s.sync;

	~swellold = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /swell old.wav");

	s.sync;

	~shortesaw = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/short excerpt sawing.wav");

	s.sync;

	~bize5 = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /biz&é5.wav");

	s.sync;


		~drippyonplastic = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/drippy on plastic.wav");

	s.sync;

		~orb50 = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /orb50.wav");

	s.sync;

		~sloop1 = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /sloop1.wav");

	s.sync;


	~slibit = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /slibit.wav");

	s.sync;

	~harmonies = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/harmonies.wav");
	// ~setting = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/setting.wav");
	// ~ici = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/ici.wav");
	// ~brutobstruction = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/brut obstruction.wav");
	~absurdes = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/absurdes.wav");
	// ~horizon = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/horizon.wav");
	// ~bleu = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/bleu.wav");
	// ~ciel = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/ciel.wav");
	// ~purpledusk = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/purple dusk.wav");
	// ~effusions3 = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/effusions3.wav");
	// ~dramaticwine = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/dramatic wine.wav");
	~cygne = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/cygne.wav");
	// ~notimedraft = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/no time draft.wav");
	// ~distortionsaida = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/distortions-aida.wav");
	~howmuch = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/how much.wav");
	// ~geometriezither = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/geometrie zither.wav");
	// ~cagnar = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/cagnar.wav");
	// ~kindsof = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/kinds of.wav");
	// ~aleauderose = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/a l'eau de rose.wav" );
	// ~cle = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/cle.wav");

	~routine = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/Routine.aiff");

	// ~aidaheadphoneopera = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/aida headphone opera.wav");

	// ~propellerfan = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/pm_gl_fan_propeller_impact_metal_rattle_2.wav");

	~djembefeedbackloop = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /djembé feedback loop o.wav");

	// ~usedtobe = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/used to be.wav");

	// following might have changed name, but still contains 'vibration grave'
	~vibrationgrave = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/vibration grave (bois ou verre).WAV");

	// following might
	// ~pygmee = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/pygmee.aiff");

	~etirements = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/etirements2.wav");

	~stableflight = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/stable flight.aif");

	// ~ground14 = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/ground_014.aif");

	// ~ground = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/ground.aif");

	// ~iterationsvoix = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/iterations voix.wav");

	// ~zapdown = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /zap down.wav");

	~marinero = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/marinero.wav");

	~eternal = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/eternal.wav");

	~gentle008 = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/gentle_008.aif");

	// ~vocoderfeedbackbuffer = Buffer.read(s, "/Volumes/backup/son/vocoder feedback!.wav");

	~highheavysoft = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /high heavy soft.wav");

	~clefboucle = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/clefboucle.wav");


	~rhythm1 = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SC_201001_154349.aiff");
	~cymbalsoft = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /cymbal soft.wav");

	~aidaheartbeatnote = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/aida heartbeat note.wav");

	// ~oddhighspikes = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SC_200829_004117.aiff");

	// ~highspikes = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SC_200829_003137.aiff");

	~brilliantradiator = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/brilliant radiator.WAV");

	~armoire = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/armoire.WAV");

	~closetexture = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/close texture.WAV" );

	~ondesnuit = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SC_200928_215046.aiff");

	~ourvoices = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/our voices +.aif");


	~fanclose = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/fan close.wav");

	~glitches = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SC_210511_143546.wav");

	~pigeon = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/son/pigeon paris.WAV", channels:0);

	~resonancetoilette = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /resonance toilette drive (even harmonics).wav", channels: 0);

	~cleartick = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /cleartick ..wav");

	~multidrums = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/multi drums.wav");

	~saggingdirtholes = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/sagging dirtholes.aif");

	~funny = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/funny.aiff");

	~tingle = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/tingle.wav");

	~gouttes = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/G O U T T E S.wav");

	~electricite = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/électricité.WAV");

	~miracle = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/mir acle.wav" );

	~justaboutloop = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/just about loop.wav");

	~jevaistefrapper = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/rires je vais te frapper.wav");

	~fire = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/fire *.WAV");

	~theywontcome = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/they won't come (june).wav");


	~joyeuxanniversaire = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/joyeux anniversaire.WAV");

	~creakingwood = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/CREAKING WOOD.wav");


	~matiereparticulaire = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/matiere particulaire.aiff" );


	~rejets = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/rejets.wav" );

	~creakingchair = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/creaking chair.wav");

	~firebottle = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /fire bottle ..wav");

	~pitchfollow2 = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /pitchfollow2.wav");

	~filamentsedit = Buffer.read(s, "Users/maxlouisraugel/Documents/son/filaments.wav");

	~withzone = Buffer.read(s, "Users/maxlouisraugel/Documents/son/withzone.wav");

	~clef = Buffer.read(s, "Users/maxlouisraugel/Documents/son/clef.wav");

	~farinetuna = Buffer.read(s,"/Users/maxlouisraugel/Documents/son/farine tuna.WAV");

	~bassdrum023 = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /bassdrum_23.wav");

	~basseabstraite = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /bass abstraite.wav");

	~verrenote = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /verre note.wav");

	~rambardemicrotactile = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/rambarde micro tactile.wav");

	~basslighttick = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /basslighttick ..wav");

	~declicbassriche = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /declic bass riche x.wav");

	~artlan = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/artificial landscape.wav");

}
);


