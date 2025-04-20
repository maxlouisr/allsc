
MIDIClient.init;


(
~midiOut1 = MIDIOut.newByName("IAC Driver", "IAC Bus 1"); // substitute your own device here
~midiOut2 = MIDIOut.newByName("IAC Driver", "IAC Bus 2"); // substitute your own device here
~midiOut3 = MIDIOut.newByName("IAC Driver", "IAC Bus 3"); // substitute your own device here
~midiOut4 = MIDIOut.newByName("IAC Driver", "IAC Bus 4"); // substitute your own device her
~midiOut5 = MIDIOut.newByName("IAC Driver", "IAC Bus 5"); // substitute your own device here
~midiOut6 = MIDIOut.newByName("IAC Driver", "IAC Bus 6"); // substitute your own device here
~midiOut7 = MIDIOut.newByName("IAC Driver", "IAC Bus 7"); // substitute your own device here
);


~dirt.soundLibrary.addMIDI(\midi1, ~midiOut1);
~dirt.soundLibrary.addMIDI(\midi_drums, ~midiOut2);

(
~dirt.soundLibrary.addMIDI(\hard1, ~midiOut1);
~dirt.soundLibrary.addMIDI(\hard2, ~midiOut2);
~dirt.soundLibrary.addMIDI(\hard3, ~midiOut3);a
~dirt.soundLibrary.addMIDI(\hard4, ~midiOut4);
~dirt.soundLibrary.addMIDI(\hard5, ~midiOut5);
~dirt.soundLibrary.addMIDI(\hard6, ~midiOut6);
~dirt.soundLibrary.addMIDI(\hard7, ~midiOut7);
)

~midiOut.latency = 0.01;



// custom synth defsxz



// SYNTHS
(
SynthDef("kick1", {arg out, amp = 0.3, freq = 50, gliss = 0.9, atk = 0.01, rel = 0.45, pan;
		var env, snd, ramp;
		env = Env.perc(atk, rel, amp).kr(doneAction: 2);
		ramp = XLine.kr(
			start: freq,
			end: freq * gliss,
			dur: rel
		);
		snd = SinOsc.ar(freq: ramp);
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
	}).add;

)

(
SynthDef(\mop, {arg out, pan, brass = 1, rel = 1;
	var lfsaw = LFSaw.kr(0.1).range(0.001,0.2);
	var freq = \freq.kr(100);
	var snd = SinOscFB.ar(freq, \feedback.kr(1.1)) + CombC.ar(WhiteNoise.ar(brass / 10), 0.2, 1/freq, SinOsc.kr(3).range(0.1, 10) + 1);
	var env = Env.perc(\att.kr(0.01), rel, \amp.kr(1.0), \curve.kr(-4)).kr(2, gate: 1, timeScale: \dur.kr(1));

	// snd = snd * env;


	snd = LPG.ar(
		input: snd,
		controlinput: env,
		controloffset: lfsaw,
		controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
		vca: LFNoise2.kr(1).unipolar + 0.001,
		resonance:1.1,
		lowpassmode:1,
		linearity:1
	) * 0.25;

	// snd = BRF.ar(snd, LFNoise2.kr(10).range(20, 1000), 10);
	// snd = BPeakEQ.ar(snd, 200, 1, -6);
	// snd = Pan2.ar(snd, \pan.kr(0)) * 0.4;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;
)


SynthDef("moogbass", {
		arg out, pan, freq = 440, amp = 1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, atk = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

		var osc, filter, env, filterenv, snd, chorusfx, envperc, envasr;

		osc = Mix(VarSaw.ar(
			freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
			iphase: Rand(0.0,1.0) ! 3,
			width: Rand(0.5,0.75) ! 3,
			mul: 0.5));

		filterenv = EnvGen.ar(
			envelope: Env.asr(0.2, 1, 0.2),
			gate: gate);

		filter =  MoogFF.ar(
			in: osc,
			freq: cutoff * (1.0 + (0.5 * filterenv)),
			gain: gain);

		envasr = EnvGen.ar(
			envelope: Env.adsr(atk, dec, sus, rel, amp * 0.1),
			gate: gate,
			doneAction: 2);

		// envperc = Env.perc(atk, rel, amp * 0.1).ar(2, gate);

		snd = (0.7 * filter + (0.3 * filter.distort)) * envasr;

		chorusfx = Mix.fill(7, {

			var maxdelaytime = rrand(0.005, 0.02);
			DelayC.ar(
				in: snd,
				maxdelaytime: maxdelaytime,
				delaytime: LFNoise1.kr(
					freq: Rand(5, 10),
					mul: 0.25 * maxdelaytime,
					add: 0.75 * maxdelaytime)
			)
		});

		snd = snd + (chorusfx * chorus);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));

	}).add;


SynthDef(\percsine, {arg out, pan, legato, fat = 100, curve = 'lin', sawmul = 0.001;
	var sig, sine, saw, env, freq;
	// gate = KeyState.kr(5, 0, 1);
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	// sawmul = VarLag.kr(\sawmul.kr(0.001), \gliss2.kr(0));
	env = Env.perc(0.01, 1.0).kr(2);
	sig = SinOsc.ar({freq * rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
	sig = Splay.ar(sig * fat).tanh;
	sig = OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;

SynthDef("pluk", {arg out, pan, amp = 0.1, freq = 440, decay = 5, dampen = 0.1;
	var env, snd;
	// env = Env.linen(0, decay, 0).kr(doneAction: 2);
	snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
		coef: dampen);
	OffsetOut.ar(out, DirtPan.ar([snd, snd], ~dirt.numChannels, pan));
}).add;

// FXs


(
SynthDef("sevenSaw", {arg out, pan, gate=1, freq = 32.1, att=0, sus=0.7, rel=2;
	var snd, env;
	env = Env.adsr(att, 0.4, sus, rel);
	snd = Splay.ar(BPF.ar(Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1));
	OffsetOut.ar(out, DirtPan.ar(snd * env.kr(doneAction: 2, gate: gate), ~dirt.numChannels, pan));
}).add;

SynthDef("sines", {arg out, pan, hi = 20000, lo = 20, rate = 0.0, freq = 100;
	var snd, array;
	snd = Splay.ar({SinOsc.ar(freq + exprand(20, 20000) * LFNoise2.kr(rate), mul:0.1)}!100);
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels));
}).add;
)

(
SynthDef("10sines", {arg out, gate = 1, lo = 20, hi = 20000, pan = 0, attack = 0.01, amp = 0.1, release = 1;
	var snd, array, env;
	env = Env.asr(attack, amp, release).kr(2, gate);
	array = {exprand(20,20000)}!100;
	snd = Splay.ar(SinOsc.ar(array, mul:0.1));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan) * env);
}).add;
)

x = Synth("10sines")
x.release;

(
SynthDef("sines2", {arg out, hi = 20000, lo = 20, rate = 0.0, pan = 0;
	var snd, env;
	env = EnvGen.kr(Env.perc(attack, release), doneAction: 2);
	snd = Splay.ar({SinOsc.ar(exprand(20, 2000) * LFNoise2.kr(rate), mul:0.1)}!100);
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
}).add;
)

(
SynthDef(\pingz, { |out,pan,freq=440,attack=0.00001,release=1|
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var signal = Resonz.ar(env, freq, 0.99);
	OffsetOut.ar(out, DirtPan.ar(signal * 2 , ~dirt.numChannels, pan));
}).add;
)

(
SynthDef(\pulsa, { arg out, pan, freq=220, att=0.1, rel=1;
  var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
  var signal = Pulse.ar(freq, SinOsc.kr(3000/freq));
  signal = (LocalIn.ar(1).distort) + (Delay1.ar(signal));
  signal = MoogLadder.ar(signal, freq*2.7, 0);
	LocalOut.ar(signal);
	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan) * env);
}).add;
)


(
SynthDef(\mbm, { |out=0, freq=440, pan=0, attack=0.01, release=0.4|
  var env = EnvGen.ar(Env.perc(attack, release * LFTri.kr(2).range(0.5, 1.5)));
  var carrier = SinOsc.ar(freq*16);
  var signal = SinOsc.ar(freq);
  var sig = signal * carrier;

  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
)

Synth(\mbm, [freq: 50])

(
SynthDef(\abbass, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var env = Env.asr;
  var volume = IEnvGen.ar(env, line);
  var sig;

  freq = max(0, freq * speed * (1 + (accelerate * line)));
	sig = Saw.ar(freq*2) * 0.5 +
	  Pulse.ar(freq/2) * 0.5 +
	  SinOsc.ar(freq/4) * 0.5;

	// sig = Pulse.ar([freq * 0.98, freq], mul:0.5) +
	// PinkNoise.ar(LFNoise0.ar(2).range(0, 1.0)) +
	// Saw.ar([freq, freq * 1.025], mul:2);
  /*sig = MoogVCF.ar(sig.clip2(0.5), LFCub.kr(
		freq:LFPulse.kr(0.25, 0, width: 0.25).range(1, 6) ).exprange(40, 8500),
	res: 0.4, mul: 2);*/

  Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
}).add;
)


Synth(\abbass, [freq: 120]);

(
SynthDef(\blow, { |out, decay=0, sustain=0.03, freq, pan, accelerate, voice = 0.5, semitone=12, resonance=0.3, lfo=1, pitch1=1, width = 0.3|
	var imp = LFNoise1.kr(80);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var lfof1 = min(basefreq*10*pitch1, 22000);
	var lfof2 = min(lfof1 * (lfo + 1), 22000);
	var sig = LPF.ar(
		SinOsc.ar(
			LFNoise1.kr(3).range(2,4) * basefreq / 2.sqrt
		),
		LFNoise2.kr(40).range(lfof1, lfof2), resonance
	);
	var env = LFGauss.ar(sustain, width, loop: 0).range(0, 1);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;
)

(
SynthDef(\plaits, {|out, sustain=1, pan, accelerate, freq = 100, harm=0.5, timbre=0.5, morph=0.5, engine=2|
    var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	var sound = MiPlaits.ar(pitch: freq.cpsmidi, engine: engine, harm: harm/* * LFNoise2.kr(1, 0.5, 0.5)*/, timbre: timbre /** LFNoise2.kr(1, 0.5, 0.5)*/, morph: morph);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;
)

Synth(\plaits, [engine: 2, morph: 1, harm: 0.1, amp: 0.1])



// physical models based on the synthesis toolkit: the synthesis toolkit: https://ccrma.stanford.edu/software/stk/index.html

(
SynthDef(\plock,{arg out, freq = 5 ,gate=1,amp=2, atk = 0, rel = 10, reedstiffness = 30, reedaperture = 1, noisegain = 0, blowposition = 10, vibfreq=50, vibgain=1, loudness=110, pan = 0, detune = 0.01;
    var sig,env;
	env = EnvGen.kr(Env.perc(atk, rel, 1),gate,doneAction:2);
    sig = StkInst.ar(
		Stk.at("Saxofony"),
		freq + LFNoise2.kr(0.1, detune),
		gate,
		amp,
		0.5,
		[
			2,reedstiffness,
			26, reedaperture,
			4,noisegain,
			11,blowposition,
			29, vibfreq,
			1,vibgain,
			128,loudness

	]);
	// Normalizer.ar(sig, 1);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
)

Synth(\plock, [freq: 50, atk: 3, rel: 3, reedstiffness: 70, amp: 1.2])

(
SynthDef(\percsine, {arg pan = 0, out = 0, atk = 0.01, rel = 1, level = 0.5, curve = -3, amp = 1;
	var sig, env, freq;
	freq = VarLag.kr(\freq.kr(200), \gliss.kr(0));
	env = Env.perc(atk, rel, level, curve).kr(2);
	sig = SinOsc.ar(freq, 0, 0.1);
	sig = sig * env * amp;
	sig = PanAz.ar(2, sig, \pan.kr(0) + 1.5);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
)

(
SynthDef(\Saxofony,{arg out, freq = 100, gate=1,amp=0.5, reedstiffness = 80, reedaperture = 50, noisegain = 1, blowposition = 10, vibfreq=50, vibgain=1, loudness=128, pan;
    var sig,env;
	// env = EnvGen.kr(Env.perc(atk, release, 1),gate,doneAction:2);
    sig = StkInst.ar(
		Stk.at("Saxofony"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,reedstiffness,
			26, reedaperture,
			4,noisegain,
			11,blowposition,
			29, vibfreq,
			1,vibgain,
			128,loudness

	]);
	sig = Pan2.ar(sig, pan);
    OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
)



x = Synth(\Saxofony, [freq: 50])
x.release(30);

(
SynthDef(\whiteperc, {
		var snd, env = Env.perc(\att.kr(0.1), \rel.kr(0.1), \amp.kr(1.0), \curve.kr('sine')).kr(2);
		snd = WhiteNoise.ar(env);
	Out.ar(\out.kr(0),DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
	}).add;
)




// adding effects
SuperDirt.start;







/*~dirt.addModule('pitchshift', { |dirtEvent|
	dirtEvent.sendSynth('pitchshift' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			pitch: ~pitch,
			out: ~out
		]

	)}, { ~pitch.notNil });


SynthDef("pitchshift" ++ ~dirt.numChannels, {
	| out, pitch = 1, freq|
		var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = PitchShiftPA.ar(dry, freq, pitch, pitch, 10, 20, 2);
		ReplaceOut.ar(out, wet);
	}).add;*/

// without formants