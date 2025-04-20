// SETUP BLUETOOTH OUT



(
~one.stop(30);
~two.stop(30);
)

// TRANSDUCERS
(
~trans1.release(0);
~trans1 = {
	var snd, lfo;
snd =	SinOsc.ar(LFNoise2.kr(0.1).exprange(100, 170), 0, 0.3);
	snd = snd + SinOsc.ar([100, 170], 0, 0.1);
	snd = snd.clip;
	lfo = LFNoise2.kr(0.3);
	snd;
	// snd = Splay.ar(snd);
}.play(fadeTime:30);
)

(
~transimpacts.free;
~transimpacts =
{
	var snd, env, gate;
	gate = {Dust.kr(0.3)}!2;

	env = Env.perc(0, 0.01).kr(0, gate);

	snd = WhiteNoise.ar(1);
	snd = BPF.ar(snd);
	snd = snd * env;

}.play(fadeTime:30);
)



// TRANSDUCERS?
// Spring 23

~s23 = Ndef(\s23, Pbind(\instrument, \percsinefb, *[freq: Pxrand([68, 61], inf).midicps * Prand([1, 2, 0.5], inf), atk: 10, rel: 20, amp: 0.07, feedback: 1/2, dur: 5, pan: Prand([-1, 1.0], inf)])).play(fadeTime:30);
~one.stop(10);

// 23 Jours

Synth(\percsine, [freq: 63.midicps])

~23J = Ndef("23J", Pbind(\instrument, \percsinefb, *[freq: Pxrand([73, 69, 61, 63], inf).midicps, atk: 10, rel: 20, amp: 0.08, feedback: 1/2, dur: 5, pan: Prand([-1, 1.0], inf)])).play(fadeTime:30);
