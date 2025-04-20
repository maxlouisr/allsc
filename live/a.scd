


"/Users/maxlouisraugel/Documents/sc/live/FX.scd".load;

// -> ABLETON INSTRUMENTS
Pbind(\instrument, \poom, *[atk: 0, rel: 1, freq: Pseq([60-36, 60-24, 60-12, 60, 60+12, 60+24, 60+36]).midicps, amp: 1, dur: 2]).play;

--------


(
C.p(\kick, folder: \bassdrums, index: 19, dur: 1/4, amp:1/3);
C.p(\snares, folder: \snares, index: Pseq([1, 2], inf), rate: Pxrand([0.7, 0.9, 1], inf), dur: Pseq([Rest(1/8), 1/8], inf), amp: 1/5);
);

(
C.s(\kick);
C.s(\snares);
)

~filaments.play(fadeTime: 30);
~filaments.stop;

~sweeps.stop; ~sweeps.reset; ~sweeps.play;
~sweeps.stop;

~samples = Pbindef(\samples, \instrument, \play, \buffer, Pxrand(50.collect{|i| w[i]}, inf), \dur, Pxrand([1, 2, 5, 1/2, 1/5], inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1/2);

~wsamples.play;
~wsamples.stop;

Ndef(\wobl).play(0);
Ndef(\wobl).stop;



------

(
~sweeps.stop;
~samples.stop;
Ndef(\wobl).stop(0);
~pond.play;
~filaments.stop(0);
)

----

(
~freeverbus = ~freeverbus ?? Bus.audio(s, 2);
~freeverb = Synth(\freeverb, [in: ~freeverbus, out: 0], s, 'addToTail');
)


(
var durs = 1/5;
Pdef(\solo,
	Pbind(
		\instrument, \percsinefb,
		\dur, durs,
		\note, Pseq([Prand(\Em.asNotes, 50), Prand(\Bm.asNotes, 25), Prand(\Am.asNotes, 25)], inf)
		+ Pseq([0, 12, 24], inf),
		\rel, Pkey(\dur),
		\detune, Prand([1, 3, -1], inf),
		\strum, Prand([0, 0.3], inf),
		\feedback, Pwhite(0, 1),
		\amp, 1/10,
		\out, ~freeverbus
	);
).play(quant:1);
)

(
~accelerate.stop;
~accelerate = Pbind(\instrument, \buffercombmodulation, \dur, Prand([1, 2], inf)/Pseg([0.5, 20, 0.5], [30, 30], 'exp'), \buffer, Prand(C.get(\snares, (0..50)), inf), \note, Pseq([Pseq(\Em.asNotes, 50), Pseq(\Bm.asNotes, 25), Pseq(\Am.asNotes, 25) ], inf), \mul, 5, \rate, 70, \add, Pkey(\freq) + Prand([10, 5, 8, 1], inf), \amp, 3).play(quant:1);
)


(
~waveys1.stop;
~waveys1 = Pbind(\instrument, \buffercombmodulation, \dur, Prand([1, 2], inf), \buffer, Prand(C.get(\thanks, [6, 6, 9, 6, 9, 6]), inf), \freq, Pseq([606, 310, 310, 606, 310, 310], inf), \mul, 5, \add, Pkey(\freq) + Prand([10, 5, 20], inf), \amp, 1).play(quant:1);
)

(
~accelerate.stop;
~waveys.stop;
~waveys = Ndef(\waveys, Pbind(\instrument, \buffercombmodulation,
	\dur, 1/16,
	\buffer, Prand(C.get(\snares, (0..50)), inf),
	\note, Pseq([Pseq(\Em.asNotes, 50), Pseq(\Bm.asNotes, 25), Pseq(\Am.asNotes, 25) ], inf),
	\mul, 5,
	\rate, 70,
	\add, Pkey(\freq) * PSinOsc(0.100001, 0, 0.1/5, 1),
	\amp, 1.5,
	\rel, Pseg([2, 0.1, 2], [30, 30], 'lin', inf)
)).play(quant:1);

~poom.stop;
~poom = Ndef(\moogbass, Pmono(\moogbass, \vibrato, 15/2, \dur, 1/16 * 3 * Pseq([50, 25, 25], inf), \atk, Pkey(\dur) - 0.1, \rel, 0.1, \midinote, Pseq([\E1, \B0, \A1].asNote, inf), \amp, 5)).play;
)



(
~poom.stop(0);
~waveys.stop(0);
~waveys1.stop;
Pdef(\solo).stop;
)



----




















--------
Ndef(\i).clear;


(
Ndef(\i, {
	var snd, trig, freqs, space, env;
	trig = Dust.kr(MouseX.kr(0.1, 3));
	env = Env.perc(0.01, 1, 0.5).ar(0, trig);
	snd = Pan2.ar(env, TRand.kr(-1, 1.0, trig));
	// freqs = TChoose.kr(trig, [50, 52, 54, 42].midicps * 4);
	freqs = TChoose.kr(trig, [42, 45, 47, 49, 50].midicps * 4);
	snd = snd.blend(Resonator.ar(snd, freqs, resolution: 24, structure: 0.5, brightness: 0.5, damping: MouseY.kr(0.7, 0.3)));


	space = \space.kr(0);
	space = space * 10;
	snd = GVerb.ar(snd, space + 1, space + 0.1, drylevel: 1);

	snd = snd * MouseY.kr(0, 2);

	// snd = (snd * 30).cos * 0.2;
	// snd = snd.blend((snd*30).sin * 0.2, 0.1 * \drive.kr(1));

	snd = LeakDC.ar(snd);
}).mold(2).fadeTime_(1);
)


Ndef(\i).play;

Ndef(\i).stop;

Ndef(\i)[10] = \set -> Pbind(\drive, Pseq([0, 0.2, 0.3, 0.8], inf))

Synth(\kick, [freq: 50, rel: 5]);


(
Ndef(\ii, {
	var snd, trig, freqs, space;
	trig = Dust.kr(MouseX.kr(0.1, 10));
	snd = Env.perc(0.01, 1, 0.5).ar(0, trig);
	snd = Pan2.ar(snd, TRand.kr(-1, 1.0, trig));
	freqs = Select.kr(SinOsc.kr(0.2, 0, 5).abs, [42, 45, 47, 49, 50].midicps * 4);
	snd = snd.blend(Resonator.ar(snd, freqs, resolution: 24, damping: MouseY.kr(0.7, 0.3)));
	snd = GVerb.ar(snd, 1, 0.1, drylevel: 1);
	snd = (snd*30).sin * 0.2;
	snd = snd.blend((snd*10).cos * 0.2, 0.1 * \drive.kr(0));
	snd = LeakDC.ar(snd);
}).mold(2);
)

Ndef(\ii).play;
Ndef(\ii).stop;

(
Ndef(\kick, {
	var snd, trig, freq, freqs, space;
	freq = \freq.kr(40) * Line.kr(10, [1, 1.01], 0.01);
	trig = Impulse.kr(MouseX.kr(0.1, 2));
	snd = SinOsc.ar(freq);
	snd = Env.perc(0.01, 1, 0.5).ar(0, trig) * snd;
	// freqs = TChoose.kr(trig, [42, 45, 47, 49, 50].midicps * 4);
	// freqs = Select.kr(SinOsc.kr(0.2, 0, 5).abs, [42, 45, 47, 49, 50].midicps * 4);
	snd = snd.blend(Resonator.ar(snd, freq * 8, resolution: 24, damping: MouseY.kr(0.7, 0.3)));
	snd = GVerb.ar(snd, 1, 0.1, drylevel: 1);
	snd = (snd*30).sin * 0.2;
	snd = snd.blend((snd*10).cos * 0.2, 0.1 * \drive.kr(0));
	snd = LeakDC.ar(snd);
}).mold(2);
)

Ndef(\kick).play;
