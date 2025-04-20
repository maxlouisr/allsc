(
~honk = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /HONK - .wav");
~noteovertonepiano = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /note overtone piano ..wav");
~sic = Buffer.readChannel(s,  "/Users/maxlouisraugel/Documents/ /sic ..wav");
~hitbasshigh = Buffer.readChannel(s,  "/Users/maxlouisraugel/Documents/ /hit bass high high..wav");
~guitarslap = Buffer.readChannel(s,  "/Users/maxlouisraugel/Documents/ /guitar slap ..wav");
~guitarnotelongtail = Buffer.readChannel(s,  "/Users/maxlouisraugel/Documents/ /guitar note long tail.wav");
)

~bottom.stop;



(
a.release;
~dit = [ 156, 487, 118, 272, 475, 255, 291, 460, 467, 315 ];
a = {
	arg gate = 1;

	// Splay.ar(SinOsc.ar(~dit,mul:Env.asr(10, 0.05, 10).kr(2, gate);));

	SinOsc.ar(~dit * LFNoise2.kr(0.3, 0, 1), mul:Env.asr(10, 0.05, 10).kr(2, gate));
}.play;
)

{Splay.ar(PlayBuf.ar(2, ~honk, rate: Env([0, 0.09, 0], [8, 0.1]).kr(2)), 1, 0.5)}.play;

a.free;

(
{Splay.ar({PlayBuf.ar(2, ~guitarslap, rate: [0.5, 1], doneAction:2)} * 0.3)}.play;

{Splay.ar({PlayBuf.ar(2, ~hitbasshigh, rate: [0.6], doneAction: 2) * 1}!10 * 0.3)}.play;
)

(
{Splay.ar({PlayBuf.ar(2, ~guitarslap, rate: {[0.7, 0.9, 1, 1.2, 1.5].choose}!2, doneAction:2)} * 0.3)}.play;

{Splay.ar({PlayBuf.ar(2, ~hitbasshigh, rate: {[0.7, 0.9, 1, 1.2, 1.5].choose.postln}!2, doneAction:2) * 1} * 0.3)}.play;
)

// {Splay.ar({PlayBuf.ar(2, ~hitbasshigh, rate: [4, 5], doneAction:2)} * 1)}.play

// to kill preceding page:

(
Ndef(\c).clear(30);
e.release(10);
f.release(10);
Ndef(\whitenoise).clear(30);
)

~s1.release(30);
~s2.release(30);

~bottom.stop;


~guitarloop.stop;

~ch.release;


/*(

z = [ 274, 354, 204, 152, 457, 444, 110, 271, 463, 148 ];

x = [ 241, 216, 335, 453, 154, 293, 254, 133, 118, 441 ];

y = [ 293, 373, 334, 421, 320, 218, 181, 111, 134, 271 ];

v = [ 458, 396, 157, 352, 318, 266, 280, 307, 436, 463 ];

b.free;
b = {
	Splay.ar(
		LFSaw.ar(
			Env([z, z, x, x, y, y, v, v], [20, 7, 32, 5, 27, 12, 37], 'exp').kr(2),
			mul:Line.kr(0, 0.01, 5)
))}.play;
)*/

(

z = [ 274, 354, 204, 152, 457, 444, 110, 271, 463, 148 ];

x = [ 241, 216, 335, 453, 154, 293, 254, 133, 118, 441 ];

y = [ 293, 373, 334, 421, 320, 218, 181, 111, 134, 271 ];

v = [ 458, 396, 157, 352, 318, 266, 280, 307, 436, 463 ];

~chordswaving.release;
~chordswaving = {|gate 1|
	var snd;

	snd =SinOsc.ar(
			Env(
				[z, z, x, x, y, y, v, v],
				[20, 10, 32, 5, 27, 12, 37],
				'exp').circle.kr(2),
			mul:Env.asr(10, 0.05, 10).kr(2, gate));
	// snd = Splay.ar(snd);
}.play;
)

(
a.release(30);
~chordswaving.release(30)
)


(
~rrr.release(30);
~rrr = {
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
		level: 1.2);
	snd = Mix(snd);
	PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1));
}.play(fadeTime: 30);
)


// Synth(\percsine, [freq: 1000])



(
~hhh.release;
~hhh = {
	|gate 1|
	Splay.ar(
		BPF.ar(
			PlayBuf.ar(2, ~sic, rate: LFNoise2.kr(0.1, 2, 2), trigger: Impulse.kr(LFNoise2.kr(1, 5, 5)), loop:1),
			Array.fib(12, LFNoise2.kr(0.1, 20, 30), 30),
			0.005,
			mul: Line.kr(0, 10, 3),
			add: [0, 0]),
		spread: SinOsc.kr(0.1, 0, 1,0),
		level: Env.asr(30, 1.2, 30).kr(2, gate))}.play;
)




(
{Splay.ar({PlayBuf.ar(2, ~b2, rate: [0.5, 1])} * 0.5)}.play;
Synth(\fm2, [\freq, [600, 400, 500].choose, \pan, -1]);
Synth(\fm, [\freqB, [100, 150, 50].choose, \pan, 1])
)


(
// Ndef(\x, {
// 	Splay.ar(
// 		LFSaw.ar(
// 			Env([{exprand(20, 100)}!100, {exprand(10000, 10010)}!1], 0.5, 'exp').kr(2),
// 			0,
// 		Line.kr(0, 1, 5)),
// 		spread: 0,
// 		level: 1
// )});
// Ndef(\x).play;
// )


// (
// {
// 	Splay.ar(
// 		FreeVerb.ar(
// 			PlayBuf.ar(2, ~b3,
// 				Env([{exprand(0.30, 2)}, {exprand(2, 1)}!1], 0.5, 'exp').kr(2),
// 		), 0.5, 0.5), 0, 2, 0.2
//
// 	)
// }.play;
//
// Ndef(\x, {
// 	Splay.ar(
// 		LFSaw.ar(
// 			Env([{exprand(20, 20000)}!100, {exprand(20000, 10)}!1], 0.5, 'exp').kr(2),
// 			0,
// 		Line.kr(0, 1, 5)),
// 		spread: 0,
// 		level: 1
// )});
// Ndef(\x).play;
)


(
Ndef(\whitenoise).play;
Ndef(\whitenoise).fadeTime = 2;
Ndef(\whitenoise, {
	Splay.ar(
		FreeVerb.ar(
			WhiteNoise.ar(
				LFNoise2.kr(
					100,
					0.01,
				[0.01, 0.01])
			),
			0.3,
		0.5),
		SinOsc.kr(0.1, 0),
	LFGauss.kr(10, 0.5, 0))
});
)

Ndef(\whitenoise).clear(10);


// (
// Ndef(\saws, {
// 	Splay.ar(
// 		LFSaw.ar(
// 			Env([{exprand(20, 100)}!10, {exprand(10000, 10010)}!10], 100, 'exp').kr(2),
// 			0,
// 		Line.kr(0, 0.01, 5)),
// 		spread: 1,
// 		level: 2
// )});
// Ndef(\saws).play;
// )


~azimpulses = {PanAz.ar(16, Impulse.ar(10), LFNoise2.kr().range(0, 4))}.play;
~azimpulses.free;

~rrr.release(30);

(
~lowfibonaccihits.release(1);

~lowfibonaccihits = {
	|gate 1|
	var snd = BPF.ar(
		LFSaw.ar(
		SinOsc.kr(
				0.1, 0, 1, 1), 0, 0.1

		), Array.fib(12, 10, 12), 0.01, 100,

	);
	snd = PitchShiftPA.ar(snd, 100 * EnvFollow.ar(snd, 0.99, 1, 0));
	snd = PanAz.ar(2, snd, LFNoise2.kr(0.3).range(0, 2), Env.asr(15, 1, 15).kr(2, gate));
	snd = Sanitize.ar(snd);
	snd = snd / 1.5;
}.play;
)