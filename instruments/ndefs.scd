// General specs

Spec.add(\amp, [0.0, 5.0, \lin, 0.0, 0.1]);
Spec.add(\min, [0.0, 10000, \lin, 0, 0]);
Spec.add(\max, [0.0, 20000, \lin, 0, 2]);
Spec.add(\pos, [0.0, 1.0, \lin, 0, 0]);

(
Routine.run{

	~jpverb_bus = ~jpverb_bus ?? Bus.audio(s, 2);

	s.sync;

	// ~jpverb = Synth(\jpverb, [in: ~jpverb_bus, time: 0.00007, damp: 0, mix: 1, out: 0], s, 'addToTail');
	~jpverb = Ndef(\jpverb, {JPverb.ar(In.ar(~jpverb_bus), \time.kr(0.00007), \damp.kr(0))}).play;


}
);



// (
// Ndef(\u, {var snd;
// 	snd = Splay.ar(
// 		{
// 			SinOsc.ar(LFNoise0.kr(1).exprange(\minfreq.kr(20), \maxfreq.kr(20000)),
// 				mul: Env(
// 					[0, 1, 0, 0],
// 					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, 3)],
// 					-1
// 				).circle.kr(2)
// 				* Line.kr(0, 0.5, 0)
// 	)}!3);
// 	// snd = HighShelf.ar(snd, 10000, 1, -6);
// });
// );

(
Ndef(\u, {var snd;
	snd = Splay.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(\minfreq.kr(20), \maxfreq.kr(20000)),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
	)}!3);
	// snd = HighShelf.ar(snd, 10000, 1, -6);
});
);


(

~drone1 = Ndef(\drone1, {
	var snd, lfo, freq1, freq2, stereo, freq;
	freq = \freq.kr(#[70, 200], 0);
	lfo = LFNoise2.kr(0.01);
	freq1 = lfo.linexp(-1, 1, 3000, 300);
	freq2 = lfo.exprange(20, 2000);
	// stereo = [freq1, freq2];
	snd = NeoFormant.ar(freq, freq, LFNoise2.kr(1));
	snd = snd + SinOscFB.ar(freq, lfo.range(0, 1.5), 1);
	snd = snd + (VarShapeOsc.ar((lfo.abs).reciprocal, lfo.abs, lfo.abs, 0.1, [ 50, 59 ].midicps) * 1);
	// snd = LPF.ar(FreeVerb2.ar(snd[0], snd[1], 1, 1, 0), \lpf.kr(2e4, 10));
	// snd = XFade2.ar(snd, JPverb.ar(Splay.ar(snd), 1, 0, modDepth: 1, modFreq: lfo.abs / 2 + 0.7), -0.5);
	snd = Splay.ar(snd);
	snd = JPverb.ar(snd, 1, 0, modDepth: lfo.range(0.3, 1.2), modFreq: lfo.abs / 2 + 0.7);

	snd = BPeakEQ.ar(snd, 100, 1, -10);

	snd = snd * \amp.kr(0.1);

	snd = Pan2.ar(snd, 0, 0.8);
	// snd = PanAz.ar(~numChannels, snd, 0, 1, 2.0, 0.5);
	snd = RLPF.ar(snd, \lpf.kr(20000, 0.3), \lpq.kr(0.5, 0.3));
	snd = HPF.ar(snd, 200);
	snd = Limiter.ar(snd.tanh, 1);
}).mold(~numChannels);

);


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

~wobl = Ndef(\wobl, {
	var mod = SinOsc.kr(0.1);
	var asr = Env([0, 1, 1, 0], [0.1, {Rand(1/2, 1.0)}, 0.1], 'lin').kr(0, Dust.kr(0.1));
	var sig = ZOsc.ar(
		freq: LFNoise2.kr(10).exprange(10.0,100.0),
		formantfreq: LFNoise2.kr(1).exprange(70,1000),
		shape: mod,
		mode: SinOsc.kr(0.91)
	);
	sig = BRF.ar(sig, SinOsc.kr(1).range(100, 1000), 10);
	sig = Pan2.ar(sig.tanh * asr, mod, 1/2);
	// sig = Splay.ar(sig, SinOsc.kr(0.7).abs);
});

~ht = Ndef(\high_tilts, {
	var sig, scale, arp, env, trig, asr;
	trig = Impulse.kr(10);
	scale = Array.interpolation(5, 100, 2001);
	arp = TChoose.kr(trig, scale / 2);
	asr = Env([0, 1, 1, 0], [0.01, {Rand(1, 6)}, 0.1], 'lin').kr(0, Dust.kr(0.1));
	env = Env.perc(0.01, 0.3, 2).kr(0, trig);
	sig = VarShapeOsc.ar(
		freq: arp * arp / 10 + 10000,
		pw: 0.9,
		waveshape:0.4,
		sync: 1,
		syncfreq: arp
	);
	Pan2.ar(sig * env * asr, TRand.kr(-1, 1.0, trig), 2);
});



~tabble = Ndef(\table, {|tempo=1.0, envdur=0.91, comb 0 feedback 1.1 midinotes #[ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ] transpose #[0.5, 1.0, 1.5]|
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
	Pan2.ar(sig, 0.5*TRand.kr(-1.0,1.0,trig)) * \amp.kr(0.4);
}).mold(2).lag(\comb, 100, \tempo, 100, \feedback, 100, \midinotes, 30, \transpose, 30, \amp, 30);

/*~neoformant = {
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
};*/

~neoformant = Ndef(\neoformant, {
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
	snd = Pan2.ar(snd, 0, 0.04 * \amp.kr(1));
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
	PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1)) * \amp.kr(1);
});


~whiteshuffle = Ndef(\whiteshuffle, {Splay.ar(
	WhiteNoise.ar(
		Saw.kr(freq:{LFNoise1.kr(1).range(0.01,1)}!5, mul:0.1)
))});

/*~moan1 = Ndef(\moan1, {
var snd, buffer;
buffer = \buffer.kr({rrand(0, 100)}!3);
snd = PlayBuf.ar(1, buffer, {LFNoise2.kr(0.3).range(7, 20)}!3, 1, 0, 1);
snd = Splay.ar(snd, 10);
// snd * Env.perc(0.01, 0.5).kr(0, Impulse.kr(LFNoise2.kr(0.3, 10, 10))) * 0.6;
snd = BPF.ar(snd, LFNoise2.kr(0.3).exprange(3000, 10000), 0.7, 0.1);
snd = snd * 5;
});

~theaterkicks = Pbind(\instrument, \kick, \freq, 66, \dur, Pseq([1/3], {rrand(2, 5)}), \amp, 1/2);

~resnare1 = Ndef(\resnare1, { |pan 0 freq 200|
var trig = Dust.kr(0.3);
var snare = AnalogSnareDrum.ar(
trig, freq: freq, decay: TRand.kr(0.1,0.5,trig)
);

var sig = Resonator.ar(
input: snare,
freq: TExpRand.kr(25.0,250.0,trig),
position: 0.0,
resolution: 24,
structure: SinOsc.kr(0.01).unipolar,
brightness: SinOsc.kr(0.01, 0.5*pi).unipolar * 0.5,
damping: TRand.kr(0.2,0.8, trig)
);

// Limiter
sig = sig.tanh;

Pan2.ar(sig, TRand.kr(-1, 1.0, trig));
});

~squine = Ndef(\squine, {|freq 100 clip 0 skew 0.0 sync 0.0 amp 0.5 iminsweep 0 initphase 1.25 pan 0|
var snd;
snd = Squine.ar(freq: freq * {LFNoise2.kr(0.3!3).range(0.99, 1.01)}, clip: clip * SinOsc.ar(freq, 0, 1, freq), skew: skew, sync: sync, mul: amp, add: 0,iminsweep: iminsweep, initphase: initphase);
snd = Splay.ar(snd);
snd = FreeVerb2.ar(snd[0], snd[1], \mix.kr(0), \room.kr(1))
// snd = Pan2.ar(snd, pan);
}).mold(2);*/

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
)}!10)});




















Ndef(\whitenoise, {WhiteNoise.ar(0.2)!2});

Ndef(\sine, {SinOsc.ar(\freq.kr(100), 0, \amp.kr(0.1))});

Ndef(\varsaw, {VarSaw.ar(\freq.kr(100), \iphase.kr(0), \width.kr(0.5), \amp.kr(0.2))});

Ndef(\bowed, {arg amp=1, bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, bowvelocity = 100, loudness=128, pan = 0.5;
	var sig, freq;
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	sig = StkInst.ar(
		Stk.at("Bowed"),
		\freq.kr(100),
		1,
		1,
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
			100,
			bowvelocity,
			128,
			loudness

	]);
	sig = Pan2.ar(sig, pan) * amp;
});

(
	Ndef(\blip, {var snd = Blip.ar(\freq.kr(100), \harms.kr(5), 0.1);
		snd = Pan2.ar(snd, \pan.kr)
	});
);


// changed BufDur to BufFrames.kr
~play = Ndef(\play, {PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.kr(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufFrames.kr(\buffer.kr), \loop.kr(0), \doneaction.kr(2))});


~wsamples = Pbindef(\wsamples, \instrument, \play, \buffer, Pxrand(50.collect{|i| d[\w][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1, \pan, Pwhite(-1, 1.0));


/*~allsamples = Pbindef(\allsamples, \instrument, \play, \buffer, Pxrand(50.collect{|i| d[\alluntitled][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1);*/

// ~lsamples = Pbindef(\lsamples, \instrument, \play, \buffer, Pxrand(19.collect{|i| d[\l][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5] * 2, inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1);

~seizedec = Pbindef(\seizedec, \instrument, \play, \buffer, Pxrand(d[\16].size.collect{|i| d[\16][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5] * 2, inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 2);



~iter2 = Ndef(\iter2, {
	arg freq = 200, dev = 1.02;
	var temp, sum;
	sum = 0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
});



// requiring buffers

~swooshes = Ndef(\sw, Pbind(\instrument, \play, \buffer, d[\coupdevent][0], \dur, Pxrand([2, 3, 5] * 3, inf), \rate, Pseq([0.9, 0.7, 0.5], inf) * Pxrand([1, 1.05, 0.93], inf), \pan, Pwhite(-1, 1.0), \amp, 0.5));

// ~blimp = Ndef(\blimp, {
// 	var snd, trig, freq, conv;
// 	trig = Impulse.kr(\density.kr(0.2));
// 	freq = Demand.kr(trig, 0, Drand([1000, 700, 920, 1200]/2, inf));
// 	snd = LFSaw.ar(freq) * Env.perc(0.01, 1, 1, 4).kr(0, trig) * 0.1;
// 	snd = ~bassconv.ar(snd);
// 	snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.1), LFNoise2.kr(0.7, 0.2, 1), 5, 10);
// 	snd = Balance2.ar(snd[0], snd[1], 1);
// 	snd = Pan2.ar(snd, TRand.kr(-0.90, 0.90, trig));
// 	snd = Limiter.ar(snd.tanh, 0.1);
// 	snd = FreeVerb2.ar(snd[0], snd[1], 0.5, 3);
// 	snd = snd * 0.7;
// }).mold(2);

~vpoints = Ndef(\vanishingpoints, {
	var buffer, snd, trig, env;
	trig = Dust.kr(0.1);
	env = Env.perc(0.01, 10).kr(0, trig);
	buffer = \buffer.kr(d[\thanks][5]);
	snd = PlayBuf.ar(2, buffer, TRand.kr(2.0, 10.0, trig) * BufRateScale.kr(buffer), trig, 0, 1) * 0.1;
	snd = Balance2.ar(snd[0], snd[1], TRand.kr(-0.7, 0.7, trig));
	snd = snd * env * 1.7 * \amp.kr(1);
}
);

~cdglitchs = Ndef(\trip, {var lfo, snd;
	lfo = LFNoise2.kr(1);
	snd = MiPlaits.ar(lfo.exprange(50, 300), lfo.range(0, 4), lfo.abs, lfo.abs, lfo.abs);
	// snd = snd + WhiteNoise.ar(0.03);
	snd = CDSkip.ar(snd, 2, 1);
	snd = Limiter.ar(snd, 0.1);
	snd = snd * TChoose.kr(Dust.kr(0.1), [0, 1])
});