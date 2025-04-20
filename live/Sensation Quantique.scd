(
~spaces1.stop;
~spaces1 = {
	{
		~space1.release(15);

			~space1 = {
				var snd, lpflfo, lfo, freq1, freq2, stereo, freq, chord;
				freq = ({{(Scale.ritusen.cents / [[2, 1.5]]).choose}!4}!4).choose;
				// freq = ([ [587.32953583454, 523.2511306012, 523.2511306012, 659.25511382513], [659.25511382513, 587.32953583454, 523.2511306012, 783.99087196223], [698.4564628652, 587.32953583454, 523.2511306012, 987.76660250974], [1174.6590716691, 783.99087196223, 659.25511382513, 2637.0204553005] ]*1/4).choose;
				lfo = LFNoise2.kr(0.05);
				lpflfo = LFNoise2.kr(1/10);
				stereo = [freq1, freq2];
				snd = NeoFormant.ar(freq, freq, LFNoise2.kr(1));
				// snd = LPG.ar(snd, Dust.kr(1), 0.5, 0.5, 1, 1.1);
				snd = snd + SinOscFB.ar(freq * {lfo.range(0.99, 1.01)}, lfo.range(0, 1.5)) * 0.1;
				snd = snd + VarShapeOsc.ar(freq * {lfo.range(0.99, 1.01)}, lfo.abs, lfo.abs, 1, freq);
				// snd = LPF.ar(FreeVerb2.ar(snd[0], snd[1], 1, 1, 0), \lpf.kr(2e4, 10));
				snd = snd + CombC.ar(WhiteNoise.ar(0.5), 1, 1/(freq), 1, 0.1);
				snd = JPverb.ar(Splay.ar(snd), 1, modDepth: 1, modFreq: lfo.abs / 2 + 1) * 0.1;
				snd = RLPF.ar(snd, lpflfo.range(100, 1000), 0.2) * lpflfo.range(9, 9/2);
				snd = Pan2.ar(snd, 0, 0.1);
			snd = snd.lag(0.01)
			}.play(fadeTime: 15);


		15.wait;

	}.loop

}.fork
)



~rrr = Ndef(\rrr, {
		var snd =
		Splay.ar(
			BPF.ar(
				LFSaw.ar(
					LFNoise2.kr(0.5).exprange(7, \density.kr(17))
					// LFNoise2.kr(0.5).exprange(10, [1000, 100])
				),
				Array.fib(12, LFNoise2.kr(0.1, 20, 30), 20),
				0.005,
				mul: Env.perc(1, LFNoise1.kr(1, 1, 5), level: 10, curve: -3).circle.kr(2)
		));
		snd = LPF.ar(snd, 3000);
		// PanAz.ar(~numChannels, snd.sum, SinOsc.kr(0.1).range(-0.25, 1.25), 1, \width.kr(3.0), 0.5, 0) * \amp.kr(0) * 1.5;
		PanAz.ar(~numChannels, snd.sum, LFNoise2.kr(0.1).range(0, 2.0), 1, \width.kr(3.0), 0.5, 0) * \amp.kr(0) * 1.5;
	}
	).mold(~numChannels);


Synth(\poom, [atk: 3, rel: 12, freq: (69-12).midicps, amp: 0.6]);



~wsamples.play;
~wsamples.stop;

Synth(\poom, [atk: 3, rel: 12, freq: (69-12).midicps, amp: 0.6]);
Synth(\poom, [atk: 3, rel: 12, freq: (71-12).midicps, amp: 0.6]);

Synth(\pom, [atk: 3, rel: 15, freq: (69-12).midicps, amp: 1, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (71-12).midicps, amp: 1, thin: -20, out: ~jpverb_bus]);

Synth(\k, [freq: 50, amp: 1.3 , rel: 7, distortion: 2]);

Synth(\pom, [atk: 3, rel: 15, freq: (74-12).midicps, amp: 0.9, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (73-12).midicps, amp: 0.9, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (69-12).midicps, amp: 0.9, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (71-12).midicps, amp: 0.9, thin: -20, out: ~jpverb_bus]);

Synth(\pom, [atk: 3, rel: 15, freq: (66-12).midicps, amp: 1.2, thin: -20, out: ~jpverb_bus]);


Ndef(\neoformant).play(fadeTime: 50); Ndef(\neoformant).vol_(1.2)




(
~lines_ripples.stop;
~lines_ripples = Routine.run({{
	var freq = [100, 150, 300, 600].choose;

	Ndef(\sine).set(\freq, freq).mold(2).play(fadeTime: 3);
	15.rand.wait;
	Synth(\percsine, [freq: freq * rrand(0.980, 1.02), atk: 0.1, rel: 5, amp: 0.1]);
	6.wait;
	Ndef(\sine).stop(7);
	15.wait;
}.loop;
})
)

~lines_ripples.stop; Ndef(\sine).stop(10);


~vpoints.play(10);



(
Ndef(\m).fadeTime = 5;
Ndef(\m, {
	var snd;
	snd = Splay.ar(
		{
			SinOsc.ar(
				// ([76, 74, 71, 69, 66, 64, 62, 59, 78, 81] * [[1, 0.5, 2]]).midicps.choose,
				exprand(20, 1000),
				mul: Line.kr(0, 0.03, 10)
				* {LFNoise2.ar(\waver.kr(0.5))}
		)}!30
		, 1);
	snd = LPF.ar(snd, 5000) * 10;
	// snd = snd + (\distort.kr(0) * LFNoise2.ar(200));
});
Ndef(\m).play;

)

Ndef(\u).play;


u.play(fadeTime:0);
u.vol=0.9;
u.stop(30);

u.fadeTime = 30; u.xset(\minfreq, 200, \maxfreq, 20000); u[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};

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

(
Ndef(\u).fadeTime = 30; Ndef(\u).xset(\minfreq, 200, \maxfreq, 20000); Ndef(\u)[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};
Ndef(\m).fadeTime = 30; Ndef(\m)[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};
)


(
~one = Ndef(\t_one, Pbind(\instrument, \percsinefb, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf), atk: 20, rel: 30, amp: 0.07, feedback: 1/2, dur: 5, pan: Prand([-1, 1.0], inf)])).play(fadeTime:30);

~two = Ndef(\t_two, Pbind(\instrument, \moogb, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf), atk: 20, rel: 30, amp: 2, dur: 10, pan: Prand([-1, 1], inf)])).play(fadeTime:30);
)



~rrr.play(fadeTime: 30);
~rrr.stop(60);






(
~p1.stop; ~p2.stop;
~p1 = Pdef(\sinesaw_mono, Pbind(\instrument, \sinesaw, \dur, 7, \freq, Pxrand([200, 220, 500, 380], inf), \amp, 1, \out, Pxrand((0..3), inf))).play;
~p2 = Pbind(*[\instrument, \percsine_mono, dur: Pwhite(1, 3), freq: Pxrand([200, 220, 500, 380], inf), \amp, 0.1, \out, Pxrand((0..3), inf)]).play;
);








(
~map1.release(20);

~crack_amp = 0.1;
MIDIdef.cc(\foo, {|val| ~crack_amp = val.linexp(0, 127, 0.001, 0.3) }, 64);
// ~bar = ~bar ?? MIDIFunc.cc({|val| ~foo = val.linlin(0, 127, 0, 0.5) }, 64);

~varispeed = 1;
MIDIdef.cc(\varispeed, {|val| ~varispeed = val.linlin(0, 127, 10, 1) }, 65);
// ~bar2 = ~bar2 ?? MIDIFunc.cc({|val| ~varispeed = val.linlin(0, 127, 1, 0.1) }, 65);

~crack.stop;
~crack = Pbindef(\crack,
	\instrument, \percsinefb,
	\freq, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf)
	// *Pfunc({~transposecrack})
	,
	// \dur, PSinOsc(0.28, 0, 0.1, 0.1)/4,
	\dur, PSinOsc(0.28, 0, 0.1, 0.1)/4 * Pfunc({~varispeed}),
	\atk, 0,
	\rel, 0.1,
	// \rel, Pkey(\dur),
	\amp, Pfunc({~crack_amp}),
	// \amp, 0.04,
	\feedback, Pseries(0, 0.12, inf),
	// \feedback, 0,
	\pan, Pxrand([1, 2, 3, 4], inf)
);

~crack.play;
)



Ndef(\avion, {|lag 10|
		var air, bass, snd;
		air = BrownNoise.ar({LFNoise2.kr(0.3, 0.02, 0.08).abs * \air.kr(1, 10)}!4); air = LPF.ar(air) * 3;
		air = BPeakEQ.ar(air, 50, 5, 15);
		snd = SplayAz.ar(~numChannels, air, 1, 1, 2, LFNoise2.kr(0.1).range(0, 1));
		snd = snd.blend((BPF.ar(snd, LFNoise2.kr(0.1).exprange(100, 200) * \height.kr(1, 10), \rq.kr(0.01, 10), 30)*3).cos, \avion.kr(0, 30));
		snd = Limiter.ar(snd * 0.9, \limit.kr(0.9, 10));
		snd = HPF.ar(snd, \hpf.kr(30));
		snd = snd * \amp.kr(0);
	}).mold(~numChannels).fadeTime_(10);



Synth(\fml, [\freqA, 20, \freqB, (123 * [13, 11, 15, 9, 6, 8]).choose, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1/3, \atk, 0.1, \rel, 3]);


(
// ~toll.free;
~toll = {
	// var notes = Array.makeScaleCps(100, 'major', 50, 200);
	var sound;
	sound = VarSaw.ar(({(123 * [13, 11, 15, 9, 6, 8]).choose}!5) / 4 , 0, Line.kr(0.5, 0, 1.3), Env.perc(1, 5, 0.1).kr(0));
	// sound = VarSaw.ar(({(123 * [13, 11, 15, 9, 6, 8]).choose}!5) / 4 , 0, Line.kr(0.5, 0, 1.3), 0.1);
	sound = Splay.ar(sound * 10);
	// sound = Limiter.ar(sound);
	sound = JPverb.ar(sound, 5);
	DetectSilence.ar(sound, 0.00001, doneAction:2);
	sound = MoogLadder.ar(sound, 2000);
	sound * 1/2
}.play;
)


(
	Ndef(\bb, {
		|freq 130|
		var snd, auto, trig;
		trig = Dust.ar(3);
		trig = ToggleFF.ar(trig).lag(\lag.kr(3));
		auto = trig.lagud(0.1, 0.3);
		snd = Saw.ar(freq);
		snd = Splay.ar(snd);
		snd = (snd * 3).fold2;
		snd = RLPF.ar(snd, freq * 10, 0.1);
		/*	snd = (snd * 5).fold2;
		snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
		snd = (snd * 5).fold2;*/
		snd = MoogFF.ar(snd, auto.linexp(0, 1, \floor.kr(100), 20000), 0, 0, 2);
		snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
		snd = (snd * 3.dbamp).tanh;
		snd = HPF.ar(snd, 100) * 0.1;
	}).play;
)

(
~partial = Ndef(\partial, {
	|rate = 1, buffer, speed = 0.1, threshold = 0.1, numFrames 2|
	var chain, snd;
	chain = PlayBuf.ar(2, buffer, rate * BufRateScale.kr(buffer), 1, 0, 1);
	// chain = In.ar(\bus.kr(0), 2);
	// chain = SoundIn.ar(0, 0.1);
	chain = FFT(Buffer.alloc(s, 2048), chain); chain = PV_PartialSynthF(chain, MouseY.kr(0, 5), 2);	snd = IFFT(chain);
	snd = Limiter.ar(snd * \amp.kr(5, 5) * MouseY.kr(5, 1), 1);
	// snd = (snd * 10).tanh;
	snd!2 * 2
}).mold(2);
)



(
~stringvoice = Ndef(\stringvoice, {
	var trig, seq, snd;
	trig = Impulse.kr(\density.kr(1));
	seq = Demand.kr(trig, 0, Dseq(([0, 1, 3, 7, 1]+60).midicps, inf));
	StringVoice.ar(
		trig: trig,
		infsustain:  0,
		freq:  seq,
		accent:  \accent.kr(0.2),
		structure: \structure.kr(0.8),
		brightness: \brightness.kr(0.3) ,
		damping:  \damping.kr(0.4)
)!2 * 1/2}
);
~stringvoice.play(fadeTime:0);
);

~stringvoice.set(\freq, 400);

(
~stringvoice = Ndef(\stringvoice).addSpec(
	\amp, \amp,
	\freq, \freq,
	\accent, [0, 1],
	\structure, [1, 1],
	\brightness, [0, 1.0],
	\damping, [0, 1]
	// \levB, [0.01, 3,\exp],
);

~ccControlled = Order.newFromIndices(
	[
		\freq, \accent, \structure, \brightness, \damping
	], (0..4);
);


MIDIdef.cc(
	"stringvoice",
	{arg val, num;
		var control = ~ccControlled[ num ];

		~stringvoice.set(
			control,
			~stringvoice.getSpec(control).map(val/127)
		);

		/*Ndef( ~grainsin_pulsar[\name] ).softSet(
		control,
		Ndef( ~grainsin_pulsar[\name] ).getSpec(control).map(val/127),
		mapped: true,
		spec: Ndef( ~grainsin_pulsar[\name] ).getSpec( control )
		)*/

	},
	ccNum: ~ccControlled.indices,
	chan: 0,
	// srcID: nil
).fix;
)

MIDIdef.freeAll


---

(
var time = 5;
(
instrument: \playlinen,
atk: time / 2, sus: 1, rel: time/2,
type: \notemap,
pan: Array.fill(1, { |i|
	(
		instrument: \ctlEnv,
		env: Env([-1, 1, -1, 1].rotate(i), [1, 1, 1] / 3),
		time: time,
		addAction: \addBefore
	)
	}),
buffer: C.get(\snares, (0..200).choose),
// buffer: d[\bd].choose,
rate: Array.fill(1, { (
	instrument: \ctlEnv,
	env: Env(
		Array.fill(8, { exprand(0.5, 50.0) }).scramble,
		Array.fill(7, { rrand(1, 50.0) }).normalizeSum,
		\exp
	),
	time: time,
	addAction: \addBefore
) }),
loop: 1,
amp: 1
).play;
)

x.play;

(
var time = 1;
x = (
instrument: \playlinen,
atk: time / 2, sus: 0, rel: time/2,
type: \notemap,
pan: Array.fill(1, { |i|
	(
		instrument: \ctlEnv,
		env: Env([-1, 1, -1, 1].rotate(i), [1, 1, 1] / 3),
		time: time,
		addAction: \addBefore
	)
}),
// buffer: C.get(\snares, [125, 150].choose),
buffer: d[\thanks][6],
rate: Array.fill(1, { (
	instrument: \ctlEnv,
	env: Env(
		[rrand(20, 50), rrand(1, 5.0)],
		[1].normalizeSum,
		\lin
	),
	time: time,
	addAction: \addBefore
) }),
loop: 1,
amp: (
	instrument: \ctlEnv,
	env: Env([0, 10], 1, 'lin'),
	time: time,
	addAction: \addBefore
)
).play;
)



// FX MIDI


(
x.free;
x = {
	var snd, env;
	// env = Env.perc().kr(0, gate: Impulse.kr(0.1));
	snd = LFSaw.ar(10, 0, 0.1);
	snd = Greyhole.ar(snd, \del.kr(2.0), \damp.kr(0), \size.kr(1.0), \diff.kr(0.7), \fb.kr(0.9));
}.play;
)

MIDIdef.cc(\test, {|val, src, chan, num| [num, chan, src, val].postln})

(
MIDIdef.cc(\greyhole_del, {|val| x.set(\del, val.linlin(0, 127, 0.01, 8))}, 8);
MIDIdef.cc(\greyhole_damp, {|val| x.set(\damp, val.linlin(0, 127, 0.0, 1))}, 9);
MIDIdef.cc(\greyhole_size, {|val| x.set(\size, val.linlin(0, 127, 0.01, 8))}, 10);
MIDIdef.cc(\greyhole_diff, {|val| x.set(\diff, val.linlin(0, 127, 0.01, 1))}, 11);
MIDIdef.cc(\greyhole_fb, {|val| x.set(\fb, val.linlin(0, 127, 0.01, 1))}, 12);
)

(
x.free;
x = {
	var snd, env;
	// env = Env.perc().kr(0, gate: Impulse.kr(0.1));
	snd = LFSaw.ar(\freq.kr(100, 1), 0, 0.1);
	snd = GVerb.ar(snd, \room.kr(10), \time.kr(3), \damp.kr(0.5), \bw.kr(0.5), 15, \dry.kr(1), \early.kr(0.7), \tail.kr(0.5))
}.play;
)

(
MIDIdef.cc(\gverb_room, {|val| x.set(\room, val.linlin(0, 127, 0.01, 8))}, 64);
MIDIdef.cc(\gverb_time, {|val| x.set(\time, val.linlin(0, 127, 0.01, 10))}, 65);
MIDIdef.cc(\gverb_damp, {|val| x.set(\damp, val.linlin(0, 127, 0.0, 1))}, 66);
MIDIdef.cc(\gverb_bw, {|val| x.set(\bw, val.linlin(0, 127, 0.01, 1))}, 67);
MIDIdef.cc(\gverb_early, {|val| x.set(\early, val.linlin(0, 127, 0, 1))}, 68);
MIDIdef.cc(\gverb_dry, {|val| x.set(\dry, val.linlin(0, 127, 0.0, 1))}, 69);
MIDIdef.cc(\gverb_tail, {|val| x.set(\tail, val.linlin(0, 127, 0.01, 1))}, 70);

MIDIdef.cc(\gverb_tail, {|val| x.set(\freq, val.linexp(0, 127, 0.1, 20000))}, 71);
)


(
y.free;
y = {
	var snd, env;
	// env = Env.perc().kr(0, gate: Impulse.kr(0.1));
	snd = LFSaw.ar(\freq.kr(100, 0.1), 0, 0.1);
	snd = GVerb.ar(snd, \room.kr(10, 0.1), \time.kr(3, 0.1), \damp.kr(0.5, 0.1), \bw.kr(0.5, 0.1), 15, \dry.kr(1, 0.1), \early.kr(0.7, 0.1), \tail.kr(0.5, 0.1))
}.play;
)

(
MIDIdef.cc(\cc72, {|val| y.set(\room, val.linlin(0, 127, 0.01, 8))}, 72).fix;
MIDIdef.cc(\cc73, {|val| y.set(\time, val.linlin(0, 127, 0.01, 10))}, 73).fix;
MIDIdef.cc(\cc74, {|val| y.set(\damp, val.linlin(0, 127, 0.0, 1))}, 74).fix;
MIDIdef.cc(\cc75, {|val| y.set(\bw, val.linlin(0, 127, 0.01, 1))}, 75).fix;
MIDIdef.cc(\cc76, {|val| y.set(\early, val.linlin(0, 127, 0, 1))}, 76).fix;
MIDIdef.cc(\cc77, {|val| y.set(\dry, val.linlin(0, 127, 0.0, 1))}, 77).fix;
MIDIdef.cc(\cc78, {|val| y.set(\tail, val.linlin(0, 127, 0.01, 1))}, 78).fix;

MIDIdef.cc(\cc79, {|val| y.set(\freq, val.linexp(0, 127, 20, 20000))}, 79);
)


(
~combwhite.release;
~combwhite = Ndef(\combwhite, {
	var sound, trig, env, comb, lfo, freq, detune, lag, mix, width, amp, reverbmix, movement;
	movement = \movement.kr(10, 0.1);
	lfo = LFNoise2.kr(movement);
	trig = Impulse.kr(1/4);
	// freq = \freq.kr(200);
	// freq = TRand.kr(50, 180, trig).midicps;
	// freq = TChoose.kr(trig, [47, 72, 28, 90, 100].midicps);
	freq = Demand.kr(trig, 0, Dseq(~harmonicSequence, inf));
	detune = \detune.kr(0);
	lag = \lag.kr(0);
	mix = \mix.kr(0);
	width = \width.kr(0.3);
	amp = \amp.kr(1);
	reverbmix = \reverbmix.kr(0.5);
	sound = WhiteNoise.ar(0.03);
	// width = SinOsc.kr(1).unipolar;
	sound = PanAz.ar(s.options.numOutputBusChannels, sound, lfo, 1, width);
	// sound = Balance2.ar(sound, sound, LFNoise2.kr(1))
	comb = CombC.ar(sound, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
	sound = XFade2.ar(sound, comb, mix * 2 - 1) * amp/2;
	// sound = LPF.ar(sound, 10000);
	sound = sound.blend(JPverb.ar(sound, \revtime.kr(1, 0.1)) * 2, reverbmix);
});

~combwhite.play;
)


---


(
~comb2.release(10);
~comb2 = {
	|freq = 200, mix = 1|
	var sound, env, width, comb;
	sound = WhiteNoise.ar(0.03);
	sound = sound + SinOsc.ar(50, 0, 0.2);
	sound = sound + LFTri.ar(LFNoise2.kr(10).range(5000, 5020), 0, 0.1);
	// width = SinOsc.kr(1).unipolar;
	sound = PanAz.ar(s.options.numOutputBusChannels, sound, LFNoise2.kr(10), 1, 0.3);
	// sound = Balance2.ar(sound, sound, LFNoise2.kr(1))
	comb = CombC.ar(sound, 0.2, 1/freq, 1, 0.1);
	sound = XFade2.ar(sound, comb, mix);
}.play(fadeTime: 20);
)



(
~tinnitus.release(1);
~tinnitus = {
	|bassfreq = 50|
	var sound, env, width;
	sound = WhiteNoise.ar(0.03);
	sound = CrossoverDistortion.ar(sound, 1, 0.99);
	sound = sound + SinOsc.ar(bassfreq, 0, 0.2);
	sound = sound + LFTri.ar(LFNoise1.kr(10).range(10000, 10100), 0, 0.1);
	sound = LPF.ar(sound, 3000);
	sound = Limiter.ar(sound, 0.5);
	sound = SplayAz.ar(~numChannels, sound, 1, 1, ~numChannels);
}.play(fadeTime: 5);
)






(
~combwhite.release;
~combwhite = {
	|freq = 200, detune = 0, lag = 0, mix = 0, width = 0.3, amp = 1, reverbmix = 0|
	var snd, env, comb;
	// env = Env.asr(3, 1, 3).kr(2, gate);
	snd = WhiteNoise.ar(0.03);
	// snd = snd * env;
	// width = SinOsc.kr(1).unipolar;
	snd = PanAz.ar(s.options.numOutputBusChannels, snd, LFNoise2.kr(10), 1, width);
	// snd = Balance2.ar(snd, snd, LFNoise2.kr(1))
	comb = CombC.ar(snd, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
	snd = XFade2.ar(snd, comb, mix * 2 - 1) * amp;
	// snd = FreeVerb.ar(snd, reverbmix);
}.play(fadeTime: 30);

~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, Array.makeScaleCps(300, 'major', 20, 10000).choose, \lag, 0, \mix, 1, \lag, 0, \amp, 2, \reverbmix, 0, \amp, 1);
		0.1.wait;
}}.fork
)


(
~harmonies.release(30);
~harmonies ={arg vin=0.1;
	var snd;
	snd = Splay.ar(
		BPF.ar(
			Saw.ar(
				Array.geom(10, 32.1, 1.5)),
			LFNoise2.kr(vin).range(100,1000),
			0.05, 5

		), 1, 1/2

	);
	BRF.ar(snd, 1000);
}.play(fadeTime: 30);
)



(
~iter2 = Ndef(\iter2, {
	arg freq = 200, dev = 1.02;
	var temp, sum;
	sum = 0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(8/count) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
});
)




(
~iter2.set(\freq, 200);
~iter2.lag(\freq, 10);
~iter2.play(fadeTime: 10);
)

~iter2.set(\freq, 400/4);


(
~middle.release(30);
~middle = {
	Splay.ar(SinOsc.ar(
		{LFNoise2.kr(0.01).range(100,1000)}!10,
		mul: {LFNoise2.kr(1).range(0.001,0.2)}!10) * \amp.kr(1))
}.play(fadeTime: 30);
)



(
~cuves.release(3);
~cuves = {
	var snd, trig, lfo;
	lfo = LFNoise2.kr(3);
	lfo = LFNoise2.kr(lfo * 5);
	trig = Impulse.kr(lfo.range(0.1, 0.2));
	snd = SinOscFB.ar(lfo.exprange(200, 220), 0.5, 0.1);
	snd = snd * Env.perc(0.01, \rel.kr(2) + (lfo.abs * 2)).kr(0, gate: trig);
	snd = GVerb.ar(snd, 2, (lfo * lfo).range(0.5,2));
	snd = Limiter.ar(snd, 0.1);
	snd = PanAz.ar(~numChannels, snd.sum, LFNoise2.kr(1).range(-0.25, 1.75), \amp.kr(1));
	snd = Sanitize.ar(snd);
}.play(fadeTime:10);
)