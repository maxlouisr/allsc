(
j.release;

~tvar = 10;

~ji1 = [1, 2, 2/3, 3/4, 3/5, 6/5, 5/6, 1/2, 4/3, 1/4];
~ji2 = {~ji1.choose}!2;

SynthDef(\ji1, {
	var snd, f, t;
	// t = Impulse.kr(LFNoise2.kr(0.3, 1, 1));
	f = \freq.kr(440);
	snd = SinOscFB.ar(f, LFNoise2.kr(0.2), 0.1);
	snd = snd * Env.perc(\atk.kr(0.01), \rel.kr(3)).kr(2);
	// snd = PanAz.ar(~numChans, snd, rrand(0, 1.0));
	Out.ar(\out.kr(0), snd);
}).add;

Pbindef(\ji1, \instrument, \moogbass,
	\dur, Pxrand(~ji1 * ~tvar, inf),
	\freq, 440 * Pxrand(~ji1, inf),
	\atk, Pwhite(0.01, 3) * (~tvar/2),
	\rel, Pwhite(3, 7) * (~tvar/2),
	\amp, 1,
	\out, Pwhite(0, 5.0)
).play;

Pbindef(\ji2, \instrument, \moogbass,
	\dur, Pxrand(~ji1 * ~tvar, inf),
	\freq, 440 * Pxrand(~ji1, inf),
	\atk, Pwhite(0.01, 3) * (~tvar/2),
	\rel, Pwhite(3, 7) * (~tvar/2),
	\amp, 1,
	\out, Pwhite(0, 5.0)
).play;

)