~armoire = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /armoire.WAV");
// rate 0.7, ratelfo 0.5 rateDev 0.5


a.stop; a = {{Synth(\bwing, [add: exprand(20, 20000), pan: rrand(-1, 1.0), amp: 0.1]); 0.1.wait}.loop}.fork
a.stop;


(
Pdef(\physical1).stop;
Pdef(\physical2).stop;
)

(
Pdef(\physical1).play;
Pdef(\physical2).play;
)


(
Pdef(\stil).stop;

{


	Pdef(\pat1,
	Pbind(
		\instrument, \bwing,
		\dur, Pseq((100 .. 50)/100, inf),
		\amp, 0.2
	)
).play;

	0.1.wait;

Pdef(\pat2,
	Pbind(
		\instrument, \perconvol,
		\dur, Pseq((100 .. 50)/100, inf),
		\rateDev, 0.5,
		\ratelfo, 0.5,
		\rate, 0.7,
		\buffer, ~armoire,
		\amp, 10,
	)
).play;

}.fork;
)

(
Pdef(\pat1).stop;
Pdef(\pat2).stop;
)

~jpverb.play;

(
Pdef(
	\stk1,
	Pbind(
		\instrument, \stkBowed,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([2, 3, 5, 3]- 24, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1,
		\rel, 2,
		// \out, ~jpverb_bus,
		\out, 0
	)
).play(quant:1);
)


// Synth(\stkbowed, [freq: (7 + 60).midicps])
(
Pdef(
	\stk2,
	Pbind(
		\instrument, \stkBowed,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([9, 10, 12, 10] - 24, inf) + 12,
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1,
		\rel, 2,
		\amp, 0.1/2
	)
).play(quant:1);
)

Pdef(\stk2).stop;

(
Pdef(
	\stk3,
	Pbind(
		\instrument, \moogb,
		// \instrument, \percsine,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([5, 24, 9, 24] - 24, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1,
		\rel, 2
	)
).play(quant:1);
)

Pdef(\stk3).stop;

(
Pdef(
	\mb,
	Pbind(
		\instrument, \moogb,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([5, 17, 19, 17] - 24, inf),
		// \note, Pseq([5, 7, 9, 7] - 24, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1,
		\rel, 2
	)
)
)

Pdef(\mb).play(quant:1);

Pdef(\mb).stop;



(instrument: \percsine, note: 14).play;


(
SynthDef(\saw, {
	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, comb = 0.02;
	var env, sig;
	env = Env.perc(0.5, release, 1, curve).kr(2);
	sig = LFSaw.ar(freq, 0, mul);
	sig = CombC.ar(sig, 0.2, comb, 10);
	// sig = FreeVerb.ar(sig, mix, room);
	// sig = GVerb.ar(sig);
	sig = BRF.ar(sig, 50, 2);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig * env * amp);
}).add;
)


(
Pdef(
	\stk1,
	Pbind(
		\instrument, \stkBowed,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([2, 3, 5, 3] - 24, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1
	)
).play(quant:1);

Pdef(
	\csaw,
	Pbind(
		\instrument, \saw,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([-2, 3, 5, 3]- 24, inf),
		\curve, Pxrand([-1, 0], inf),
		\comb, Pseq([0.02, 0.02, 0.03, 0.02], inf),
		\release, Pseq([3, 5, 3, 5], inf),
		\amp, 0.2,
		\legato, 0.1
	)
).play(quant:1)
)


(
Pdef(
	\stk1,
	Pbind(
		\instrument, \stkBowed,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([2, 3, 5, 3]- 24, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1
	)
).play;

Pdef(
	\csaw,
	Pbind(
		\instrument, \saw,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([2, 3, 5, 7]- 24, inf),
		\curve, Pxrand([-1, 0], inf),
		\release, Pseq([3, 5, 3, 5], inf),
		\amp, Pseq([Pseq(0.15!3, inf), 0.3]*2, inf),
		\legato, 0.1
	)
).play;
)






--------------



(
~fretless = Array.new;
~folder = PathName("/Users/maxlouisraugel/Documents/ /fretlessbass/");

~folder.entries.do({
	arg path;
	~fretless = ~fretless.add(Buffer.read(s, path.fullPath));
});

~ricercati = Array.new;
~folder = PathName("/Users/maxlouisraugel/Documents/ /ricercati/");

~folder.entries.do({
	arg path;
	~ricercati = ~ricercati.add(Buffer.read(s, path.fullPath));
});


SynthDef.new(\play4, {
	arg buf=0, rate=1, amp=1, comb = 0.1, rel = 2;
	var sig, env;
	env = Env.perc(0.01, rel).kr(2);
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf)*rate, doneAction:2);
	sig = CombL.ar(sig, 0.2, comb, 2);
	sig = HPF.ar(sig, 500);
	// sig = BRF.ar(sig, 200, 5);
	// sig = Limiter.ar(sig, 0.5, 0.1);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

(
Pdef(\csaw).stop;
Pdef(\stk1).stop;
)


(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \play4,
		\dur, Pseq([1/8], inf),
		\buf, Pseq(
			[
				Prand(~fretless, 1),
				Prand(~fretless, 7),
				~ricercati[3],
				Prand(~fretless, 7),
			],inf
		),
		\rate, Pseq((0.9!(8*4))++(1!(8*4))++(1.2!(8*4))++(1!(8*4)), inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)]*1.5, inf),
		\comb, 0.0002
	);
).play;

/*Pdef(
	\rhythmsine,
	Pbind(
		\instrument, \percsine,
		\stretch, 2,
		\dur, Pseq([1/16], inf),
		\freq, Pseq((((0.9!(8*4))++(1!(8*4))++(1.2!(8*4))++(1!(8*4))).ratiomidi + 72 + 24).midicps, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)]*10, inf),
		\rel, 0.03,
		\atk, 0
		// \comb, 0.0002
	);
).play*/
)

((0.9!(8*4))++(1!(8*4))++(1.2!(8*4))++(1!(8*4))).ratiomidi.midicps



(
Pdef(\pat2).stop;
Pdef(\pat1).stop;
)





(
Pdef(
	\cpat5,
	Pbind(
		\instrument, \play3,
		\buffer, a,
		\dur, Prand([2, 4], inf),
		\start, Prand([5568000, 2016000, 3072000, 5088000, 9120000], inf),
		\lfmul, 0.1,
		\ratemax, 1,
		\amp, 5
	)
	).play(quant:1);
)

(
Pdef(
	\cpat5,
	Pbind(
		\instrument, \perconvol2,
		\dur, Prand([2, 4], inf),
		\start, Prand([5568000, 2016000, 5088000, 9120000], inf).poll,
		\lfmul, 0.1,
		\ratemax, 1,
		\amp, 1
	)
	).play(quant:1);
)

Pdef(\stil).stop;


(
Pdef(\stk1).stop;
Pdef(\csaw).stop;
Pdef(
	\sawdrone,
	Pbind(
		\instrument, \saw,
		\dur, Pwhite(3, 6, inf),
		// \note, Prand([3, 5] - 24,inf),
		\note, 3 - 24,
		\curve, Pxrand([-1, 0], inf),
		\combf, 50,
		\rel, Pkey(\dur, inf),
		\amp, 0.09,
		\legato, 0.1
	)
).play(quant:1);


Pdef(\cpat5).stop;
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/8], inf),
		\buf, Pseq(
			[
				Prand(~fretless, 1),
				Prand(~fretless, 7),
				~ricercati[3],
				Prand(~fretless, 7),
			],inf
		),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)]/2, inf),
		\comb, 0.0002
	);
).play(quant:1)
)

(
Pdef(\sawdrone).stop;

Pdef(
	\cpat5,
	Pbind(
		\instrument, \perconvol2,
		\dur, Prand([2, 2.25], inf),
		\stretch, 1.875,
		\start, Pxrand([5568000, 2016000, 3072000, 5088000, 9120000], inf),
		\lfmul, 0.1,
		\ratemax, 1,
		\amp, 1
	)
	).play(quant:1.875);

Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pseq(
			[
				Prand(~fretless, 1),
				Prand(~fretless, 7),
				~ricercati[3],
				// ~ricercati[5],
				Prand(~fretless, 7),
			],inf
		),
		\amp, Pseq([0.4, Pexprand(0.01, 0.3, 7)]/2, inf),
		\comb, Pwhite(0.0001, 0.002).round(0.001)
	);
).play(quant:1.875);
)


(
Pdef(\cpat5).stop;
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/8], inf),
		\buf, Pseq(
			[
				Prand(~fretless, 1),
				Prand(~fretless, 7),
				~ricercati[[3, 4]],
				Prand(~fretless, 7),
			],inf
		),
		\rate, Pseq([0.9, 1, 1.2, 0.9, 1, 1.1], inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)]/2, inf),
		\comb, 0.0002
	);
).play(quant:1.875)
)



// new addition to top of page

(
Pdef(
	\bass,
	Pbind(
		\instrument, \poom,
		\atk, 3,
		\dur, Pseq([3, 5, 3, 5], inf),
		\rel, Pkey(\dur),
		\note, Pseq([2, 7, [5, 9], 3] - 24, inf),
		\amp, 0.3
	)
).play;
)

// Pbindef(\tt, \instrument, \saw2, \dur, 2, \atk, 0.5, \rel, 2, \freq, Pseq([120, 90, 80, 90], inf) * [1, 1/2, 1/4], \amp, 1/2, \out, 0).play;


Ndef(\stk).clear;
Ndef(\stk, \stkBowed).play;
Ndef(\stk)[20] = \filter -> {|in| JPverb.ar(in)}
Ndef(\stk).fadeTime = 10;
Ndef(\stk).set(\wet20, 0.6)
Ndef(\stk)[40] = \xset -> Pbind(\dur, Pxrand([3, 7, 8], inf), \freq, Pxrand([50, 120, 230], inf));
Ndef(\stk).stop(50);

(
~arp.stop;
~arp = Ndef(\test, PbindProxy(\instrument, \sinesaw1, \dur, 0.1, \atk, 1/1000, \rel, Pkey(\dur), \freq, Pseq([50, 120, 230], inf), \detune, Pseg([0, -5, 5, 0], [30, 30, 30], 'lin', inf), \spread, 0, \pan, Pseq([-1, 1, -1], inf), \amp, 2)).play;
)

\freq, Pseq([50, 120, 230], inf) * Pseq([1, 2, 1/2, 2, 1, 2], inf);

~dbass = Pbindef(\dbass, \instrument, \poom, \dur, Pxrand([3, Rest(4), 0.2, 0.2], inf), \freq, Pxrand([50, 120, 230], inf), \rel, Pkey(\dur), \amp, 1).play;
~dbass.stop;

(
C.p(\kick, folder: \bassdrums, index: 19, dur: 1/4, amp:1/3);
C.p(\snares, folder: \snares, index: Pseq([1, 2], inf), rate: Pxrand([0.7, 0.9, 1], inf), dur: Pseq([Rest(1/8), 1/8], inf), amp: 1/3);
);

(
{{
	C.p(\kick);
	C.p(\snares);

	rrand(3, 5.0).wait;

	C.s(\kick, 1/2);
	C.s(\snares, 1/2);

		rrand(3, 5.0).wait;

}.loop;}.fork
)

(
~resonatedsine = Ndef(\resonatedsine, {|freq 100| var snd; snd = SinOsc.ar(freq, 0, 0.1); snd = Resonator.ar(snd, freq / 2) * 2; snd = snd.blend(BRF.ar(snd, freq), 0.6); snd = FreeVerb.ar(snd, 0.3, 1); snd = Pan2.ar(snd, \pan.kr(0), 2 * \amp.kr(1));});

~resonatedsine[100] = \set -> Pbind(\dur, Pxrand([2, 3]/4, inf), \freq, Pxrand([100, 200, 240] * 2, inf), \amp, 2, \pan, Pwhite(-1, 1));

~resonatedsine.vol=1.3;
~resonatedsine.play(fadeTime: 30);
);

~resonatedsine.stop(0);