~saws.free;

(
~armoire = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /armoire.WAV");
~officesdcard = Buffer.read(s,"/Users/maxlouisraugel/Documents/ /office_sd_card_case_open.wav");
// b = Buffer.read(s,"/Users/maxlouisraugel/Documents/ /elastic convolution ..wav")

~technologyheadphone = Buffer.read(s,"/Users/maxlouisraugel/Documents/ /technology_headphone_jack_adaptor_put_down_on_table_1.wav")
)

Buffer.freeAll;

// careful with first one!! was designed with X/Y with second screen, so stay lower left
(
~ticks1.free;
~ticks2.free;
g.free;
z.free
)
~high.release;

(
~clicks.release;
~clicks = {
    var input, kernel, sig, buffer1, buffer2;
	buffer1 = \buffer1.kr(~officesdcard);
	buffer2 = \buffer2.kr(~technologyheadphone);


	kernel = PlayBuf.ar(2, buffer1, {MouseX.kr(1, 2) + LFNoise2.kr(1, 1, 0)}!3, loop:1);
	input = PlayBuf.ar(2, buffer2, {MouseY.kr(1, 10) + LFNoise2.kr(1, 1, 0)}!3, loop:1);

    // must have power of two framesize
	sig = Convolution.ar(input, kernel, 2048, mul: 0.09);
	sig = CrossoverDistortion.ar(sig, 0.1, 1) * 0.2;
	sig = CombC.ar(sig, 0.2, LFNoise2.kr(0.01, 0, [0.00035, 0.00032, 0.00031]), 0.1);
	sig = Splay.ar(sig);
	// sig = FreeVerb.ar(sig, 0.3, 0.00001, 0.9);
	sig = SmoothDecimator.ar(sig, 96000, 10) * 1;
}.play;
)

// rate 1, ratelfo 1, rateDev 0.02


(
Pdef(
	\cpat1,
	Pbind(
		\instrument, \perconvol,
		\dur, Pwhite(0.1, 2.0)*3,
		// \note, Prand([0, 2, 5, 7], inf),
		\ampcd, 0.05,
		\pan, Pwhite(-1, 1),
		\buffer, ~armoire,
		\rate, 0.5,
		\start, Pseq([0.000001, 69] * ~armoire.sampleRate, inf),
		\amp, Pseq([7, 2], inf),
		\ratelfo, 1,
		\rateDev, 0.02,
		\rateScale, 1
	)
).play;
)


Ndef(\sax, \stkSaxofony);
Ndef(\sax).play;
Ndef(\sax)[10] = \xset -> Pbind(\dur, Pxrand([1, 2, 3], inf), \freq, Pxrand(Array.fib(5, 1.2, 50), inf), \amp, 1/5);
Ndef(\sax).stop(1)

Pdef(\cpat1);

// (
// SynthDef(\saw, {
// 	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0.3, room = 0.5, amp = 1, legato, comb =  0.00045642;
// 	var env, sig;
// 	env = Env.perc(0.01, release, 1, curve).kr(2);
// 	sig = LFSaw.ar(freq, 0, mul);
// 	// sig = CombC.ar(sig, 0.2, comb, 10);
// 	sig = CombC.ar(sig, 0.2, LFNoise2.kr(0.1, 0.0001, 0.0005), 10);
// 	sig = FreeVerb.ar(sig, mix, room);
// 	sig = Pan2.ar(sig, pan);
// 	Out.ar(0, sig * env * 0.5);
// }).add;
// )


/*(
Pdef(
	\csaw,
	Pbind(
		\instrument, \saw,
		\dur, Pwhite(2, 4),
		\freq, Prand([50, 93], inf),
		// \harmonic, Pwhite(0, 10).round,
		// \scale, Scale.major,
		\curve, Pxrand([-1, 0], inf),
		\release, Pwhite(3, 6, inf),
		// \comb, Prand([0.00045642, 0.000499, 0.00045], inf),
		\amp, 3,
		\legato, 0.1,
		\pan, Pwhite(-0.8, 0.8),
	)
).play;
)

Pdef(\csaw).stop;*/

//
// (
// SynthDef(\sine, {
// 	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0.3, room = 0.5, amp = 1, legato, comb =  0.00045642;
// 	var env, sig;
// 	env = Env.perc(0.01, release, 1, curve).kr(2);
// 	sig = SinOsc.ar(freq, 0, mul);
// 	// sig = CombC.ar(sig, 0.2, comb, 10);
// 	sig = CombC.ar(sig, 0.2, LFNoise2.kr(0.1, 0.0001, 0.0005), 10);
// 	sig = FreeVerb.ar(sig, mix, room);
// 	sig = Pan2.ar(sig, pan);
// 	Out.ar(0, sig * env * 0.5);
// }).add;
// )
//
//
// (
// Pdef(
// 	\csine,
// 	Pbind(
// 		\instrument, \sine,
// 		\dur, Pwhite(1, 2.0),
// 		\freq, Prand([50, 93], inf),
// 		// \harmonic, Pwhite(0, 10).round,
// 		// \scale, Scale.major,
// 		\curve, Pxrand([-1, 0], inf),
// 		\release, Pwhite(2, 3, inf),
// 		\comb, Prand([0.00045642, 0.000499], inf),
// 		\amp, 5,
// 		\legato, 0.1,
// 		\pan, Pwhite(-0.8, 0.8),
// 	)
// ).stop;
// )



/*(
Pdef(
	\cpat2,
	Pbind(
		\instrument, \perconvol,
		\dur, Pwhite(0.1, 2.0)*3,
		\note, Prand([0, 2, 5, 7], inf),
		\ampcd, 0.05,
		\amp, 2,
		\pan, Pwhite(-1, 1),
		\rate, Pxrand([0.5, 1], inf),
		\start, Pxrand([0.0000001, 69] * b.sampleRate, inf)
\rateDev, 0.02,
\ratelfo, 1
	)
).play;
)*/

Pdef(\cpat1).stop;

x = Synth(\stkSaxofony)
x.set(\freq,50)
x.release(10)

(
Pdef(\csaw).stop;
~clicks.free;
)


(
Pdef(\physical1,

	Pbind(
		\instrument, \stkBowed,
		\dur, 0.25,
		\degree, Pseq([1,5,7+3, 11], inf),
		// \ctranspose, [0, -12, -24],
		\amp , Pseq([0.9,0.7,0.5],inf),
		\bowposition , Pseq([10,20,30,40,50,60] * 2,inf)
	)
).play;
)


(
Pdef(\physical2,

	Pbind(
		\instrument, \stkSaxofony,
		\dur, 0.3,
		\degree, Pseq([1,5,7+3, 11], inf),
		// \ctranspose, [0, -12],
		\amp, Pseq([0.9,0.7,0.5],inf),
		\bowposition, Pseq([10,20,30,40,50,60] * 2,inf),
		\amp, 0.1,
		\pan, Pwhite(-1, 1.0)
	)
).play;
)


(
Pdef(\physical1).stop;
Pdef(\physical2).stop;
)
// HAVE THIS WITH BEGINNING OF 10.SCD


(
Pdef(
	\cpat3,
	Pbind(
		\instrument, \perconvol,
		\dur, Pwhite(3, 6),
		\start, Pseq([5568000], inf),
		\rate, 0.5,
		\amp, 10
	)
	).play;
)

Pdef(\cpat2).stop;

(
Pdef(
	\cpat4,
	Pbind(
		\instrument, \perconvol,
		\dur, Prand([3, 6], inf),
		\start, 9120000,
		\rate, 0.5,
		\ampcd, 0.05,
		\hpf, 1000,
		\amp, 17
	)
	).play;
)



(
Pdef(\physical1).stop;
Pdef(\physical2).stop;
Pdef(\cpat3).stop;
Pdef(\cpat4).stop;
)



(
Pdef(\stil,
	Pbind(
		\instrument, \play3,
		\dur, Pwhite(0.1, 0.01),
		\pan, Pwhite(-1, 1),
		\ratemax, Pwhite(1, 5).round(1),
		\buffer, ~armoire,
		\amp, 5,
		\pan, 0
	);
).play;
)

Pdef(\stil).play;
Pdef(\stil).stop;


(
Pdef(\physical1).stop;
Pdef(\physical2).stop;
Pdef(\cpat3).stop;
Pdef(\cpat4).stop;
)










