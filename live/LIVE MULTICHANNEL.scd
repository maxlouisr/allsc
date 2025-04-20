
"/Users/maxlouisraugel/Documents/sc/instruments/MULTICHANNEL INST.scd".load;

// PanAz Behaviour?
{var snd; snd = SinOsc.ar([100, 200], 0, Env.perc().kr(2)); snd = PanAz.ar(~numChannels, snd, \pan.kr(4).linlin(0, ~numChannels, 0, 2), 1, 2.0, 0)}.scope;

// SplayAz Behaviour?

(
{var snd; snd = SinOsc.ar([100, 1], 0, Env.perc().kr(2));
	snd = SplayAz.ar(~numChannels, snd, 1, 1, width: 2.0)
}.scope;
)


--------------

~drone1.set(\dmod, 0.1)


(
~drone1.play(fadeTime: 0);

MIDIdef.cc(\dronemod, {|val| ~drone1.set(\dmod, val.linexp(0, 127, 0.01, 1).lag(0.7))}, 1).fix;
MIDIdef.cc(\droneamp, {|val| ~drone1.set(\amp, val.linexp(0, 127, 0.00001, 0.3).lag(0.8))}, 2).fix;
MIDIdef.cc(\dronelpf, {|val| ~drone1.set(\lpf, val.linexp(0, 127, 20, 20000).lag(0.8))}, 3).fix;
);


~blimp.vol_(1).play(fadeTime: 10); ~blimp.set(\density, 0.1);

~vpoints.vol_(1.2).play(fadeTime: 10); ~vpoints.set(\density, 0.5);

~swooshes.vol(1).play(fadeTime: 30);


// CHORDS

(

~jpverb.play;

~chords = Pbindef(\chords, \instrument, \pom, \dur, 12, \atk, 7, \rel, 9, \freq, Pseq([[43.35, 38, 47], [40, /*43.35, */50, 54] ], inf).midicps, \hpf, 150, \amp, 2, \thin, -6, \out, ~jpverb_bus).play;

)

~chords.stop;

// VPOINTS

~swooshes.play(fadeTime: 30)

Synth(\pom, [atk: 3, rel: 12, freq: (69-12).midicps, amp: 0.8, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 12, freq: (71-12).midicps, amp: 0.7, out: ~jpverb_bus]);

Synth(\k, [freq: 50, amp: 1 , rel: 7, distortion: 2]);

Synth(\pom, [atk: 3, rel: 15, freq: (74-12).midicps, amp: 0.8, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (73-12).midicps, amp: 0.7, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (69-12).midicps, amp: 0.8, thin: -20, out: ~jpverb_bus]);
Synth(\pom, [atk: 3, rel: 15, freq: (71-12).midicps, amp: 0.8, thin: -20, out: ~jpverb_bus]);

Synth(\pom, [atk: 3, rel: 15, freq: (66-12).midicps, amp: 0.8, thin: -20, out: ~jpverb_bus]);


Ndef(\neoformant).play(fadeTime: 30); Ndef(\neoformant).vol_(1.1)

Ndef(\neoformant).stop(30);

Synth(\percsine, [freq: 1980, pan: -0.5, atk: 0.1, rel: 0.1, amp: 0.2]);


(
~blimp.release(10);
Ndef(\neoformant).stop(50);
~swooshes.stop(30);
// ~drone1.clear(50);
~intro1.stop(30);
~intro2.stop(30);
)


------------------


// BASS
(
~chords.stop;
Synth(\poom, [atk: 15, rel: 15, freq: 50, amp: 1.3, curve: 'sine']);
)

// 150, 665, then 200, 250, 300, 500, 570, 600, 740

var freq = 500; Synth(\ixxbass, [env: Env([0, 1.7, 0], [15, 17]), freq: freq, lpfreq: freq, out: rrand(0, ~numChannels -1)]);

var freq = 740; Synth(\percsinefb, [freq: freq, atk: 20, rel: 30, amp: 0.03, feedback: 1/2, out: rrand(0, ~numChannels -1)]);


~jpverb.play; Synth(\fml, [\freqA, 50, \freqB, ([250, 300, 600, 500]/2).choose, \time, 10, \pan, rrand(-1, 1.0), \amp, 0.2, \atk, 0.1, \rel, 10, \out, ~jpverb_bus]);

Synth(\fml, [\freqA,([250, 300, 600, 500]/2).choose, \freqB, 20 , \time, 10, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.3, \rel, 10, \out, ~jpverb_bus]);

// {d[\thanks][6].play; 2.wait; d[\thanks][9].play;}.fork


(
~lines_ripples.stop;
~lines_ripples = Routine.run({{
	var freq = [100, 150, 300, 600].choose, pan = rrand(0, ~numChannels);

	Ndef(\sine).set(\freq, freq, \pan, pan).mold(~numChannels).play(fadeTime: 3);
	15.rand.wait;
	Synth(\percsine, [freq: freq * rrand(0.980, 1.02), atk: 0.1, rel: 5, amp: 0.1, pan: pan]);
	6.wait;
	Ndef(\sine).stop(7);
	15.wait;
}.loop;
})
)



~whiteshaker.play(fadeTime: 30);

~whiteshaker.stop(30);

~vpoints.stop(30);

------------


~wsamples.play;
~wsamples.stop;

(

~cuves.stop(0);

~cuves.play(fadeTime:0);

// ~bells.play(fadeTime: 20);

)

~cuves.stop;


(

~one_amp = 0.1;
~two_amp = 0.5;

MIDIdef.cc(\one_amp, {|val| ~one_amp = val.linexp(0, 127, 0.0001, 0.2) }, 1).fix;
MIDIdef.cc(\two_amp, {|val| ~two_amp = val.linexp(0, 127, 0.0001, 8) }, 1).fix;

~one.stop;
~one = Pbind(\instrument, \percsinefb_mono, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf)
	// * Pxrand([1, 2, 4], inf)
	, atk: 20, rel: 30,
	// amp: Pfunc({~one_amp}),
	amp: 0.1,
	feedback: 1/2, dur: 5,
	// out: Pxrand((0..1), inf)
	out: Pxrand((0..(~numChannels - 1)), inf)
]).play;

~two.stop;
~two = Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf)
	// * Pxrand([1, 2, 4], inf)
	, atk: 20, rel: 30,
	// amp: Pfunc({~two_amp}),
	amp: 0.5,
	dur: 10,
	// out: Pxrand((0..1), inf)
	out: Pxrand((0..(~numChannels - 1)), inf)
]).play;
)

~lines_ripples.stop; Ndef(\sine).stop(10);

~drone1.clear(50);

-----


Ndef(\x).clear;

(

x = Ndef(\x, {var snd, mc, lfo;

	mc = 10;

	lfo = LFNoise2.kr(\mod.kr(0.3)).range(0, 3.0);
	// lfo = LFNoise2.kr(\mod.kr(0.3));
	snd = SinOscFB.ar(([200, 220, 500, 380]*[[0.5, 1, 2]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(1.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar({exprand(20, 9000)}!mc, lfo.range(0, \fb.kr(0.0)), {LFNoise2.kr(3, 0.05, 0.1)}!mc);
	snd = HPF.ar(snd, 100);

	// snd = SplayAz.ar(8, snd, 1, 1, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0);
	snd = SplayAz.ar(~numChannels * 2, snd, 1, 1, 2, lfo.range(0, ~numChannels / 2)) * 0.3 * \amp.kr(0);
	// snd = SplayAz.ar(~numChannels, snd, 1, 1, 2, lfo.range(0, ~numChannels - 1)) * 0.3 * \amp.kr(0);


	snd = snd.blend(JPverb.ar(snd, 6, 0, 1.0, modFreq: 0.3), \jpverb.kr(0).range(0.3, 1));

}).fadeTime_(3).mold(~numChannels);

Ndef(\x).play;

MIDIdef.cc(\xamp, {|val| Ndef(\x).set(\amp, val.linexp(0, 127, 0.01, 50))}, 12, 0).fix;
// MIDIdef.cc(\xmod, {|val| Ndef(\x).set(\xmod, val.linlin(0, 127, 0.01, 0.5))}, 13, 0).fix;
// Ndef(\x).set(\mod, 0.3);
MIDIdef.cc(\xfb, {|val| Ndef(\x).set(\fb, val.linlin(0, 127, 0, 1.5))}, 13, 0).fix;
MIDIdef.cc(\xverb, {|val| Ndef(\x).set(\jpverb, val.linexp(0, 127, 0.01, 0.5))}, 13, 0).fix;

);


(
~wpyramid.play;
~washes.play(fadeTime:30);
)



~sub.play(fadeTime:10);
~sub.stop(30);


(
~p1.stop; ~p2.stop;

~p1 = Pdef(\sinesaw_mono, Pbind(\instrument, \sinesaw, \dur, 7, \freq, Pxrand([200, 220, 500, 380], inf), \amp, 0.5, \out, Pxrand((0..(~numChannels-1)), inf))).play;
~p2 = Pbind(*[\instrument, \percsine_mono, dur: Pwhite(1, 3), freq: Pxrand([200, 220, 500, 380], inf), \amp, 0.2, \out, Pxrand((0..(~numChannels-1)), inf)]).play;

);

(
~washes.stop(30);
~wpyramid.stop;
)

(
Pbindef(\glisses, \instrument, \fmlmulti,
	\freqA, exprand(2000, 100), \freqB, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf),
	\dur, Pxrand([13, 7, 18], inf),
	\time, Pxrand([0.1, 0.1, 0.2, 0.1, 0.5, 1.0], inf),
	\amp, 0.2,
	\atk, Pwhite(0.01, 1), \rel, Pwhite(5, 10),
	\pan, Pwhite(0, ~numChannels));

Pbindef(\glisses).play;
)

Pbindef(\glisses).stop;


(instrument: \epyramid, ampe: Env([0, 0.5, 0], [rrand(3, 30), rrand(3, 30)]), freqe: Env([exprand(300, 3000), exprand(300, 3000)], 6), x: Env([-1, 1], rrand(3, 30)), y: Env([-1, 1], rrand(3, 30))).play;


(
~lines_ripples.stop; Ndef(\sine).stop(10);
~p1.stop; ~p2.stop;
~washes.stop(30);
~one.stop;
~two.stop;
Pbindef(\glisses).stop;
~cuves.stop;
~kharm.stop;
Ndef(\x).stop(50);
~map1.release(30);
~wpyramid.stop;
~sub.stop;
)


(
~sub.stop(30);
a.play(fadeTime:0);

MIDIdef.cc(\air_amp, {|val| a.set(\amp, val.linlin(0, 127, 0, 1))}, 10).fix;
// MIDIdef.cc(\avion, {|val| a.set(\avion, val.linlin(0, 127, 0.01, 1))}, 9).fix;
a.set(\avion, 0.3);
MIDIdef.cc(\height, {|val| a.set(\height, val.linlin(0, 127, 0.01, 2))}, 11).fix;
)


a.stop(30)
~cuves.stop

Synth(\percsine);

(
MIDIdef.cc(\rrramp, {|val| ~rrr.set(\amp, val.linlin(0, 127, 0, 2)) }, 4).fix;
MIDIdef.cc(\rrrdens, {|val| ~rrr.set(\density, val.linlin(0, 127, 1, 30)) }, 5).fix;
~rrr.play(fadeTime:0);
)

~rrr.stop(30);



a.stop(60);





------


// Multichannel phase

(
Ndef(\bleep1, {var snd, lfo1, lfo2;
	lfo1 = LFNoise2.kr(0.3).range(1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(200, 400).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0, 1, 2.0);
}).mold(~numChannels).play;

Ndef(\bleep2, {var snd, lfo1, lfo2;
	lfo1 = LFNoise2.kr(0.3).range(1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(500, 1000).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0.75, 1, 2.0);
}).mold(~numChannels).play;

Ndef(\bleep3, {var snd, lfo1, lfo2;
	lfo1 = LFNoise2.kr(0.3).range(1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(400, 750).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 1.25, 1, 2.0);
}).mold(~numChannels).play;
)



(
Ndef(\bleep1, {var snd, lfo1, lfo2, trig;
	trig = Dust.kr(10);
	lfo1 = LFNoise2.kr(0.3).range(0.1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(200 * lfo1 * Env([0.5, 2 * lfo1], lfo2/10, 'lin').kr(gate: trig), 400* lfo2).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0, 1, 2.0);
}).mold(~numChannels).play;

Ndef(\bleep2, {var snd, lfo1, lfo2, trig;
		trig = Dust.kr(10);
	lfo1 = LFNoise2.kr(0.3).range(0.1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(500 * lfo1, 1000 * lfo2 * Env([0.5, 1 * lfo1], lfo2/10, 'lin').kr(gate: trig)).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0.75, 1, 2.0);
}).mold(~numChannels).play;

Ndef(\bleep3, {var snd, lfo1, lfo2, trig;
	trig = Dust.kr(10);
	lfo1 = LFNoise2.kr(0.3).range(0.1, 3);
	lfo2 = LFNoise2.kr(0.3).range(1, 3);
	snd = SinOsc.ar(freq: LFPulse.kr([lfo1, lfo2]).range(400 * lfo1 * Env([0.5, 4 * lfo1], lfo2/10, 'lin').kr(gate: trig), 750 * lfo2).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 1.25, 1, 2.0);
}).mold(~numChannels).play;
)

Ndef(\bleep1).stop;Ndef(\bleep2).stop;Ndef(\bleep3).stop;


(
Ndef(\bleep1, {var snd;
	snd = SinOsc.ar(freq: LFPulse.kr([11, 13]).range(200, 400).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0, 1, ~numChannels);
}).mold(~numChannels).fadeTime_(20).play(fadeTime:20);

Ndef(\bleep2, {var snd;
	snd = SinOsc.ar(freq: LFPulse.kr([17, 19]).range(500, 1000).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0, 1, ~numChannels);
}).mold(~numChannels).fadeTime_(20).play(fadeTime:20);

Ndef(\bleep3, {var snd;
	snd = SinOsc.ar(freq: LFPulse.kr([7, 11]).range(400, 750).lag(0.01), mul:0.1);
	snd = PanAz.ar(~numChannels, snd, 0, 1, ~numChannels);
}).mold(~numChannels).fadeTime_(20).play(fadeTime:20);
)


(

~drone1 = Ndef(\drone1, {

	var snd, lfo, freq;
	freq = \freq.kr(#[70, 200], 0);
	lfo = LFNoise2.kr(1);
	snd = VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 0.1, [ 50, 59 ].midicps);
	snd = Splay.ar(snd);
	snd = JPverb.ar(snd, 1, 0, modDepth: lfo.range(0.3, 1.2), modFreq: lfo.abs / 2 + 0.7);
	snd = BPeakEQ.ar(snd, 100, 1, -10);
	snd = HPF.ar(snd, 200);
	snd = RLPF.ar(snd, 400, \lpq.kr(0.5, 0.3));
	snd = Pan2.ar(snd, 0, 0.8);

	snd = snd * MouseX.kr(0, 10);

	// snd = Limiter.ar(snd, 1, 0.05);

}).play;

);


// MAUG + Ndef(\x) + Avion + whiteshaker a bit + a few notes from chords to introduce --- going backwards