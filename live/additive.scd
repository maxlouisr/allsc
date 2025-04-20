(
Ndef(\bass, {
	var snd, env, trig;
	trig = Impulse.kr(LFNoise2.kr(1, 3).abs);
	env = Env([0.01, 1], 1).kr(0, trig);
	snd = SinOsc.ar(Array.series(30, 50, 12), 0, Array.fill(30, {LFNoise2.kr(0.1).abs}));
	snd = snd * env;
}).play;
)

Ndef(\bass).stop(30);

(
Ndef(\additive, {
	var snd, env, trig, lfo;
	lfo = LFNoise2.kr(0.3, 3).abs;
	trig = Impulse.kr(lfo);
	env = Env([0, 1/2, 0], [0.01, 0.3]).kr(0, trig);
	snd = SinOsc.ar(Array.fill(30, {LFNoise2.kr(0.02).exprange(20, 20000)}).poll, 0, Array.fill(30, {LFNoise2.kr(0.01).abs}));
	snd = snd * env;
}).play;
)

(
~additive = Ndef(\additive, {
	var snd, env, trig, lfo;
	lfo = LFNoise2.kr(0.3, 10).abs;
	trig = Impulse.kr(lfo);
	env = Env([0, 1/2, 0], [0.01, 1/lfo]).kr(0, trig);
	snd = VarSaw.ar(Array.fill(80, {LFNoise2.kr(0.02).exprange(20, 20000)}).poll, 0, Array.fill(80, {LFNoise2.kr(0.3).abs}), Array.fill(80, {LFNoise2.kr(0.01).abs}));
	snd = snd * env * 1/5;
	// snd * SinOsc.ar(1);
}).play;
)