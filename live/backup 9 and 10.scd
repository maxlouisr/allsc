// 9

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
~clicks.free;
~clicks = {
    var input, kernel, sig;


	kernel = PlayBuf.ar(2, ~officesdcard, {MouseX.kr(1, 2) + LFNoise2.kr(1, 1, 0)}!3, loop:1);
	input = PlayBuf.ar(2, ~headphonejack, {MouseY.kr(1, 10) + LFNoise2.kr(1, 1, 0)}!3, loop:1);

    // must have power of two framesize
	sig = Convolution.ar(input, kernel, 2048, mul: 0.09);
	sig = CrossoverDistortion.ar(sig, 0.1, 1) * 0.2;
	sig = CombC.ar(sig, 0.2, LFNoise2.kr(0.01, 0, [0.00035, 0.00032, 0.00031]), 0.1);
	sig = Splay.ar(sig);
	// sig = FreeVerb.ar(sig, 0.3, 0.00001, 0.9);
	sig = SmoothDecimator.ar(sig, 96000, 10) * 1;
}.play;
)

(
SynthDef(\perconvol, {
	arg frequencies = #[ 2408.1393930766, 67.381566708784, 141.76650188961, 4379.2612701457, 387.24758031496, 422.57985140667, 206.26147638206, 127.96288310263, 1352.752004142, 616.80948042647 ],
	rate = 1,
	ratemax = 1,
	ratelfo = 1,
	ampcd = 0.05,
	start =  96000*4,
	hpf = 50,
	rel = 0.5,
	amp = 2;

	var input, kernel, sig, env, buffer;
	buffer = \buffer.kr(~armoire);
	env = Env.perc(0.01, rel).kr(2);
	kernel = PlayBuf.ar(
		2,
		buffer,
		rate: rate * LFNoise2.kr(ratelfo, 0.02, ratemax),
		startPos: start,
		loop:1);
	input = SinOsc.ar(frequencies) * 0.5;

	// must have power of two framesize
	sig = Convolution.ar(input, kernel, 512 * 4, 2);
	sig = BRF.ar(sig, frequencies, 0.1, 1);
	sig = BRF.ar(sig, 150, 2) * 2;
	sig = HPF.ar(sig, hpf);
	sig = Splay.ar(sig * env);
	sig = CrossoverDistortion.ar(sig, ampcd, 1);
	Out.ar(0, sig * amp);
}).add;
)


(
Pdef(
	\cpat1,
	Pbind(
		\instrument, \perconvol,
		\dur, Pwhite(0.1, 2.0)*3,
		// \note, Prand([0, 2, 5, 7], inf),
		\ampcd, 0.05,
		\pan, Pwhite(-1, 1),
		\rate, 0.5,
		\start, Pseq([0.000001, 69] * ~armoire.sampleRate, inf),
		\amp, Pseq([7, 2], inf)
	)
).play;
)

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
	)
).play;
)*/

Pdef(\cpat1).stop;

// two physical models:

(
SynthDef(\stkBowed,{arg out=0,freq=220,rel = 0.1,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
    var sig,env;
    env = EnvGen.kr(Env.asr(0,1,rel),gate,doneAction:2);
    sig = StkInst.ar(
		Stk.at("Bowed"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,
			bowpressure,
			4,
			bowposition,
			11,
			vibfreq,
			1,
			vibgain,
			128,
			loudness

	])*env;
    Out.ar(out, sig.dup);
}).add;
)

(
SynthDef(\stkSaxofony,{arg out=0,freq=220,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
    var sig,env;
    env = EnvGen.kr(Env.asr(0,1,0.1),gate,doneAction:2);
    sig = StkInst.ar(
		Stk.at("Saxofony"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,
			bowpressure,
			4,
			bowposition,
			11,
			vibfreq,
			1,
			vibgain,
			128,
			loudness

	])*env;
    Out.ar(out, sig.dup);
}).add;
)

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
		\amp, 0.1
	)
).play;
)

Pdef(\physical2).stop;

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
SynthDef(\perconvol2, {
	arg frequencies = #[ 2408.1393930766, 67.381566708784, 141.76650188961, 4379.2612701457, 387.24758031496, 422.57985140667, 206.26147638206, 127.96288310263, 1352.752004142, 616.80948042647],
	lfmul = 0.1,
	lfspeed= 0.1,
	ratemax = 3.8,
	rel = 0.5,
	ampcd = 0.05,
	start =  1,
	hpf = 50;

	var sig, env;
	env = Env.perc(0.01, rel).kr(2);
	sig = PlayBuf.ar(
		2,
		~armoire,
		rate: LFNoise2.kr(lfspeed, lfmul, ratemax),
		// rate,
		startPos: start,
		loop:0);
	// sig = BRF.ar(sig, frequencies, 0.1, 1);
	// sig = BRF.ar(sig, 150, 2);
	sig = HPF.ar(sig, hpf);
	// sig = Splay.ar(sig);
	sig = Pan2.ar(sig);
	sig = CrossoverDistortion.ar(sig, 0.05, 1);
	sig = sig * env;
	Out.ar(0, sig * 5);
}).add;
)


(
Pdef(\physical1).stop;
Pdef(\physical2).stop;
Pdef(\cpat3).stop;
Pdef(\cpat4).stop;


Pdef(\stil,
	Pbind(
		\instrument, \perconvol2,
		\dur, Pwhite(0.1, 0.01),
		\pan, Pwhite(-1, 1),
		\ratemax, Pwhite(1, 5).round(1)
	);
).play;
)

Pdef(\stil).stop;































































// 10

(
a = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /armoire.WAV");

SynthDef(\perconvol, {
	arg frequencies = #[ 2408.1393930766, 67.381566708784, 141.76650188961, 4379.2612701457, 387.24758031496, 422.57985140667, 206.26147638206, 127.96288310263, 1352.752004142, 616.80948042647 ],
	rate = 0.7,
	ratemax = 1,
	ratelfo = 0.5,
	ampcd = 0.05,
	start =  96000*4,
	hpf = 50,
	rel = 0.5,
	amp = 2;

	var input, kernel, sig, env, buffer;
	buffer = \buffer.kr(a);
	env = Env.perc(0.01, rel).kr(2);
	kernel = PlayBuf.ar(
		2,
		buffer,
		rate: rate * LFNoise2.kr(ratelfo, 0.5, ratemax),
		startPos: start,
		loop:1);
	input = SinOsc.ar(frequencies) * 0.5;

	// must have power of two framesize
	sig = Convolution.ar(input, kernel, 512 * 4, 2);
	sig = BRF.ar(sig, frequencies, 0.1, 1);
	sig = BRF.ar(sig, 150, 2) * 2;
	sig = HPF.ar(sig, hpf);
	sig = Splay.ar(sig * env);
	sig = CrossoverDistortion.ar(sig, ampcd, 1);
	Out.ar(0, sig * 10);
}).add;

)


a.stop; a = {{Synth(\bwing, [add: exprand(20, 20000), pan: rrand(-1, 1.0), amp: 0.1]); 0.1.wait}.loop}.fork
a.stop;

Synth(\bwing)

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
		\dur, Pseq((100 .. 50)/100, inf)
	)
).play;


}.fork;
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
		\vibfreq, 0.1,
		\rel, 2,
	)
).play;
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
).stop;
)

Synth(\percsine, [freq: 65.midicps])

(
Pdef(
	\stk3,
	Pbind(
		\instrument, \stkBowed,
		\dur, Pseq([3, 5, 3, 5], inf),
		\note, Pseq([5, 7, 9, 7] - 12, inf),
		\mix, 0,
		\bowpressure, 100,
		\bowposition, 52,
		\vibgain, 1,
		\vibfreq, 0.1,
		\rel, 2
	)
).play;
)

Pdef(\stk2).stop;

MasterEQ.new


// don't forget the synth def

(
SynthDef(\saw, {
	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, comb = 0.02;
	var env, sig;
	env = Env.perc(0.5, release, 1, curve).kr(2);
	sig = LFSaw.ar(freq, 0, mul);
	sig = CombC.ar(sig, 0.2, comb, 10);
	// sig = FreeVerb.ar(sig, mix, room);
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
).play;

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
).play
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


SynthDef.new(\bufplay, {
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
Pdef(\stk1).stop
)


(
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
SynthDef(\saw, {
	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, comb = 0.02;
	var env, sig;
	env = Env.perc(0.5, release, 1, curve).kr(2);
	sig = LFSaw.ar(freq, 0, mul);
	sig = CombC.ar(sig, 0.2, comb, 10);
	sig = FreeVerb.ar(sig, mix, room);
	sig = BRF.ar(sig, 50, 2);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig * env * amp);
}).add;

SynthDef(\perconvol2, {
	arg frequencies = #[ 2408.1393930766, 67.381566708784, 141.76650188961, 4379.2612701457, 387.24758031496, 422.57985140667, 206.26147638206, 127.96288310263, 1352.752004142, 616.80948042647],
	lfmul = 0.1,
	ratemax = 3.8,
	rel = 0.5,
	ampcd = 0.05,
	start =  1,
	amp = 1,
	hpf = 50;

	var sig, env;
	env = Env.perc(0.01, rel).kr(2);
	sig = PlayBuf.ar(
		2,
		a,
		rate: LFNoise2.kr(0.1, lfmul, ratemax),
		// rate,
		startPos: start,
		loop:1);
	sig = BRF.ar(sig, frequencies, 0.1, 1);
	sig = BRF.ar(sig, 150, 2);
	sig = HPF.ar(sig, hpf);
	sig = Splay.ar(sig);
	sig = CrossoverDistortion.ar(sig, 0.5, 1);
	sig = sig * env * amp;
	Out.ar(0, sig * 5);
}).add;
)



/*(
Pdef(
	\cpat5,
	Pbind(
		\instrument, \perconvol2,
		\dur, Prand([2, 4], inf),
		\start, Prand([5568000, 2016000, 3072000, 5088000, 9120000], inf),
		\lfmul, 0.1,
		\ratemax, 1,
		\amp, 1
	)
	).play(quant:1);
)*/

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


/*(
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
		\comb, 0.02,
		\release, Pkey(\dur, inf),
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
)*/


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



// (
// SynthDef(\saw, {
// 	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, comb = 0.02;
// 	var env, sig;
// 	env = Env.perc(0.5, release, 1, curve).kr(2);
// 	sig = VarSaw.ar(freq, 0, mul);
// 	sig = CombC.ar(sig, 0.2, comb, 10);
// 	sig = FreeVerb.ar(sig, mix, room);
// 	sig = BRF.ar(sig, 50, 2);
// 	sig = BRF.ar(sig, 100, 2);
// 	sig = BRF.ar(sig, 3000, 5);
// 	sig = Pan2.ar(sig, pan);
// 	Out.ar(0, sig * env * amp);
// }).add;
// )













