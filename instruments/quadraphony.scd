(
Routine.run{

	d = d ?? ~dirt.buffers;

	s.sync;


	w = Array.new;
	~folder = PathName("/Users/maxlouisraugel/Documents/son/w/");

	~folder.entries.do({
		arg path;
		w = w.add(Buffer.read(s, path.fullPath));
	});

	s.sync;

	~armoire = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/armoire.WAV");

	s.sync;



	n = Ndef(\n,
		{
			var snd;
			snd = PinkNoise.ar(LFGauss.kr(\dur.kr(10, 30), LFNoise2.kr(0.3, 0.2, 0.2)).range(0, 0.1));
			snd = PanAz.ar(4, snd, LFNoise2.kr(0.1, 3, 3), 1, 2, 0);
		}
	);

	~buffer = Ndef(\buffer, {
		var snd, buffer;
		buffer = \b.kr();
		snd = PlayBuf.ar(1, buffer, \note.kr(0, \lag.kr(0.0)).midiratio * BufRateScale.ir(buffer), \trigger.kr(1.0), \pos.kr(0) * BufFrames.ir(buffer), \loop.kr(0));
		snd = PanAz.ar(4, snd, \pan.kr(0.0), 1, \width.kr(5.0), 0);
	}).mold(4);

	SynthDef(\play4, {
		var snd, rate, env, envlinen, buffer;
		buffer = \buffer.kr;
		env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
		rate = \rate.kr(1);
		snd = PlayBuf.ar(2, \buffer.kr, BufRateScale.ir(\buffer.kr) * (\note.kr(0).midiratio), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
		snd = Pan4.ar(snd[0], \x.kr(-1), \y.kr(-1));
		snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
		Out.ar(\out.ar(0), snd * env * \amp.kr(1))
	}).add;

	SynthDef(\playAz, {
		var snd, rate, env, envlinen, buffer;
		buffer = \buffer.kr;
		env = Env.linen(\atk.kr(0), \sus.kr(1.0), \rel.kr(3)).kr(2);
		rate = \rate.kr(1);
		snd = PlayBuf.ar(2, \buffer.kr, BufRateScale.ir(\buffer.kr) * (\note.kr(0).midiratio), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
		snd = PanAz.ar(4, snd.sum * 0.5, \pan.kr(0).linlin(0, 4, 0, 2), 1, 2.0, 0);
		snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
		// snd = snd.blend(JPverb.ar(snd), 0.5);
		Out.ar(\out.ar(0), snd * env * \amp.kr(1))
	}).add;

	SynthDef(\playAzComb, {
		var snd, rate, env, envlinen, buffer, done;
		buffer = \buffer.kr;
		env = Env.linen(\atk.kr(0), \sus.kr(1.0), \rel.kr(3)).kr(0);
		rate = \rate.kr(1);
		snd = PlayBuf.ar(2, \buffer.kr, BufRateScale.ir(\buffer.kr) * (\note.kr(0).midiratio), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(0));
		snd = snd.blend(CombC.ar(snd, 0.2, 1/\combfreq.kr(100), \combd.kr(1.0)), \combmix.kr(0.5));
		snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
		snd = PanAz.ar(4, snd.sum * 0.5, \pan.kr(0).linlin(0, 4, 0, 2), 1, 2.0, 0);
		// snd = snd.blend(JPverb.ar(snd), 0.5);
		// TDelay.ar(FreeSelf.kr(snd), 2);
		snd = snd * env * \amp.kr(1);
		DetectSilence.ar(snd, 0.001, 0.1, doneAction:Done.freeSelf);
		Out.ar(\out.ar(0), snd);
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

	SynthDef(\sinesaw_mono, {arg out, pan = 0, gate = 1, legato, atk = 3, rel = 10, amp = 1, curve = 'lin', sawmul = 0.001;
		var sig, sine, saw, env, freq;
		freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
		env = Env.asr(atk, 2, rel, curve).kr(2, gate);
		sine = SinOsc.ar({freq* rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
		saw = LFSaw.ar({freq * rrand(0.99, 1.01)}!3, 0, sawmul);
		sig = sine + saw;
		sig = sig.sum * 0.5;
		Out.ar(out, sig * env * amp);
	}).add;

	SynthDef(\sweep4, {|gate 1|
		var snd, freq, amp;
		freq = \freq.kr(Env.newClear(3).asArray);
		freq = EnvGen.kr(freq, gate, doneAction:2);
		amp = \amp.kr(Env.newClear(3));
		amp = EnvGen.kr(amp, gate);
		snd = SinOsc.ar(freq, 0, amp);
		snd = PanAz.ar(4, snd, \pan.kr(0).linlin(0, 3, 0, 1.5), 1, \width.kr(2.0), 0);
		Out.ar(\out.kr(0), snd);
	}).add;

	~ssaw = Pbindef(\ssaw, \instrument, \sinesaw, \dur, Pseq([1, 2, 1.2], inf), \freq, Pseg([100, 300, 310, 413], [1, 2, 3], 'exp', inf), \x, Pwhite(-1, 1.0), \y, Pwhite(-1, 1.0), \amp, 2);

	~sweeps = Routine.new({{var dur = rrand(0.7, 1.0); Synth(\sweep4, [freq: Env([exprand(20, 2000), exprand(20, 2000)], dur), amp: Env([0, 0.1, 0], [dur/2, dur/2]), pan: rrand(0, 3.0)]); 5.wait;}.loop});


	~pvwhite = Ndef(\pvwhite1, {
		var snd, fft;
		snd = PinkNoise.ar();
		snd = snd * LFGauss.kr(3 * LFNoise2.kr(0.3, 0.5, 1.3).abs).abs;
		// fft = FFT(LocalBuf(2048), snd); snd = PV_MagAbove(fft, 22); snd = IFFT(snd);
		snd = Greyhole.ar(snd, 0.01, 0.7, feedback: 0.1);
		snd = Pan4.ar(snd, FSinOsc.kr(2), FSinOsc.kr(1.2), 0.3);
		snd = (snd * 3).sin;
		// snd = snd.blend(DelayL.ar(GVerb.ar(snd, 3, 3, 0.9), 0.3, 0.3), 0.5);
		snd = HPF.ar(snd, 30);
		snd = Limiter.ar(snd, 0.5) * 0.3;
	}).mold(4);

	~sub = Ndef(\sub, {
	var snd;
	snd = BrownNoise.ar(0.1);
	snd = LPF.ar(snd, \freq.kr(80));
	snd = Pan4.ar(snd) * 5 * \amp.kr(1);
}).mold(4);

	~fib = Ndef(\fib,
		{|density 0.3|
			var snd;
			snd = LFSaw.ar(LFNoise2.kr(0.2, density).abs).lag(0.001);
			snd = BPF.ar(snd, Array.fib(12, \stretch.kr(3), \root.kr(45) * LFNoise2.kr(0.1, \detune.kr(0), 1)), 0.01, 30);
			snd = HighShelf.ar(snd, 2000, 1, 10);
			snd = SplayAz.ar(4, snd);
			// snd = snd.blend(BPF.ar(GVerb.ar(snd, 30, 10, 0.9, drylevel:0)), 0.5); snd = SplayAz.ar(4, snd) * 2;
			snd = snd.blend(LPF.ar(JPverb.ar(snd, density.linlin(0.001, 10, 10, 0.1)), 1000), 0.3) * {LFNoise2.kr(0.3, 0.3, 0.8).abs}!4; snd = SplayAz.ar(4, snd) * 0.5;
			// snd = JPverb.ar(snd, 5)!2;
	}).mold(4).lag(\density, 5);

	// ~trickle = Pbindef(\trickle, \type, \dirt, \dirt, ~dirt, \s, \ml, \n, 1, \attack, 0.01, \release, 0.1, \note, Pseg([0, 0.3, -11, -12, 0], [4, 2, 7, 5]*10, 0, inf) + 2.8 + 60, \begin, 0.1, \end, 0.13, \amp, Pseg([0, 0.5, 0.2, 0.2, 0.5, 0, 0.5, 0], 100!7, 'lin', inf) * 10, \dur, Pseg([0.03, 0.03, 0.1, 0.1, 0.07, 0.12], [3, 3, 2, 2, 4], 0, inf), \pan, Pseg([-1, 1, 0, 1, -1], [1, 2, 1, 3, 2]*50, 0, inf), \lpf, 1000, \legato, Pkey(\dur) * 10);

	~boom = Pbindef(\b, \type, \dirt, \dirt, ~dirt, \s, \wd, \n, Prand([0, 1, 8], inf), \dur, Pwhite(1, 10), \amp, 1/2, \pan, Pwhite(-1/3, 1.0/3), \lpf, 1000, \room, 0.1, \size, 0.9, \speed, Pwhite(0.2, 0.40));

	// ~bells = Ndef(\d, Pbind(\instrument, \playAz, \buffer, d[\bells][3], \dur, Pxrand([0.2, 0.3, 1], inf)/2, \pan, Pwhite(0, 3.0), \note, Pxrand([0, 2, 5], inf) * Pwhite(2, 4) + 7.3, \amp, Pwhite(0, 1.0))).mold(4);

	~bells = Ndef(\d, Pbind(\instrument, \playAz, \buffer, d[\bells][3], \dur, Pxrand([0.2, 0.3, 1], inf)*5, \pan, Pwhite(0, 3.0), \note, Pxrand([ -4.6500422849992, -0.78690514635088, 2.3695077236547, 11.213094853649, 13.481500746329, 14.369507723655, 18.0002609639 ], inf) + 7.3 - 24, \amp, Pwhite(0, 1.0))).mold(4);


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
		));
		PanAz.ar(4, snd.sum, SinOsc.kr(0.1).range(-0.25, 1.25), 1, \width.kr(3.0), 0.5, 0) * \amp.kr(1) * 1.5;
	}).mold(4);


	SynthDef(\pyramid, {| gate 1 x1 -1 x2 1 y1 -1 y2 1 f0 10000 f1 800 f2 100 dur 8|
		var snd, env;
		snd = WhiteNoise.ar(Env([0, 0.2, 0], [dur/2, dur/2]).kr(2));
		snd = BPF.ar(snd, Env([f0, f0, f1, f2, f2], [dur/8, 3*dur/8, 3*dur/8, dur/8], 'exp').kr(2), \rq.kr(1));
		snd = LPF.ar(snd, \lpf.kr(3000));
		snd = Pan4.ar(snd, Env([x1, x1, 0, x2, x2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2), Env([y1, y1, 0, y2, y2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2));
		Out.ar(\out.kr(), snd);
	}).add;

	SynthDef("mkick", {|out|
	var snd, trig, env, freq, disto, sustain;

	freq = \freq.kr(50) * Line.kr(2, [1.01, 0.99], 0.01);
	snd = SinOsc.ar(freq);

	env = Env.perc(0.01, \rel.kr(1.0), 1).kr(2);
	snd = snd * env;

	disto = snd * (\d.kr(0) * 100 + 10);
	disto = Select.ar(\mode.kr(0), [disto.sin, disto.cos, disto.tanh, disto.distort, disto.softclip]);

	snd = snd.blend(disto * 0.2, 0.4);
	snd = LeakDC.ar(snd);
		snd = HPF.ar(snd, \hpf.kr(0));
		snd = BPeakEQ.ar(snd, 62, 10, \brf.kr(0));

	// snd = Balance2.ar(snd[0], snd[1], \pan.kr(0.5) * 2 -1);
		snd = Pan4.ar(snd);
		Out.ar(out, snd * 0.2 * \amp.kr(1));
}).add;




	SynthDef(\pyramidc, {| x1 -1 x2 1 y1 -1 y2 1 f0 10000 f1 800 f2 100 dur 8|
		var snd, env;
		snd = WhiteNoise.ar(Env([0, 0.2, 0], [dur/2, dur/2], 'sine').kr(2));
		snd = CombL.ar(snd, 0.2, 1/\comb.kr(100), \res.kr(1.0));
		snd = GVerb.ar(snd, 3, 3).sum * 0.1;
		snd = Pan4.ar(snd, Env([x1, x1, 0, x2, x2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2), Env([y1, y1, 0, y2, y2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2));
		snd = Limiter.ar(snd * 0.5, 0.5);
		Out.ar(\out.kr(), snd);
	}).add;

	SynthDef(\cpyramid, {| x1 -1 x2 1 y1 -1 y2 1 f0 10000 f1 800 f2 100 dur 8|
		var snd, env, fenv;
		snd = WhiteNoise.ar(Env([0, 0.2, 0], [dur/2, dur/2], 'sine').kr(2));
		fenv = Env([f0, f0, f1, f2, f2], [dur/8, 3*dur/8, 3*dur/8, dur/8], 'exp').kr(2);
		snd = CombL.ar(snd, 0.2, 1/fenv, \res.kr(1.0));
		snd = snd.blend(GVerb.ar(snd, \groom.kr(3), 3).sum * 0.1, \gverb.kr(0));
		snd = Pan4.ar(snd, Env([x1, x1, 0, x2, x2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2), Env([y1, y1, 0, y2, y2], [dur/8, 3*dur/8, 3*dur/8, dur/8]).kr(2));
		snd = Limiter.ar(snd * 0.5, \limit.kr(0.1));
		Out.ar(\out.kr(), snd);
	}).add;


	SynthDef(\stkSaxofony4,{arg out=0, rel = 0.1, freq=220,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
		var sig,env;
		env = EnvGen.kr(Env.asr(0,1,rel),gate,doneAction:2);
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
		sig = PanAz.ar(4, sig, \pan.kr(0).linlin(0, 3, 0, 1.5)) * 1.3;
		Out.ar(out, sig);
	}).add;

	SynthDef(\stkBowed4,{arg out=0,freq=220,rel =0.1,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
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
		sig = PanAz.ar(4, sig, \pan.kr(0).linlin(0, 3, 0, 1.5), 1, \width.kr(2));
		Out.ar(out, sig);
	}).add;





	~cpyramid = Pbindef(\cpyramid, \instrument, \cpyramid, \x1, Pwhite(1, 0.70), \x2, Pwhite(-1, -0.70), \y1, Pwhite(1, 0.90), \y2, Pwhite(-1, -0.70), \f0, Pwhite(2000, 20000), \f1, Pwhite(200, 2000), \f2, Pwhite(20, 200), \dur, Pwhite(10, 20), \res, 1);




	SynthDef(\epyramid, {| gate 1|
		var snd, env;
		env = Env.newClear(8).asArray;
		snd = WhiteNoise.ar(EnvGen.kr(\ampe.kr(env), gate, doneAction:2));
		snd = BPF.ar(snd, EnvGen.kr(\freqe.kr(env), gate), \rq.kr(1));
		snd = Pan4.ar(snd, EnvGen.kr(\x.kr(env), gate), EnvGen.kr(\y.kr(env), gate));
		Out.ar(\out.kr(0), snd);
	}).add;


	// asymmetric bounces and chord

	SynthDef(\fml4, {
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
		car = PanAz.ar(4, car * 0.5, \pan.kr(0).linlin(0, 3, 0, 1.5), 1, \width.kr(2.0), 0);
		Out.ar(out, car);
	}).add;

	~p1 = Ndef(\p1, Pbind(\instrument, \playAz,  \buffer, d[\dx7][0], \note, Pseq([7, 4, 0], inf), \dur, Pseq([1, 0.5, 1.5], inf), \pan, Pwhite(0, 3.0), \rel, 1, \amp, 1/4)).mold(4);
	~p2 = Ndef(\p2, Pbind(\instrument, \playAz, \buffer, d[\dx7][0], \note, Pseq([5, 10, 12], inf), \dur, 1, \pan, Pwhite(0, 3.0), \rel, 1, \amp, 1/4)).mold(4);
	~p3 = Ndef(\p3, Pbind(\instrument, \playAz, \buffer, d[\dx7][7], \note, Pseq([8, 12, 13], inf), \dur, Pseq([1, 1/3, 2/3], inf), \rel, 1, \pan, Pwhite(0, 3.0), \amp, 1/4)).mold(4);

	~buzz = Ndef(\buzz, {var snd; snd = LFSaw.ar({LFNoise2.kr(LFNoise2.kr(0.3, 1, 2), 3, 100)}!4, 0, 0.1); snd = BPF.ar(snd, LFNoise2.kr(0.3, 300, 600), 0.1) * 2; snd = JPverb.ar(snd); snd = BPeakEQ.ar(snd, {LFSaw.ar(rrand(0.10, 0.130)).exprange(20, 20000)}!4, 0.5, 10); snd = BRF.ar(snd, 300, 2)};).mold(4);

	~washes = Ndef(\washes, {
		var snd, tide;
		tide = LFGauss.ar(duration: 10, width: 0.1).range(-1, 1.0);
		snd = WhiteNoise.ar(0.1);
		snd = LPF.ar(snd, 7000);
		snd = snd * tide.range(0, 1);
		snd = Pan4.ar(snd, 0, tide);
		// snd = Pan4.ar(snd, 0, LFSaw.kr(1/3).range(-1, 1.0).lag(0.1));
		snd = snd.blend(JPverb.ar(snd, 10), 0.4);
		snd = LPF.ar(snd, 4000);
	}).fadeTime_(10);


	// FX

	~magAbove = {|in| var snd, fft; fft = FFT(LocalBuf(2048), Splay.ar(in)); snd = PV_MagAbove(fft, \threshold.kr(2)); Pan4.ar(IFFT(snd)) * \gain.kr(1);};

	~freeverb = {|in| FreeVerb.ar(in, \verb.kr(0.33), \room.kr(0.5), \damp.kr(0.5)) * 1.1};

	~jpverb = {|in| JPverb.ar(in)};

	~nhhall = {|in| NHHall.ar(in, \time.kr(1))};

	~greyhole = {|in| var snd; snd = in.blend(Greyhole.ar(in, 0), \greyhole.kr(0.5)); snd = PanAz.ar(4, snd.sum * 0.7, LFNoise2.kr(0, 1.5), 1)};

	~pitch = {|in| var snd; snd = PitchShift.ar(in, 0.2, \pitch.kr(1.0))};

	~panAz = { |in| var snd; snd = PanAz.ar(4, in.sum * 0.5, \pan.kr(0.5) * LFNoise2.kr(0.3, \drift.kr(3)).abs, 1, \width.kr(2.0))};

	~smear = {|in| var snd; snd = FFT(LocalBuf(2048), in); snd = PV_MagSmear(snd, \smear.kr(0.1)) ; snd = IFFT(snd); snd = Pan4.ar(snd.sum)};

	~bpfgeom = {|in| var snd; snd = BPF.ar(in, Array.geom(10, \start.kr(20), \grow.kr(1.1)), \rq.kr(0.1)); snd = Pan4.ar(snd.sum, 0, 0, \amp.kr(5));};



	~fb = Ndef(\fb, {
		var in, snd, fft;
		in = SoundIn.ar([0]);
		snd = in * \gain.kr(10);
		snd = Normalizer.ar(in, \norm.kr(1));
		snd = FreeVerb.ar(in, \verb.kr(0.33), \room.kr(0.5));
		snd = PitchShift.ar(in, 0.2, \pitch.kr(0.9) * LFNoise2.kr(0.3, \detune.kr(0.02), 1));
		fft = FFT(LocalBuf(2048), snd); snd = PV_BrickWall(fft, \bw.kr(0.01)) ; snd = IFFT(snd);
		snd = Normalizer.ar(snd); snd = Limiter.ar(snd, 0.9);
		snd = PanAz.ar(4, snd, \pan.kr(0) + (1 * LFNoise2.kr(0.3).range(0, \space.kr(2.0))), 1, \width.kr(2), orientation: 0);
	});

	~lfnoise2 = Ndef(\lfnoise2, {LFNoise2.kr(\lfreq.kr(0.3)).range(\min.kr(0), \max.kr(1))}).mold(2, 'kr');


	~sinespulse = Ndef(\sinespulse, {
		var snd, freq;
		freq = {exprand(20, 10000).round(10)}!30 * {LFNoise2.kr(\modspeed.kr(0.1, 0.1), \rrange.kr(0.1,0.1), 1)};
		snd = SinOsc.ar(freq, 0, 0.02);
		snd = snd * LFPulse.ar({exprand(0.01, 3.0)}!30 * \speed.kr(1, 0.1)).lag(\soft.kr(0.01));
		// snd = BPF.ar(snd, freq * 2, 0.5);
		snd = LPF.ar(snd, 3000).tanh;
		snd = PanAz.ar(4, snd, {rrand(0, 3.0)}!30) * 1;
	}).mold(4).fadeTime_(3);

	~fibpulses = Ndef(\fibpulses, {
		var snd, freq;
		freq = \freq.kr({Array.fib(13, 100, 2).choose}!8) * {LFNoise2.kr(0.1, 0.01, 1)};
		snd = SinOsc.ar(freq * SinOsc.ar(freq, 0, 10), 0, 0.02);
		snd = snd * LFPulse.ar({exprand(0.1, 3.0)}!4).lag(\soft.kr(0.01));
		snd = BPF.ar(snd, freq * 2, 0.5);
		snd = PanAz.ar(4, snd, (0..3)) * 2;
	}).mold(4).fadeTime_(3);

	~foursaw = Ndef(\foursaw, {|rate 0.1|
		var snd, freq;
		freq = {LFNoise2.kr(rate, 3, LFNoise2.kr(rate, 100, 300))}!4;
		snd = LFSaw.ar(freq, 0, 0.1);
		snd = BPF.ar(snd, {LFNoise2.kr(rate, 300, 600)}!4, 0.1);
		snd = BPeakEQ.ar(HPF.ar(snd, 300) * 2, 5000, 1.0, 10);
		snd = BRF.ar(snd, 200, 10) * 2;
	}).mold(4).fadeTime_(10);

	~dc = Ndef(\dc, {
		var snd;
		snd = SinOsc.ar(SinOsc.ar(200 * LFGauss.kr(30, 0.1).range(1, {LFNoise2.kr(0.1, 0.1, 1)}!4), 0, 1, SinOsc.ar(300, 0, 10, 10)), 0, 1);
		snd = Limiter.ar(snd, 1);
	}).mold(4);


	~sinpi = Ndef(\sinpi,
		{var snd, fft;
			snd = LFSaw.ar(\freq.kr(100, \lag.kr(0)), 0, 0.2);
			snd = PitchShift.ar(snd, 0.2, \pitch.kr(2.0, \lag.kr(0)));
			fft = FFT(LocalBuf(2048), snd); fft = PV_MagAbove(fft, \threshold.kr(2)); snd = IFFT(fft);
			snd = snd.blend(JPverb.ar(snd), 1);
			snd = Pan4.ar(snd.sum, \x.kr(0, \lag.kr(0.0)), \y.kr(0, \lag.kr(0.0))) * \amp.kr(0.1);
			snd = LPF.ar(snd, 8000);
	}).fadeTime_(3).mold(4);

	~perc = Ndef(\perc, {
		var snd, trig, freq;
		trig = Impulse.kr(1);
		freq = XLine.kr(8, 1, 0.01) * \freq.kr(2000, 10);
		snd = SinOsc.ar(freq + [0, 13, 8, 10]);
		snd = snd * Env.perc().kr(0, trig) * 0.1/3;
		// snd = PanAz.ar(4, snd.sum, \pan.kr(0, 10), 1, \width.kr(2.0, 10));
	}).mold(4);

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
		snd = PanAz.ar(4, snd.sum, \pan.kr(0.5), 1, 3.0, 0.5);
		snd = snd * Env([0, 1, 1, 0], [\atk.kr(0.1), \sus.kr(7), \rel.kr(5)], 'sine').kr(2);
		Out.ar(out, snd);
		// Out.ar(out, snd.lag(0.01) * 10);
	}).add;

	~vibes = Ndef(\vibes, Pbind(\instrument, \vibes, \atk, 0.5, \dur, Pseq((5!5)++10, inf), \freq, Pseq([152, 190, 138, 162, 120, 152], inf), \pan, Pwhite(0, 2.0))).mold(4);

	~vibesB = Ndef(\vibesB, Pbind(\instrument, \k, \dur, Pseq((5!5)++10, inf), \rel, 5, \freq, Pseq([152, 190, 138, 162, 120, 152, 152, 190, 210, 200, 120, 152]/2, inf), \pan, Pwhite(0, 2.0), \amp, 0.3)).mold(4);

	SynthDef(\percsine, {arg out = 0, t_trig = 1,  atk = 0.01, rel = 1, curve = -3, amp = 1, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = PanAz.ar(4, sig, \pan.kr(0).linlin(-1, 1, 0, 3), amp, \width.kr(2.0));
		sig = sig * env;
		Out.ar(out, sig);
	}).add;

	SynthDef(\percsinefb, {arg t_trig = 1,  atk = 0.01, rel = 1, curve = -3, amp = 1, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = PanAz.ar(4, sig, \pan.kr(0).linlin(1, 4, -0.25, 1.25), amp, \width.kr(2.0));
		sig = sig * env;
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\percsinefb_mono, {arg  atk = 0.01, rel = 1, curve = -3, amp = 1, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		env = Env.perc(atk, rel, 1, curve).kr(2, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = sig * env;
		Out.ar(\out.kr(0), sig * amp);
	}).add;


	SynthDef(\percsine_mono, {arg t_trig = 1,  atk = 0.01, rel = 1, curve = -3, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
		freq = XLine.kr(\freq.kr(100) * 16, \freq.kr(100), 0.01);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = sig * env * \amp.kr(1);
		Out.ar(\out.kr(0), sig);
	}).add;



	SynthDef(\psine, {arg out = 0, t_trig = 1,  atk = 0.01, rel = 1, curve = -3, amp = 1, dur = 1;
		var sig, env, freq;
		// freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \curve.kr(0));
		freq = \freq.kr(100);
		env = Env.perc(atk, rel, 1, curve).kr(2, gate: t_trig, timeScale:dur);
		sig = SinOsc.ar(freq);
		sig = LPF.ar(sig, \lpf.kr(2e4));
		sig = PanAz.ar(4, sig, \pan.kr(0).linlin(0, 3, 0, 1.5), amp, \width.kr(2.0));
		sig = sig * env;
		Out.ar(out, sig);
	}).add;

	~filaments = Ndef(\filaments, {SplayAz.ar(4,
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
	)}!10)});

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
			1/50,
			rel/8,
			rel

		]).kr(0);
		snd = SinOscFB.ar(freq: ramp, feedback: \fb.kr(0.0),  mul: env);
		snd = Pan2.ar(snd);
		Out.ar(out, snd);
	}).add;

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

	~wsamples = Pbindef(\wsamples, \instrument, \playAz, \buffer, Pxrand(50.collect{|i| w[i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 2, \pan, Pwhite(0, 3.0), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1);


	SynthDef(\pom, {
		var sound, done, mul;
		mul = Env.perc(\atk.kr(0.01), \rel.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0);
		sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), mul);
		DetectSilence.ar(sound, doneAction:2);
		sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
		sound = RHPF.ar(sound, \hpf.kr(20));
		sound = BPeakEQ.ar(sound, 150, 1, -6);
		sound = Pan4.ar(sound);
		// sound = sound.blend(BPeakEQ.ar(sound, \eqf.kr(200), 1, -10), \eqMix.kr(0));
		Out.ar(\out.kr(0), sound)
	}).add;

	~wpyramid = Pbindef(\pyramid, \instrument, \pyramid, \x1, Pwhite(-1, 1), \x2, Pwhite(-1, 1).poll, \y1, Pwhite(-1, 1), \y2, Pwhite(-1, 1), \f0, Pwhite(20, 20000), \f1, Pwhite(100, 10000), \f2, Pwhite(20, 20000), \dur, Pwhite(10, 40), \amp, 0.03);


	~tabble = Ndef(\pom, {|tempo=1.0, envdur=0.91, comb 0 feedback 1.1 midinotes #[ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ] transpose #[0.5, 1.0, 1.5]|
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
		PanAz.ar(4, sig, TChoose.kr(trig, [0, 1, 2, 3]).linlin(-0.25, 1.75, 0, 3), 1, \width.kr(2.0), 0.5) * \amp.kr(1);
		// ReplaceOut.ar(sig, 0));
	}).mold(4).quant_(1).lag(\comb, 100, \tempo, 100, \feedback, 100, \midinotes, 30, \transpose, 30, \amp, 30);


	~shifts = Ndef(\shifts, {
		var snd;
		snd = SinOsc.ar(\freq.kr([330, 370, 1900, 3100], \lag.kr(3)), 0, 0.1);
	}).mold(4);

	a = Ndef(\air, {|lag 10|
		var air, bass, snd;
		air = BrownNoise.ar({LFNoise2.kr(0.3, 0.02, 0.08).abs * \air.kr(1, 10)}!4); air = LPF.ar(air) * 3;
		air = BPeakEQ.ar(air, 50, 5, 15);
		snd = SplayAz.ar(4, air, 1, 1, 2, LFNoise2.kr(0.1).range(0, 1));
		snd = snd.blend((BPF.ar(snd, LFNoise2.kr(0.1).exprange(100, 200) * \height.kr(1, 10), \rq.kr(0.01, 10), 30)*3).cos, \avion.kr(0, 30));
		snd = Limiter.ar(snd * 0.9, \limit.kr(0.9, 10));
		snd = HPF.ar(snd, \hpf.kr(30));
		snd = snd * \amp.kr(1);
	}).mold(4).fadeTime_(10);


	 ~broken = Ndef(\broken, {
		var air, bass, snd, trig, broken;
		// air = BrownNoise.ar(0.1); air = LPF.ar(air) * 2;
		air = BrownNoise.ar({LFNoise2.kr(0.3, 0.02, 0.08)}!4);
		snd = LPF.ar(air) * 3;
		bass = LFNoise2.ar(100);
		bass = LPF.ar(bass, 100);
		bass = BPeakEQ.ar(bass, 80, 1, 10);
		snd = air + bass;
		snd = HPF.ar(snd, 100);
		snd = snd.blend(InsideOut.ar(snd, 1), 0.1).lag(0.01);
		snd = SplayAz.ar(4, snd, 1, 1, 2, LFNoise2.kr(0.3).range(0, 1));
		snd = Limiter.ar(snd);
		trig = Dust.kr(2);
		broken = snd * Env.perc(0.01, 0.2).kr(0, trig); broken = PanAz.ar(4, broken.sum, TRand.kr(-0.25, 1.75, trig), 1, 2, 0);
		broken = BPeakEQ.ar(broken, 5000, 10, 30); broken = BRF.ar(broken, 200, 10) * 2;
		broken = BPeakEQ.ar(broken, 10000, 10, 10);
		broken = broken.blend(CombC.ar(broken, 0.2, 1/10), 0.2);
	}).mold(4).fadeTime_(0);


	h = Ndef(\harmonic1, {
		var snd;
		snd = HarmonicOsc.ar(\freq.kr(1000, 10) * {LFNoise2.kr([0.3, 0.2], 0.1, 1)}!4, 1, Array.exprand(16, 0.001, 0.001));
		snd = Pan4.ar(snd.sum, LFNoise2.kr(0.3), LFNoise2.kr(0.3)) * 2;
		snd = BPF.ar(snd, {LFNoise2.kr(0.3, 500, 700)}!3, 0.2);
		snd = FreeVerb.ar(snd, 0.5, 0.9) * 10;
		snd = PitchShift.ar(snd, 0.2, \pitch.kr(1.05, 10), \rndpitch.kr(0, 10), \time.kr(0.1, 10));
	}).fadeTime_(10).mold(4).lag(\amp, 10, \rndpitch, 10, \time, 10);

	~harmonic = Ndef(\harmonic, {
		var snd;
		snd = HarmonicOsc.ar(\freq.kr(1000, 1) * {LFNoise2.kr([0.3, 0.2], 0.1, 1)}!4, 1, Array.exprand(16, 0.001, 0.001));
		snd = Pan4.ar(snd.sum, LFNoise2.kr(0.3), LFNoise2.kr(0.3)) * 2;
		snd = BPF.ar(snd, {LFNoise2.kr(0.3, 500, 700)}!3, 0.2);
		snd = FreeVerb.ar(snd, 0.5, 0.9) * 10;
		snd = PitchShift.ar(snd, 0.2, \pitch.kr(1.05, 1), \rndpitch.kr(0, 0.1), \time.kr(0.1, 1));
		snd = Normalizer.ar(snd, * 0.1) * \amp.kr(1, 0.1);
	}).fadeTime_(1).mold(4);


	g = Ndef(\gauss, {
		var snd;
		snd = SinOsc.ar(200 * LFGauss.kr(30, 0.1).range(1, {LFNoise2.kr(0.1, 0.1, 1)}!4), 0, 0.05) * LFSaw.kr(LFNoise2.kr(3).abs).abs.lag(0.01);
	}).fadeTime_(10).mold(4);

	p = Ndef(\p, Pbind(\instrument, \percsine, \freq, Pwhite(2000, 210!2), \dur, 8, \rel, 0.1, \pan, [0, 1, 2, 3], \amp, Pwhite(0.1, 0.2!4))).fadeTime_(30).mold(4);


	u = Ndef(\u, {var snd, nchans;
		nchans = 4;
		snd =
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(\minfreq.kr(20), \maxfreq.kr(20000)),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, nchans)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
		)}!nchans;
		snd = snd * \amp.kr(0.2);
	}).mold(4);





	s.sync;

	CmdPeriod.run;

}
)