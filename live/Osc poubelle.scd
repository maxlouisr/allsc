(
SynthDef(\blosc, {|freq #[100, 1000] mul 1|
	var snd, lfo, sine, env;
	env = Env.linen(\atk.kr(30), 0, \rel.kr(30)).kr(2);
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	snd = FreqShift.ar(snd, freq);
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100);
	// snd = XFade2.ar(snd, JPverb.ar(snd, 0.01, 07), \wet.kr(-0.7));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1));
}).add;
)

//


(
var fade = 30;~blosc.release(fade);
// 480, 500, 1100, 100, 320, 100, 230
~blosc = {|freq 100 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo/1.5);
	// snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) / 2 * \amp.kr(1);
}.play(s, 0, fade);
)

~blosc.set(\min, Ndef(\sine), \max, Ndef(\major), \waveform, Ndef(\lfnoise))



(
var fade = 30;~blosc.release(fade);
// 480, 500, 1100, 100, 320, 100, 230
~blosc = {|freq 100 mul 1|
	var snd, lfo, sine, env;
	env = Env.perc(\atk.kr(50), \rel.kr(50)).kr(2);
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100);
	snd = XFade2.ar(snd, JPverb.ar(snd, 0.01, 07), \wet.kr(0));
}.play(s, 0, fade);
)

(
var fade = 30;
~blosc.release(fade);
// 480, 1100, 100
~blosc = {|freq 100 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3)!2;
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(2), \max.kr(200));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	snd = HPF.ar(snd, 30);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 2 * \amp.kr(1);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = XFade2.ar(snd, JPverb.ar(snd, 0.01, 07), \wet.kr(0));
}.play(s, 0, fade);
)

(
var fade = 30;~blosc.release(fade);
// 480, 500, 1100, 100, 320, 100, 230
~blosc = {|freq 100 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo/2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) / 2 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 10;~blosc.release(fade);
// 480, 500, 1100, 100, 320, 100, 230
~blosc = {|freq 1030 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) * 2 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 0;
Synth(\percsine, [freq: 50]);
~blosc.release(fade);
// 480, 500, 1100, 100, 320, 100, 230
~blosc = {|freq 490 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	// snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) / 2 * \amp.kr(1);
}.play(s, 0, fade);
)



w = Synth(\blosc, [freq: 1030, atk: 30, rel: 30]);


// Synth(\blosc, [freq: 250, amp: 0.5])

// Synth(\blosc, [freq: 380])

y = Synth(\blosc, [freq: 1200, atk: 30, rel: 30])

z = Synth(\blosc, [freq: 380 * 3, atk: 30, rel: 30])

(
var freq = 500;
// Synth(\sine, [freq: freq, atk: 100, rel: 100, amp: 0.3]);
Synth(\blosc, [freq: freq])
)

(
var fade = 1;
~blosc.release(fade);
// 480, 1100, 100
~blosc = {|freq 1000 mul 1|
	var snd, lfo, sine, env;
	// env = Env.perc(1, 3, 1, 10).kr(2);
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq * LFNoise2.ar(0.3, 0.001, 0.0015), 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	snd = HPF.ar(snd, 50);
	snd = BRF.ar(snd, 500);
	snd = BPeakEQ.ar(snd, 50, 0.5, 6);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 4), 1, 0.2);
	snd = snd / (freq/100) * \amp.kr(2);
}.play(s, 0, fade);
)


(
var freqgeom = #[100, 150, 170];
var rhythm = {SinOsc.ar(3)};
var grow = 1.7;

var fade = 30;
~swap.release(fade);
~swap2.release(fade);

~swap = {
	|freq 100|
	var snd;
	snd = SinOsc.ar(LFNoise2.ar(0.1, 0.01, 1) * freq, 0, 0.1);
	snd = snd * (snd / (rhythm * LFNoise2.ar(0.3, 0.01, 1)));
	snd = Compander.ar(snd, 1, 0.5);
	snd = BPF.ar(snd, Array.geom(10, freqgeom, grow), 0.01, 20).tanh/10;
	// snd = BPF.ar(snd, Array.geom(10, 100, 1.3), 0.1, 0.5);
	// snd = Limiter.ar(snd, 0.7);
	snd = Splay.ar(snd);
}.play(s, 0, fade);

~swap2 = {
	|freq 100|
	var snd;
	snd = SinOsc.ar(LFNoise2.ar(0.1, 0.01, 1) * freq, 0, 0.1);
	snd = snd * (snd / rhythm * LFNoise2.ar(0.3, 0.01, 1));
	snd = ComplexRes.ar(snd, Array.geom(10, freqgeom,grow * 2), 0.1).tanh;
	// snd = BPF.ar(snd, Array.geom(10, 100, 1.3), 0.1, 0.5);
	// snd = Limiter.ar(snd, 0.7);
	snd = Splay.ar(snd, 1, 0.3, 0.7);
}.play(s, 0, fade);
)


(
var fade = 30; ~whiteshaker.release(fade);
// 480, 1100, 100, 320, 100, 230
~whiteshaker = {|freq 10 mul 100|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo/2);
	snd = snd / (freq/100) / 5 * \amp.kr(1);
}.play(s, 0, fade);
)


(
var fade = 30; ~blosc.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc = {|freq 1 mul 100|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 0.5, 0.1, 0.7).tanh;
	snd = HPF.ar(snd, 50);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 10 * \amp.kr(1);
}.play(s, 0, fade);
)


(
Pdef(\crackle,
	Pbind(\instrument, \blosc,
		\freq, Pseq([100!5, 1!5].flatten, inf),
		\mul, Pseq(Array.geom(10, 0.001, 1.5), inf),
		\dur, Pseq((Array.geom(10, 1, 1.5)/10).mirror, inf),
		// \dur, Prand([1, 2, 5]/5, inf),
		\atk, 0.01,
		\rel, Pkey(\dur) / 5,
		\amp, 1
	)
).play;
)

Pdef(\crackle).stop;


(
var fade = 30;
~swap.release(fade);
~swap2.release(fade);
)


















(
var fade = 30;
~blosc.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc = {|freq 30 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) / 10 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 30;~blosc.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc = {|freq 30 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1 * LFNoise2.ar(0.3, 0.3, 1)), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100) / 2 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 10;~blosc.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc = {|freq 30 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 10 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 1;~blosc2.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc2 = {|freq 10 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 0.5, 0.1, 0.7).tanh;
	snd = HPF.ar(snd, 50);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 10 * \amp.kr(1);
}.play(s, 0, fade);
)

(
~swap.release(30);
~swap2.release(30);
)



(
var fade = 10; ~blosc2.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc2 = {|freq 20 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul, 0);
	sine = sine * sine.range(\min.kr(20), \max.kr(20000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 0.5, 0.1, 0.7).tanh;
	snd = HPF.ar(snd, 100);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 50 * \amp.kr(1);
}.play(s, 0, fade);
)

(
var fade = 3; ~blosc3.release(fade);
// 480, 1100, 100, 320, 100, 230
~blosc3 = {|freq 20 mul 1|
	var snd, lfo, sine;
	lfo = LFNoise2.kr(0.3);
	sine = VarSaw.ar(freq, 0, 0.5, mul, 0);
	sine = sine * sine.range(\min.kr(20), \max.kr(20000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 0.5, 0.1, 0.7).tanh;
	snd = HPF.ar(snd, 50);
	snd = Pan2.ar(snd, lfo / 2);
	snd = snd / (freq/100) / 50 * \amp.kr(1);
}.play(s, 0, fade);
)



(
x.release;
x = Synth(\blosc, [freq: 100, amp: 0.3])
)