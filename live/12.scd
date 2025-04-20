(
SynthDef(\souffle, {
	arg out = 0, pan = 1, freq = 100, mul = 0.5, gate = 1, curveout = 3, atk = 0.01, rel = 1, lfspeed = 0.1, lfmul = 3;
	var in, kernel, sig, env;
	env = EnvGen.kr(Env([0, 1, 0], [atk, rel], [1, curveout]), gate, 1, 0, 1, 2);
	// freq = LFNoise2.kr(0.1, 5, add);
	// in = SinOsc.ar(freq + LFNoise2.kr(lfspeed, lfmul, add), 0, mul);
	in = SinOsc.ar(freq, 0, mul);
	kernel = ClipNoise.ar(0.1);
	sig = Convolution.ar(in, kernel, 512, 0.1);
	sig = HPF.ar(sig);
	sig = PanAz.ar(2, sig, SinOsc.kr(0.1, pan, 0));
	sig = sig * env;
	Out.ar(out, sig)
}).add;


SynthDef(\reverb, {
	arg in, mix = 0.5, room = 0.5, damp = 0.5, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, mix, room, damp, 1);
	Out.ar(out, sig);
}).add;

SynthDef(\JPverb, {
	arg in, t_trig = 1, time = 1, damp = 0.5, size = 1, out = 0, modDepth = 0.1, modFreq = 2.0;
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 800, 10, 7), t_trig, 1, 0, 1, Done.freeSelf);
	sig = In.ar(in, 2);
	sig = JPverb.ar(sig, time, damp, size, 0.7, modDepth, modFreq);
	Out.ar(out, sig * env);
}).add;
)


Synth(\reverb, [\in, 11], s, 'addToTail');

// Synth(\souffle, [\out, 0, \gate, 1, \freq, exprand(100, 10000).round(301/4).postln, \atk, 30, \rel, 30, \curveout,1 , \mul, 0.1])

(
Synth(\souffle, [\out, 11, \gate, 1, \freq, 301.5*3, \atk, 0.9, \rel, 1.5, \curveout, 3, \mul, 0.3, \pan, 0])
)

(
Synth(\souffle, [\out, 0, \gate, 1, \freq, 4138.75, \atk, 60, \rel, 60, \curveout,1 , \mul, 0.1, \pan, 0]);
// Synth(\reverb, [\in, 11, \mix, 0.3]);
Synth(\souffle, [\out, 0, \gate, 1, \freq, 302.5, \atk, 60, \rel, 60, \curveout,1 , \mul, 0.1])
)


// Synth(\souffle, [\out, 0, \gate, 1, \freq, 3010, \atk, 60, \rel, 60, \curveout,1 , \mul, 0.1, \pan, 0])

// Synth(\souffle, [\out, 0, \gate, 1, \freq, 376.25, \atk, 60, \rel, 60, \curveout,1 , \mul, 0.1])

Synth(\souffle, [\out, 0, \gate, 1, \freq, 4740.75, \atk, 60, \rel, 60, \curveout,1 , \mul, 0.1])

(
Synth(\reverb, [\in, 21, \mix, 0.1]);
Synth(\souffle, [\out, 21, \gate, 1, \atk, 1.2, \rel, 1.5, \freq, 209, \mul, 0.2, \curveout, 1])
)



/*(
p = Pdef(\spat,
	Pbind(
		\instrument, \souffle,
		\dur, Pwrand([3, 10, 15], [1, 2, 3].normalizeSum, inf),
		\atk, Pwrand([3, 5, 7], [1, 2, 3].normalizeSum, inf),
		\rel, Pwhite(1, 2),
		\freq, Pexprand(100, 10000, inf).round(209),
		\mul, Pwhite(0.1, 0.2),
		\curveout, Pwhite(1, 4)
	)
)
)

p.play;
p.pause*/



(
SynthDef(\var, {
	arg out = 0, freq = 340, amp = 1;
	var sig;

	sig = VarSaw.ar({freq * rrand(0.99,0.99.reciprocal)}!2 / [1, 2, 4], 0, LFNoise2.kr(0.1, 0.5, 0.5), Line.kr(0, 0.1, 30));
	sig = Splay.ar(sig);
	Out.ar(0, sig * amp)
}).add;
)

a = Synth(\var, [\amp, 0.7])

// (
// Synth(\souffle, [\out, [0], \gate, 1, \freq, 301.5*3, \atk, 0.9, \rel, 1.5, \curveout, 3, \mul, 0.3, \pan, 0])
// )


(
SynthDef(\var2, {
	arg out = 0, freq = 340, amp = 1, atk = 5, rel = 7;
	var sig, env, fade;

	fade = Line.kr(0, 1, 10, doneAction:0);
	env = Env.perc(atk, rel, 1, 'sine').kr(2);

	sig = VarSaw.ar(
		[200, 300, 500, 100, 1200, 570],
		0,
		LFNoise2.kr(0.1, 0.5, 0.5),
		Line.kr(0, 0.1, 1));

	sig = Splay.ar(sig);
	Out.ar(0, sig * env * fade * amp);
}).add;
)


~harmony = Routine{loop{l = Synth(\var2, [\amp, 1.5]); rrand(20, 30).wait}}.play;

(
SynthDef(\imp, {arg out = 0, fadein = 5;
	var sig, freq, env;
	env = Line.kr(0, 1, fadein);
	freq = LFNoise2.kr(1!2, 1, 1);
	sig = Impulse.ar(freq, 0, 1);
	sig = Splay.ar(sig);
	Out.ar(out, sig * env)
}).add;
)

(
x.free;
Synth(\reverb, [\in, 21, \mix, 0.7, \room, 0.1]);
x = Synth(\imp, [\out, 21]);
)

(
~fireworks = Array.new;
~folder = PathName("/Users/maxlouisraugel/Documents/son/fireworks/");


~folder.entries.do({
	arg path;
	~fireworks = ~fireworks.add(Buffer.read(s, path.fullPath));
});

SynthDef(\fireworks, {arg comb = 0;
	var sig, env;
	env = Line.kr(0, 0.5, 3, doneAction:0);
	sig = PlayBuf.ar(2, ~fireworks[0], 1, 1, 0, 1, 2);
	// sig = CombC.ar(sig, 0.2, comb, 10, 1);
	sig = BPF.ar(sig, 5000, 1);
	sig = Splay.ar(sig);
	Out.ar(0, sig * env);
}).add
);

(
f.free;
f = Synth(\fireworks, [\comb, 0.00017])
)

// new random bit

Pbindef(\rbit, \instrument, \normalize, \dur, Pbjorklund2(5, 7)/4, \buffer, Pxrand((0..100), inf), \rate, Pxrand([0.5, 0.7, 0.9, 1, 1.2, 1.7, 2, 3], inf), \level, 1/3, \pan, Pwhite(-1.0, 1.0)).play;


Pbindef(\rbit).stop;
f.free;


// (
// Synth(\reverb, [\in, 11]);
//
// SynthDef(\cloche, {
// 	|freq=440, amp=0.2, dur=2, out = 0|
// 	var sig, env;
// 	env = EnvGen.kr(Env.perc(attackTime:0.01, releaseTime:dur-dur/2), doneAction:2);
// 	sig = SinOsc.ar(freq, mul:env);
// 	sig = Splay.ar(sig, spread:1, center:0);
// 	Out.ar(out, sig*amp);
// }).add;
//
// Pdef(\cloche,
// 	Pbind(
// 		\instrument, \cloche,
// 		\freq, Pfunc{{rrand(200, 10000).round(10)}!3},
// 		\dur, Pwrand([0.01, 1, 3, 5], [2, 1, 1, 1].normalizeSum, inf),
// 		\amp, 0.5,
// 		\out, Prand([0, 11], inf)
// ));
//
// c = Pdef(\cloche);
//
// c.play;
// );
//
//
// c.pause;
