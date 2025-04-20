// Server.killAll
// Ndef.clear;

MasterEQ.new

s.volume.gui;

(
"/Users/maxlouisraugel/Documents/sc/instruments/FX.scd".load;
"/Users/maxlouisraugel/Documents/sc/instruments/synthdefs.scd".load;
"/Users/maxlouisraugel/Documents/sc/instruments/ndefs.scd".load;
);

Synth(\percsine, [freq: 200, pan: 1]);

x.release(10);
x = {SinOsc.ar([MouseY.kr(200, 2000, 1), MouseY.kr(2000, 200, 1)], 0, 0.1)}.play;

----------------------------------------

(
~drone1.play(fadeTime: 0);

MIDIdef.cc(\droneamp, {|val| ~drone1.set(\amp, val.linexp(0, 127, 0.00001, 0.45).lag(0.3))}, 2).fix;
MIDIdef.cc(\dronelpf, {|val| ~drone1.set(\lpf, val.linexp(0, 127, 20, 20000).lag(0.3))}, 3).fix;
);

~drone1.stop;

~blimp.vol_(1.9).play(fadeTime: 10); ~blimp.set(\density, 0.1);

~vpoints.vol_(2).play(fadeTime:10);
~vpoints.clear;

// CHORDS

(
~jpverb.play;
~chords = Pbindef(\chords, \instrument, \pom, \dur, 12, \atk, 7, \rel, 9, \freq, Pseq([[43.35, 38, 47], [40, /*43.35, */50, 54] ], inf).midicps, \hpf, 150, \amp, 1, \thin, -6, \out, ~jpverb_bus).play;
)

~chords.stop;


// VPOINTS


~wsamples.play;
~wsamples.stop;

~swooshes.play(fadeTime: 30)

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

Ndef(\neoformant).stop(10);

Synth(\percsine, [freq: 1980, pan: -0.5, atk: 0.1, rel: 0.1, amp: 0.2]);

{WhiteNoise.ar(0.1)!2}.play;


(
~blimp.release(10);
Ndef(\neoformant).stop(50);
~swooshes.stop(30);
~drone1.clear(50);
~intro1.stop(30);
~intro2.stop(30);
)

~chords.stop;

------------------

// BASS

Synth(\poom, [atk: 15, rel: 15, freq: 50, amp: 0.5, curve: 'sine']);


// 150, 665, then 200, 250, 300, 500, 570, 600, 740

var freq = 150; Synth(\ixxbass, [env: Env([0, 2, 0], [15, 17]), freq: freq, lpfreq: freq]);

var freq = 740; Synth(\percsinefb, [freq: freq, atk: 20, rel: 30, amp: 0.03, feedback: 1/2, pan: rrand(-1, 1)/2]);




~jpverb.play; Synth(\fml, [\freqA, 50, \freqB, ([250, 300, 600, 500]/2).choose, \time, 10, \pan, rrand(-1, 1.0), \amp, 0.2, \atk, 0.1, \rel, 10, \out, ~jpverb_bus]);

Synth(\fml, [\freqA,([250, 300, 600, 500]/2).choose, \freqB, 20 , \time, 10, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.3, \rel, 10, \out, ~jpverb_bus]);

{d[\thanks][6].play; 2.wait; d[\thanks][9].play;}.fork


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

(

~whiteshaker = Ndef(\whiteshaker, {|freq 10 mul 100|
	var snd, lfo, sine;

	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul).unipolar;
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo/2);
	snd = snd / (freq/100) / 5 * \amp.kr(1);
	// snd = Sanitize.ar(snd);

}).play;

)

~whiteshaker.play(fadeTime: 0);

~whiteshaker.stop(30);

~vpoints.stop(10);


// ---> TRANSDUCERS


--------

// seldom, foregone

Pbindef(\2, \instrument, \percsinefb, \dur, 0.1, \freq, Pxrand(([76, 74, 71, 69, 66, 64, 62, 59, 78, 81]!2).flatten, inf).midicps, \pan, Pwhite(-1, 1.0), \feedback, Pwhite(0, 1.5), \amp, Pseg([0.03, Pwhite(0, 0.04)], 30, 'lin', inf), \atk, 0, \rel, Pwhite(1, 3.0), \out, 0).play(quant:1);
Pbindef(\2).stop;

Pbindef(\p, \instrument, \poom, \atk, 1, \rel, 5, \dur, 8, \freq, Pseq([49, 41], inf), \amp, 0.6).play(quant:1);


~wsamples.play;
~wsamples.stop;


(
Pbindef(\2, \amp, Pwhite(0, Pstep((40..0)/1000, 1/2)));
Pbindef(\p).stop;
~whiteshaker.stop(30);

~lines_ripples.stop;
Ndef(\sine).stop(30);
)


---------

~wobl.vol_(1).play(fadeTime:0.1);
~wobl.stop;

~sweeps.reset; ~sweeps.play;
~sweeps.stop;


-------

(
~wsamples.stop;
~lsamples.play;
)


(
Ndef(\m).fadeTime = 5;
Ndef(\m, {
	var snd;
	snd = Splay.ar(
		{
			SinOsc.ar(
				// ([76, 74, 71, 69, 66, 64, 62, 59, 78, 81] * [[1, 0.5, 2]]).midicps.choose,
				exprand(20, 20000),
				mul: Line.kr(0, 0.03, 10)
				* {LFNoise2.ar(\waver.kr(0.5))}
		)}!30
		, 1);
	snd = LPF.ar(snd, 5000) * 10;
	// snd = snd.blend(\distort.kr(0) * LFNoise2.ar(200), \distort.kr(0));
	snd = snd.blend(snd * LFNoise2.ar(200, 1, 0), \distort.kr(0));
});
Ndef(\m).play;

MIDIdef.cc(\b, {|val| Ndef(\m).set(\distort, val.linlin(0, 127, 0, 1))}, 18);
)

Ndef(\m).stop(30);

Ndef(\m).stop(10)


Ndef(\m)[10] = \filter -> {|in| RLPF.ar(in, SinOsc.kr(LFNoise2.kr(0.3).abs/10).exprange(100, 10000), 0.5)};


(
~whiteshaker.release(10);
~microgaussian.release(30);
Ndef(\m).stop(50);
Ndef(\play).stop;
Ndef(\buzz).stop(0);
// d[\kicks][1].play;
Ndef(\u).fadeTime = 0;
Ndef(\u).play;
)


// REVERB
(
Ndef(\u).fadeTime = 30; Ndef(\u).xset(\minfreq, 200, \maxfreq, 20000); Ndef(\u)[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};
Ndef(\m).fadeTime = 30; Ndef(\m)[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};
)

(
Routine.run({
	d[\weirds][0].play;

	d[\weirds][0].duration.wait;

	1.wait;

	d[\weirds][2].play;

})
)

(
Ndef(\u).fadeTime=10;
Ndef(\u)[10] = \filter -> {|in| Splay.ar(JPverb.ar(in,
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
	highcut:1000)
)}
)
s.scope


~wsamples.play;

(
~one = Ndef(\t_one, Pbind(\instrument, \percsinefb, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf), atk: 20, rel: 30, amp: 0.07, feedback: 1/2, dur: 5, pan: Prand([-1, 1.0], inf)])).play(fadeTime:30);

~two = Ndef(\t_two, Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf), atk: 20, rel: 30, amp: 2, dur: 10, pan: Prand([-1, 1], inf)])).play(fadeTime:30);
)


(
Ndef(\m).clear(30);
Pbindef(\p).stop;
~filaments.stop(10);
~sweeps.stop;
~wobl.stop(10);
~swooshes.stop;
~lines_ripples.stop;
Ndef(\sine).stop(30);
~vpoints.stop;
~blimp.stop;
Ndef(\u).stop(30);
);


(
~one.stop(20);
~two.stop(20);
)


Pbindef.stop;
Ndef.stop(30);

(
~wsamples.stop;
~lsamples.stop;
);

Ndef(\wobl).stop;

// Routine.run({~seizedec.play; (60 * 3).wait; ~seizedec.stop(3)}

~rrr.play(fadeTime: 30);
~rrr.stop(60);

~whiteshuffle.play(30);
~whiteshuffle.stop(10);


~wsamples.play;
~wsamples.stop;

~lsamples.play;
~lsamples.stop;


---