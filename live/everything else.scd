
/Buffer folders / Convenience

		s.sync;

		// C.crawl("/Users/maxlouisraugel/Documents/son/drums/", 1);
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/thanks/");
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/Ott-Orgel_1.02 ORGAN (ok to use)/Gedackt8/");
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/small instruments/", 1);


// ORGANIC SPACES


(
Ndef(\neoformant).clear;
Ndef(\neoformant).fadeTime = 15;
Ndef(\neoformant).play(fadeTime: 5);
)




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

			}.play(fadeTime: 30);


		30.wait;

	}.loop

}.fork
)


(
~space.stop;
~space = {
	{
		(
			Ndef(\neoformant, {
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
				snd = Pan2.ar(snd, 0, 0.5);
				snd = LeakDC.ar(snd);
			}).mold(2);
		);

		15.wait;

	}.loop

}.fork
)




Ndef(\wobl).vol_(0.4).play(fadeTime:0.1);

Ndef(\wobl).stop;

Ndef(\high_tilts).vol_(0.7).play(fadeTime: 1);

Ndef(\high_tilts).stop;


(
Ndef(\kick,
	Pbind(
		\instrument, \kick,
		\dur, Pseq([Rest(4/8), 1/8, 1/8, Rest(2/8), 1/100!10, Rest(4)].flatten*3,inf),
		\freq, 50,
		\pan, Pwhite(-1/2, 1/2),
		\amp, 2,
		\rel, Pseq([0.5, 0.5, 1/10!10].flatten, inf)
	)
)
)

Ndef(\kick).play;

Ndef(\kick).stop;



(
Ndef(\percsine,
	Pbind(\instrument, \percsine,
		\dur, 0.1,
		\freq, Pxrand((({{(Scale.ritusen.cents / [[2, 1.5]]).choose}!4}!4).flatten).flatten, inf) * Pwrand([2, 4, 8], [1, 1/2, 1/3].normalizeSum, inf),
		\amp, 0.2,
		\rel, 0.1,
		\lpf, Pseg([100, 700, 100], [15, 15], 'exp', 1),
		\out, rrand(0, ~numChannels-1);
	)
)
)

Ndef(\percsine).play;

Ndef(\percsine).stop(0);


(
x.free;
x = {
	var snd;
	snd = SinOsc.ar(SinOsc.ar(LFNoise2.kr(3).range(2, 7)).exprange(20, 20000), 0, 1/10);
	snd = CombC.ar(snd, 0.2, 1/LFNoise2.kr(0.3).range(100, 1000), 0.1);
	snd = Pan2.ar(snd, LFNoise2.ar(0.3));
	snd = snd * SinOsc.ar(LFNoise2.kr(0.3, 7).abs).abs * 1/2;
	// snd = snd + (PinkNoise.ar(snd));
	snd = snd * Env.perc().kr(0, gate: Dust.kr(\density.kr(0.5)));
	snd = FreeVerb.ar(snd, 0.1, 0.01, 1);

}.play
)



-----




// W JOSH

Synth(\poom, [freq: 123 * 1, atk: 3, rel: 10, amp: 1]);



Pbindef(\p, \instrument, \poom, \dur, Prand([1, 1/5], inf) * 100/60, \freq, Pxrand(123 * [13, 11, 15, 9, 6, 8], inf), \amp, Prand([0.2, 0.3], inf), \pan, Pwhite(-1, 1.0)).play(quant: 1);

Pbindef(\q, \instrument, \percsine, \dur, Pwhite(1.0, 7.0), \freq, Pseg(123 * [13, 11, 15, 9, 6, 8], {rrand(1, 10)}!5, 'lin', inf)/2, \rel, Pkey(\dur)/3, \amp, 0.5).play;


Pbindef(\p2, \instrument, \sinoscfbmod_rotate, \dur, Prand([1, 1/5] * 2, inf) * 100/60, \freq, Pxrand(123 * [13, 11, 15, 9, 6, 8], inf) / 2, \atk, Pkey(\dur), \rel, Pkey(\dur), \amp, 0.5, \pan, Pwhite(-1, 1.0)).play;

Pbindef(\p2).stop;
Pbindef(\p).stop;
Pbindef(\q).stop;

x = Synth(\sinesaw, [freq: 123, atk: 20])
x.set(\amp, 1.7)
x.free;


Synth(\fml, [\freqA, 20, \freqB, (123 * [13, 11, 15, 9, 6, 8]).choose, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1/3, \atk, 0.1, \rel, 10]);


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


----


Pbindef(\chords, \instrument, \percsine, \dur, 1/8 * 100/60, \note, Pseq([\Em, \Am].chordProg, inf), \amp, 0.1, \rel, 1).play;
Pbindef(\chords).stop;

Pbindef(\chords, \note, Pseq([\Em, \Am, \Bm7, \C0].chordProg, inf));

Pbindef(\chords, \note, Pseq([\Em, \Am, \Bm7, \C0, \C1].chordProg, inf)).play;

Pbindef(\chords, \instrument, \percsine, \dur, 1/16 * 100/60, \note, Pseq([\Em, \Am, \Bm7, \C0, \C1, \A0m].chordProg, inf), \amp, 0.1, \rel, 0.1/2).play;

{SinOsc.ar(160, 0, Env.linen(3, 0, 4, 1.4).kr(2))}.play;


(
Pbindef(\chords, \instrument, \percsine, \dur, 1/8 * 100/60, \note, Pseq([\Em, \Am].chordProg, inf), \amp, 0.1, \rel, 1).play;

Pbindef(\chords2, \instrument, \poom, \dur, 1/2 * 100/60, \note, Pseq([\Em, \Am].chordProg, inf), \amp, 0.2, \rel, 1).play;
)


Synth(\kick, [note: \Em - 24, atk: 0.1, rel: 3, amp: 1.2])

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


Ndef(\bb).lag(\freq, 100/2);
Ndef(\bb).set(\freq, 130/2);
Ndef(\bb).set(\freq, 110/2);


Pbindef(\chords).stop;


Ndef(\bassbynathan).fadeTime=30;

Ndef(\bassbynathan)[10] = \filter -> {|in| LPF.ar(in, SinOsc.ar(MouseY.kr(1, 10)).exprange(20, 20000))}

Ndef(\bassbynathan).stop(10)


-----
Tempo.bpm = 100;

-- beautiful thing at josh

(
Pdef(\fm,
	Pbind(
		\instrument, \fm,
		\dur, Pbjorklund2(6, 12, inf),

		\note, Pseq(\Em.asNotes++\Am.asNotes, inf),
		\ctranspose, Pstep([0, 4], [14, 2], inf),

		\seed, Pxrand((0..3)++(13..27)++(40..49), inf).poll,
		// \seed, Pxrand((0..53), inf).poll,

		\seedDrift, Pxrand((0..5), inf),
		\seedDriftCurve, -4,

		\freqMin, -2,
		\freqMax, 3,
		\freqRound, 0,

		\feed, Prand([1, 1.5], inf),

		\partialMax, Pwrand([1, 30], [0.9, 0.1], inf) + 20,
		\legato, 1,
		\lpf, 3000,
		\amp, 10,
		\pan, Pwhite(-1/2.0, 1.0/2),

	)
).play(quant:1);
)


Tempo.bpm = 110;

NdefMixer(s)

Pbindef(\k, \instrument, \kick, \freq, Pstep([[100, 1000], [100, 1200, 500]], [15, 1], inf), \dur, 1, \amp, 0.23, \atk, 0, \rel, 0.1, \pan, Pseq([-1, 1], inf)).play(quant:1);

Pbindef(\k).stop;


Pbindef(\kick, \instrument, \kick, \dur, 4, \freq, 60, \rel, 3, \amp, 1).play(quant:4);

Ndef(\white).play; Ndef(\white)[102] = \filter -> {|in| in * Trig.ar(Dust.kr(0.3), 0.7)}


~timing = [ 4, 1, 0.5, 0.5, 2, 4, 2, 0.5, 1, 0.5, 4, 1 ];





// techno-trap
Pbindef(\fm, \instrument, \fm, \dur, Pxrand([4, 8]/3, inf), \freq, Pxrand((\Em.asNotes + 60).midicps, inf), \ctranspose, Pxrand([-12, 0, 12, -24], inf), \seed, Pxrand([17, 8, 16, 3, 47], inf), \seedDrift, Pxrand([1, 2, 5], inf), \seedDriftCurve, -4, \amp, 1, \pan, Pwhite(-1, 1.0), \feed, Pxrand([1, 1.5], inf), \legato, 1).play(quant: 4);



(
x.free;
x = {var snd; snd = VarSaw.ar(SinOsc.ar(0.1).exprange(20, 500) * Demand.kr(Impulse.kr(120/60), 0, Drand(\Em.asNotes, inf)), 0, SinOsc.ar(3).abs, LFDNoise3.ar(10).abs /2); snd = LPF.ar(snd, 3000)!2; snd = snd * Trig.ar(Dust.kr(0.15), 0.7).lag(0.1)}.play;
)


Pbindef(\fm).clear;



-----



Ndef(\partial).clear;

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

~partial.set(\buffer, d[\thanks][6]);
~partial.fadeTime=10;
~partial.send.play;
~partial.set(\amp, 0.8)
~partial.set(\bus, 0);

~partial[10] = \filter-> {|in| CombC.ar(in, 0.2, 1/LFNoise2.kr(0.3).exprange(100, 1000), 0.1)}

~partial[10] = nil;

~partial[10] = \filter-> {|in| CombC.ar(in, 0.2, 1/LFNoise2.kr(0.3).exprange(100, 1000), 0.1)}



(
p.stop;
  p = Pbind(
	\type, \dirt,
	\dirt, ~dirt,
	\n, Pseries(0, 1, inf).poll,
	\s, Prand([\808, \nm, \jj, \bd], inf),
	\speed, 1,
	\distort, 1,
	\amp, 1.5,
	\dur, Pseq([1, 2, 0.3], inf),
	\note, -12
  ).play;
)


-------

(
~phasor = Ndef(\phasor,{
	var snd, lfo, freq;
	freq = \freq.kr(100, 0.1);
	lfo = LFNoise2.ar(1);
	snd = LFSaw.ar([freq, freq * {Rand(1, 1.010)}!3], Rand(0, 1.0), 0.1/5);
	snd = Splay.ar(snd, 1, 0.5);
	snd = AnalogPhaser.ar(snd, (lfo.abs * 2.7), 0.1, 0.9, 0.5, 2);
	snd = BPF.ar(snd, Array.fib(10, 10, freq * 2), 0.01, 10);
	snd = Splay.ar(snd, 1, 1);
	snd = HPF.ar(snd, freq * 8);
	// snd = FreeVerb.ar(snd, LFNoise2.kr(1).abs);
	// snd = (snd * 5).tanh;
	// snd = snd.blend(snd * LFSaw.ar(MouseY.kr(1, 10)).abs * 2, MouseX.kr(0, 1));
}
)
)

Ndef(\phasor).play(fadeTime: 0);

~phasor.fadeTime = 3;
~phasor.xset(\freq, 300)

~phasor[10] = \xset -> Pmono(\test, \dur, 5, \freq, Pseq([300, 270, 80, 70], inf), \amp, 2)
~phasor[10] = \xset -> Pmono(\test, \dur, Pxrand([1, 2, 5], inf), \note, Pxrand([0, 2, 7, 5, 12, 14] - 12, inf), \amp, 10);

~phasor[10] = nil;


~phasor.stop;


Pbindef(\a).stop; Pbindef(\c).stop; Pbindef(\triste).stop; Pbindef(\2).stop; ~phasor[10] =nil; ~phasor.xset(\freq, 82);


~phasor.vol = 10;

~phasor.xset(\freq, 50);

~limit = {{~phasor.xset(\freq, rrand(95, 105)); 3.wait;}.loop}.fork

MIDIdef.cc(\0, {|val| ~phasor.set(\freq, val.linexp(0, 127, 20, 200))}, 0).fix;

~phasor[20] = \filter -> {|in| CombC.ar(in, 0.2, 1/\combFreq.kr(100, 0.1), 1/2)}

MIDIdef.cc(\1, {|val| ~phasor.set(\combFreq, val.linexp(0, 127, 20, 2000))}, 1).fix;


---

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


~drone.stop(fadeTime:30);






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


Ndef(\x, {var snd, mc, lfo;
	mc = 10;
	lfo = LFNoise2.kr(\mod.kr(0.2)).range(0, 3.0);
	// lfo = \mod.kr(0.3).range(0, 3.0);
	// snd = SinOscFB.ar({exprand(20, 3000)}!mc, lfo.range(0, \fb.kr(1.0)), {LFNoise2.kr(3, 0.05, 0.1)}!mc);
	snd = SinOscFB.ar(([200, 220, 500, 380]*[[0.5, 0.25, 1, 2]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(1.0)), {lfo.range(0, 0.05)}!10);
	// snd = BPF.ar(snd, {exprand(20, 3000)});
	snd = HPF.ar(snd, 100);
	snd = SplayAz.ar(~numChannels, snd, 1, 1, 2, lfo.range(0, ~numChannels)) * 0.3 * \amp.kr(0);
	snd = snd.blend(JPverb.ar(snd, 6), \jpverb.kr(0));
}).mold(~numChannels);



[0, 2, 3, 7, 10, 12].midiratio

// FATFOLD


(
~fatfold = Ndef(\fatfold , {
	var trig, seq, snd, env, freq;
	freq = \freq.kr(55, 0.1);
	trig = Dust.kr(1);
	seq = Demand.kr(trig, 0, Drand(freq * [1, 1.2, 1.5, 0.9, 0.5], inf));
	// seq = freq;
	snd = SinOsc.ar( seq * [ 0.99, 1.02 ], mul: 0.5);
	snd = snd.fold(SinOsc.kr(\fmlo.kr(50, 0.1)), SinOsc.kr(\fmhi.kr(30, 0.1)) );
	// snd = snd.fold(SinOsc.kr(seq * \ratio1.kr(0.5)), SinOsc.kr(seq * \ratio2.kr(2)) );
	// snd = snd.fold(\ratio1.kr(0.5), \ratio2.kr(2.0));
	snd = LeakDC.ar(snd);
	snd = (snd * 10).distort;
	env = Env.perc(0.01, 3).kr(0, trig);
	snd = snd.tanh * env;
	snd * 0.5;
}).play;
);



(
MIDIdef.cc("fatfold").free;

~fatfold = Ndef(\fatfold).addSpec(
	\amp, \amp,
	\freq, \freq,
	\fmlo, \freq,
	\fmhi, \freq,
	// \ratio1, [0, 10],
	// \ratio2, [0, 10],
	// \ratio1, \freq,
	// \ratio2, \freq
);

~ccControlled = Order.newFromIndices(
	[
		\freq, \fmlo, \fmhi, \ratio1, \ratio2
	], (0..4);
);


MIDIdef.cc(
	"fatfold",
	{arg val, num;
		var control = ~ccControlled[ num ];

		~fatfold.set(
			control,
			~fatfold.getSpec(control).map(val/127)
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


~fatfold.stop;

b = "Users/maxlouisraugel/Documents/ /reverb 27 perc.wav".b;

Pbindef(\3, \instrument, \play, \dur, 1/2, \buffer, d[\thanks][[6,9]], \rate, Pxrand([\Em, \C, \B].chordProg, inf).midiratio + 3.5.midiratio, \strum, Pxrand([0.01, 0.1, 0.03], inf), \amp, 1).play;

Pbindef(\3).stop;

~drone = "Users/maxlouisraugel/Documents/son/voice drone 3.wav".b;

Pbindef(\drone, \instrument, \playlinen, \dur, ~drone.duration/2.2, \buffer, ~drone, \rate, Pseq([0, -4, [-7, 7], 3], inf).midiratio, \atk, ~drone.duration/2, \sus, 0, \rel, ~drone.duration/2, \amp, 2).play;


Pbindef(\drone).stop;





------



(
~fm2.free;
~fm2 = {
	var mod, freq, snd;
	mod = LFSaw.ar(\ffreq.kr(100), 0, \index.kr(-1));
	freq = \freq.kr(410);
	snd = SinOsc.ar(freq*(2**(mod*5)), 0, 0.1);
	snd = Pan2.ar(snd, LFNoise2.kr(\panmod.kr(1), \panrnd.kr(1)));
}.play
)

(
// MIDIdef.freeAll;
MIDIdef.cc(\freq, {|val| ~fm2.set(\freq, val.linexp(0, 127, 1, 20000))}, 4).fix;
MIDIdef.cc(\ffreq, {|val| ~fm2.set(\ffreq, val.linexp(0, 127, 1, 20000))}, 5).fix;
MIDIdef.cc(\index, {|val| ~fm2.set(\index, val.linlin(0, 127, -1, 1))}, 6).fix;
MIDIdef.cc(\panmod, {|val| ~fm2.set(\panmod, val.linlin(0, 127, 0, 20))}, 7).fix;
MIDIdef.cc(\panrnd, {|val| ~fm2.set(\panrnd, val.linlin(0, 127, 0, 1))}, 8).fix;
)


(
~fm2.release(0);
~fm2 = {
	var freq, mod, fmfreq, osc, snd, rytm, rhythms;
	freq = \freq.kr(3);
	rhythms = Select.kr(MouseY.kr(0, 3), ~rhythms);
	rytm = Dseq(rhythms, inf);
	rytm = ~rytm;
	mod = LFSaw.ar(freq, 0, \index.kr(-1));
	// mod = Dust.ar(0.2);
	fmfreq = \ffreq.kr(100)*(2**(mod*5));
	// osc = LFTri.ar(fmfreq, 0, 0.5); osc = BRF.ar(osc, 0.1);
	snd = mod.blend(Resonator.ar(mod, fmfreq, 0.1, 24, 0.5, 1, 0.1), 0.5);
	snd = snd * (freq.explin(20, 500, 1, 0));
	// snd = BPeakEQ.ar(snd, 100, 5, 48);
	// snd = snd.blend(Pan2.ar(CombL.ar(snd, 0.2, 0.2, 3), LFNoise2.kr(1)), 0.5);
	// snd = GVerb.ar(snd, 1, 3, 0.9);
}.play(fadeTime:0)
)


(
~rhythms =
	[
	[1, 5, 1, 3],
	[1, 1, 2, 1],
	[3, 7, 2],
	[1, 5, 8]
];

~rytm = {Select.kr(MouseY.kr(0, 3), ~rhythms)};
);




// [ 779.62218924418, 61.766946623989, 11604.106227752, 755.10335512206, 95.859523192072, 9141.5300789306, 162.71595718827, 42.376927437723 ];

// or [ 1597.9613421695, 43.813376424182, 3816.8757362354, 19297.099012546, 106.11746074387, 2053.6076912532, 13693.75116878, 52.849479454445 ]

(
y.free;
y = {
	var mod, snd, rytm, rhythms;
	// mod = LFSaw.ar(LFNoise2.kr(0.2).range(0.01, 3), 0, -1);
	rhythms = Select.kr(MouseY.kr(0, 3), ~rhythms);
	rytm = Dseq(rhythms, inf);
	rytm = ~rytm;
	mod = LFSaw.ar(Demand.kr(Impulse.kr(1), 0, rytm), 0, -1);

	snd = LFTri.ar(\freq.kr(410)*(2**(mod*5)), 0, 0.1)!2;
	snd = NHHall.ar(snd, 0.1, 0.5);
	snd = snd.blend(Resonator.ar(snd, Demand.ar(mod, 0, Dseq(({exprand(20, 20000)}!8).postln, inf)), 0.0001, 24, 1, 0.1), 1);
}.play;
)




Pbindef(\zone3, \instrument, \sinesaw1, \freq, Pseg([100, 250, 270, 250, 270, 100, 250], [1, 2, 3, 1, 2], 'lin', inf), \dur, 3, \atk, 1, \rel, 7, \amp, 1, \pan, Pwhite(-1, 1.0)).play;





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





------

// SHEPARD CONTROL QUARK MISSING

C.crawl("/Users/maxlouisraugel/Documents/son/thanks/");

(
~shepardbuf3.release;
~shepardbuf2.release;
~shepardbuf2 = {
    var intvs, amps, buffer, snd;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = d[\thanks][6];
    snd = (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.2;
	snd = Balance2.ar(snd[0], snd[1], intvs.linlin(0, 24, -1, 1));
}.play;
)

(
~shepardbuf3.release(10);
~shepardbuf3 = {
    var intvs, amps, buffer, snd;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\thanks, 12);
    snd = (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.3;
	snd = Balance2.ar(snd[0], snd[1], intvs.linlin(0, 24, -1, 1));
	snd = Pan2.ar(snd, intvs.linlin(0, 24, -1, 1));
}.play;
)

(
~shepardbuf1.release(5);
~shepardbuf1 = {
    var slope =  MouseX.kr(-0.1, 0.1);
    var shift = MouseY.kr(2, -2);

    var intvs, amps, snd;
    #intvs, amps = Shepard.kr(5, slope, 12, shift);
    snd = (PlayBuf.ar(2, C.get(\thanks, 14), intvs.midiratio, loop: 1) * amps).sum * 0.2;
}.play;
)

(
~shepardbuf1.release(10);
~shepardbuf2.release(10);
~shepardbuf3.release(10);
)



(
~shepardbuf3.release;
~shepardbuf3 = {
    var intvs, amps, buffer;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\snares, 33);
    (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.3;
}.play;
)


(
~shepardbuf3.release(10);
~shepardbuf3 = {
    var intvs, amps, buffer, snd;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\snares, 12);
    snd = (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps) * 0.2;
	snd = Balance2.ar(snd[0], snd[1], intvs.linlin(0, 24, -1, 1));
}.play;
);

(
~shepardbuf2.release(5);
~shepardbuf2 = {
    var intvs, amps, buffer;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\rides, 4);
    (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.2
}.play;
)

(
~shepardbuf2.release(10);
~shepardbuf2 = {
    var intvs, amps, buffer;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\thanks, 11);
    (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.1
}.play;
)

(
~faketriple.stop;
~faketriple = Pbind(\instrument, \kick, \dur, 1/10, \note, Pseq([\Em, \Am].chordProg, inf), \amp, 0.1/2).play;
)

(
~shepardbuf3.release(10);
~shepardbuf3 = {
    var intvs, amps, buffer, snd;
    #intvs, amps = Shepard.kr(5, slope: 0.01, interval: 24, shift: 0);
	buffer = C.get(\thanks, 12);
    snd = (PlayBuf.ar(2, buffer, ((intvs - 12).midiratio) * BufRateScale.kr(buffer), loop: 1) * amps).sum * 0.3;
	snd = Balance2.ar(snd[0], snd[1], intvs.linlin(0, 24, -1, 1));
	snd = Pan2.ar(snd, intvs.linlin(0, 24, -1, 1));
}.play;
)

(
~bjorklund.stop;
~bjorklund = Pbind(\instrument, \kick, \freq, 50, \dur, 0.2, \amp, Pbjorklund(3, 8)).play(quant: 0.2);
)

(
~bjorklund2.stop;
~bjorklund2 = Pbind(\instrument, \hh, \dur, 0.2, \amp, Pbjorklund(6, 16) * 0.1).play(quant:0.2);
)

(
~bjorklund3.stop;
~bjorklund3 = Pbind(\instrument, \play, \buffer, C.get(\snares, 12), \dur, 0.2, \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 0.5).play(quant:0.2);
)

(
~bjorklund4.stop;
~bjorklund4 = Pbind(\instrument, \play, \buffer, C.get(\rides, 1), \dur, 0.2, \amp, Pbjorklund(Pseq([8, 12], inf), 16) * Pseq([0.1, 0.2], inf)).play(quant: 0.2);
)

(
~faketriple.stop;
~faketriple = Pbind(\instrument, \kick, \dur, 1/10, \note, Pseq([\Em, \Am].chordProg, inf), \ctranspose, Pstep([0, 4], [14, 2], inf), \amp, 0.1/2).play(quant:0.2);
)

(
~bjorklund6.stop;
~bjorklund6 = Pbind(\instrument, \play, \dur, 0.2, \buffer, C.get(\kalimba, 3), \rate, Pseq([0.5, 0.53], inf), \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 0.7).play(quant: 0.2);
)

(
~bjorklund5.stop;
~bjorklund5 = Pbind(\instrument, \play, \dur, Pseq([0.2, 0.1, 0.2], inf), \buffer, Pseq(C.get(\Gedackt8, [4]), inf), \rate, Pseq([0.5, 0.53], inf), \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 0.1).play(quant: 0.2);
)



~ampbus = ~ampbus ?? Bus.control(s, 1);
~tartinibus = ~tartinibus ?? Bus.control(s, 1);

(
~amp = Synth(\amplitudesoundin, [out: ~ampbus, amp: 10]);
~tartini = Synth(\tartinisoundin, [out: ~tartinibus]);
)

x = Synth(\sine, [freq: ~tartinibus.asMap, amp: ~ampbus.asMap])
x.free;



(
~bjorklund.stop;
~bjorklund1.stop;
~bjorklund2.stop;
~bjorklund3.stop;
~bjorklund5.stop;
~bjorklund6.stop;

~bjorklund4.stop;
~bjorklund4 = Pbind(\instrument, \play, \buffer, C.get(\rides, 1), \dur, 0.2, \amp, Pbjorklund(Pseq([8, 12], inf), 16) * Pseq([0.1, 0.2], inf)).play(quant: 0.2);
)

(
~bjorklund4b.stop;
~bjorklund4b = Pbind(\instrument, \play, \buffer, C.get(\rides, 1), \dur, 0.1, \amp, Pbjorklund(Pseq([8, 12], inf), 16) * Pseq([0.1, 0.2], inf)).play(quant: 0.2);
)

(
~bjorklund4c.stop;
~bjorklund4c = Pbind(\instrument, \play, \buffer, C.get(\rides, 1), \dur, 0.3, \amp, Pbjorklund(Pseq([8, 12], inf), 16) * Pseq([0.1, 0.2], inf)).play(quant: 0.2);
)



(
~bjorklund.stop;
~bjorklund = Pbind(\instrument, \kick, \freq, 50, \dur, 0.2, \amp, Pbjorklund(3, 8)).play(quant: 1);

~bjorklund2.stop;
~bjorklund2 = Pbind(\instrument, \hh, \dur, 0.2, \amp, Pbjorklund(6, 16) * 0.1).play(quant: 1);

~bjorklund3.stop;
~bjorklund3 = Pbind(\instrument, \play, \buffer, C.get(\snares, 12), \dur, 0.2, \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 0.5).play(quant: 1);

~bjorklund4.stop;
~bjorklund4 = Pbind(\instrument, \play, \buffer, C.get(\rides, 1), \dur, 0.2, \amp, Pbjorklund(Pseq([8, 12], inf), 16) * Pseq([0.1, 0.2], inf)).play(quant: 1);

~faketriple.stop;
~faketriple = Pbind(\instrument, \kick, \dur, 1/10, \note, Pseq([\Em, \Am].chordProg, inf), \ctranspose, Pstep([0, 4], [14, 2], inf), \amp, 0.1/2).play(quant: 1);

~bjorklund6.stop;
~bjorklund6 = Pbind(\instrument, \play, \dur, 0.2, \buffer, C.get(\kalimba, 3), \rate, Pseq([0.5, 0.53], inf), \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 1).play(quant: 1);

~bjorklund5.stop;
~bjorklund5 = Pbind(\instrument, \play, \dur, Pseq([0.2, 0.1, 0.2], inf), \buffer, Pseq(C.get(\Gedackt8, [4]), inf), \rate, Pseq([0.5, 0.53], inf), \amp, Pbjorklund(Pseq([2, 3], inf), 16) * 0.1).play(quant: 1);
)


(
~bjorklund.stop;
~bjorklund2.stop;
~bjorklund3.stop;
~bjorklund4.stop;
~bjorklund4b.stop;
~bjorklund4c.stop;
~faketriple.stop;
~bjorklund6.stop;
~bjorklund5.stop;
)





-------


(
~bjorklund5.stop;
~bjorklund5 = Pbind(\instrument, \play, \dur, Pseq([0.2, 0.1, 0.2], inf), \buffer, Pseq(C.get(\Gedackt8, [20, 25, 18]), inf),  \amp, Pbjorklund(Pseq([1, 1.5], inf), 16) * 0.1).play(quant: 1);
)


(
~shepardbuf1.release(10);
~shepardbuf2.release(10);
~shepardbuf3.release(10);
)




------------

// WHITE.SCD




~harmonicSequence = ([\Em, \Am, \Bm].chordProg + 60).midicps;
~harmonicSequence = ~harmonicSequence ?? ([\Em, \C, \D, \Bm, \G, \A, \Fsm, \Bm].chordProg + 60).midicps;

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


~combwhite.set(\freq, 120.midicps, \lag, 0, \mix, 0.5);

~combwhite.set(\detune, 0.1.midicps);



(
~glissandos.stop;
~glissandos = {
	loop{
		~combwhite.set(\freq, rrand(50, 100).midicps.round(2), \lag, 3, \reverbmix, 0.8, \amp, 2);
		0.1.wait;

}}.fork
)

(
var ndef = ~combwhite;
var controlnames = [\amp, \movement, \detune, \lag, \mix, \width, \reverbmix];

ndef.addSpec(
	\amp, \amp,
	\movement, [0.1, 10],
	\detune, [0, 10],
	\lag, [0, 7],
	\mix, [0, 1],
	\width, [0, 4],
	\reverbmix, [0, 1]
);


~ccControlled = Order.newFromIndices(
	controlnames, (0..  controlnames.size -1);
);


MIDIdef.cc(
	( ndef.asSymbol ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);

	},	ccNum: ~ccControlled.indices, chan: 0
).fix;
)




(
~comb2.release(2);
~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, rrand(50, 180).round(11).midicps, \lag, 0, \mix, 1, \amp, 1, \detune, 0.1);
	0.1.wait;
}}.fork
)


~combwhite.release(7)

(
~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, rrand(50, 180).midicps, \lag, 0, \mix, 0.5, \amp, 5, \width, 0.1, \reverbmix, 0.3);
	0.1.wait;
}}.fork
)


// ORIGINAL

(
~combwhite.release;
~combwhite = Ndef(\combwhite, {
	var sound, env, comb, gate, freq, detune, lag, mix, width, amp, reverbmix;
	gate = 1;
	freq = \freq.kr(200);
	detune = \detune.kr(0);
	lag = \lag.kr(0);
	mix = \mix.kr(0);
	width = \width.kr(0.3);
	amp = \amp.kr(1);
	reverbmix = \reverbmix.kr(0.5);
	env = Env.asr(3, 1, 3).kr(2, gate);
	sound = WhiteNoise.ar(0.03);
	sound = sound * env;
	// width = SinOsc.kr(1).unipolar;
	sound = PanAz.ar(s.options.numOutputBusChannels, sound, LFNoise2.kr(10), 1, width);
	// sound = Balance2.ar(sound, sound, LFNoise2.kr(1))
	comb = CombC.ar(sound, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
	sound = XFade2.ar(sound, comb, mix * 2 - 1) * amp;
	// sound = LPF.ar(sound, 10000);
	sound = FreeVerb.ar(sound, reverbmix);
}).play;
)


~combwhite.set(\freq, 120.midicps, \lag, 0, \mix, 0.5);

~combwhite.set(\detune, 0.1.midicps);

(
~glissandos.stop;
~glissandos = {
	loop{
		~combwhite.set(\freq, rrand(50, 100).midicps.round(2), \lag, 3, \reverbmix, 0.8, \amp, 2);
		0.1.wait;

}}.fork
)

(
var ndef = ~combwhite;
var controlnames = [\amp, \freq, \detune, \lag, \mix, \width, \reverbmix];

ndef.addSpec(
	\amp, \amp,
	\freq, \freq,
	\detune, [-10, 10],
	\lag, [0, 7],
	\mix, [0, 1],
	\width, [0, 1],
	\reverbmix, [0, 1]
);


~ccControlled = Order.newFromIndices(
	controlnames, (0..  controlnames.size -1);
);


MIDIdef.cc(
	( ndef.asSymbol ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);

	},	ccNum: ~ccControlled.indices, chan: 0
).fix;
)




(
~comb2.release(2);
~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, rrand(50, 180).round(11).midicps, \lag, 0, \mix, 1, \amp, 1, \detune, 0.1);
	0.1.wait;
}}.fork
)


~combwhite.release(7)

(
~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, rrand(50, 180).midicps, \lag, 0, \mix, 0.5, \amp, 5, \width, 0.1, \reverbmix, 0.3);
	0.1.wait;
}}.fork
)





-------

// THROAT COMB.SAW.VERB


~rss = "/Users/maxlouisraugel/Documents/son/radiateur stutters slow.wav".b
~marimba = "/Users/maxlouisraugel/Documents/ /bass-tenor marimbaC1.wav".b;

x = Synth(\play, [out: 0, buffer: ~rss]);
x.release(5);
x.free;


(
SynthDef(\sine, {
	|out 0|
	var snd, env;
	env = Env.perc(0.01, 3).kr(2);
	snd = SinOsc.ar(\freq.kr(500), 0, 0.1);
	Out.ar(out, snd * env * 1);
}).add;
)




(
SynthDef(\throat, {
	// |dur 3|
	var snd, envperc, envlinen, trig, freq, dur;
	dur = \dur.kr({rrand(3, 10.0)}!5);
	trig = Impulse.kr(XLine.kr(20, 5, dur, doneAction:2));
	freq = Line.kr(rrand(300, 500), rrand(100, 70), dur);
	envperc = Env.perc(\atk.kr(0.0), \rel.kr(0.01), \amp.kr(1)).kr(0, trig, timeScale: dur);
	snd = VarSaw.ar(Line.kr(rrand(50, 100), rrand(130, 320), dur), 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * Line.kr(1/2, 2, dur)), \decaytime.kr(1));
	// snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	// snd = Resonator.ar(snd, Line.kr(rrand(20, 100), rrand([1000, 1003], [500, 505]), 10), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = Resonator.ar(snd, Line.kr(\freqA.kr(70), \freqB.kr(1000), 10), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = snd * Line.kr(0.0, 1.5, dur) * 2 * envperc;
	envlinen = Env.linen(dur/6, 0, dur/3, 3, 'sine').kr(0);
	snd = BRF.ar(snd, 200, 2);
	snd = LPF.ar(snd, \lpf.kr(400));
	snd = PanAz.ar(2, snd, \pan.kr(0));
	snd = Limiter.ar(snd);
	// snd = Splay.ar(snd);
	// snd = snd.tanh;
	Out.ar(\out.kr(0), snd * envlinen);
}).play;
)

Synth(\throat, [out: 0, lpf: 1000, amp: 1.8, pan: 1]);

Pbindef(\t, \instrument, \throat, \dur, Pxrand([7, 9, 12, 3, 2], inf), \amp, 1).play
Pbindef(\s, \instrument, \throat, \dur, Pxrand([7, 9, 12, 3, 2], inf)/4, \lpf, 800, \freqA, Pwhite(200, 8000), \freqB, Pwhite(200, 8000), \amp, 16, \pan, Pwhite(0, 2.0)).play

(
Synth(\play, [buffer: ~marimba, amp: 3, rate: 1.2]);
x = Synth(\percsine, [freq: 10000, rel: 3, amp: 0.1, pan: -1]);
)

x.release(3);

(
SynthDef(\resonantcs, {
	|freq 50|
	var snd, env, trig;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \dur.kr(1));
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \combratio.kr(1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	snd = Resonator.ar(snd, \resonatorf.kr(100), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = (2 * snd).tanh;
	// snd = BPF.ar(snd, env.linlin(0, 1, 20000, 20).lag(0.3), 0.5, 20);
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd * \amp.kr(1) * env);
}).add;

SynthDef(\resonantcsverb, {
	|freq 50|
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \dur.kr(1));
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \combratio.kr(1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	snd = Resonator.ar(snd, \resonatorf.kr(100), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = (2 * snd).tanh;
		snd = JPverb.ar(snd, \time.kr(1.0), \damp.kr(0.0));
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd * \amp.kr(1) * env);
}).add;
)

Pbindef(\a, \instrument, \resonantcs, \dur, 1, \freq, Pseq(([\E4m, \C4, \D4, \B3m, \G3, \A3, \F3sm, \B3m].chordProg).midicps.flatten, inf), \pan, Pwhite(-1, 1.0), \detune, 0, \amp, 1).play;


Synth(\jpverb, [in: ~jpverbus], s, 'addToTail')

Pbindef(\one, \instrument, \resonantcs, \dur, 0.1, \freq, Pseg([50, 200, 530, 300], [10, 15, 3], 'lin', inf) * [[1, 1/2]], \amp, 1, \damping, 0.3, \resonatorf, Pseg([3000, 200, 700, 100], [3, 40, 50], 'lin', inf), \pan, Pseg([-1, 1, 0, 1]/2, [3, 4, 3, 2], 'lin', inf)).play;

Pbindef(\one, \freq, Pseg([50, 200], 4, 'lin', inf), \resonatorf, Pseg([3000, 50], 3, 'lin', inf), \amp, 5);

Pbindef(\one).stop(10);

(
Synth(\play, [buffer: ~marimba, amp: 3, rate: 1.2]);
x = Synth(\sine, [freq: 12000]);
)

x.release;


Pbindef(\one, \instrument, \resonantcs, \dur, Pseg([0.1, 0.05, 0.07], [3, 4], 'lin', inf), \freq, Pseg([50, 200, 530, 300], [10, 15, 3], 'lin', inf) * [[1, 1/2]], \amp, 10, \damping, 0.3, \resonatorf, Pseg([3000, 200, 700], [3, 17], 'lin', inf), \pan, Pseg([-1, 1, 0, 1]/2, [3, 4, 3, 2], 'lin', inf)).play;

Pbindef(\one, \dur, Pseg([0.1, 0.01, 0.1], [Pwhite(10, 20), Pwhite(0.1, 0.3), Pwhite(5, 10)], 'lin', inf));

Pbindef(\one, \dur, Pgauss(0, 0.1, inf).abs.poll)

Pbindef(\two, \instrument, \resonantcsverb, \dur, Pseg([0.5, 0.1], Pxrand((3..10), inf), 'lin', inf), \freq, Pseg([500, 20, 53, 300], [10, 15, 3], 'lin', inf) * [[1, 1/2]], \amp, 2, \damping, 0.3, \resonatorf, Pseg([3000, 200, 700, 100], [3, 40, 50], 'lin', inf), \pan, Pseg([-1, 1, 0, 1]/2, [3, 4, 3, 2], 'lin', inf)).play;

Pbindef(\two).stop()

Pbindef(\one).stop;


// from redfrik sctweet
x = play{a=SinOsc;f={|...x|1.5**perform(a,\ar,*x)};Splay ar:({|i|l=perform(a,\ar,f.(i+5/150)<1).abs.round(0.5);y=perform(VarSaw,\ar,1.5**l*(f.(l/155,0,5).ceil*50.05),0,f.(l*f.(l/50))-0.55,max(f.(i+1/500.05)-1,0));z=y+perform(PitchShift,\ar,y*f.(0.1),0.5,5,0.05,1)}!15)}

x.release(3)




(
SynthDef(\modulo, {|freq 2000|
	var snd, env;
	env = Env.linen(\atk.kr(1/2), \sus.kr(1/2), \rel.kr(1/2)).kr(2, timeScale: \dur.kr(1));
	snd = SinOsc.ar([freq, freq * 1.01], 0, 0.1)%SinOsc.ar(0.01, 0, 0.05);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), \combDecay.kr(0.1));
	snd = JPverb.ar(snd);
	snd = LPF.ar(snd * 2, \lpf.kr(5000));
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd * env)
}).add;
)



Pbindef(*[\modulo, instrument: \modulo, dur: 15, freq: Pxrand([500, 1000, 1200, 2000], inf), \amp, 2]).play;

Pbindef(\modulo).stop;


(
Synth(\play, [buffer: ~marimba, amp: 3, rate: 0.78]);
x.release(5);
x = Synth(\sinesaw1, [atk: 1, rel: 10, freq: 800 / 8, amp: 1/5]);
)


Pbindef(\pan, \instrument, \play, \buffer, ~marimba, \rate, 0.78 * 8, \dur, Pseq([1/5, 1/5, Rest(5)], inf), \pan, Pseq([-1, 1, Rest(5)], inf), \amp, 1).play;



Synth(\throat);

x = Synth(\resonator, [in: ~resonatorbus], s, 'addToTail');
y = Synth(\jpverb, [in: ~jpverbus], s, 'addToTail');

x.set(\freq, 1000)

(
Pbindef(\kick, \instrument, \play, \rate, 1/2, \dur, 3.9,  \buffer, C.get(\bassdrums, 17), \amp, 1/2, \out, 0).play;
Pbindef(\snare, \instrument, \play, \dur, 4,  \buffer, C.get(\snares, 28), \amp, 1/3, \out, ~jpverbus).play;
Pbindef(\ride, \instrument, \play, \rate, 1, \loop, 0, \dur, 4, \buffer, C.get(\rides, 1), \amp, 1/5, \out, ~resonatorbus).play;
)

(
Pbindef(\kick, \dur, Pseg([4, 4, 0.1], [2, 32], 4, inf));
Pbindef(\snare, \dur, Pseg([4, 4, 0.1], [2, 32], 4, inf));
Pbindef(\ride, \dur, Pseg([4, 4, 0.1], [2, 32], 4, inf));
)


(
Pbindef(\kick).stop;
Pbindef(\snare).stop;
Pbindef(\ride).stop;
)



(
Ndef(\modulo).clear;

Ndef(\modulo, {
	var snd, env, mod1, trig, freq;

	trig = Dust.kr(\density.kr(0.1));

	mod1 = LFGauss.kr(LFNoise2.kr(0.3).range(0.1, 2.0), 0.01) * 100;

	freq = \freq.kr(100) + mod1;
	freq = freq * LFNoise0.kr(10, 0.01, 1);
	freq = {freq * rrand(0.99, 1.01)}!~numChannels;

	snd = SinOsc.ar(freq, 0, 0.1)%SinOsc.ar(0.01, 0, 0.05);
	snd = snd + Dust.ar(freq/8);

	snd = CombC.ar(snd, 0.2, 1/(freq * 2), \combdecay.kr(0.1));
	snd = LeakDC.ar(snd);

}).fadeTime_(0).play;
)

Ndef(\modulo).set(\freq, 100);



(
Ndef(\lfsine).addSpec(\min, [-1.0, 1.0, \lin, 0, 0]);


Ndef(\lfnoise, {LFNoise2.kr(\lfo.kr(20)).range(\min.kr(0), \max.kr(5))});

Ndef(\lfsine, {SinOsc.kr(\lfo.kr(1)).range(\min.kr(-1), \max.kr(1))});

// Ndef(\major, {Select.kr(MouseX.kr(0, 30), Array.makeScaleCps(300, 'major', 100, 1000)).lag(\lag.kr(0.1))});

Ndef(\major, {Select.kr(MouseX.kr(0, 7), Array.fib(7, 2, 50)).lag(\lag.kr(0.5))});

Ndef('blip', {var snd = Blip.ar(\freq.kr(100), \harms.kr(5), 0.1);
	snd = Pan2.ar(snd, \pan.kr * 2 - 1)
}).mold(2);

Ndef('lfnoise1').kr(1);
Ndef('lfnoise').kr(1);
Ndef('major').kr(1);
Ndef('blip').set('pan', Ndef('lfnoise'), 'harms', Ndef('lfnoise'), 'freq', Ndef('major'));
Ndef('blip').play(fadeTime: 30);
);




--------- MULTICHANNEL RESTS



// check

(
x.release(10);
Routine.run{
	var snd, fall;
	fall = rrand(3, 7);
	x = {SinOsc.ar(Env([exprand(10000, 20000), exprand(200, 300), {rrand(90, 110)}!4], [fall, 7], 'exp').kr(0),0, 0.03)}.play(fadeTime:10);
	fall.wait;
	d[\kicks][7].play;
	x.release(10);
};
)

s.meter;

// check

~shifts.vol_(0.1).play(fadeTime:10);

~shifts.stop(2);

~shifts.set(\lag, 3, \freq, [370, 1900, 3100, 330]);

~shifts.set(\lag, 3, \freq, {[370, 1900, 3100, 330].choose}!4);

~shifts.set(\lag, 3, \freq, [120, 170, 140, 100]);
~shifts.set(\lag, 7, \freq, [170, 140, 100, 120]);
~shifts.set(\lag, 9, \freq, [140, 100, 120, 170]);

~shifts.set(\lag, 10, \freq, [310, 330, 370, 1900]);
~shifts.set(\lag, 1, \freq, [330, 370, 1900, 3100]);

~shifts.stop(3);


MIDIdef.cc(\shifts_freq, {|val| ~shifts.set(\freq, [val.linlin(0, 127, 200, 2000)])}, 0, 0);



d[\kicks][7].play;


b = Ndef(\ball, Pbind(\type, \dirt, \dirt, ~dirt, \s, \kicks, \n, 7, \pan, Pseg((0..10)/10, (10..1)/5, 'lin', inf), \legato, 1, \dur, Pseg((20..10)/10, (10..1)/5, 'lin', inf)));

b.play;

b.stop;

------

(
p.stop;
p = Pbind(\instrument, \stkBowed4,
	\bowposition, 10,
	\dur, Prand([3, 2], inf)/20,
	\bowpressure, Pwhite(20, 200),
	\vibfreq, Pwhite(10, 2000),
	\loudness, Pwhite(0, 128),
	\freq, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf),
	\pan, Pwhite(0, 3),
	\loudness, Pwhite(20, 100);
).play
)


p.free;
-----
s.scope;

~leta = Pbindef(\leta, \instrument, \playAzComb, \buffer, Pxrand(40.collect{|i| d[\lilianeetandree][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 4, \pan, Pwhite(0, 3.0), \note, -12, \combfreq, ([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, \combmix, 0.2, \combd, 3, \amp, 0.1); ~leta.play;

~leta.stop;


-------


~ssaw.play(fadeTime:10);
~ssaw.stop(30);


~boom.play;
~boom.stop;



----

Ndef(\fatfold).clear;

(
	~ff = Ndef(\fatfold , {
	var trig, seq, snd, env, freq;
	freq = \freq.kr(55, 0.1);
	trig = Dust.kr(\density.kr(1));
	seq = Demand.kr(trig, 0, Drand([200, 250, 300, 500, 570, 600, 740], inf));
	// seq = freq;
	snd = SinOsc.ar( seq * [ 0.99, 1.02 ], mul: 0.5);
	snd = snd.fold(SinOsc.kr(\fmlo.kr(50, 0.1)), SinOsc.kr(\fmhi.kr(30, 0.1)) );
	// snd = snd.fold(SinOsc.kr(seq * \ratio1.kr(0.5)), SinOsc.kr(seq * \ratio2.kr(2)) );
	// snd = snd.fold(\ratio1.kr(0.5), \ratio2.kr(2.0));
	snd = LeakDC.ar(snd);
	snd = (snd * 10).distort;
	env = Env.perc(0.01, 3).kr(0, trig);
	snd = snd.tanh * env;
	snd * 0.5;
	snd = PanAz.ar(~numChannels, snd, TRand.kr(0, 2.0, trig)) * \amp.kr(0);
	}).mold(~numChannels);
)

(

MIDIdef.cc(\ffamp, {|val| ~ff.set(\amp, val.linlin(0, 127, 0, 0.5))}, 12, 0).fix;
MIDIdef.cc(\fffreq, {|val| ~ff.set(\density, val.linexp(0, 127, 0, 200))}, 13, 0).fix;
MIDIdef.cc(\fffmlo, {|val| ~ff.set(\fmlo, val.linlin(0, 127, 0, 200))}, 14, 0).fix;
MIDIdef.cc(\fffmhi, {|val| ~ff.set(\fmhi, val.linlin(0, 127, 0, 200))}, 15, 0).fix;

~ff.play;

)





-------------

/VIBES

x.release(10);

s.scope

Ndef(\vibes).clear;

~vibes = Ndef(\vibes, Pbind(\instrument, \vibes, \atk, 0.5, \dur, Pseq((5!5)++10, inf), \freq, Pseq([152, 190, 138, 162, 120, 152], inf), \pan, Pwhite(0, ~numChannels -1))).mold(~numChannels);

~vibesB = Ndef(\vibesB, Pbind(\instrument, \k, \dur, Pseq((5!5)++10, inf), \rel, 5, \freq, Pseq([152, 190, 138, 162, 120, 152, 152, 190, 210, 200, 120, 152]/2, inf), \pan, Pwhite(0, 15.0), \amp, 0.3)).mold(~numChannels);

~vibes.play(fadeTime:10);

~vibesB.play;
~vibesB.stop(30);

~vibes[10] = \filter -> {|in| HPF.ar(in, XLine.kr(20, 20000, 30))};

(
~vibes.stop(1);
~vibesB.stop(1)
)


------------




-----

~sinespulse.play(fadeTime: 50);

/*(
MIDIdef.cc(\rrange, {|val| ~sinespulse.set(\rrange, val.linlin(0, 127, 0.01, 0.99))}, 73, 0).fix;
MIDIdef.cc(\modspeed, {|val| ~sinespulse.set(\modspeed, val.linlin(0, 127, 0.1, 30))}, 74, 0);
MIDIdef.cc(\speed, {|val| ~sinespulse.set(\speed, val.linlin(0, 127, 0.01, 2))}, 75, 0);
)*/

~sinespulse.fadeTime=10; ~sinespulse[10] = \filter -> ~jpverb;

~sinespulse.stop(10);




---------



Ndef(\rumble, \rumble).set(\freq, 126/2); Ndef(\rumble).lag(\freq, 3, \floor, 30); Ndef(\rumble).play(fadeTime:10, vol: 0.1);


Ndef(\rumble).set(\freq, 126/2);
// 90, 82, 45

Ndef(\rumble)[5] = nil;



(
var dur = 5;
~melody.stop;
~melody = Routine.run({{
Ndef('rumble').set(\freq, 126/2 - 3);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 10);
	(dur * 2).wait;
Ndef('rumble').set(\freq, 126/2);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 3);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 10);
	(dur).wait;
Ndef('rumble').set(\freq, 126/2 - 15);
	(dur).wait;
Ndef('rumble').set(\freq, 126/2);
	dur.wait;
	}.loop;
}
)
)


Ndef(\wobl).stop;

~melody.stop; Ndef('rumble').xset(\freq, 126/2 - 20);
Ndef('rumble').xset(\freq, 126/2 - 25);

(
var fade = 50;
Ndef('rumble').stop(fade);
)



----------- 13EME B


(
~tabble.set(\midinotes, [ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ]);
~tabble.vol_(1).fadeTime_(30).play;
~tabble[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, \room.kr(0.5))};
)

(
MIDIdef.cc(\t_amp, {|val| ~tabble.set(\amp, val.linlin(0, 127, 0, 1))}, 0).fix;
MIDIdef.cc(\t_comb, {|val| ~tabble.set(\comb, val.linlin(0, 127, 0, 1))}, 1).fix;
MIDIdef.cc(\t_verb, {|val| ~tabble.set(\room, val.linlin(0, 127, 0, 1))}, 2).fix;
MIDIdef.cc(\t_tempo, {|val| ~tabble.set(\tempo, val.linlin(0, 127, 1, 8))}, 3).fix;
/*MIDIdef.cc(\t_midinotes, {|val| ~tabble.set(\midinotes, val.linlin([ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ], [ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ]))}, 4).fix;*/
)



(
~tabble.set(\transpose, [0.5, 1.0, 2]);
~tabble.set(\midinotes, [50, 52, 42, 54]);
);

~tabble[10] = \filter -> {|in| FreeVerb.ar(in, mix: 0.5, room: 1)};


~jpverb.play;

(
// 50, 49, 47, (46), 45, 44, 42
var freq = 42.midicps, rel = 15, gain = 1.7;

~moog.release(5);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 1, amp: gain * 1]);
~moog2.release(5);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: gain * 0.5]);
~moog3.release(5);
~moog3 = Synth(\moogbass, [atk: 3, freq: freq * 4, cutoff: 900, chorus: 0.3, amp: gain * 0.3]);
~moog4.release(5);
~moog4 = Synth(\moogbass, [atk: 3, freq: freq / 2, cutoff: 900, chorus: 0.1, amp: gain * 0.3]);
~sinesaw.release(5);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: gain * 0.3]);
~sinesaw2.release(5);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: gain * 0.3]);
~sinesaw3.release(5);
~sinesaw3 = Synth(\sinesaw, [freq: freq * 4, amp: gain * 0.3]);
~sinesaw4.release(5);
~sinesaw4 = Synth(\sinesaw, [freq: freq / 2, amp: gain * 0.3]);
// Pbind(\instrument, \poom, \dur, Pn(1, 1), \atk, [3, 3, 3, 3], \rel, rel!4, \freq, freq * [1, 2, 4, 1/2], \amp, 0.2, \out, 0).play;
Pbind(\instrument, \pom, \dur, Pn(1, 1), \atk, [3, 3, 3, 3], \rel, rel!4, \freq, freq * [1, 2, 4, 1/2], \amp, gain * 0.2, \out, ~jpverb_bus).play;
)



(
~tabble.fadeTime = 10; ~tabble[15] = \filter -> {|in| LPF.ar(in, 2000)}; ~tabble[10] = nil;

~tabble[15] = \filter -> {|in| LPF.ar(in, 10000)};


~tabble.fadeTime=10;
~tabble[20] = \filter -> {|in| var snd; snd = CombC.ar(in, 0.2, 1/100, 1) * 1/2; snd = LPF.ar(snd, 7000)};

~tabble[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, 3)};
)



Synth(\pom, [freq: 250, atk: 3, rel: 7, amp: 2/3, pan: -0.7, out: ~jpverb_bus]);

// only run the routine when rolling through verse
(
Routine.run{
~tabble[20] = \filter -> {|in| var snd; snd = CombC.ar(in, 0.2, 1/100, 1) * 1; snd = LPF.ar(snd, 10000)};

	1.wait;

Synth(\pom, [freq: 250, atk: 3, rel: 7, amp: 2/5, pan: -0.7, out: ~jpverb_bus]);
}
)


Synth(\pom, [freq: 295, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);



(
~tabble.fadeTime=1;

Routine.run{
~tabble[20] = \filter -> {
		|in| var snd; snd = Resonator.ar(in, 92, structure: 0.5, brightness: 0.5, damping: 0.4);
		snd = BRF.ar(snd, 200, 3);
	};

1.wait;

Synth(\pom, [freq: 370, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);
}
)

Synth(\pom, [freq: 280, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);


Pbind(*[instrument: \pom, dur: 1/2, freq: Pseq([250, 210] * [[2, 4]], 3), atk: 3, rel: 5, amp: Pseq([1/4, 1/3]*2), out:~jpverb_bus]).play;

~wsamples.play;
~wsamples.stop;


(
~tabble.fadeTime = 30;
~tabble[15] = \filter -> {|in| LPF.ar(in, 2000)};
)


(
~tabble[20] = nil;
~tabble[10] = nil;
~tabble[15] = nil;

~tabble.set(\whitemul, 0);
Ndef(\pom).set(\feedback, 0.3);
)

~tabble.set(\tempo, 1);

Routine.run{~tabble.set(\tempo, 1); 5.wait; ~tabble.set(\tempo, 7); 5.wait; ~tabble.set(\tempo, 6); 4.wait; ~tabble.set(\tempo, 5); ~tabble.set(\tempo, 4); ~tabble.set(\tempo, 3); ~tabble.set(\tempo, 1)};



Routine.run{~tabble.stop(30); 30.wait;};

(
var fade = 30;
~moog.release(fade);
~moog2.release(fade);
~moog3.release(fade);
~moog4.release(fade);
~moog5.release(fade);
~sinesaw.release(fade);
~sinesaw2.release(fade);
~sinesaw3.release(fade);
~sinesaw4.release(fade);
~sinesaw5.release(fade);
)



// Maybe ?


Ndef(\stk).vol = 0.7;
Ndef(\stk)[10] = \xset -> Pbind(\dur, Pxrand([3, 7, 8], inf), \midinote, Pxrand([50, 52, 54, 49, 45], inf) + Pxrand([0, 12, 24], inf));
Ndef(\stk).stop(0);



----
-----------------



u.play(fadeTime:10);
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


-----




(
~filaments.release(1);
Ndef(\u).stop(10);
~arp.stop;
~arp2.stop;
~kickarp.stop;

~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf), amp: 1.3, rel: Pseg([10, 5, 10], [10, 10], 'lin', inf)]).play;

~arp2 = Pbind(*[instrument: \psine, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf), amp: (1/5)]).play;

~kickarp = Pbind(*[instrument: "kick", dur: Pseq((5!2)++(0.3!5)++(4.5)++(0.03!17)++(0), 3), freq: 50, amp: 1, rel: Pkey(\dur)/10]).play;
);

(
~filaments.release(1);
Ndef(\u).stop(10);
~arp.stop;
~arp2.stop;
~kickarp.stop;
)

~one.stop;
~two.stop;



-------


-----

// CRACK

(
~crack_amp = 0.1;
MIDIdef.cc(\crack_amp, {|val| ~crack_amp = val.linexp(0, 127, 0.01, 0.5) }, 12).fix;

~varispeed = 1;
MIDIdef.cc(\varispeed, {|val| ~varispeed = val.linlin(0, 127, 50, 1) }, 13).fix;

~crack.stop;
~crack = Pbindef(\crack,
	\instrument, \percsinefb,
	\freq, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf)
	// *Pfunc({~transposecrack})
	,
	\dur, PSinOsc(0.28, 0, 0.1, 0.1)/4 * Pfunc({~varispeed}) * Pwhite(0.7, 1.50),
	\atk, 0,
	\rel, 0.01,
	// \rel, Pkey(\dur),
	\amp, Pfunc({~crack_amp}),
	// \amp, 0.04,
	\feedback, Pseries(0, 0.12, inf),
	// \feedback, 0,
	\pan, Pxrand([1, 2, 3, 4], inf)
);

~crack.play;
)


----

(
~map1.release(10);
~map1 = {
	var snd, lfsaw;
	lfsaw = LFSaw.kr(\lfreq.kr(1), 0, \lamp.kr(1));
	snd = SinOscFB.ar(\freq.kr(100) + lfsaw, 0.5, \sinamp.kr(0));
	snd = snd * LFGauss.kr(\lfgauss.kr(2), \lfwidth.kr(1.5));
	snd = PanAz.ar(~numChannels, snd, lfsaw.range(0, 3));
}.play;

MIDIdef.cc(\65, {|val| ~map1.set(\sinamp, val.linlin(0, 127, 0, 0.7))}, 12, 0).fix;
MIDIdef.cc(\64, {|val| ~map1.set(\freq, val.linexp(0, 127, 20, 200))}, 13, 0).fix;
MIDIdef.cc(\66, {|val| ~map1.set(\lfreq, val.linexp(0, 127, 0.01, 30))}, 14, 0).fix;
MIDIdef.cc(\67, {|val| ~map1.set(\lamp, val.linlin(0, 127, 0, 1))}, 15, 0).fix;
// MIDIdef.cc(\68, {|val| ~map1.set(\lfgauss, val.linlin(0, 127, 1, 3))}, 12, 0);
// MIDIdef.cc(\69, {|val| ~map1.set(\lfwidth, val.linlin(0, 127, 0.01, 3))}, 13, 0);
)



------


(
~bounces = Ndef(\bounces, {
	var snd, rate, env, envlinen, buffer, t;
	t = Impulse.kr([1, 1.001, 0.999, 1.997]);
	buffer = \buffer.kr(w[3]);
	env = Env.perc(0.01, 0.1, 0.1).kr(0, gate: t);
	snd = PlayBuf.ar(2, buffer, BufRateScale.ir(\buffer.kr) * (\note.kr([0, 2, 7, 11]).midiratio), t, \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(0));
}).mold(4).fadeTime_(10).play;
)
(

~overlap = Routine.run({{

~bounces[10] = \filter-> {|in| Greyhole.ar(in, 0.5, \damp.kr(0.9), \size.kr(1.0), 0.707, \fb.kr(0.4))};

	rrand(5, 10).wait;

~bounces[20] = \filter-> {|in| Pan4.ar(in.sum)};

	rrand(5, 10).wait;

~bounces.xset(\buffer, (0..100).choose);

}.loop});




)
~bounces.xset(\buffer, w[3])

/with macos sound of dumping in trash = perfect


// check
(
p.play(fadeTime:20);
p[10] = \filter -> {|in| var snd; snd = Greyhole.ar(in, \delay.kr(0.5, 10), \damp.kr(0, 10)); Pan4.ar(snd.sum)}; p.set(\wet10, 0.5);
)

p[10] = nil;

(
MIDIdef.cc(\delay, {|val| p.set(\delay, val.linlin(0, 127, 0, 2))}, 0, 0);
MIDIdef.cc(\damp, {|val| p.set(\damp, val.linlin(0, 127, 0, 1))}, 1, 0);
MIDIdef.cc(\wet10, {|val| p.set(\wet10, val.linlin(0, 127, 0, 1))}, 2, 0);
);


g.play(fadeTime:3);

h.play(fadeTime:3);



(
~kharm.stop;
~kharmvolume = 0;
~kharmoct = 0;

MIDIdef.cc(\kharmvolume, {|val| ~kharmvolume = val.linlin(0, 127, 0, 1) }, 7).fix;
MIDIdef.cc(\kharmoct, {|val| ~kharmoct = val.linlin(0, 127, 0, 1) }, 15).fix;

~kharm = Pbindef(\kharm,\instrument, \mkick,  [\freq, \dur],
	// Pseq([[50, 7]], inf),
	Pseq([[50, 7], [57, 10], [75, 3]], inf),
	\rel, 10, \amp, Pfunc({~kharmvolume}), \hpf, 0,
	// \oct, Pfunc({~kharmoct})
	// \disto, 0.2, \disto2, 0.9

);

~kharm.play;
)