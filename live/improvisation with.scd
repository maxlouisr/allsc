(
~pitchbus = ~pitchbus ?? Bus.control;
~ampbus = ~ampbus ?? Bus.control;
~tartinibus = ~tartinibus ?? Bus.control;
)

(
Ndef(\livepitch, {Out.kr(\out.kr(~pitchbus), Pitch.kr(SoundIn.ar(0), execFreq: 0, ampThreshold: \ampthresh.kr(0.1)))}).play;

Ndef(\tartini, {Out.kr(\out.kr(~tartinibus), Tartini.kr(SoundIn.ar(0), \threshold.kr(0.93))[0].poll)});

Ndef(\amp, {Out.kr(\out.kr(~ampbus), Amplitude.kr(SoundIn.ar(0)))});
)

(
Ndef(\tartini).play;
Ndef(\livepitch).play;
)






-------




(
~whitesmear.release(3);
~whitesmear = {
	var snd, trig, buffer;
	trig = Dust.ar(1000);
	buffer = ~resonancetoilette;
	snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.ir(buffer), trig, LFNoise2.kr(0.1).abs * BufDur.kr(buffer)) * 10;
	// snd = BPF.ar(snd) * 15;
}.play(fadeTime: 2);
)

(
~whitesmear.release(3);
~whitesmear = {
	var snd, trig, buffer;
	trig = Dust.ar(1000);
	buffer = C.get(\thanks, 1);
	// buffer = ~resonancetoilette;
	snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.ir(buffer), trig, LFNoise2.kr(0.1).abs * BufDur.kr(buffer)) * 10;
	// snd = BPF.ar(snd) * 15;
}.play(fadeTime: 2);
)

(
~whitesmear.release(3);
~whitesmear = {
	var snd, trig, buffer;
	trig = Dust.ar(1000);
	buffer = C.get(\thanks, 14);
	// buffer = ~resonancetoilette;
	snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.ir(buffer), trig, LFNoise2.kr(0.1).abs * BufDur.kr(buffer)) * 10;
	// snd = BPF.ar(snd) * 15;
}.play(fadeTime: 2);
)





----


// UNDERSTANDING THE OTHERS





(
~filaments.release(30);
~filaments = {Splay.ar(
	{SinOsc.ar(
		LFNoise2.kr(0.1).range(2000,20000),
		mul:Env([0, 1, 0, 0, 1, 0, 0]*2,
			[0.1,
				0.1,
				LFNoise2.kr(1).range(1, 3),
				0.1,
				0.1,
				LFNoise2.kr(1).range(1,3)
			]*5

		).circle.kr(2) * XLine.kr(0.00001, 0.05, 15)
)}!10)}.play(fadeTime:30);
)





(
Ndef(\u, { var snd;

	snd = Splay.ar(BPF.ar(
		LFSaw.ar(
			LFSaw.kr(
				682 + LFNoise2.kr(1, 1, 0),
				0,
				1000,
				// [1000] *8,
				[2000]
				// [2000]*4

),
			0,
			0.7
)));
	snd = BPF.ar(snd, 700);
	// [Mono(snd), DelayC.ar(Mono(snd), 0.2, Line.kr(0, 0.1, 10))];
}
);

Ndef(\u).play(fadeTime: 10);
)



(
Ndef(\u).fadeTime = 0;
Ndef(\u, {var snd;
	snd = Splay.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(20, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
	)}!3);
});

Ndef(\u).play;
)

Ndef(\u)[10] = \filter -> {|in| PitchShiftPA.ar(in, 440, SinOsc.ar(3, 0, 1/2, 1/2), 2) * 0.3};

Ndef(\u)[20] = \filter->{|in| in * 2}

Ndef(\u)[10] = \filter -> {|in| PitchShiftPA.ar(in, 440, SinOsc.ar(3, 0, 1/2, 1/2), 2, 10, 10, 10, 3) * 0.3};


Ndef(\u).stop;


Ndef(\u)[10] = \filter -> {|in| PitchShiftPA.ar(in, Ndef(\u).ar, SinOsc.ar(3, 0, 1/2, 1/2), 2) * 0.3}

Ndef(\u)[10] = \filter -> {|in| PitchShiftPA.ar(in, 440, 1/10, 2)}

Ndef(\m).clear(50);

// add reverb:

(
Ndef(\u).fadeTime = 30;
Ndef(\u, {
	Splay.ar(
		FreeVerb.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(200, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 2, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
)}!3,
			mix: 0.3,
			room: 3,
			damp: 0.5
		)

)});
Ndef(\u).play;
)

~microgaussian.release(30);

(
~kick.clear;
~percsine.clear;
)

(
Ndef(\u, {
	Splay.ar(
		JPverb.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(200, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 2, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
)}!3,
			10,
			damp: 0,
			size: 1,
			earlyDiff: 0.7,
			modDepth: 0.2,
			modFreq: 2,
			low: -1,
			mid: 0.2,
			high: 0.3,
			lowcut: 100,
			highcut:1000
		)

)});
// Ndef(\u).play;
)

-------



// We are fooled

(
Ndef(\m).fadeTime = 30;
Ndef(\m, {
	Splay.ar(
		{
			SinOsc.ar(
				exprand(20, 20000),
				mul:Line.kr(0, 0.05, 10) * {LFNoise2.ar(\amps.kr(0))}
)}!100
)});
Ndef(\m).play(fadeTime:30);
)

Ndef(\m).xset(\amps, 0.5);


Ndef(\m)[10] = \filter -> {|in| PitchShiftPA.ar(in, 440, SinOsc.ar(3, 0, 1/2, 1/2), 2) * 0.3}

Ndef(\m).fadeTime=10;

Ndef(\m)[20] = \filter -> {|in| in * SinOsc.ar(5, 0, 2).abs}

Ndef(\m)[30] = \filter-> {|in| var snd, trig; trig = Dust.kr(0.2); snd = in * Env.perc(0.1, 5).kr(0, trig)};


Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1, \rel, 10]);

~speeds.release(10)



Synth(\fml, [\freqA, 20, \freqB, rrand(1000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1, \rel, 0.7]);








-------






(
~wabble.release(10);
~wabble = {
	var snd, trig, env;
	trig = Dust.kr(0.3);
	env = Env.perc(0.01, 3).kr(0, trig);
	snd = Rongs.ar(trig, trig, \f0.kr(500), \structure.kr(0.2), LFNoise2.kr(0.3, 0.3, 0.75), TChoose.kr(trig, [0.5, 0.6, 0.7]), \accent.kr(0.9), TRand.kr(0, 0.3, trig), \position.kr(0.15), \loss.kr(0.15), 5, 3);
	snd = Pan2.ar(snd * env, LFNoise2.kr(0.3, 0.5)) * \amp.kr(1);
	// snd = Limiter.ar(snd, 0.1);
	snd = LeakDC.ar(snd) * 1/3;
	snd = LPF.ar(snd, 2000);
}.play;
)


(
~rongs.release(1);
~rongs = {
	var snd, trig;
	trig = Dust.kr(4);
	snd = Rongs.ar(trig, trig, \f0.kr(1000), \structure.kr(0.2), \brightness.kr(0.5), \damping.kr(0.75), \accent.kr(0.9), \stretch.kr(0.5), \position.kr(0.15), \loss.kr(0.15), 5, 3);
	snd = Pan2.ar(snd, LFNoise2.kr(0.3, 0.5)) * \amp.kr(1);
	snd = Limiter.ar(snd, 0.1);
}.play;
)



// 480, 1100, 100, 320, 100, 230
~whiteshaker.play(fadeTime: 30);

~whiteshaker.stop(30);

(
Pdef(\crackle,
	Pbind(\instrument, \blosc,
		\freq, Pseq([100!5, 1!5].flatten, inf),
		\mul, Pseq(Array.geom(10, 0.001, 1.5), inf),
		\dur, Pseq((Array.geom(10, 1, 1.5)/10).mirror, inf),
		// \dur, Prand([1, 2, 5]/5, inf),
		\atk, 0.01,
		\rel, Pkey(\dur) / 5,
		\amp, 1/2
	)
)
)

Pdef(\crackle).play;
Pdef(\crackle).pause;
Pdef(\crackle).resume;

Ndef(\wobl).vol_(0.7).play;
Ndef(\wobl).stop;

Ndef(\high_tilts).clear;





------


(
~high.release(10);
~high = {
	Saw.ar(
		15000,
		mul: LFPulse.kr(1, width: 0.2).range(0, 0.05)
)}.play(fadeTime:10);
)

~kick.clear;

r.free;
k.release;

(
~ticks1.release(10);
~ticks1 = {
	Splay.ar(
		SinOsc.ar(
			freq: Impulse.kr(10, mul:10000, add:10000),
			mul: Impulse.kr([LFNoise2.kr(1, 10, 3),
				LFNoise2.kr(1, 10, 3)],
			mul:Line.kr(0, 1, 30),
			add:0))
)}.play(fadeTime: 10);

~highsinefluctuating.release(10);
~highsinefluctuating = {
	SinOsc.ar(
		10000 + LFNoise2.kr(1).range(-1000,5000),
		mul:0.02
)}.play(fadeTime: 30);
)



(
~ticks2.release(10);
~ticks2 = {
	Splay.ar(
		SinOsc.ar(
			freq: Impulse.kr(10, mul:10000, add:10000)/[2, 8, 8, 4],
			mul: Impulse.kr([LFNoise2.kr(1, 10, 3),
				LFNoise2.kr(1, 10, 3)],
			mul:0.1,
			add:0))
)}.play(fadeTime: 30);
);




(
~ticks1.release(10);

~ticks2.release(10);

~high.release(10);

~highsinefluctuating.release(10);
)







(
~percsine = PbindProxy(\instrument, \percsine, \freq, Pwhite(15000, 17000).round(10), \atk, 0.01, \rel, 0.1);
~kick = PbindProxy(\instrument, \kick, \freq, Pwhite(20, 40).round(10), \amp, 0.5);

~durs = Prand([1, 2, 5]*2, inf);

~percsine.set(\dur, ~durs);
~kick.set(\dur, ~durs, \amp, 1, \freq, Prand([30, 30 * 1.2, 30 * 1.5, 30 * 1.7], inf));

~percsine.play;
~kick.play;
)

(
~percsine.clear;
~kick.clear;
)

(
~teasingsaws.release(30);
~teasingsaws = {Saw.ar(LFNoise2.kr([2, 3]).range(100, 10000), LFPulse.kr([10 * LFNoise2.kr(0.3).abs, 5 * LFNoise2.kr(0.3).abs]/5) * 0.1/2)}.play(fadeTime: 30);
)



Ndef(\soubresaut, {SinOsc.ar(freq: Saw.kr(freq: [0.2, 0.1], mul:[LFNoise2.kr(0.1, mul:100, add:300), LFNoise2.kr(0.1, mul:200, add:300)], add:150), mul: 0.1 * \amp.kr(1))}).play(fadeTime: 10);

(
Ndef(\soubresaut).fadeTime=10;
Ndef(\soubresaut)[10] = \filter-> {|in| LPF.ar(in)};
)

Ndef(\soubresaut).stop(3);


(
Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1/2, \rel, 0.2]);
Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1/2, \rel, 0.2]);
)


(
var fade = 10; ~speeds.release(fade);
~speeds = {
	var snd, lfo, freq;
	lfo = LFNoise2.kr(1).range(0.01, 10);
	snd = Impulse.ar(lfo)!2;
	snd = BPF.ar(snd, Array.fib(12, 5, 50), 0.07, 100);
	snd = HPF.ar(snd, 500) * \amp.kr(0.7);
	snd = Splay.ar(snd * 0.1);
}.play(fadeTime: fade);
)



(
var fade = 0;~pointillism.release(fade);

~pointillism = {
	var snd, combfreq;
	combfreq = {exprand(20, 10000).round(100) * LFNoise2.kr(\detune.kr(0.1)).range(1, 2)};
	snd = {Dust.ar(\density.kr(0.3))};
	snd = CombC.ar(snd!10, 0.2, 1/combfreq!10, 0.5);
	snd = Pan2.ar(Mix(snd!10), {rrand(-1, 1.0)}!5);
	// snd = snd.softclip;
	snd = snd * \amp.kr(0.1);
}.play(outbus: 0, fadeTime: fade);
)

~pointillism.free;

(
Routine.run({
	~pointillism.set(\density, 10);
	1.wait;
	~pointillism.set(\density, 0.1)
})
)













(
SynthDef(\basslight, {
	| gate=1 rate=1 amp=0.5 pan=0 out=0 |
	var buffer, snd;
	buffer = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /basslighttick ..wav");
	snd = PlayBuf.ar(2, buffer, rate*BufRateScale.kr(buffer), doneAction:2);
	snd = FreqShift.ar(snd, \freqshift.kr(0));
	snd = HPF.ar(snd, 100);
	Out.ar(out, Balance2.ar(snd[0], snd[1], pan, amp));
}).add;
)

(
var durs = Pxrand([1, 2, 5], inf);
var adjust = 0;

Ndef(\basslight1, Pbind(\instrument, \basslight, \rate, Pxrand(([50, 52, 56, 42, 54]*[1, 1/2, 1/4, 2]).midiratio, inf), \dur, durs, \amp, Pxrand([0.7, 1, 1.2], inf), \freqshift, Pxrand([1, 2, 7, 8, 9, 10]*100, inf) - adjust, \quant, 4)).play;

Ndef(\basslight2, Pbind(\instrument, \basslight, \rate, Pxrand(([50, 52, 56, 42, 54]*[1, 1/2, 1/4, 2]).midiratio, inf) - adjust, \dur, durs, \amp, Pxrand([0.7, 1, 1.2], inf), \quant, 4)).play;
);

(
Ndef(\basslight1).stop(0);
Ndef(\basslight2).stop(0);
)


Synth(\sinesaw, [freq: 1300, atk: 10, rel: 10])







(
Ndef('wove')[0] = ({|pan 0.5|
	var snd = SinOsc.ar(\freq.kr(300), 0, 0.1);
	snd = Pan2.ar(snd, pan* 2 -1);
	// snd = HPF.ar(snd, 100)
});

Ndef('wove')[2] = ('filter' -> {|in| HPF.ar(in, SinOsc.ar(\speed.kr(10, 7)).range(20, 10000), \hpfmul.kr(1))});

Ndef('wove').set('speed', 0.30128576422198, 'hpfmul', 14.408313758733, 'wet2', 0.78839461844446, 'fadeTime', 10, 'pan', 0.53439153439153, 'wet1', 0.05, 'freq', 62.100269902497);
Ndef('wove').play(fadeTime: 30);
);

Ndef('wove').clear(10);








Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 10000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.01, \atk, 0.1, \rel, 10]);



Synth(\fml, [\freqA, 20, \freqB, ~tartinibus.asMap, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1, \rel, 3]);

x = Synth(\sinesaw, [freq: ~tartinibus.asMap, rel: 10]);

y = Synth(\poom, [freq: ~tartinibus.asMap, rel: 10])





(
var fade = 1; ~slowrrr.release(fade);
~slowrrr = {|lfospeed 1|
	var snd, lfo;
	lfo = LFNoise2.kr(lfospeed);
	snd =
	Splay.ar(
	BPF.ar(
		LFSaw.ar(
				lfo.range(0.1, 0.5)
				// LFNoise2.kr(0.5).exprange(10, [1000, 100])
			),
		Array.fib(12, lfo.range(10, 50), 30),
		0.005,
		mul: 30
),
		spread: 0);
	snd = Mix(snd);
	PanAz.ar(2, snd , lfo.range(0.5, 1.5)) * 0.1;
}.play(fadeTime: fade);
)



(
~splashes.release(1);
~splashes = {|density 0.1|
	var snd, trig;
	trig = Dust.kr(density);
	snd = BrownNoise.ar(0.1);
	snd = Pluck.ar(snd, trig, 10, 1/LFSaw.kr(10).range(100, 200), 10, 0.9) * 5;
	snd = Pan2.ar(snd, LFNoise2.kr(1, 0.5)) * 0.1
}.play(fadeTime: 1);
)


(
var fade = 1; ~splashesmix.release(fade);
~splashesmix = {|lfospeed 1 density 0.5|
	var snd, snd2, trig, lfo;
	lfo = LFNoise2.kr(lfospeed);
	snd =
	Splay.ar(
	BPF.ar(
		LFSaw.ar(
				lfo.range(0.1, 0.5)
				// LFNoise2.kr(0.5).exprange(10, [1000, 100])
			),
		Array.fib(12, lfo.range(10, 50), 30),
		0.005,
		mul: 30
),
		spread: 0);
	snd = Mix(snd);
	PanAz.ar(2, snd, lfo.range(0.5, 1.5));
	trig = Dust.kr(density);
	snd2 = BrownNoise.ar(0.1);
	snd2 = Pluck.ar(snd2, lfo, 10, 1/LFSaw.kr(10).range(100, 200), 10, 0.9) * 5;
	snd2 = Pan2.ar(snd2, LFNoise2.kr(1, 0.5));
	snd + snd2;
}.play(0, s, 3);
)










(
var fade = 5;~whiteslaps.release(fade);
// 480, 1100, 100, 320, 100, 230
~whiteslaps = {|freq 1 mul 100|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 0.5, 0.1, 0.7).tanh;
	snd = HPF.ar(snd, 50);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 3 * \amp.kr(0.01);
}.play(s, 0, fade);
)