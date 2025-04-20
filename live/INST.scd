(
Routine.run{
	// convolution reverbs


	// ~bassconv = EZConv("/Users/maxlouisraugel/Documents/ /bassdrum_23.wav");

	s.sync;



	/*Ndef(\drone1, {
		var snd, lfo, freq1, freq2, stereo, freq;
		freq = \freq.kr(#[70, 200], 0);
		lfo = LFNoise2.kr(0.01);
		freq1 = lfo.linexp(-1, 1, 3000, 300);
		freq2 = lfo.exprange(20, 2000);
		stereo = [freq1, freq2];
		snd = NeoFormant.ar(freq, freq, LFNoise2.kr(1));
		// snd = LPG.ar(snd, Dust.kr(1), 0.5, 0.5, 1, 1.1);
		snd = snd + SinOscFB.ar(freq, lfo.range(0, 1.5), 1);
		snd = snd + VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 1, [50, 59].midicps);
		// snd = LPF.ar(FreeVerb2.ar(snd[0], snd[1], 1, 1, 0), \lpf.kr(2e4, 10));
		// snd = XFade2.ar(snd, JPverb.ar(Splay.ar(snd), 1, 0, modDepth: 1, modFreq: lfo.abs / 2 + 0.7), -0.5);
		snd = JPverb.ar(Splay.ar(snd), 1, 0, modDepth: 1, modFreq: lfo.abs / 2 + 0.7);
		// snd = HPF.ar(snd, 50, 1);
		snd = Pan2.ar(snd, 0, 0.1 * \amp.kr(0.2));
	}).mold(2);

	~blimp = Ndef(\blimp, {
		var snd, trig, freq, conv;
		trig = Dust.kr(\density.kr(0.2));
		freq = Demand.kr(trig, 0, Drand([1000, 700, 920, 1200]/2, inf));
		snd = LFSaw.ar(freq) * Env.perc(0.01, 1, 1, 4).kr(0, trig) * 0.1;
		snd = ~bassconv.ar(snd);
		snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.1), LFNoise2.kr(0.7, 0.2, 1), 5, 10);
		snd = Balance2.ar(snd[0], snd[1], 1);
		snd = Pan2.ar(snd, TRand.kr(-0.7, 0.70, trig));
		snd = Limiter.ar(snd.tanh, 0.1);
		snd = FreeVerb2.ar(snd[0], snd[1], 0.2, 0.3);
		snd = snd * 0.7;
	}).mold(2);

	~whiteshaker = Ndef(\whiteshaker, {|freq 10 mul 100|
		var snd, lfo, sine;
		lfo = LFNoise2.kr(0.3);
		sine = SinOsc.ar(freq, 0, mul);
		sine = sine * sine.range(\min.kr(20), \max.kr(2000));
		snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
		snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
		// snd = HPF.ar(snd, 500);
		snd = Pan2.ar(snd, lfo/2);
		snd = snd / (freq/100) / 5 * \amp.kr(1);
	});

	~vpoints = Ndef(\vanishingpoints, {
		var buffer, snd, trig, env;
		trig = Dust.kr(0.3);
		env = Env.perc(0.01, 10).kr(0, trig);
		buffer = \buffer.kr(C.get(\thanks, 5));
		snd = PlayBuf.ar(2, buffer, TRand.kr(2.0, 10.0, trig) * BufRateScale.kr(buffer), trig, 0, 1) * 0.1;
		snd = Balance2.ar(snd[0], snd[1], TRand.kr(-0.7, 0.7, trig));
		snd = snd * env * 1.7 * \amp.kr(1);
	}
	);

	~neoformant = {
		var snd, lfo, freq1, freq2, stereo;
		lfo = LFNoise2.kr(0.1);
		freq1 = lfo.linexp(-1, 1, 3000, 300).round(77).lag(3);
		freq2 = lfo.exprange(20, 2000).round(77).lag(3);
		stereo = [freq1, freq2];
		snd = NeoFormant.ar(freq1, freq2, LFNoise2.kr(1));
		snd = LPG.ar(snd, Env.perc(3, 3).kr(0, gate: Dust.kr(1)), 0.5, 0.5, 1, 1.1);
		snd = snd + SinOscFB.ar(stereo, lfo.range(0, 1.5));
		snd = snd + VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 1, 100);
		snd = FreeVerb2.ar(snd[0], snd[1], 1, 1, 0);
		snd = Pan2.ar(snd, 0, \amp.kr(0.015));
	};

	Ndef(\neoformant, {
		var snd, lfo, freq1, freq2, stereo;
		lfo = LFNoise2.kr(0.1);
		freq1 = lfo.linexp(-1, 1, 3000, 300).round(77).lag(3);
		freq2 = lfo.exprange(20, 2000).round(77).lag(3);
		stereo = [freq1, freq2];
		snd = NeoFormant.ar(freq1, freq2, LFNoise2.kr(1));
		snd = LPG.ar(snd, Env.perc(3, 3).kr(0, gate: Dust.kr(1)), 0.5, 0.5, 1, 1.1);
		snd = snd + SinOscFB.ar(stereo, lfo.range(0, 1.5));
		snd = snd + VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 1, 100);
		snd = FreeVerb2.ar(snd[0], snd[1], 1, 1, 0);
		snd = Pan2.ar(snd, 0, \amp.kr(0.015));
	}).mold(2);

	Ndef(\blosc2, {|freq 1000 mul 1|
		var snd, lfo, sine, env;
		// env = Env.perc(1, 3, 1, 10).kr(2);
		lfo = LFNoise2.kr(0.1);
		sine = SinOsc.ar(freq * LFNoise2.ar(0.3, 0.001, 0.0015), 0, mul);
		sine = sine * sine.range(\min.kr(20), \max.kr(2000));
		snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
		snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
		snd = HPF.ar(snd, 50);
		snd = BRF.ar(snd, 500);
		snd = BPeakEQ.ar(snd, 50, 0.5, 6);
		snd = Pan2.ar(snd, lfo / 2);
		snd = CombC.ar(snd, 0.2, 1/(freq * 4), 1, 0.2);
		snd = snd / (freq/100) * 1/2 * \amp.kr(1);
		// snd = snd.tanh;
	});

	Ndef(\wabble, {
		var snd, trig, env;
		trig = Dust.kr(\density.kr(0.1));
		env = Env.perc(0.01, 3).kr(0, trig);
		snd = Rongs.ar(trig, trig, \f0.kr(500), \structure.kr(0.2), LFNoise2.kr(0.3, 0.3, 0.75), TChoose.kr(trig, [0.5, 0.6, 0.7]), \accent.kr(0.9), TRand.kr(0, 0.3, trig), \position.kr(0.15), \loss.kr(0.15), 5, 3);
		snd = Pan2.ar(snd * env, LFNoise2.kr(0.3, 0.5)) * \amp.kr(1);
		// snd = Limiter.ar(snd, 0.1);
		snd = LeakDC.ar(snd) * 1/3;
		snd = LPF.ar(snd, 2000);
	});

	Ndef(\rongs, {
		var snd, trig;
		trig = Dust.kr(\density.kr(4));
		snd = Rongs.ar(trig, trig, \f0.kr(1000) * LFNoise2.kr(0.1, 0, 1), \structure.kr(0.2), \brightness.kr(0.5), \damping.kr(0.75), \accent.kr(0.9), \stretch.kr(0.5), \position.kr(0.15), \loss.kr(0.15), 5, 3);
		snd = Pan2.ar(snd, SinOsc.kr(0.1)) * \amp.kr(1);
		snd = Limiter.ar(snd, 0.1);
	});

	// Routine

	~tinnitus = Ndef(\tinnitus, {
		|bassfreq = 50|
		var sound, env, width;
		sound = WhiteNoise.ar(0.03);
		sound = CrossoverDistortion.ar(sound, 1, 0.99);
		sound = sound + SinOsc.ar(bassfreq, 0, 0.2);
		sound = sound + LFTri.ar(LFNoise1.kr(10).range(10000, 10100), 0, 0.1);
		sound = Limiter.ar(sound, 0.1);
		sound = sound!2;
	});

	~comb2 = Ndef(\comb2, {
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
		sound = HPF.ar(sound, 50);
	});

	~combwhite = Ndef(\combwhite, {
		|freq = 200, detune = 0, lag = 0, mix = 0, width = 0.3, amp = 1, reverbmix = 0|
		var snd, env, comb;
		// env = Env.asr(3, 1, 3).kr(2, gate);
		snd = WhiteNoise.ar(0.03);
		// snd = VarSaw.ar(300);
		// snd = snd * env;
		// width = SinOsc.kr(1).unipolar;
		snd = PanAz.ar(s.options.numOutputBusChannels, snd, LFNoise2.kr(10), 1, width);
		// snd = Balance2.ar(snd, snd, LFNoise2.kr(1))
		comb = CombC.ar(snd, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
		snd = XFade2.ar(snd, comb, mix * 2 - 1) * amp;
		// snd = FreeVerb.ar(snd, reverbmix);
	});

	~rrr = Ndef(\rrr, {
		var snd =
		Splay.ar(
			BPF.ar(
				LFSaw.ar(
					LFNoise2.kr(0.5).exprange(7, 17)
					// LFNoise2.kr(0.5).exprange(10, [1000, 100])
				),
				Array.fib(12, LFNoise2.kr(0.1, 20, 30), 30),
				0.005,
				mul: Env.perc(1, LFNoise1.kr(1, 1, 5), level: 10, curve: -3).circle.kr(2)
			),
			spread: 0,
			level: 1);
		snd = Mix(snd);
		PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1)) * \amp.kr(1/2);
	});


	~whiteshuffle = Ndef(\whiteshuffle, {Splay.ar(
		WhiteNoise.ar(
			Saw.kr(freq:{LFNoise1.kr(1).range(0.01,1)}!5, mul:0.1)
	))});

	~moan1 = Ndef(\moan1, {
		var snd, buffer;
		buffer = \buffer.kr({rrand(0, 100)}!3);
		snd = PlayBuf.ar(1, buffer, {LFNoise2.kr(0.3).range(7, 20)}!3, 1, 0, 1);
		snd = Splay.ar(snd, 10);
		// snd * Env.perc(0.01, 0.5).kr(0, Impulse.kr(LFNoise2.kr(0.3, 10, 10))) * 0.6;
		snd = BPF.ar(snd, LFNoise2.kr(0.3).exprange(3000, 10000), 0.7, 0.1);
		snd = snd * 5;
	});

	~theaterkicks = Pbind(\instrument, \kick, \freq, 66, \dur, Pseq([1/3], {rrand(2, 5)}), \amp, 1/2);

	~squine = Ndef(\squine, {|freq 100 clip 0 skew 0.0 sync 0.0 amp 0.5 iminsweep 0 initphase 1.25 pan 0|
	var snd;
	snd = Squine.ar(freq: freq * {LFNoise2.kr(0.3!3).range(0.99, 1.01)}, clip: clip * SinOsc.ar(freq, 0, 1, freq), skew: skew, sync: sync, mul: amp, add: 0,iminsweep: iminsweep, initphase: initphase);
	snd = Splay.ar(snd);
	snd = FreeVerb2.ar(snd[0], snd[1], \mix.kr(0), \room.kr(1))
	// snd = Pan2.ar(snd, pan);
}).mold(2);

	~sweeps = Routine.new({{var dur = rrand(0.7, 1.0); Synth(\sweep, [freq: Env([exprand(20, 200), exprand(20, 200)], dur), amp: Env([0, 0.1, 0], [dur/2, dur/2]), pan: rrand(-1, 1.0)]); 5.wait;}.loop});

	~filaments = Ndef(\filaments, {Splay.ar(
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
)}!10)});*/
}
)

