(
~miwarps.release(0);
~miwarps = {
	var car, mod, snd, lfo;
	// car = PlayBuf.ar(2, 120, 1 * BufRateScale.kr(1), 1, 0, 1);
	// car = WhiteNoise.ar(0.1);
	// car = LFSaw.ar(LFNoise2.kr(), 0, 0.1/2);
	lfo = LFNoise2.kr(1);
	mod = SinOsc.ar(100, 0, 0.1);
	snd = MiWarps.ar(0, mod, 1/2, 1/2, 5, SinOsc.ar(1).abs, lfo.range(1, 3))[1];
	snd = Pan2.ar(snd, lfo) * LFPulse.kr(LFNoise2.kr(10).range(1, 2)).abs;
}.play(fadeTime:0)
)

C.get(\snares, 1).play;

(
~miverb = Ndef(\miverb, {
	var snd, buffer;
	buffer = C.get(\zither, 1);
	snd = PlayBuf.ar(2, buffer, 1/2 * BufRateScale.kr(buffer), 1);
	snd = MiVerb.ar(snd, 0.7, 0.5, 0.5);
}).play;
)


// Then check out MiTides, MiRipples, MiRings, MiPlaits, MiOmi, MiMu, MiElements, MiClouds, MiBraids


(
~mitides = Ndef(\mitides, {
	var snd;
	snd = MiTides.ar(110, 0.5, 0.5, LFNoise2.kr(0.3).abs);
}).play;
)

~mitides.stop;

{var snd; snd = SinOsc.ar(LFNoise2.kr(0.1).exprange(20, 20000), 0, MouseY.kr(0, 2)); snd = JPverb.ar(snd)}.play;


(
~mimu = Ndef(\mimu, {
	var dry, wet;
	dry = MiTides.ar(100, 0.5, 0.5, LFNoise2.kr(0.3).abs);
	wet = MiMu.ar(dry, 10);
	wet = XFade2.ar(dry, wet, -1/2);
	wet = Limiter.ar(wet, 1/2);
	// wet = BPeakEQ.ar(wet, LFNoise2.kr(0.3).exprange(20, 20000), 0.2, 12).tanh
}).play;
)







(
~miclouds = Ndef(\miclouds, {
    var input = PlayBuf.ar(2, 2, 1, loop: 1)!2;

    var size = 0.35, dens = 0.02, tex = 0.3;

	var snd = MiClouds.ar(input, 0, 0.5, 1/1000, 0.1, drywet: 1, rvb: 0.8, fb: 0.8, mode: \mode.kr(3));
	// snd = LPF.ar(snd,5000) * 2;
	snd * 2
}).play
)


~miclouds.stop;


(  // example for study
y = {
    var imp = Dust.ar([0.8,1.1]);
    var freq = Latch.ar(PinkNoise.ar(24,80), imp).midicps;
    var input = RLPF.ar(imp, freq, 0.002, 4);

    var pit = LFNoise1.kr(0.3,12);
    var pos = LFNoise2.kr(0.4,0.5,0.5);
    var size = LFNoise1.kr(0.3,0.5,0.5);
    var dens = LFNoise1.kr(0.3,0.5,0.5);
    var tex = LFNoise1.kr(0.3,0.5,0.5);

    var frez = LFClipNoise.kr(0.3);

    MiClouds.ar(input, pit, pos, size, dens, tex, drywet: 0.5, in_gain: 2, rvb:0.3, fb: 0.8,
        freeze: frez, lofi: 1, mode: 0);

}.play
)

x.free;
(
~miel = Ndef(\miel, {
	var snd, trig, lfo;
	lfo = LFDNoise3.kr(0.1);
	trig = LFPulse.kr(lfo.range(0.1, 10));
	snd = MiElements.ar(PinkNoise.ar(0.1), 0, trig, [48, 43, 52, 53], lfo.range(0.9, 0.3), lfo.range(0.4, 0.1));
	snd = Splay.ar(snd);
	snd = FreeVerb.ar(snd) * 3;
}).play;
)


~miel.stop;

Ndef(\u).stop;









Pbindef(\test, \instrument, \percsine, \dur, Pxrand([1,2, 5], inf))





+++

// do audiorate with envelopes ?
(
~envaudio = Ndef(\envaudio, {
	var snd, freq;
	freq = LFNoise2.ar(3).exprange(100, 2000);
	snd = Env([0, -0.5, 1, 0], 1, [4, -4]).ar(0, gate: Impulse.ar(freq), timeScale: 1/freq);
	snd.lag(1/1000)!2
	}).mold(2).play;
)

Env([0, -1, 1, 0], 1, [4, -4]).plot
