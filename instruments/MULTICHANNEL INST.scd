(




Routine.run{


	Routine.run{

		~jpverb_bus = ~jpverb_bus ?? Bus.audio(s, ~numChannels);

		s.sync;

		// ~jpverb = Synth(\jpverb, [in: ~jpverb_bus, time: 0.00007, damp: 0, mix: 1, out: 0], s, 'addToTail');
		~jpverb = Ndef(\jpverb, {var snd;
			snd = JPverb.ar(In.ar(~jpverb_bus), \time.kr(0.00007), \damp.kr(0));
			snd = PanAz.ar(~numChannels, snd, 0, 0.2, 6)

		}).mold(~numChannels);

	};


	d = d ?? ~dirt.buffers;

	s.sync;


	w = Array.new;
	~folder = PathName("/Users/maxlouisraugel/Documents/son/SONS/w/");

	~folder.entries.do({
		arg path;
		w = w.add(Buffer.read(s, path.fullPath));
	});

	s.sync;

	~armoire = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SONS/armoire.WAV");

	s.sync;

	~wsamples = Pbindef(\wsamples, \instrument, \playAz, \buffer, Pxrand(50.collect{|i| w[i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 2, \pan, Pwhite(0, 15.0), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 0.7);

	~cuves = Ndef(\cuves, {
		var snd, trig, lfo;
		lfo = LFNoise2.kr(3);
		trig = Impulse.kr(lfo.range(0.02, 0.2));
		snd = SinOscFB.ar(lfo.exprange(200, 220), 0.5, 0.1);
		snd = snd * Env.perc(0.01, \rel.kr(2)).kr(0, gate: trig);
		snd = GVerb.ar(snd, 2, (lfo * lfo).range(0.5,1));
		snd = Limiter.ar(snd, 0.1);
		snd = PanAz.ar(~numChannels, snd.sum, LFNoise2.kr(0.3).range(0, 2.0), \amp.kr(0.7));
		snd = Sanitize.ar(snd);
	});


	/*	// QUAD EXAMPLE
	x = Ndef(\x, {var snd, mc, lfo;
	mc = 10;
	lfo = LFNoise2.kr(\mod.kr(0.3)).range(0, 3.0);
	// lfo = \mod.kr(0.3).range(0, 3.0);
	// snd = SinOscFB.ar({exprand(20, 3000)}!mc, lfo.range(0, \fb.kr(1.0)), {LFNoise2.kr(3, 0.05, 0.1)}!mc);
	snd = SinOscFB.ar(([200, 220, 500, 380]*[[0.5, 0.25, 1, 2]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(1.0)), {lfo.range(0, 0.05)}!10);
	// snd = BPF.ar(snd, {exprand(20, 3000)});
	snd = HPF.ar(snd, 100);
	snd = SplayAz.ar(8, snd, 1, 1, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0);
	snd = snd.blend(JPverb.ar(snd, 6), \jpverb.kr(0));
	}).mold(~numChannels);*/


	u = Ndef(\u, {var snd, nchans;
		nchans = ~numChannels;
		snd =
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(\minfreq.kr(20), \maxfreq.kr(20000)),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, nchans) * 5],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
		)}!nchans;
		snd = snd * \amp.kr(0.1);
	}).mold(~numChannels);

	~washes = Ndef(\washes, {
		var snd, tide;
		tide = LFGauss.ar(duration: 10, width: LFNoise2.kr(0.3, 0.1, 0.1));
		snd = WhiteNoise.ar(0.1);
		snd = LPF.ar(snd, 7000);
		snd = snd * tide.range(0, 1);
		snd = PanAz.ar(~numChannels, snd, tide.range(0, 2.0));
		// snd = Pan4.ar(snd, 0, LFSaw.kr(1/3).range(-1, 1.0).lag(0.1));
		snd = snd.blend(JPverb.ar(snd, 10), 0.4);
		snd = LPF.ar(snd, 4000);
	}).mold(~numChannels).fadeTime_(10);


	Ndef(\test,
		{
			var snd, nchans;
			nchans = ~numChannels;
			snd = PinkNoise.ar(0.5);
			snd = PanAz.ar(nchans, snd, MouseX.kr(0, nchans).linlin(0, nchans, 0, 2.0), 1, 2.0, 0);
		}
	).mold(~numChannels);

	n = Ndef(\n,
		{
			var snd;
			snd = PinkNoise.ar(0.5);
			snd = PanAz.ar(~numChannels, snd, LFGauss.kr(5, 1), 1, 2, 0);
		}
	).mold(~numChannels);

	~buffer = Ndef(\buffer, {
		var snd, buffer;
		buffer = \b.kr();
		snd = PlayBuf.ar(1, buffer, \note.kr(0, \lag.kr(0.0)).midiratio * BufRateScale.ir(buffer), \trigger.kr(1.0), \pos.kr(0) * BufFrames.ir(buffer), \loop.kr(0));
		snd = PanAz.ar(~numChannels, snd, \pan.kr(0.0).linlin(0, 15, 0, 2.0), 1, \width.kr(5.0), 0);
	}).mold(~numChannels);

	SynthDef(\playmulti, {
		var snd, rate, env, envlinen, buffer;
		buffer = \buffer.kr();
		env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
		rate = \rate.kr(1);
		snd = PlayBuf.ar(2, buffer, BufRateScale.ir(buffer) * (\note.kr(0).midiratio), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
		snd = PanAz.ar(~numChannels, snd, \pan.kr(0.0).linlin(0, ~numChannels-1, 0, 2.0));
		snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
		Out.ar(\out.ar(0), snd * env * \amp.kr(1))
	}).add;

	SynthDef(\playAz, {
		var snd, rate, env, envlinen, buffer;
		buffer = \buffer.kr;
		env = Env.linen(\atk.kr(0), \sus.kr(1.0), \rel.kr(3)).kr(2);
		rate = \rate.kr(1);
		snd = PlayBuf.ar(2, \buffer.kr, BufRateScale.ir(\buffer.kr) * \rate.kr(1), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
		snd = PanAz.ar(~numChannels, snd.sum * 0.5, \pan.kr(0).linlin(0, ~numChannels, 0, 2), 1, 2.0, 0);
		snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
		Out.ar(\out.ar(0), snd * env * \amp.kr(1));
	}).add;


	SynthDef(\sinesaw, {arg out, pan = 0, gate = 1, legato, atk = 3, rel = 10, amp = 1, curve = 'lin', sawmul = 0.001;
		var sig, sine, saw, env, freq;
		freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
		env = Env.asr(atk, 2, rel, curve).kr(2, gate);
		sine = SinOsc.ar({freq* rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
		saw = LFSaw.ar({freq * rrand(0.99, 1.01)}!3, 0, sawmul);
		sig = sine + saw;
		sig = sig.sum * 0.5;
		sig = Pan4.ar(sig, \x.kr(0), \y.kr(0));
		Out.ar(out, sig * env * amp);
	}).add;


	SynthDef(\percsinefb, {arg t_trig = 1,  atk = 0.01, rel = 1, curve = -3, amp = 1, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		// env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = PanAz.ar(~numChannels, sig, \pan.kr(0).linlin(1, ~numChannels, -0.25, 1.25), amp, \width.kr(2.0));
		sig = sig * env;
		Out.ar(\out.kr(0), sig);
	}).add;


	SynthDef(\percsinefb_mono, {arg  t_trig = 1, atk = 0.01, rel = 1, curve = -3, amp = 1;
		var sig, env, freq, vibrato;
		vibrato = SinOsc.ar(rrand(0.1, 0.30), 0, \vibrato.kr(0.0), 1);
		freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0)) * vibrato;
		// env = Env.perc(atk, rel, 1, curve).kr(2, timeScale:\dur.kr(1));
		env = Env.perc(atk, rel, 1, curve).kr(2, t_trig);
		sig = SinOscFB.ar(freq, \feedback.kr(1/2));
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = sig * env * amp;
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\percsine_mono, {arg t_trig = 1,  atk = 0.01, rel = 1, curve = -3, dur = 1;
		var sig, env, freq;
		freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		// freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = sig * env * \amp.kr(1);
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\pyramid, {| gate 1 x1 -1 x2 1 y1 -1 y2 1 f0 10000 f1 800 f2 100 dur 8|
		var snd, env;
		snd = WhiteNoise.ar(Env([0, 0.2, 0], [dur/2, dur/2]).kr(2));
		snd = BPF.ar(snd, Env([f0, f0, f1, f2, f2], [dur/8, 3*dur/8, 3*dur/8, dur/8], 'exp').kr(2), \rq.kr(1));
		snd = LPF.ar(snd, \lpf.kr(3000));
		snd = PanAz.ar(~numChannels, snd, Env([x1, x1, 0, x2, x2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2), Env([y1, y1, 0, y2, y2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2));
		Out.ar(\out.kr(), snd);
	}).add;

	~wpyramid = Pbindef(\pyramid, \instrument, \pyramid, \x1, Pwhite(-1, 1), \x2, Pwhite(-1, 1).poll, \y1, Pwhite(-1, 1), \y2, Pwhite(-1, 1), \f0, Pwhite(20, 20000), \f1, Pwhite(100, 10000), \f2, Pwhite(20, 20000), \dur, Pwhite(10, 40), \amp, 0.03);


	SynthDef("moogbass", {
		arg  pan = 0, freq = 440, amp = 1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, atk = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

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
					freq: Rand(2, 6),
					mul: 0.25 * maxdelaytime,
					add: 0.75 * maxdelaytime)
			)
		});

		snd = snd + (chorusfx * chorus);

		// Out.ar(out, Pan4.ar(snd, pan, pan));

		// Out.ar(\out.kr(0), PanAz.ar(4, snd, \pan.kr(0).linlin(-0.25, 1.25, 0, 3)));

		Out.ar(\out.kr(0), snd);
	}).add;



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


	SynthDef("mkick", {|out|
		var snd, trig, env, freq, disto, sustain;

		freq = \freq.kr(50) * Line.kr(2, 1.0, 0.01);
		snd = SinOsc.ar(freq);

		env = Env.perc(0.01, \rel.kr(1.0), 1).kr(2);
		snd = snd * env;

		disto = snd * (\d.kr(0) * 100 + 10);
		disto = Select.ar(\mode.kr(0), [disto.sin, disto.cos, disto.tanh, disto.distort, disto.softclip]);

		snd = snd.blend(disto * 0.2, 0.4);
		snd = LeakDC.ar(snd);
		snd = HPF.ar(snd, \hpf.kr(20));
		snd = BPeakEQ.ar(snd, 62, 10, \brf.kr(0));

		// snd = CrossoverDistortion.ar(snd, \disto.kr(0.0), \disto2.kr(0.5));

		// snd = snd + SinOscFB.ar(\freq.kr(50) * 4, 0.8, \oct.kr(0.0));

		snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels);


		Out.ar(out, snd * 0.5 * \amp.kr(1));
	}).add;


	a = Ndef(\avion, {|lag 10|
		var air, bass, snd;
		air = BrownNoise.ar({LFNoise2.kr(0.3, 0.02, 0.08).abs * \air.kr(1, 10)}!4); air = LPF.ar(air) * 3;
		air = BPeakEQ.ar(air, 50, 5, 15);
		snd = SplayAz.ar(~numChannels, air, 1, 1, 2, LFNoise2.kr(0.1).range(0, 1));
		snd = snd.blend((BPF.ar(snd, LFNoise2.kr(0.1).exprange(100, 200) * \height.kr(1, 10), \rq.kr(0.01, 10), 30)*3).cos, \avion.kr(0, 30));
		snd = Limiter.ar(snd * 0.9, \limit.kr(0.9, 10));
		snd = HPF.ar(snd, \hpf.kr(30));
		snd = snd * \amp.kr(0);
	}).mold(~numChannels).fadeTime_(10);



	SynthDef(\fmlmulti, {
		arg out = 0, freqA = 100, freqB = 100, time = 0, mRatio=1, cRatio=1,
		index1 = 20, index2 = 20, index0 = 0, iScale=0.05, cAtk=4, cRel=(-4),
		amp=0.2, atk=0.01, rel=3;
		var freq, car, mod, env, iEnv, index;
		index = Line.kr(index1, index2, index0);
		iEnv = EnvGen.kr(
			Env(
				[index, index*iScale, index],
				[atk, rel],
				[cAtk, cRel]
			)
		);
		freq = Line.kr(freqA, freqB, time, 1, 0, 0);
		env = EnvGen.kr(Env.perc(atk,rel, curve:[cAtk,cRel]),doneAction:2);
		mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
		car = SinOsc.ar(freq * cRatio + mod) * env * amp;
		// car = car + BPF.ar(PinkNoise.ar(env * 0.1), freq);
		car = car.blend(JPverb.ar(car, 3), 0.5);
		car = PanAz.ar(~numChannels, car * 0.5, \pan.kr(0).linlin(0, 15, 0, 2.0), 1, \width.kr(2.0), 0);
		Out.ar(out, car);
	}).add;


	~sub = Ndef(\sub, {
		var snd;
		snd = BrownNoise.ar(0.1);
		snd = LPF.ar(snd, \freq.kr(80));
		snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels) * 5 * \amp.kr(1);
	}).mold(~numChannels);

	SynthDef(\vibes, {|out|
		var snd, mod, fft;
		mod = FSinOsc.kr(XLine.kr(0.7, LFNoise2.kr(0.3).exprange(100, 3000), 20).lag(1),0, 3600,4000);
		snd = Saw.ar(\freq.kr(100),0.5) + SinOscFB.ar(\freq.kr(100), 1) + PinkNoise.ar(0.1);
		snd = BPF.ar(snd, mod, 0.3);
		// MoogFF
		snd = LPF.ar(snd, 2000) * 0.5;
		// fft = FFT(LocalBuf(2048), snd); fft = PV_MagAbove(fft, \threshold.kr(0.1)); snd = IFFT(fft);
		snd = snd.blend(JPverb.ar(snd), 0.7);
		// snd = SplayAz.ar(4, snd);
		snd = PanAz.ar(~numChannels, snd.sum, \pan.kr(0.5).linlin(0, ~numChannels-1, 0, 2.0), 1, 3.0, 0.5);
		snd = snd * Env([0, 1, 1, 0], [\atk.kr(0.1), \sus.kr(7), \rel.kr(5)], 'sine').kr(2);
		Out.ar(out, snd);
	}).add;

	~tabble = Ndef(\pwom, {|tempo=1.0, envdur=0.91, comb 0 feedback 1.1 midinotes #[ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ] transpose #[0.5, 1.0, 1.5]|
		var trig = Impulse.kr(tempo);
		var lfsaw = LFSaw.kr(0.1).range(0.0,0.2);
		var seq = TWChoose.kr(trig, transpose, [0.75, 0.125, 0.125]) *  Demand.kr(trig, 0, Dseq((midinotes+12).midicps,inf)).lag(0.01);

		// var sig = SinOscFB.ar(seq, 1.1) + WhiteNoise.ar(0.02);
		var sig = SinOscFB.ar(seq, feedback /*TRand.kr(0, 1.7, trig)*/) + CombC.ar(WhiteNoise.ar(SinOsc.kr(0.01).abs * comb / 10 + 0.001), 0.2, 1/seq, SinOsc.kr(3).range(0, 100) + 1);
		var rand = TRand.kr(trig: trig);
		var env = Env.perc(rand,1.0-rand).kr(gate: trig, timeScale: envdur/tempo);

		sig = LPG.ar(
			input: sig,
			controlinput: env,
			controloffset: lfsaw,
			controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
			vca: LFNoise2.kr(1).unipolar,
			resonance:1.1,
			lowpassmode:1,
			linearity:1
		) * 0.25;

		// sig = FreeVerb.ar(sig, 0.1);
		// sig = BRF.ar(sig, LFNoise2.kr(10).range(20, 1000), 10);
		// sig = BPeakEQ.ar(sig, 200, 1, -6);
		PanAz.ar(~numChannels, sig, 0.5*TRand.kr(0.0,2.0,trig)) * \amp.kr(0.4);
	}).mold(~numChannels).lag(\comb, 100, \tempo, 100, \feedback, 100, \midinotes, 30, \transpose, 30, \amp, 30);



	SynthDef(\rumble, {|out|
		var snd, auto, trig, freq;
		freq = \freq.kr(40, 1);
		trig = Dust.ar(3);
		trig = ToggleFF.ar(trig).lag(\lag.kr(3));
		auto = trig.lagud(0.1, 0.3);
		snd = Saw.ar(freq);
		snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels);
		snd = (snd * 3).fold2;
		snd = RLPF.ar(snd, freq * 10, 0.1);
		/*	snd = (snd * 5).fold2;
		snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
		snd = (snd * 5).fold2;*/
		snd = MoogFF.ar(snd, auto.linexp(0, 1, \floor.kr(100), 20000), 0, 0, 2);
		snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
		snd = (snd * 3.dbamp).tanh;
		snd = HPF.ar(snd, 100);
		Out.ar(out, snd * \amp.kr(0.5));
	}).add;






	// DEMOCRATIE MOBILE II

	~drone1 = Ndef(\drone1, {
		var snd, lfo, freq1, freq2, stereo, freq, wiggle;
		freq = \freq.kr(#[70, 200], 0);
		lfo = LFNoise2.kr(0.02);
		freq1 = lfo.linexp(-1, 1, 3000, 300);
		freq2 = lfo.exprange(20, 2000);
		// stereo = [freq1, freq2];
		snd = NeoFormant.ar(freq, freq, LFNoise2.kr(1));
		snd = snd + SinOscFB.ar(freq, lfo.range(0, 1.5), 1);
		snd = snd + (VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 0.1, [ 50, 59 ].midicps) * 1);
		snd = Splay.ar(snd);
		snd = JPverb.ar(snd, 1, 0, modDepth: lfo.range(0.1, 1.2), modFreq: lfo.abs / 2 + 0.7);
		snd = BPeakEQ.ar(snd, 100, 1, -10);
		snd = snd * \amp.kr(0);
		snd = PanAz.ar(~numChannels, snd, 0, 1, ~numChannels, 0.5);
		snd = RLPF.ar(snd, \lpf.kr(20000, 0.3), \lpq.kr(0.3, 0.3));
		snd = HPF.ar(snd, 200);

	}).mold(~numChannels);

	~bassconv = EZConv("/Users/maxlouisraugel/Documents/son/SONS/ /bassdrum_23.wav");

	s.sync;

	~blimp = Ndef(\blimp, {
		var snd, trig, freq, conv;
		trig = Impulse.kr(\density.kr(0.2));
		freq = Demand.kr(trig, 0, Drand([1000, 700, 920, 1200]/2, inf));
		snd = LFSaw.ar(freq) * Env.perc(0.01, 1, 1, 4).kr(0, trig) * 0.1;
		snd = ~bassconv.ar(snd);
		snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.1), LFNoise2.kr(0.7, 0.2, 1), 5, 10);
		snd = Balance2.ar(snd[0], snd[1], 1);
		snd = Pan2.ar(snd, TRand.kr(-0.90, 0.90, trig));
		snd = Limiter.ar(snd.tanh, 0.1);
		snd = FreeVerb2.ar(snd[0], snd[1], 0.5, 3);
		snd = snd * 0.7;
		snd = PanAz.ar(~numChannels, snd.sum, TRand.kr(0, 2.0, trig), 1, 2.0, 0);
	}).mold(~numChannels);


	~vpointsbuf = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/SONS/ /clear ..wav");

	~vpoints = Ndef(\vanishingpoints, {
		var buffer, snd, trig, env;
		trig = Dust.kr(\density.kr(0.1));
		env = Env.perc(0.01, 10).kr(0, trig);
		// buffer = \buffer.kr(d[\thanks][5]);
		buffer = ~vpointsbuf;
		snd = PlayBuf.ar(2, buffer, TRand.kr(2.0, 10.0, trig) * BufRateScale.kr(buffer), trig, 0, 1) * 0.1;
		snd = snd * env * 3 * \amp.kr(1);
		snd = PanAz.ar(~numChannels, snd.sum, TRand.kr(0, 2.0, trig), 1, 2.0, 0);
	}).mold(~numChannels);


	~swooshesbuf = Buffer.read(s , "/Users/maxlouisraugel/Documents/sc/instruments/buffers/coupdevent2.wav");

	s.sync;


	~swooshes = Ndef(\sw, Pbind(\instrument, \playAz, \buffer, ~swooshesbuf, \dur, Pxrand([2, 3, 5] * 2, inf), \rate, Pseq([0.9, 0.7, 0.5], inf) * Pxrand([1, 1.05, 0.93], inf), \pan, Pwhite(0, ~numChannels), \amp, 0.4)).mold(~numChannels);


	~neoformant = Ndef(\neoformant, {
		var snd, lfo, freq1, freq2, stereo;
		lfo = LFNoise2.kr(0.1);
		freq1 = lfo.linexp(-1, 1, 3000, 300).round(77).lag(3);
		freq2 = lfo.exprange(20, 2000).round(77).lag(3);
		stereo = [freq1, freq2];
		snd = NeoFormant.ar(freq1, freq2, LFNoise2.kr(1));
		snd = LPG.ar(snd, Env.perc(3, 3).kr(0, gate: Dust.kr(1)), 0.5, 0.5, 1, 1.1);
		snd = snd + SinOscFB.ar(stereo, lfo.range(0, 1.5));
		snd = snd + VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 1, freq1);
		// snd = snd + VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 1, 100);
		snd = FreeVerb2.ar(snd[0], snd[1], 1, 1, 0);
		snd = SplayAz.ar(~numChannels, snd, 1, 0.04 * \amp.kr(1), lfo.range(2, ~numChannels), lfo.range(0, ~numChannels/2), lfo.range(0, ~numChannels/2) * lfo);
	}).mold(~numChannels);


	SynthDef(\pom, {
		var sound, done, mul;
		mul = Env.perc(\atk.kr(0.01), \rel.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0);
		sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), mul);
		DetectSilence.ar(sound, doneAction:2);
		sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
		sound = RHPF.ar(sound, \hpf.kr(20));
		sound = BPeakEQ.ar(sound, 150, 1, -6);
		// sound = SplayAz.ar(~numChannels, sound, 1, 0.1, ~numChannels);
		// sound = sound.blend(BPeakEQ.ar(sound, \eqf.kr(200), 1, -10), \eqMix.kr(0));
		Out.ar(\out.kr(0), sound)
	}).add;

	SynthDef(\poom, {
		var sound, done;
		sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), Env.perc(\atk.kr(0.01), \rel.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0));
		// DetectSilence.ar(sound, doneAction:2);
		sound = Pan2.ar(sound, \pan.kr(0));
		sound = JPverb.ar(sound, \reverbTime.kr(0.00007), \damp.kr(0));
		sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
		DetectSilence.ar(sound, doneAction:2);
		// sound = SplayAz.ar(~numChannels, sound, 1, 1, ~numChannels);
		// sound = PanAz.ar(~numChannels, sound, 0, 1, \width.kr(~numChannels), 0.5);
		// sound = sound.softclip;
		Out.ar(\out.ar(0), sound)
	}).add;


	SynthDef(\ixxbass, {
		| freq = 110, index  = 10, lpfreq = 500, sindex = 3.84, amp = 0.8, out = 0, gate = 1|
		var o = Pulse.ar(freq),
		e  = \env.kr(Env.newClear(4).asArray),
		ee = EnvGen.kr(e,gate,doneAction:2),
		cf = ee.exprange(55,lpfreq);
		o  = [ o,
			PitchShift.ar(o,0.3,1.0001,1e-4,0.2),
			PitchShift.ar(o,0.3,0.995,1e-4,0.2)
		].sum/3;
		o = o + Pulse.ar(freq/2,0.5,0.1);
		o = o + SinOsc.ar(freq/2,0,0.1);
		o = RLPF.ar(o, cf);
		o = tanh(sin(sindex*o));
		o = GVerb.ar(0.3*o,99,7).mean;
		o = RLPF.ar(o,(4*cf).clip(20,20000));
		o = o + LPF.ar(tanh(4*o),80,1.0);
		3.do { o = HPF.ar(o, 35) };
		o = BLowShelf.ar(o, 110, 1,6.0.neg);
		o = BPeakEQ.ar(o,3169,0.8,7.neg);
		o = Compander.ar(o,o,16.neg.dbamp,1,1/6,0.1,0.2,1.0);
		o = PanAz.ar(~numChannels, o, \pan.kr(0), 1, ~numChannels);
		Out.ar(out, ee*(amp*Limiter.ar(LeakDC.ar(o),0.9)));
	}).add;


	~whiteshaker = Ndef(\whiteshaker, {|freq 10 mul 100|
		var snd, lfo, sine;
		lfo = LFNoise2.kr(0.1);
		sine = SinOsc.ar(freq, 0, mul).unipolar;
		sine = sine * sine.range(\min.kr(20), \max.kr(2000));
		snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
		snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
		// snd = HPF.ar(snd, 500);
		snd = PanAz.ar(~numChannels, snd, lfo.linlin(-1, 1, 0, 2.0), 1, ~numChannels/2);
		snd = snd / (freq/100) / 5 * \amp.kr(1);
		snd = Sanitize.ar(snd);
	}).mold(~numChannels);

	SynthDef("k", {arg out = 0, amp = 0.5, freq = 60, p_env = 5, atk = 0.01, rel = 1;
		var env, snd, ramp;
		env = Env.perc(atk, rel, amp).kr(doneAction: 2);
		ramp = Env([
			freq * p_env,
			freq,
			freq,
			freq * 0.9
		],
		[
			1/100,
			rel/8,
			rel

		]).kr(0);
		snd = SinOscFB.ar(freq: ramp, feedback: \fb.kr(0.0),  mul: env);
		snd = Select.ar(\distortion.kr(0), [snd, snd.clip, snd.tanh, snd.sin, snd.cos, snd.clip2, snd.fold, snd.distort]);
		snd = PanAz.ar(~numChannels, snd, 0, 1, ~numChannels);
		Out.ar(out, snd);
	}).add;


	SynthDef(\percsinefb, {arg out = 0, t_trig = 1, pan = 0, atk = 0.01, rel = 1, curve = -3, amp = 1;
		var sig, env, freq;
		freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		env = Env.perc(atk, rel, 1, curve).kr(2, t_trig);
		sig = SinOscFB.ar(freq, \feedback.kr(1/2));
		sig = LPF.ar(sig, \lpf.kr(2e4));
		// sig = Pan2.ar(sig, pan);
		sig = sig * env * amp;
		Out.ar(out, sig);
	}).add;


	Ndef(\sine, {
		var snd;
		snd = SinOsc.ar(\freq.kr(100), 0, \amp.kr(0.1));
		snd = PanAz.ar(~numChannels, snd, \pan.kr(0), 1, ~numChannels);
	}).mold(~numChannels);

	SynthDef(\percsine, {arg out = 0, t_trig = 1, pan = 0, atk = 0.01, rel = 1, curve = -3, amp = 1;
		var sig, env, freq;
		freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		env = Env.perc(atk, rel, 1, curve).kr(2, t_trig);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = PanAz.ar(~numChannels, sig, pan, 1, ~numChannels);
		sig = sig * env * amp;
		Out.ar(out, sig);
	}).add;

	s.sync;

	CmdPeriod.run;

}
)