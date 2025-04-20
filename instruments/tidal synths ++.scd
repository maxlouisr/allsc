(
SynthDef(\percsine, {arg out, pan;

	var snd, env;

	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 0.2, -3), timeScale: \sustain.kr, doneAction:2);
	snd = SinOsc.ar(\freq.kr(100));

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\sfenv, {arg out, pan, speed = 1, accelerate = 1;

	var snd, env, freq;

	freq = \freq.kr(440) * DirtFreqScale.kr(speed, accelerate, \sustain.kr(1.0));

	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 0.2, -3), timeScale: \sustain.kr, doneAction:2);
	snd = SinOsc.ar(freq * env * 5);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));

}).add;

SynthDef(\sglis, {arg out, pan, speed = 1, accelerate = 1;

	var snd, env, freq, glis;

	// freq = \freq.kr(440) * DirtFreqScale.kr(speed, accelerate, \sustain.kr(1.0));

	freq = \freq.kr(440);
	freq = freq * Line.kr(1, \glisf.kr(0.0).midiratio, \glist.kr(1.0));

	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 1, -3), timeScale: \sustain.kr, doneAction:2);

	snd = SinOsc.ar(freq * env);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));

}).add;



SynthDef(\saxofony,{arg out, freq = 100, gate=1, speed = 1, accelerate = 0, sustain = 1, amp=0.5, reedstiffness = 80, reedaperture = 50, noisegain = 1, blowposition = 10, vibfreq=50, rel = 5, vibgain=1, loudness=128, pan;
	var sig,env, pitch;
	pitch = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	// env = EnvGen.kr(Env.perc(0.01, rel, 1),gate,timeScale: sustain, doneAction:2);
	sig = StkInst.ar(
		Stk.at("Saxofony"),
		pitch,
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
	// took off Pan2.ar
	Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;

SynthDef("hypersaw1", {
	arg freq = 180, atk=0.01, sus=0.7, rel=4, out, pan;
	var snd, env;
	env = Env.linen(atk, sus, rel).kr(2);
	snd = Splay.ar(Saw.ar(freq + (0, 0.1..1)));
	// snd = Splay.ar(Saw.ar(freq + Array.geom(10, 0.1, 1.1)));
	snd = snd * env;
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env * 0.5));
}).add;

SynthDef(\synpi, {
	|rel 10 pan out|

	var delayTime, pitch, detune, strike, hammerEnv, hammer, snd, env;



	pitch = \freq.kr(1000).cpsmidi;

	snd = Mix.ar(Array.fill(3, { arg i;

		detune = #[-0.05, 0, 0.04].at(i);

		delayTime = 1 / (pitch + detune).midicps;

		hammer = LFNoise2.ar(\harm.kr(1).linlin(0, 1, 3000, 20000), Env.perc(0.008, 0.1).kr(0));

		CombC.ar(hammer,

			delayTime,

			delayTime,

			rel)

	}));

	snd = LPF.ar(snd, 19000);

	env = Env.linen(\atk.kr(0.01), \sus.kr(1.0), rel).kr(2);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env * 0.1));

}).add;


SynthDef(\combsaw, {|sustain = 1, combf = 100|
	var snd, env;
	env = EnvGen.ar(Env.perc(\att.kr(0.01), \rel.kr(1.0)), timeScale: sustain, doneAction: 2);
	snd = LFSaw.ar(\freq.kr(100));
	snd = CombC.ar(snd, 0.2, 1/combf, \res.kr(1));
	Out.ar(\out.kr, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;


SynthDef(\sfb, {
	var snd, env, freq;
	// freq = \freq.kr(100) * {Rand(0.98, 1.02)}!3;
	freq = \freq.kr(100);
	env = EnvGen.ar(Env.linen(0.01, 1, 0.01, 1, -3), timeScale: \sustain.kr, doneAction:2);
	snd = SinOscFB.ar(freq, \fb.kr(0.0));
	Out.ar(\out.kr, DirtPan.ar(Splay.ar(snd), ~dirt.numChannels, \pan.kr, env));
}).add;

SynthDef(\plaits, {|out, sustain=1, pan, accelerate, freq = 100, harm=0.5, timbre=0.5, morph=0.5, engine=2|
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	var sound = MiPlaits.ar(pitch: freq.cpsmidi, engine: engine, harm: harm/* * LFNoise2.kr(1, 0.5, 0.5)*/, timbre: timbre /** LFNoise2.kr(1, 0.5, 0.5)*/, morph: morph);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\stkbowed,{arg out=0,freq=220,rel =0.5,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
	var sig,env;
	env = EnvGen.kr(Env.asr(0.01,1,rel),gate,doneAction:2);
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

	]);
	Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, \pan.kr, env));
}).add;

SynthDef(\mop, {arg out, pan, brass = 1;
	var lfsaw = LFSaw.kr(0.1).range(0.001,0.2);
	var freq = \freq.kr(100);
	var snd = SinOscFB.ar(freq, \feedback.kr(1.1)) + CombC.ar(WhiteNoise.ar(brass / 10), 0.2, 1/freq, SinOsc.kr(3).range(0.1, 10) + 1);
	var env = Env.perc(\att.kr(0.01), \rel.kr(1), \amp.kr(1.0), \curve.kr(-4)).kr(2, gate: 1, timeScale: \dur.kr(1));

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
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;


SynthDef(\fakebrass, {arg out, pan;
	var dur = \dur.kr(1);
	var lfsaw = LFSaw.kr(0.1).range(0.001,0.2);
	var fwobble = \fwobble.kr(0);
	// var fscat = \fscat.kr(0); var freqscatter = LFNoise0.kr(fscat * 20, fscat, 1);
	var freq = \freq.kr(100) * LFNoise2.kr(fwobble * 20, fwobble.linexp(0, 1, 0.0001, 0.5), 1);
	var brass = \brass.kr(1, dur);
	var env = Env.perc(\attack.kr(0.01), \release.kr(1), 1.0, \curve.kr(-4)).kr(2, gate: 1, timeScale: \dur.kr(1));
	var comb = CombC.ar(WhiteNoise.ar(brass * 0.05), 0.2, 1/freq, SinOsc.kr(3).range(0.1, 10) + 1, env);
	var snd = SinOscFB.ar(freq, \fb.kr(1.1, dur)) + comb;

	// snd = snd * env;


	snd = LPG.ar(
		input: snd,
		controlinput: env,
		controloffset: lfsaw,
		controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
		vca: LFNoise2.kr(1).unipolar + 0.001,
		resonance: \resonance.kr(1.1),
		lowpassmode:1,
		linearity:1
	) * 0.25;

	// snd = RLPF.ar(snd, env.linexp(0, 1, 1, 64) * freq, 0.1, 0.5);

	// snd = BRF.ar(snd, LFNoise2.kr(10).range(20, 1000), 10);
	// snd = BPeakEQ.ar(snd, 200, 1, -6);
	// snd = Pan2.ar(snd, \pan.kr(0)) * 0.4;
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;


SynthDef("moogb", {
	arg out, pan, freq = 440, amp = 1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, chorus = 0.7, sustain;

	var osc, filter, env, filterenv, snd, chorusfx, envperc, envasr;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.adsr(0.2, 1, 0.2), gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	// envasr = EnvGen.ar(envelope: Env.adsr(atk, dec, sus, rel, amp * 0.1),gate: gate,doneAction: 2);

	env = EnvGen.ar(Env.linen(\atk.kr(0.01), 0, \rel.kr(1)), timeScale: sustain, doneAction:2);

	// envperc = Env.perc(atk, rel, amp * 0.1).ar(2, gate);

	snd = (0.7 * filter + (0.3 * filter.distort));

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

	// snd = Limiter.ar(snd);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));

}).add;

SynthDef(\rescomb, {
	|freq 50|
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \sustain.kr);
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \cratio.kr(1)), \cres.kr(1));
	snd = Resonator.ar(snd, \resf.kr(100), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = (2 * snd).tanh;
	snd = Limiter.ar(snd) * 1;
	Out.ar(\out.kr, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr, env));
}).add;

SynthDef("okick", {arg out, amp = 1, freq = 50, gliss = 0.9, atk = 0.01, rel = 1, pan;
	var env, snd, ramp;
	env = Env.perc(atk, rel, amp).kr(timeScale: \sustain.kr, doneAction: 2);
	ramp = XLine.kr(
		start: freq,
		end: freq * gliss,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\whiteperc, {
	var snd, env = Env.perc(\atk.kr(0.001), \rel.kr(0.1), \amp.kr(1.0), \curve.kr('sine')).kr(2);
	snd = WhiteNoise.ar(env);
	Out.ar(\out.kr, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;


// ndr_brt

SynthDef(\friab, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
	var envLength = sustain*(end-begin)/speed;
	var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

	var env = Env.asr;
	var sig = (Impulse.ar(basefreq) + VarSaw.ar(basefreq/2) + Impulse.ar(basefreq, LFTri.kr(line*4)))/2;

	var volume = IEnvGen.ar(env, line);
	Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
}).add;

SynthDef(\supersub, {|out=0,freq=440,sustain=1,pan=0,model=0,begin=0,end=1,speed=1,accelerate=0, harm=0, phase=0|
	var envLength = sustain*(end-begin)/speed;
	var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
	var rate = max(0, speed * (1 + (accelerate * line)));

	var env = Env.asr;
	var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

	var sig = Select.ar(model, [
		SinOsc.ar(basefreq, phase),
		SinOscFB.ar(basefreq),
		Saw.ar(basefreq),
		VarSaw.ar(basefreq, phase),
		SyncSaw.ar(basefreq, basefreq),
		Impulse.ar(basefreq, phase),
		Blip.ar(basefreq, harm),
		Pulse.ar(basefreq),
	]);

	var volume = IEnvGen.ar(env, line);
	Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;

(
SynthDef("sillyvoice", { arg
	out,
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	sustain,
	pan = 0;

	var in, vibrato, env, va, ve, vi, vo, vu, snd;

	vibrato = SinOsc.kr(vibratoSpeed, mul: vibratoDepth);
	in = Saw.ar(Lag.kr(freq, lag) + vibrato);
	env = EnvGen.kr(Env([0.0001, 1, 0.00001], [att, rel], 'lin'), timeScale: sustain, doneAction: 2);

	va = BBandPass.ar(
		in: in,
		freq: [ 600, 1040, 2250, 2450, 2750 ],
		bw: [ 0.1, 0.067307692307692, 0.048888888888889, 0.048979591836735, 0.047272727272727 ],
		mul: [ 1, 0.44668359215096, 0.35481338923358, 0.35481338923358, 0.1 ]);

	ve = BBandPass.ar(
		in: in,
		freq: [ 400, 1620, 2400, 2800, 3100 ] ,
		bw: [ 0.1, 0.049382716049383, 0.041666666666667, 0.042857142857143, 0.038709677419355 ],
		mul: [ 1, 0.25118864315096, 0.35481338923358, 0.25118864315096, 0.12589254117942 ]);

	vi = BBandPass.ar(
		in: in,
		freq: [ 250, 1750, 2600, 3050, 3340 ] ,
		bw: [ 0.24, 0.051428571428571, 0.038461538461538, 0.039344262295082, 0.035928143712575 ],
		mul: [ 1, 0.031622776601684, 0.15848931924611, 0.079432823472428, 0.03981071705535 ] );

	vo = BBandPass.ar(
		in: in,
		freq:[ 400, 750, 2400, 2600, 2900 ] ,
		bw: [ 0.1, 0.10666666666667, 0.041666666666667, 0.046153846153846, 0.041379310344828 ],
		mul: [ 1, 0.28183829312645, 0.089125093813375, 0.1, 0.01 ]);

	vu = BBandPass.ar(
		in: in,
		freq: [ 350, 600, 2400, 2675, 2950 ],
		bw: [ 0.11428571428571, 0.13333333333333, 0.041666666666667, 0.044859813084112, 0.040677966101695 ],
		mul: [ 1, 0.1, 0.025118864315096, 0.03981071705535, 0.015848931924611 ]);

	snd = SelectX.ar(Lag.kr(vowel, lag), [va, ve, vi, vo, vu]);
	snd = Mix.new(snd);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env * 5));
}).add;
);

SynthDef(\xenbass, { arg out, pan, note, tuning = 19, atk = 0.01, rel = 1, depth = 1, sustain;
	var signal, env, freqenv, octave, freq;
	// octave = ((note/tuning)-5).trunc(1);
	// freq = [440 * (pow(2, octave)) * (pow(2, ((mod(note, tuning))/tuning)))];  //sets microtonal properties according to Guiot's technique
	freq = \freq.kr(100);
	freqenv = EnvGen.ar(Env([freq, freq * 6, freq], [atk, rel], 'exp')); // filter envelope
	env = EnvGen.ar(Env([0.0001, 2, 0.0001], [atk, rel], [-5, -4]), timeScale: sustain, doneAction: 2); //amplitude envelope
	signal = Gendy1.ar(1, 5, 1, 1, freq, [freq + depth, freq + depth + 1 ], 0.5, 0.6, 6); // a Gendy1 oscillator
	signal = LPF.ar(signal, freqenv) * env; // applies filter and amplitude envelope to the oscillator
	signal = LeakDC.ar(signal); //remove DC Offset
	signal = Mix.ar(signal); //necessary for panning
	// signal = signal * env;
	Out.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env)); //configures the synth for Tidalcycles
}).add;

SynthDef(\merci, {
	| out speed accelerate sustain|
	var snd, env, freq, pitch;
	freq = \freq.kr(100);
	freq = freq * ({LFNoise2.kr(0.1, 0.01, 1)}!3);
	// freq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	env = EnvGen.ar(Env.linen(0.01, 1, 0.01, 1, -3), timeScale: sustain, doneAction:2);
	snd = LFSaw.ar(freq, 0, 0.2);
	snd = snd.blend(
		LPF.ar(
			CombC.ar(snd.sum, 0.2, 1/(Array.fill(30, {LFNoise2.kr(0.1).exprange(20, 20000)})),
				\decaytime.kr(0.5)
			), \dampen.kr(0).linexp(0, 1, 20000, 100)
		),
		0.3);
	snd = Splay.ar(snd);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr, env));
}).add;

SynthDef(\dsaw, {
	| out speed accelerate sustain|
	var snd, env, freq, pitch;
	freq = \freq.kr(100);
	freq = freq * ({LFNoise2.kr(0.1, \detune.kr(0).linlin(0, 1, 0, 0.1), 1)}!3);
	// freq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	env = EnvGen.ar(Env.linen(0.01, 1, 0.01, 1, -3), timeScale: sustain, doneAction:2);
	snd = LFSaw.ar(freq, 0, 0.2);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr, env));
}).add;

SynthDef(\bass8, {
	arg out = 0, amp = 0.1, gate = 1, pan = 0, freq = 200, speed =1, accelerate = 0, sustain =1;
	var sig;
	var osc = Array.newClear(6);
	var env = Array.newClear(6);

	env[0] = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env[1] = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env[2] = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env[3] = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env[4] = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env[5] = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);

	freq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	freq = (freq / 4) * ((0..1)/1 - 0.5 * 0.0007 + 1);

	osc[0] = SinOsc.ar(freq * 11 + 0) * env[0];
	osc[1] = SinOsc.ar(freq * 6 * ( osc[0] * 2.5 + 1 )) * env[1];
	osc[2] = SinOsc.ar(freq * 2 * 1 + 0) * env[2];
	osc[3] = SinOsc.ar(freq * 1 * ( osc[2] * 2.5 + 1 ) + 0) * env[3];
	osc[4] = SinOsc.ar(freq * 1 * ( osc[1] * 2.5 + 1 ) * (osc[3] * 2.5 + 1)) * env[4];
	osc[5] = SinOsc.ar(freq * 2) * env[5];

	sig = osc * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig = sig * 0.5;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ), gate, doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig = sig.sum;
	Out.ar(out, Pan2.ar(sig, pan, amp));

}).add;


SynthDef("mkick", {|amp 1 out pan 0|
	var snd, trig, env, freq, disto, sustain;

	sustain = \sustain.kr(1);

	// freq = \freq.kr(50) * DirtFreqScale.kr(\speed.kr(1), \accelerate.kr(0), \sustain.kr(1));

	freq = \freq.kr(50) * Line.kr(\pitchenv.kr(2), 1, \pitch_attack.kr(0.01));

	snd = SinOsc.ar(freq);

	// env = Env.perc(\atk.kr(0.01), \rel.kr(1.0), 1).kr(2);
	env = Env.perc(\attack.kr(0.01), \release.kr(1.0), 1).kr(2);
	// env = EnvGen.ar(Env.linen(\attack.kr(0.01), sustain, \release.kr(1.0)), timeScale:sustain, doneAction:2);
	// snd = snd * env;

	disto = snd * (\d.kr(0) * 100 + 10);
	disto = Select.ar(\mode.kr(0), [disto.sin, disto.cos, disto.tanh, disto.distort, disto.softclip]);

	snd = snd.blend(disto * 0.2, 0.4);
	snd = LeakDC.ar(snd);
	snd = HPF.ar(snd, 20);

	// snd = SplayAz.ar(~numChannels, snd, 1, 2, ~numChannels);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
	// Out.ar(out, snd * \amp.kr(1));
}).add;


SynthDef(\resk, {
	var snd, trig, freq, freqs, space;
	freq = \freq.kr(40) * Line.kr(\penv.kr(10), [1, 1.01], \penvdur.kr(0.01));
	snd = SinOsc.ar(freq, 0);
	snd = Env.perc(0.01, 1, 0.5).ar(2) * snd;
	snd = snd.blend(Resonator.ar(snd, freq * 8, resolution: 24, damping: MouseY.kr(0.7, 0.3)));
	// snd = snd.blend(Resonator.ar(snd, \resf.kr(100), resolution: 24;, damping: 0.3));
	snd = GVerb.ar(snd, 1, 0.1, drylevel: 1);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\sevenSaw, {arg out, freq = 32.1, amp = 0.5;
	var snd, env;
	env = EnvGen.ar(Env.linen(\atk.kr(0.01), 1, \rel.kr(0.01), amp), timeScale: \sustain.kr, doneAction:2);
	snd = Splay.ar(
		BPF.ar(
			Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1)
	);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;

SynthDef(\sevensaws, {arg out, freq = 32.1, amp = 0.5;
	var snd, env;
	env = EnvGen.ar(Env.perc(\attack.kr(0.01), \release.kr(0.01), amp), timeScale: \sustain.kr, doneAction:2);
	snd = Splay.ar(
		BPF.ar(
			Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1)
	);
	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;

SynthDef("10sines", {arg out, gate = 1, lo = 20, hi = 20000, pan = 0, att = 0.01, amp = 0.1, rel = 1;
	var snd, array, env;
	env = Env.asr(att, amp, rel).kr(2, gate);
	array = {exprand(20,20000)}!100;
	snd = Splay.ar(SinOsc.ar(array, mul:0.1));
	snd = snd * env;
	Out.ar(out, snd);
}).add;

SynthDef(\poom, {|out|
	var sound, done, env;
	env = Env.perc(\attack.kr(0.01), \release.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0);
	sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \attack.kr(0.01) + \release.kr(3)), env);
	// DetectSilence.ar(sound, doneAction:2);
	sound = Pan2.ar(sound, \pan.kr(0));
	sound = JPverb.ar(sound, \reverbTime.kr(0.00007), \damp.kr(0));
	sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
	DetectSilence.ar(sound, doneAction:2);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, \pan.kr(0), env));
}).add;

SynthDef(\additiverandom, {|out|
	var snd, env, npartials, trig, f;

	npartials = 100;

	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 0.2, -3), timeScale: \sustain.kr, doneAction:2);

	snd = SinOsc.ar({TRand.kr(1, 10000, 1)}!npartials, 0, {TRand.kr(0, 1.00, 1)}!npartials);

	// snd = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;

SynthDef(\fib1, {|out|
	var snd, env;


	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 1.0, -3), timeScale: \sustain.kr, doneAction:2);

	snd = LFSaw.ar(0.1, pi);

	snd = BPF.ar(
		snd,
		Array.fib(12, \freq.kr(440)/8, 30),
		\rq.kr(0.005),
		50
	);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));
}).add;



SynthDef(\gendy, {|out|
	var snd, env, freq;

	env = EnvGen.ar(Env.linen(\attack.kr(0.01), \sustain.kr(1.0), \release.kr(0.01), 1.0, -3), timeScale: \sustain.kr, doneAction:2);

	freq = \freq.kr(440) * SinOsc.ar(\vibf.kr(0.0), 0, \vib.kr(0), 1);
	// freq = \freq.kr(440) * LFSaw.ar(\vibf.kr(0.0), 0, \vib.kr(0), 1);

	snd = Gendy3.ar(

		3,
		5,
		1.0,
		1.0,
		freq,
		// \dust.kr(0.0),
		rrand(0.01,0.05),
		rrand(0.001,0.016),
		5,
		mul:0.1

	);

	Out.ar(out, DirtPan.ar(snd, ~dirt.numChannels, \pan.kr(0), env));

}).add;



SynthDef(\cmdp, {|out|

	CmdPeriod.run;

}).add;


)


