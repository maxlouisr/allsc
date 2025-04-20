//////////////////////
// GRANULAR SAMPLING
// Code examples
//////////////////////
(
// Replace path (a string of characters) with a path to a wav or aiff file on your computer
b = Buffer.readChannel(server: s, path: "/Users/maxlouisraugel/Documents/ /DROP.WAV", channels: 0);

c = Buffer.readChannel(server:s, path: "/Users/maxlouisraugel/Documents/ /pet ..wav", channels: 0);

b = Buffer.readChannel(server:s, path: "/Users/maxlouisraugel/Documents/ / : note trombone ..wav" , channels: 0);
)
// Load synthdef
(
SynthDef("grain", {arg buffer = d, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0;
	var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate);
	snd = PlayBuf.ar(
		numChannels:  1,
		bufnum:  buffer,
		rate: rate,
		startPos: startPos * BufSamples.kr(buffer)
	);
	snd = snd * env;
	Out.ar(0, Pan2.ar(snd, pan));
	DetectSilence.ar(snd, doneAction: 2);
}).add;
)

// ===================
// Pattern examples
// Note that in these examples grain duration is controlled indirectly through \dur, \legato, and \release
// Also because we are using Pbinds there is a limit on how many grains you can play per second

(
~stubborn = Pbind(
	\instrument, "grain",
	\buffer, [c, d],
	\startPos, Pseq([Pn(0.1, 10), Pn(0.3, 10), Pn(0.8, 5)], inf), // 0.0=beginning of sample, 0.5=half way into sample, 1.0=end of sample
	\dur, Pwhite (0.05, 0.001),
	\att, Prand ([0.001, 1], inf),
	\rel, Prand([0, 1], inf),
	\rate, Pgauss (0, 1),
	// \rate, Pseq ([1,1.2,1,1.7]*[100,10,1], 1000, 0), //Pwhite(1, 1.5), // 1=original speed, 0.5=half speed, 2=twice speed, etc.
	// a negative number for \rate makes sound goes backward
	\amp, Pgauss (0,0.5),
	\pan, Pwhite(-1.0, 1.0),
	\legato, Pwhite (0.01, 1)
).play.stop;

~stubborn.play;
)

(
{Pbind(
    \instrument, "grain",
	\buffer, b,
    \amp, 0.1,
	\decay, Pseq ([1,2], inf),
	\dampen, Pseq([0.01,0.5], inf),
	\scale, Scale.mixolydian,
	\dur, Pxrand([0.51, 0.1], inf),
	\pan, Pwhite (-1, 1),
	\rate, Pwhite (0, 10),
).play;}!10;
)

(
Pbind(
	\instrument, "grain",
	\buffer, b,
	\rate, Pseq((series(-3,-2,5)).mirror, inf),
	\dur, 0.1,
	\scale, Scale.mixolydian,
	\rel, 0.01,
	\legato, 0.01,
	\pan, Pwhite (-1, 1),
	\amp, 1.5
).play;
)




(
~go = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, 0.1, // 0.0=beginning of sample, 0.5=half way into sample, 1.0=end of sample
	\dur, 2,
	\att, 0.001,
	\rel, 1,
	\rate, Pwhite(1, 1.5), // 1=original speed, 0.5=half speed, 2=twice speed, etc.
	// a negative number for \rate makes sound goes backward
	\amp, 0.75,
	\pan, Pwhite(-1.0, 1.0),
	\legato, 1
).play.stop;

~go.play;
)

(
~rhythm = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, Prand([0.04, 0.12, 0.215, 0.78], inf),
	\dur, 1,
	\att, 0.001,
	\rel, 0.01,
	\rate, -1, // normal speed, but reverse
	\amp, 0.75,
	\pan, Pwhite(-1.0, 1.0),
	\legato, 0.7
).play.stop;

~rhythm.play;
)

(
~allOver = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, Pseq([0.4, 0.32, 0.6215, 0.8], inf) + Pwhite(0.0, 0.05),
	\dur, 1/4,
	\att, 0.001,
	\rel, 1,
	\rate, Prand([Pn(-2, 4), 1, -4], inf),
	\amp, Pwhite(0.5, 0.75),
	\pan, Pwhite(-0.3, 0.3),
	\legato, 0.1
).play.stop;

~allOver.play;
)

~allOver.play;
~rhythm.play;

(
~upAndAway = Pbind(
	\instrument, "grain",
	\buffer, c,
	\startPos, Prand([0.44, 0.32, 0.6215, 0.8], inf),
	\dur, Pwhite(1/16, 1/17),
	\att, 0.001,
	\rel, 0.01,
	\rate, Pn(Pgeom(1, 1.1, 20)),
	\amp, Pwhite(0.2, 0.75),
	\pan, Pwhite(-1.0, 1.0),
	\legato, 1
).play.stop;

~upAndAway.play;
)

(
~shorty = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, Pwhite(0.0, 0.1),
	\dur, 1/20,
	\att, 0.001,
	\rel, 0.1,
	\rate, Pseq([1, 5, 3, 3.3], inf),
	\amp, Pwhite(0.5, 0.95),
	\pan, Pwhite(-1.0, 1.0),
	\legato, Pn(Pgeom(0.01, 1.05, 40))
).play.stop;

~shorty.play;
)

(
~kik = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, 0.1,
	\dur, 1/8,
	\att, 0.001,
	\rel, 0.1,
	\rate, 0.2,
	\amp, Pseq([
		1, 0, 0, 0, 1, 0, 0, 0
	], inf),
	\pan, 0,
	\legato, 0.1
).play.stop;

~kik.play;
)

(
~snair = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, 0.49,
	\dur, 1/8,
	\att, 0.001,
	\rel, 0.13,
	\rate, 1,
	\amp, Prand([
		Pseq([0, 0, 1, 0, 0, 0, 1, 0], 2),
		Pseq([0, 0, 1, 0, 0, 1, 1, 0], 1),
		Pseq([0, 0, 1, 0, 0, 0, 1, 1], 1)
	], inf),
	\pan, 0,
	\legato, 0.2
).play.stop;

~snair.play;
)

(
~helloHat = Pbind(
	\instrument, "grain",
	\buffer, b,
	\startPos, 0.78,
	\dur, 1/16,
	\att, 0.001,
	\rel, Pwhite(0.1, 0.2),
	\rate, Pwhite(4, 4.1),
	\amp, Prand([
		Pseq([0, 1, 0, 1, 0, 1, 0, 1], 2),
		Pseq([0, 1, 1, 1, 0, 1, 1, 1], 1),
		Pseq([0, 1, 1, 1, 0, 1, 1, 1], 1)
	], inf) * Pwhite(0.25, 0.5),
	\pan, 0,
	\legato, 0.2
).play.stop;

~helloHat.play;
)


// quick .fork example
(
~bpm = TempoClock.new(60/60).permanent_(true);
{
	~snair.reset.play(~bpm);
	~kik.reset.play(~bpm);
	~helloHat.reset.play(~bpm);
	8.wait;
	~shorty.reset.play(~bpm);
	4.wait;
	~shorty.stop;
	~stubborn.reset.play(~bpm);
	4.wait;
	~stubborn.stop;
	4.wait;
	~upAndAway.reset.play(~bpm);
	4.wait;
	~rhythm.reset.play(~bpm);
	4.wait;
	~snair.stop;
	~kik.stop;
	~helloHat.stop;
	4.wait;
	~upAndAway.stop;
	~rhythm.stop;
	~go.reset.play(~bpm);
	8.wait;
	~go.stop;
}.fork(~bpm);
)