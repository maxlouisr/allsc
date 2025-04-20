
(
~cuves.stop(0);

~cuves.play(fadeTime:0);

// ~bells.play(fadeTime: 20);
)

~cuves.stop;


---


(
~one = Ndef(\t_one, Pbind(\instrument, \percsinefb, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf), atk: 20, rel: 30, amp: 0.07, feedback: 1/2, dur: 5, pan: Pwhite(-1, 1.0, inf)])).play(fadeTime:30);

~two = Ndef(\t_two, Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf), atk: 20, rel: 30, amp: 2, dur: 10, pan: Pwhite(-1, 1.0, inf)])).play(fadeTime:30);
)

~one.stop(30)
~two.stop(30)


(

Ndef(\x).clear;

x = Ndef(\x, {var snd, mc, lfo;
	mc = 10;
	// lfo = LFNoise2.kr(\xmod.kr(0.3)).range(0, 3.0);
	lfo = LFNoise2.kr(0.3).range(0, 3.0);
	// snd = SinOscFB.ar({exprand(20, 3000)}!mc, lfo.range(0, \fb.kr(1.0)), {LFNoise2.kr(3, 0.05, 0.1)}!mc);
	snd = SinOscFB.ar(([200, 220, 500, 380]*[[0.5, 0.25, 1, 2]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(1.0)), {lfo.range(0, 0.05)}!10);
	// snd = BPF.ar(snd, {exprand(20, 3000)});
	snd = HPF.ar(snd, 100);
	// snd = SplayAz.ar(8, snd, 1, 1, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0);
	snd = SplayAz.ar(~numChannels * 2, snd, 1, 1, 2, lfo.range(0, \mod.kr(2, 1))) * 0.3 * \amp.kr(0);
	snd = snd.blend(JPverb.ar(snd, 6), \jpverb.kr(0));
});


Ndef(\x).play;

MIDIdef.cc(\xamp, {|val| Ndef(\x).set(\amp, val.linexp(0, 127, 0.01, 50))}, 12, 0).fix;
// MIDIdef.cc(\xmod, {|val| Ndef(\x).set(\xmod, val.linlin(0, 127, 0.01, 0.5))}, 13, 0).fix;
// MIDIdef.cc(\mod, {|val| Ndef(\x).set(\mod, val.linlin(0, 127, 0.5, 4))}, 13, 0).fix;
MIDIdef.cc(\xfb, {|val| Ndef(\x).set(\fb, val.linlin(0, 127, 0, 1.5))}, 13, 0).fix;
MIDIdef.cc(\xverb, {|val| Ndef(\x).set(\jpverb, val.linexp(0, 127, 0.01, 0.5))}, 13, 0).fix;

// MIDIdef.clear;

);


(
~p1.stop; ~p2.stop;

~p1 = Pdef(\sinesaw_mono, Pbind(\instrument, \sinesaw, \dur, 7, \freq, Pxrand([200, 220, 500, 380], inf), \amp, 0.3, \out, Pxrand((0..(~numChannels-1)), inf))).play;
~p2 = Pbind(*[\instrument, \percsine_mono, dur: Pwhite(1, 3), freq: Pxrand([200, 220, 500, 380], inf), \amp, 0.1, \out, Pxrand((0..(~numChannels-1)), inf)]).play;

);


(
~wpyramid.play;
~washes.play(fadeTime:30);
)

(
~washes.stop(30);
~wpyramid.stop;
)



(
~glis = Pbindef(\glisses, \instrument, \fmlmulti,
	\freqA, exprand(2000, 100), \freqB, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf),
	\dur, Pxrand([13, 7, 18], inf),
	\time, Pxrand([0.1, 0.1, 0.2, 0.1, 0.5, 1.0], inf),
	\amp, 0.1,
	\atk, 0.01, \rel, 10,
	\pan, Pwhite(0, 15.0));

Pbindef(\glisses).play;
)

Pbindef(\glisses).stop;




(
a.play(fadeTime:0);

MIDIdef.cc(\air_amp, {|val| a.set(\amp, val.linlin(0, 127, 0, 1))}, 10).fix;
// MIDIdef.cc(\avion, {|val| a.set(\avion, val.linlin(0, 127, 0.01, 1))}, 9).fix;
a.set(\avion, 0.3);
MIDIdef.cc(\height, {|val| a.set(\height, val.linlin(0, 127, 0.01, 2))}, 11).fix;
)





(
MIDIdef.cc(\rrramp, {|val| ~rrr.set(\amp, val.linlin(0, 127, 0, 2)) }, 4).fix;
MIDIdef.cc(\rrrdens, {|val| ~rrr.set(\density, val.linlin(0, 127, 1, 30)) }, 5).fix;
~rrr.play(fadeTime:0);
)

~rrr.stop(30);





(
u = Ndef(\u, {var snd, nchans;
		nchans = ~numChannels;
		snd =
		{
		SinOsc.ar(Demand.kr(Dust.kr(1), 0, Drand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5, 2]]).flatten, inf)),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, nchans)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
		)}!nchans;
		snd = snd * \amp.kr(0.5);
	});

u.play;

u.fadeTime = 0; u.xset(\minfreq, 200, \maxfreq, 20000); u[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};
)


u.stop(1);

u[10] = nil

(
u.fadeTime=10;
u[10] = \filter -> {|in| Splay.ar(JPverb.ar(in,
	t60: 10,
	damp: 0,
	size: 1,
	earlyDiff: 0.7,
	modDepth: 0.2,
	modFreq: 2,
	low: -1,
	mid: 0.2,
	high: 0.3,
	lowcut: 100,
	highcut:1000);
)}
);


