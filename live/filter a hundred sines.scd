(
~filter.release;
~filter = {
	var snd, trig;
	trig = Dust.kr(8);
	trig = ToggleFF.kr(trig);
	snd = LFSaw.ar({exprand(20, 20000)}!33, 0, 0.1);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, trig.linlin(0, 1, 50, 20000).lag(0.3));
	// snd = MoogFF.ar(snd, trig.linlin(0, 1, 20, 20000).lag(0.3), 0) * 3;
	// snd = snd.blend(GVerb.ar(snd, 1, 1, 0.1), 0.1);
}.play;
)