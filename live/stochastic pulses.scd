(
x.release;
x = { var snd, freq, amp, trig;
	trig = Dust.kr(3);
	// trig = Impulse.kr(TChoose.kr(trig, [0.1, 0.2, 0.7, 1.2, 2.8, 7.4, 10]));
	freq = Env({exprand(1, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	// snd = Pan2.ar(snd, amp);
	snd = Resonator.ar(snd, Array.fib(10, 10, 50)/2, damping: 0.1);
	// snd = Resonator.ar(snd, Array.fib(10, 10, 50) * LFNoise2.kr(0.1, 0.1, 1), damping: amp.linlin(0, 1, 0, 0.3));
	snd = BPF.ar(snd, Array.fib(10, 10, 50)/2, 0.1, 10);
	snd = Splay.ar(snd, 1, 3, LFNoise0.kr(1));
	snd = Normalizer.ar(snd, 0.5);	snd = Limiter.ar(snd);
}.play;
)


(
y.release;
y = { var snd, freq, amp, trig, arp;
	trig = Dust.kr(0.3);
	// trig = Impulse.kr(Demand.kr(Impulse.kr(1), 1, Drand([0.5, 0.2, 1, 1.3], inf)));
	// trig = TChoose.kr(trig, [0.5, 1, 1.1]);
	freq = Env({exprand(50, 60)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = MiTides.ar(freq, amp, 0.9, 1, 3, trig, 0, 2, 1, 9, 1, mul: amp);
	// snd = BPF.ar(snd, freq, 0.3, 10);
	// snd = snd + MiBraids.ar(freq, timbre: 1, color: 1, model:42, trig: trig, resamp: 0, decim: 0, bits:0, ws: 1, mul: amp);
	snd = Balance2.ar(snd[0], snd[1], amp, 0.2);
	snd = Limiter.ar(snd * 5);
}.play;
)

(
z.release;
z = { var snd, freq, amp, trig;
	trig = Dust.kr(2);
	freq = Env({exprand(30, 60)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	// models 42, 33, 46, 39?
	snd = MiBraids.ar(freq, timbre: 1, color: 1, model:42, trig: trig, resamp: 0, decim: 0, bits:0, ws: 1, mul: amp);
	snd = Pan2.ar(snd, amp.linlin(0, 1, -1, 1), 0.3);
	snd = BPF.ar(snd, freq, 0.3, 10);
}.play;
);

p.stop; p = Pbind(\instrument, \percsine, \dur, 1, \note, Pseq([\Am, \Em, \B, \B].chordProg, inf), \amp, 1).play;



(
a.release;
a = { var snd, freq, amp, trig;
	trig = Dust.kr(3);
	freq = Env({exprand(30, 40)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	// models 42, 33, 46, 39?
	snd = MiBraids.ar(freq, timbre: 1, color: 1, model:46, trig: trig, resamp: 0, decim: 0, bits:0, ws: 1, mul: amp);
	snd = Pan2.ar(snd, amp.linlin(0, 1, -1, 1), 0.3);
	// snd = BPF.ar(snd, freq, 0.3, 10);
	snd = Limiter.ar(snd * 5);
}.play;
)

-----

(
b.release;
b = { var snd, freq, amp, trig, freq_res;
	trig = Dust.kr(1);
	freq = Env({exprand(20, 90)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	// snd = BPF.ar(snd, freq, 0.3, 10);
	snd = Pan2.ar(snd, amp);
	snd = Resonator.ar(snd, freq_res, damping: 0.1);
	snd = Pluck.ar(snd, trig, 0.2, 1/(freq), 1);
	snd = FreeVerb.ar(snd, 0.3, 1, 0.99, 1);
	snd = snd * 30;
}.play;
)

(
b.release;
b = { var snd, freq, amp, trig, freq_res;
	trig = Dust.kr(3);
	freq = Env({exprand(20, 90)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	// snd = BPF.ar(snd, freq, 0.3, 10);
	snd = Pan2.ar(snd, amp);
	snd = Resonator.ar(snd, freq_res, damping: 0.1);

	snd = FFT(LocalBuf(2048/4, 2), snd);
	snd = PV_BinScramble(snd, 0.9, 0.1, trig);
	snd = IFFT(snd).dup;
	// snd = WhiteNoise.ar(snd);
	snd = Pluck.ar(snd, trig, 0.2, 1/(freq*2), 1);
	snd = FreeVerb.ar(snd, 0.3, 1, 0.99, 1);
	snd = snd * 30;
	// snd = snd * WhiteNoise.ar(5);
}.play;
)

(
c.release;
c = { var snd, freq, amp, trig, freq_res;
	trig = Dust.kr(0.3);
	freq = Env({exprand(1, 20)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 200)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	snd = Pan2.ar(snd, amp);
	// snd = Resonator.ar(snd, freq_res, 1, 24, 0.5, brightness: 0.4, damping: 0.5);
	snd = Resonator.ar(snd, freq_res, brightness: 0.5, damping: 0.1);
	snd = BPeakEQ.ar(snd, 7000, 1, 20);
	snd = FFT(LocalBuf(2048, 2), snd);
	snd = PV_Freeze(snd, freq.linlin(1, 20, -1, 1));
	snd = IFFT(snd).dup;
	snd = BPeakEQ.ar(snd, freq * 4, 0.1, 50);
	// snd = CombC.ar(snd, 0.2, [0.4, 0.3], 0.4);
	snd = Normalizer.ar(snd, [0.02, LFNoise2.kr(0.3).range(0.01, 0.03)]);
	// snd = XFade2.ar(snd, FreeVerb.ar(snd), LFNoise2.kr(0.3).range(-1, 0));
	// snd = snd / SinOsc.ar(44099, 0, 1);
	snd * 5;
}.play;
)


(
a.release;
a = { var snd, freq, amp, trig, freq_res;
	trig = Dust.kr(1);
	// trig = Impulse.kr(EaseOutAtan.kr(1, 2));
	freq = Env({exprand(20, 90)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	snd = Resonator.ar(snd, freq_res, damping: 0.1);
	snd = BPeakEQ.ar(snd, 7000, 1, 20);
	snd = FFT(LocalBuf(2048, 2), snd);
	snd = PV_BinScramble(snd, 0.4, TChoose.kr(trig, [0.0001, 0.01]), trig);
	snd = IFFT(snd).dup;
	snd = Pan2.ar(snd, amp.linlin(0, 1, -1, 1.0));
	// snd = CombC.ar(snd, 0.2, 1/(freq * 32), 0.01);	snd * 0.3;
	// snd = snd + SinOsc.ar(freq, 0, Amplitude.kr(snd).lag(0.1) * 2);
}.play;
)

(
x.release;
x = { var snd, freq, amp, trig, freq_res;
	trig = Dust.kr(3);
	freq = Env({exprand(20, 90)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	// snd = Pan2.ar(snd, amp);
	// snd = Resonator.ar(snd, freq_res, damping: 0.1);
	snd = BPeakEQ.ar(snd, 7000, 1, 20);
	snd = FFT(LocalBuf(2048), snd);
	snd = PV_BrickWall(snd, LFNoise2.kr(1, 0.5, 0.7).abs);
	snd = IFFT(snd);
	snd = Pan2.ar(snd, amp);
	snd * 30;
}.play;
)

(
z.release;
z = { var snd, freq, amp, trig, freq_res, buffer;
	buffer = C.get(\bassdrums, 30);
	// buffer = 100;
	// buffer= ~dirt.buffers[\bd][0];
	trig = Dust.kr(3);
	freq = Env({exprand(20, 90)}!10, ({rrand(0, 10)}!9).normalizeSum * 10, 'exp').kr(0, trig);
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = PlayBuf.ar(1, buffer, freq.cpsmidi.midiratio * BufRateScale.kr(buffer), trig, 0, loop:0, doneAction:0) * 0.1;
	// snd = Pan2.ar(snd, amp);
	// snd = Resonator.ar(snd, freq_res, damping: 0.1);
	snd = BPeakEQ.ar(snd, 7000, 1, 20);
	snd = FFT(LocalBuf(2048), snd);
	snd = PV_MagAbove(snd, 1.4);
	snd = IFFT(snd);
	snd = Pan2.ar(snd, amp);
	// snd = RLPF.ar(snd, LFNoise2.kr(0.3).exprange(200, 2000), 0.1);
	// snd = MoogFF.ar(snd, freq * 8);
	// snd = RLPF.ar(snd, freq * 2, 0.1);
	snd = snd * Env.linen(0.3, 1, 0.3).kr(0, Dust.kr(1));
	snd * 3;
}.play;
)

SuperDirt



(
a.release;
a = { var snd, pitch, amp, trig;
	trig = Dust.kr(0.2);
	pitch = Env({LFNoise2.kr(0.01).exprange(30, 40)}!10, ({LFNoise2.kr(0.1).abs}!9).normalizeSum, 'exp').kr(0, trig);
	pitch = TChoose.kr(trig, [57, 59, 60, 47]).poll;
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	// models 42, 33, 46, 39?
	snd = MiBraids.ar(pitch, timbre: 1, color: 1, model:42, trig: trig, resamp: 0, decim: 0, bits:0, ws: 1, mul: amp);
	snd = Pan2.ar(snd, amp.linlin(0, 1, -1, 1), 0.3);
	snd = XFade2.ar(snd, JPverb.ar(snd, 5), 0);
	snd = snd * 5;
}.play;
);

c = "Users/maxlouisraugel/Documents/ /toum.wav".b;
(
y.release;
y = {var snd; snd = PlayBuf.ar(2, c, 1 * BufRateScale.kr(c), Impulse.kr(1/c.duration), doneAction:0); snd = PitchShift.ar(snd, 0.01, TChoose.kr(Impulse.kr(1/(c.duration * 16)), [1, 1.2, 1.5])); snd = HPF.ar(snd, 100); snd*2}.play;
)

// (
// y.release;
// y = {var snd; snd = PlayBuf.ar(2, c, 1 * BufRateScale.kr(c), Impulse.kr(1/c.duration), doneAction:0); snd = PitchShift.ar(snd, 0.01, TChoose.kr(Impulse.kr(1/(c.duration * 16)), [1, 1.2, 1.5])); snd = snd * 3; snd = BPeakEQ.ar(snd, 100, 1, -12); LPF.ar(snd, 5000)}.play;
// )

(
z.release;
z = { var snd, freq, amp, trig, freq_res, arp;
	trig = Dust.kr(0.02);
	trig = Dust.kr(Env([1, 0.3], 10, 'lin').kr(0, trig));
	// trig = Env([1, 0.3], 10, 'lin').kr(0, Dust.kr(0.2));
	// trig = Dust.kr(trig);
	arp = Demand.kr(trig, 0, Dseq([0.5, 1, 2], inf));
	freq = Env({LFNoise2.kr(0.01).exprange(20, 90/*TChoose.kr(trig, [30, 9000])*/)}!10, ({LFNoise2.kr(0.01).range(0, 1)}!9).normalizeSum, 'exp').kr(0, trig) * arp;
	freq_res = Env({exprand(50, 300)}!10, ({rrand(0, 10)}!9).normalizeSum, 'exp').kr(0, trig);
	amp = {Env([0]++({rrand(0, 1)}!8)++[0], ({rrand(0, 10)}!9).normalizeSum).kr(0, trig)};
	snd = LFPulse.ar(freq, 0, 0, amp);
	snd = Resonator.ar(snd, freq_res * arp, damping: 0.1);
	snd = BPeakEQ.ar(snd, 7000, 1, 20);
	snd = FFT(LocalBuf(2048), snd);
	snd = PV_MagGate(snd, 10, 0.1);
	snd = IFFT(snd);
	snd = RLPF.ar(snd, 800, 0.1);
	snd = Pan2.ar(snd, amp.linlin(0, 1, -1, 1));
	snd = Normalizer.ar(snd, 0.2);
}.play;
)



(
Pbindef(\1, \instrument, \play, \buffer, C.get(\thanks, 8), \pos, PSinOsc(0.302, 0, 0.1, 1) * PSinOsc(0.301, 0, 0.1, 1) * 0.88, \dur, 0.05, \amp, 1/3).play;

Pbindef(\2, \instrument, \play, \buffer, C.get(\thanks, 3), \pos, PSinOsc(0.302, 0, 0.1, 1) * PSinOsc(0.301, 0, 0.1, 1) * 0.88, \dur, 0.05, \amp, 5).play;
)

(
Pbindef(\1).stop;
Pbindef(\2).stop;
)

(
~sin.release(5);
~sin = {var snd; snd = SinOsc.ar(440); snd * SinOsc.ar(401) * 0.1}.play;
)

(
~sin.release(30);
~sin = {var snd; snd = SinOsc.ar(440); snd = snd * SinOsc.ar(420) + (snd * LFNoise2.ar(219, 0.2)) * 0.05; snd!2}.play;
)

(
~sin.release(30);
~sin = {var snd; snd = SinOsc.ar(440 * 32); snd = snd + (snd * LFNoise2.ar(219, 0.2)) * 0.05 * LFPulse.ar(10).lag(0.01); snd!2}.play;
)

Pbindef(\3, \instrument, \play, \dur, 1, \buffer, C.get(\thanks, 6), \pos, {rrand(0, 0.1/5)}!50, \amp, {rrand(0, 0.50)}!50, \strum, 0, \pan, 0).play(quant: 1);

Pbindef(\3, \instrument, \play, \dur, 1, \buffer, C.get(\thanks, 6), \pos, Pfunc({{rrand(0, 0.1/5)}!50}), \amp, {rrand(0, 0.50)}!50).play(quant:1);

Pbindef(\3, \instrument, \play, \dur, 1/5, \buffer, Pwrand(C.get(\snares, [10, 50]), [0.9, 0.1], inf), \pos, Pfunc({{rrand(0, 0.1/5)}!50}), \amp, {rrand(0, 0.50)}!50, \pan, 0).play(quant:1);

Pbindef(\3, \instrument, \play, \dur, 1, \buffer, C.get(\thanks, 6), \pos, {rrand(0, 0.1)}!50, \amp, {rrand(0, 0.50)}!50, \strum, Pwrand([0, 0.1, 0.11, 0.9], [0.1, 0.3, 0.3, 0.3], inf), \pan, Pwhite(-1, 1.0)).play;

Pbindef(\3).clear;





{var buffer, snd; buffer = C.get(\bassdrums, 4); snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.kr(buffer), doneAction:2); snd = Normalizer.ar(snd, 0.5);}.play;

Pbind(\instrument, \percsine, \dur, Pn(8, 1), \rel, 3, \note, 0, \amp, 1/2).play;


b = "Users/maxlouisraugel/Documents/ /raspy wooden orb.wav".b;

{var snd; snd = PlayBuf.ar(2, b, 1/2 * BufRateScale.kr(b)); snd = PitchShift.ar(snd, 1, [1, 1.1, 1.5, 0.5].choose)}.play;

c = "Users/maxlouisraugel/Documents/ /toum.wav".b;
(
z.release(10);
z = {var snd; snd = PlayBuf.ar(2, c, TChoose.kr(Impulse.kr(1/(c.duration * 16)), [1, 1.2, 1.5]) * BufRateScale.kr(c), Impulse.kr(1/c.duration), doneAction:0)}.play;
)

(
a.release;
a = {|freq 100 amp 0.3| var snd; snd = SinOsc.ar(freq, 0, amp) * LFNoise2.ar(freq, amp); snd = snd * 3; snd!2}.scope
)


