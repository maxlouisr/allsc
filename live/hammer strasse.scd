Buffer.freeAll
s.reboot;

(
~basseabstraite = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /bass abstraite.wav");
~cleartick = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /cleartick ..wav");
~verrenote = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /verre note.wav");
~verrenote = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /verre note.wav");
~rambardemicrotactile = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/rambarde micro tactile.wav");
~basslighttick = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /basslighttick ..wav");
~declicbassriche = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /declic bass riche x.wav");
)

NdefMixer(s)

(
~analogsnare.release(1);
~analogsnare = {
	var snd, trig;
	trig = Dust.kr(0.2);
	snd = AnalogSnareDrum.ar(trig, 0, 0.1, \freq.kr(200, 6), 0.1, 0.3, 0.5);
	// snd = LPF.ar(snd, \cutoff.kr(100, 1000));
}.play(fadeTime: 1);

~analog1.release(1);
~analog1 = {var snd, trig;
	trig = Dust.kr(0.2);
	snd = AnalogBassDrum.ar(trig, 0, 0.5, \freq.kr(53, 3) - LFNoise2.ar(0.3, 0).abs, 0.5, 3, 0.5, 3)!2;
	snd = BPeakEQ.ar(snd, 50, 1, 30) * 3;
	snd = LPF.ar(snd);
}.play(fadeTime: 1);
)

(
~analogsnare.release(30);
~analog1.release(30);
)

(
Ndef(\play).copy(\basseabstraite).set(\buffer, ~basseabstraite, \loop,1);

Ndef(\basseabstraite).play(fadeTime: 30);
)

x = Synth('wavering', [atk: 100])


Ndef(\play).copy(\verrenote).set(\buffer, ~verrenote);



(
{
	var root = 2;

	Ndef(\verrenote).set(\rate, root).send.play(vol: 0.5);
	0.2.wait;
	// Synth('hh', [freq: root * 16 * 16 * 16 * 4]);
	x.set(\freq, root * 1000);
	x.set(\amp, 2)
}.fork
)

Routine.run{Ndef(\verrenote).set(\rate, 2).send.play(vol: 1); x.set(\amp, 0)}

Ndef(\play).copy(\cleartick).set(\buffer, ~cleartick);


Synth(\poom, [atk: 0.1, freq: 57, cutoff: 500]);

Pbindef(\now, \instrument, \sinesaw, \dur, Prand([3, 5], inf), \freq, Pxrand([57, 50, 47], inf), \rel, Pkey(\dur), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

Synth(\percsine, [amp: 0.2, rel: 2]);
Ndef(\cleartick).set(\rate, 1).send.play(vol: 1);



(
Ndef('rumble', 'bassbynathan').set(\freq, 100);
Ndef('rumble').play(fadeTime:30, vol: 0.1);
);

Ndef('rumble').stop(30);





/*Ndef('rumble').fadeTime = 10;
Ndef('rumble').xset(\amp, 0.05)*/


(
~pluck.release(30);
~pluck = {
	var snd, trig;
	trig = Dust.kr(1);
	snd = PlayBuf.ar(2, ~basslighttick, 1, trig);
	snd = Pluck.ar(snd, trig, 0.2, 1/\freq.kr(100), 3, \coef.kr(0.9), \freq.kr(100)/100 * 100 * \amp.kr(1));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(3))
}.play(fadeTime:30);
)


// ~pluck.set(\freq, rrand(20, 200));


(
~pluckelastic.release(0);
~pluckelastic = {
	var snd, trig, freq;
	trig = Dust.kr(1);
	snd = PlayBuf.ar(2, ~cleartick, 1, trig);
	freq = Tartini.kr(snd, 0.93);
	snd = Pluck.ar(snd, trig, 0.2, 1/freq, 1, 0.8);
	// snd = Pluck.ar(snd, trig, 0.2, 1/freq, 1, 0.8) / (freq[1] + 0.001);
	snd = Limiter.ar(snd, 0.5)
}.play(fadeTime: 10);
)

Ndef(\basseabstraite).stop(30)

Ndef('rumble').stop(20)

x.release(10);


(
Synth(\percsine, [freq: 1000, \rel, 0.3]);
Ndef('rumble').stop(0);
~plucktear.free;
~plucktear = {
	var snd, trig, freq, hasFreq;
	trig = Dust.kr(\density.kr(30));
	snd = PlayBuf.ar(2, ~verrenote, MouseY.kr(0.5, 2), trig);
	# freq, hasFreq = Tartini.kr(snd, 0.93);
	freq[0].poll;
	snd = Pluck.ar(snd, trig, 0.2, 1/freq, 1, 0.3) * freq[1];
	snd = Limiter.ar(snd, 0.5);
	snd = Balance2.ar(snd[0], snd[1], -1);
	snd = Pan2.ar(snd.sum, 0);
}.play(fadeTime: 0);
)

~plucktear.set(\density, 30)


Synth(\poom, [freq: (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10] + [12, 24, 36]).midicps.choose, atk: 1, rel: 7, amp: 0.5]);

// following tartini poll?

(
var freq = 1000;
Synth(\poom, [freq: freq, atk: 1.5, rel: 7]);
// ~pluck.set(\freq, freq / 6)
)

x.release(30)

(
var freq = 1000;
Synth(\poom, [freq: freq, atk: 5, rel: 5]);
Synth(\poom, [freq: freq / 2, atk: 5, rel: 5, amp: 0.3]);
Synth(\poom, [freq: freq / 4, atk: 5, rel: 5, amp: 0.3]);
// Synth(\poom, [freq: freq / 8, atk: 3, rel: 9, amp: 0.3]);
// Synth(\poom, [freq: freq / 16, atk: 4, rel: 10, amp: 0.3]);
// ~pluck.set(\freq, freq / 6)
)


(
~pluck1.release(5);
~pluck1 = {
	var snd, trig;
	trig = Dust.kr(0.3);
	snd = PlayBuf.ar(2, ~basslighttick, LFNoise2.kr(30)/2 + 1, trig);
	snd = Pluck.ar(snd, trig, 0.2, 1/\freq.kr(100), 3, \coef.kr(0.9), \freq.kr(100)/100 * \amp.kr(150));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(3))
}.play;

~pluck2.release(5);
~pluck2 = {
	var snd, trig;
	trig = Dust.kr(0.3);
	snd = PlayBuf.ar(2, ~basslighttick, LFNoise2.kr(30)/2 + 1, trig);
	snd = Pluck.ar(snd, trig, 0.2, 1/\freq.kr(100) * LFNoise2.ar(3).range(0.7, 1.3), 3, \coef.kr(0.9), \freq.kr(100)/100 * \amp.kr(150));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(3))
}.play;
)





(
~declic.release(1);
~declic = {
	var snd, trig;
	trig = Dust.kr(\density.kr(0.1));
	// snd = PlayBuf.ar(2, ~declicbassriche, {Rand(1, 1.1)}!2, trig,/* MouseX.kr(0, 1) * ~declicbassriche.numFrames*/);
	snd = PlayBuf.ar(2, ~declicbassriche, 1 * BufRateScale.ir(~declicbassriche), trig);
	snd = Balance2.ar(snd[0], snd[1], MouseX.kr(-1, 1));
	// snd = FreeVerb.ar(snd, Line.kr(0.00001, 0.1, ~declicbassriche.duration));
	// snd = JPverb.ar(snd, 0.01, 0.3, 0.1)
}.play;
)

~plucktear.release(30)

~pluck.release(10)
x.release(30)

C.crawl;
C.p(\one, seed: rrand(0, 1000), index: Pxrand([4]++(6..9)++[13,14], inf).poll, dur: Prand([1, 2, 5]*5, inf));
// C.p(\one, seed: rrand(0, 1000), index: Pwhite(0, 300).poll, dur: Prand([1, 2, 5]*5, inf));
C.s(\one)

YES 14

Not 2, 10

(
~basshops.release(1);
~basshops = {
	var snd, trig, verb, source;
	trig = Dust.kr(0.3);
	source = PlayBuf.ar(2, ~basslighttick, 1 * BufRateScale.ir(~basslighttick), trig).softclip;
	snd = source * LFPulse.kr(LFNoise2.kr(3).abs).unipolar;
	snd = Mono(snd);
	snd = LinPan2.ar(snd, LFSaw.kr(1));
	snd = XFade2.ar(source, snd, LFNoise2.kr(0.3));
	snd = BRF.ar(snd, 300);
	// snd = Limiter.ar(snd, 1/2);
	snd = LPF.ar(snd, 50);
	// snd = XFade2.ar(JPverb.ar(snd, 0.0001), snd, LFNoise2.kr(0.3));
}.play(fadeTime: 1);
)

(
~pluck1.release(10);
~pluck2.release(10);
~basshops.release(10);
)


(
~clearbumble.release(30);
~clearbumble = {
	var trig, snd, freqs;
	trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 10));
	freqs = (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10] + [-12, 0, 12, 24]).midicps;
	snd = Pluck.ar(Hasher.ar(Sweep.ar(trig)) * -10.dbamp, trig, freqs.reciprocal, freqs.reciprocal, 0.9, 0.5);
	snd = LeakDC.ar(snd).sum;
	snd = MoogFF.ar(snd, LFNoise2.kr(1).linexp(-1, 1, 500, 16000), 0);
	// snd = CombC.ar(snd, 0.2, (freqs * 1).reciprocal, 0.1) / 3;
	snd = snd ! 2;
	snd;
}.play(outbus: 0, fadeTime: 100);
)



(
~effa.release(30);
~effa = {
	var trig, snd, freqs;
	trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 0.1, 1));
	freqs = (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10] + [-12, 0, 12, 24]).midicps;
	snd = Pluck.ar(Hasher.ar(Sweep.ar(trig)) * -10.dbamp, trig, freqs.reciprocal, freqs.reciprocal, LFNoise2.kr(0.5).range(2, 5), \coef.kr(0.5));
	snd = LeakDC.ar(snd).sum;
	snd = MoogFF.ar(snd, LFNoise2.kr(0.3).linexp(-1, 1, 5000, 12000), 0);
	snd = BRF.ar(snd, 200);
	snd = CombC.ar(snd, 0.2, (freqs * 1).reciprocal, 0.1) / 3;
	snd = snd ! 2;
	snd = XFade2.ar(JPverb.ar(snd, 1, 0.9), snd, LFNoise2.kr(0.3));
	snd;
}.play(outbus: 0, fadeTime: 100);
)



Synth(\poom, [freq: (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10] + [-12, 0, 12, 24, 36]).midicps.choose, atk: 1, rel: 7, amp: 0.5])



(
~clearbumble.release(3);
~clearbumble = {
	var trig, snd, freqs;
	trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 10));
	freqs = (60.5 + [0, 2, 4, 5, 7, 9, 10] + [-12, 0, 12, 24]).midicps;
	snd = Pluck.ar(Hasher.ar(Sweep.ar(trig)) * -10.dbamp, trig, freqs.reciprocal, freqs.reciprocal, 0.9, 0.5);
	snd = LeakDC.ar(snd).sum;
	snd = MoogFF.ar(snd, LFNoise2.kr(1).linexp(-1, 1, 500, 16000), 0);
	snd = CombC.ar(snd, 0.2, (freqs * 1.2).reciprocal, 0.1) / 3;
	snd = snd ! 2;
	snd;
}.play(outbus: 0, fadeTime: 3);
)


Synth(\poom, [freq: (60.5 + [0, 2, 4, 5, 7, 9, 10] + [-12, 0, 12, 24]).midicps.choose, atk: 1, rel: 7, amp: 0.5]);


(
~clearbumble.release(3);
~clearbumble = {
	var trig, snd, freqs;
	trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 10));
	freqs = (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10] + [-12, 0, 12, 24]).midicps;
	snd = Pluck.ar(Hasher.ar(Sweep.ar(trig)) * -10.dbamp, trig, freqs.reciprocal, freqs.reciprocal, 0.9, 0.5);
	snd = LeakDC.ar(snd).sum;
	snd = MoogFF.ar(snd, LFNoise2.kr(1).linexp(-1, 1, 500, 16000), 0);
	// snd = CombC.ar(snd, 0.2, (freqs * 1).reciprocal, 0.1) / 3;
	snd = snd ! 2;
	snd;
}.play(outbus: 0, fadeTime: 3);
)

// Synth(\poom, [freq: (60.5 + ([0, 2.2, 4.7, 5.1, 7, 9.9, 10]!2).flatten + [-12, 0, 12, 24, 36]).midicps.choose, atk: 1, rel: 7, amp: 0.5])

Synth(\poom, [freq: (60.5 + [0, 2.2, 4.7, 5.1, 7, 9.9, 10]+ [-12, 0, 12, 24, 36]).midicps.choose, atk: 1, rel: 7, amp: 0.5]);




// modulate 'synthetic' param + 'amp'

(
~fakeriver.release(30);
~fakeriver = {|speed 10|
	var snd, trig;
	trig = Dust.kr(speed);
	snd = WhiteNoise.ar(0.1);
	snd = CombC.ar(snd, 10, 1/LFSaw.kr(speed).range(100, 200), \synthetic.kr(0.2), 0.1).dup * \amp.kr(3);
	snd = BPF.ar(snd);
}.play(s, 0, 30);
)


(
~bass.release(5);
~bass = {
	var snd, freq;
	freq = 60.5.midicps/4;
	snd = PMOsc.ar(freq, freq, SinOsc.kr(0.03).unipolar, SinOsc.kr(0.03, 0.3).unipolar, \amp.kr(1/4) * LFNoise2.kr(0.1, 0.2, 0.8))!2;
	snd = JPverb.ar(snd);
}.play(0, s, 3);
)


~basshops.release;

(
~effa.release(100);
~clearbumble.release(100);
~declic.release(30);
)

~bass.release(30);


(
~splashes.release(10);
~splashes = {|density 0.5|
	var snd, trig;
	trig = Dust.kr(density);
	snd = BrownNoise.ar(0.1);
	snd = Pluck.ar(snd, trig, 10, 1/LFSaw.kr(10).range(100, 200), 10, 0.9) * 5;
	snd = Pan2.ar(snd, LFNoise2.kr(1, 0.5))
}.play(0, s, 3);
)

~fakeriver.release(30);


(
~twiddle.release(30);
~twiddle = {
	arg mratio=4, amp=1, boost=2, index = 0.5;
	var env, freqenv, freq, trig, sig;
	trig = Dust.kr(1);
	sig = PlayBuf.ar(2, ~cleartick, 1, trig);
	// sig = trig;
	sig = FreqShift.ar(sig, LFNoise2.kr(15).range(100, 10000));
	sig = XFade2.ar(sig, JPverb.ar(sig, 1, mid: 0.3, high: 0.3) / 5, LFNoise2.kr(0.3));
	sig = Balance2.ar(sig[0], sig[1], LFNoise2.kr(1));
	sig = LPF.ar(sig, 500) * 50;
}.play(fadeTime: 1);
)


(
~summum.release(30);
~summum = {
    arg mratio=4, amp=1, boost=2, index = 10000;
    var env, freqenv, freq, trig, sig;
	trig = Impulse.ar(LFNoise2.kr(0.3, \density.kr(1)).abs);
    env = Env.perc(0.0001, 1.0, curve: -8).ar(0, trig);
    freqenv = Env.perc(0.0001, 0.4, curve: -8).ar(0, trig);
	freq = 16;
    freq = freq * freqenv.linexp(0, 1, 1, \slide.kr(40));
    sig = SinOsc.ar(freq, SinOsc.ar(freq * mratio) * index);
	sig = LPF.ar(sig, \cutoff.kr(20000));
	sig = FreqShift.ar(sig, \freqshift.kr(1));
    (sig!2 * boost).tanh * env * 0.2 * amp;
}.play(fadeTime: 30);
)

~summum.set(\mratio, 4, \boost, 2, \index, 0.5);

(
~pluck1.release(3);
~pluck2.release(3);
)

~pluckelastic.release;

~basshops.release;

C.pp(\one, \dur, Prand([1, 2, 5], inf))



(
~twiddle2.release(30);
~twiddle2 = {
	arg mratio=4, amp=1, boost=2, index = 0.5;
	var env, freqenv, freq, trig, sig, rate;
	trig = Dust.kr(0.3);
	rate = Demand.kr(trig, 1, Drand([0.4, 0.2, 0.6], inf));
	sig = PlayBuf.ar(2, ~cleartick, rate, trig);
	sig = FreqShift.ar(sig, LFNoise2.kr(1).range(100, 500));
	sig = XFade2.ar(sig, JPverb.ar(sig, 1, mid: 0.3, high: 0.3) / 5, LFNoise2.kr(0.3));
	sig = Balance2.ar(sig[0], sig[1], LFNoise2.kr(1));
	sig = LPF.ar(sig, 500) * 10;
}.play(fadeTime: 30);
)

~summum.release(30);
~twiddle.release(30);

C.s(\one);

(
// 50, 52, 42, 54 ... 50, 52, 56
var freq = 50.midicps;
~moog.release(3);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 0.5, amp: 1]);
~sinesaw.release(3);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: 0.5]);
~poom.release(3);
~poom = Synth(\poom, [atk: 3, rel: 10, freq: freq, amp: 0.2]);
)

(
// 50, 52, 42, 54 ... 50, 52, 56
var freq = (50).midicps;
~moog.release(3);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 1, amp: 1]);
~moog2.release(3);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: 0.5]);
~sinesaw.release(3);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: 0.5]);
~sinesaw2.release(3);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: 0.5]);
~poom.release(3);
~poom = Synth(\poom, [atk: 3, rel: 10, freq: freq, amp: 0.2]);
~poom2.release(3);
~poom2 = Synth(\poom, [atk: 3, rel: 10, freq: freq *2, amp: 0.2]);
)

~splashes.release(10)


~twiddle2.release;

(
// 50, 52, 42, 54 ... 50, 52, 56
var freq = (50).midicps;
~moog.release(3);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 1, amp: 1]);
~moog2.release(3);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: 0.5]);
~moog3.release(3);
~moog3 = Synth(\moogbass, [atk: 3, freq: freq * 4, cutoff: 900, chorus: 0.3, amp: 0.3]);
~sinesaw.release(3);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: 0.5]);
~sinesaw2.release(3);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: 0.3]);
~sinesaw3.release(3);
~sinesaw3 = Synth(\sinesaw, [freq: freq * 4, amp: 0.3]);
~poom.release(3);
~poom = Synth(\poom, [atk: 3, rel: 10, freq: freq, amp: 0.2]);
~poom2.release(3);
~poom2 = Synth(\poom, [atk: 3, rel: 10, freq: freq *2, amp: 0.2]);
~poom3.release(3);
~poom3 = Synth(\poom, [atk: 3, rel: 10, freq: freq *4, amp: 0.2]);
)

Ndef.clear;

(
// 50, 52, 42, 54 ... 50, 52, 56
var freq = (50).midicps;
~moog.release(5);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 1, amp: 1]);
~moog2.release(5);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: 0.5]);
~moog3.release(5);
~moog3 = Synth(\moogbass, [atk: 3, freq: freq * 4, cutoff: 900, chorus: 0.3, amp: 0.3]);
~moog4.release(5);
~moog4 = Synth(\moogbass, [atk: 3, freq: freq / 2, cutoff: 900, chorus: 0.1, amp: 0.3]);
~sinesaw.release(5);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: 0.3]);
~sinesaw2.release(5);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: 0.3]);
~sinesaw3.release(5);
~sinesaw3 = Synth(\sinesaw, [freq: freq * 4, amp: 0.3]);
~sinesaw4.release(5);
~sinesaw4 = Synth(\sinesaw, [freq: freq / 2, amp: 0.3]);
~poom.release(5);
~poom = Synth(\poom, [atk: 3, rel: 10, freq: freq, amp: 0.2]);
~poom2.release(5);
~poom2 = Synth(\poom, [atk: 3, rel: 10, freq: freq *2, amp: 0.2]);
~poom3.release(5);
~poom3 = Synth(\poom, [atk: 3, rel: 10, freq: freq *4, amp: 0.2]);
~poom4.release(5);
~poom4 = Synth(\poom, [atk: 3, rel: 10, freq: freq / 2, amp: 0.2]);
)

(
// 50, 52, 42, 54 ... 50, 52, 56
var freq = (50).midicps;
~moog.release(3);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 0.3, amp: 1]);
~moog2.release(3);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: 0.5]);
~moog3.release(3);
~moog3 = Synth(\moogbass, [atk: 3, freq: freq * 4, cutoff: 900, chorus: 0.3, amp: 0.5]);
~moog4.release(3);
~moog4 = Synth(\moogbass, [atk: 3, freq: freq / 2, cutoff: 900, chorus: 0.1, amp: 0.5]);
~moog5.release(3);
~moog5 = Synth(\moogbass, [atk: 3, freq: freq * 8, cutoff: 900, chorus: 0.1, amp: 0.5]);
~sinesaw.release(3);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: 0.5]);
~sinesaw2.release(3);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: 0.5]);
~sinesaw3.release(3);
~sinesaw3 = Synth(\sinesaw, [freq: freq * 4, amp: 0.5]);
~sinesaw4.release(3);
~sinesaw4 = Synth(\sinesaw, [freq: freq / 2, amp: 0.5]);
~poom.release(3);
~poom = Synth(\poom, [atk: 3, rel: 7, freq: freq, amp: 0.2]);
~poom2.release(3);
~poom2 = Synth(\poom, [atk: 3, rel: 7, freq: freq *2, amp: 0.2]);
~poom3.release(3);
~poom3 = Synth(\poom, [atk: 3, rel: 7, freq: freq *4, amp: 0.2]);
~poom4.release(3);
~poom4 = Synth(\poom, [atk: 3, rel: 7, freq: freq / 2, amp: 0.1]);
~poom5.release(3);
~poom5 = Synth(\poom, [atk: 3, rel: 7, freq: freq / 8, amp: 0.2]);
)


// two alternatives

(
var progression = Pseq([50, 52, 42, 54, Rest(3), 50, 52, 56, Rest(7)], inf).midicps;
Pbind(\instrument, \poom, \dur, 8, \atk, 3, \rel, 7, \freq, progression * [1, 2, 4, 1/2, 1/8], \amp, [0.2, 0.2, 0.2, 0.1, 0.2]).play;
Pmono(\moogbass, \dur, 8, \atk, 3, \freq, progression * [1, 2, 4, 1/2, 8], \cutoff, 900, \chorus, [0.3, 0.3, 0.3, 0.1, 0.1], \amp, [1, 0.5, 0.5, 0.5, 0.5]).play;
)

~progression = Pseq([50, 52, 42, 54, 50, 52, 56].midicps, inf).asStream;
(instrument: \percsine, atk: 3, rel: 7, freq: ~progression.next * [1, 2, 4, 1/2, 1/8], out: 100).play;

Synth(\jpverb, [in: 100], s, 'addToTail');


(
~moog.release(30);
~moog2.release(30);
~moog3.release(30);
~moog4.release(30);
~moog5.release(30);
~sinesaw.release(30);
~sinesaw2.release(30);
~sinesaw3.release(30);
~sinesaw4.release(30);
~sinesaw5.release(30);
~poom.release(30);
~poom.release(30);
~poom2.release(30);
~poom3.release(30);
~poom4.release(30);
~poom5.release(30);
)


(
~tinnitus.release(30);
~tinnitus = Synth(\tinnitus, [atk: 1000]);
)

(
~tinnitus.release(1000);
~tinnitus = Synth(\tinnitus, [atk: 1000]);

~geom = Pseq(Array.geom(30, 50, 1.1), inf).asStream;

~astronaut = Routine.run({{~tinnitus.set(\bassfreq, ~geom.next); 0.1.wait}.loop})
)

Routine.run({~tinnitus.release(30); 30.wait; ~astronaut.stop;});

// -> resonator.scd



