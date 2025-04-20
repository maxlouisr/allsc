// structure: neutral / hypnotic >> grotesque, colourful >> stable again, more abstract


(
~honk = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /HONK - .wav", channels:0);
~bassesobre = Buffer.readChannel(s,"/Users/maxlouisraugel/Documents/ /basse sobre.wav" , channels:0);
)


// test-tune following bassess

(
~bass = {
	Splay.ar(
		SinOsc.ar(
			LFNoise2.kr([1, 1.2, 1.3]/1, mul:30, add:60),
			mul:Line.kr(0,0.3,30)
))}.play;
)

~bass.release(10);


(
x.release;
x = {
	arg gate = 1, fluctuat = 1000;
	Splay.ar(
		Resonz.ar
			(
				Saw.ar(
				LFNoise2.kr([1, 1.1, 1.2, 1.3]/fluctuat, 200, 400),
					Env.asr(1000, 0.1, 50).kr(2, gate)),
			[200, 300, 400, 700, 1100], 1, 2

		)
)}.play;
)


x.release(30);

// is it necessary?
// ~saws2 = {
// 	Splay.ar(
// 		Saw.ar(
// 			LFNoise2.kr([1, 1.1, 1.2, 1.3]/1000, 200, 400),
// 		Line.kr(0, 0.1, 3))
// )}.play;
//
// ~saws2.free;

(
~bassesobre.play;
~impulses.release(0);
~impulses = {
	Splay.ar(
		Impulse.ar(
			[20, 10, 12, 27],
			mul:LFNoise2.kr(0.1).range(0, 0.1))
)}.play;
// {Splay.ar(PlayBuf.ar([1,1], ~b1, startPos:[1000, 2000]), 1, 0.2)}.play;
)



// maybe have this one later? and thread one into the other
/*
(
~bass.free;
~bass = {
	Splay.ar(
		SinOsc.ar(
			LFNoise2.kr([1, 1.2, 1.3]/1,
				mul:1,
				add:(LFNoise2.kr(0.1).range(30,50)),
				mul:0.5),
			mul:Line.kr(0, 0.5, 10))
)}.play;
)*/

x.release;

(
~klaxons.free;
~klaxons = {
	Splay.ar(
		PlayBuf.ar(
			[1,1],
			~honk,
			rate:LFNoise2.kr([3, 1, 5, 7]).range(0.01,5),
			trigger: Impulse.kr(0.01),
			loop:Impulse.kr(LFNoise2.kr(1).range(0.01, 10))
),
		level:Line.kr(0.0001, 0.3, 30 * 5, 1, 0, 0)
)}.play;

~cryingballoons.free;
~cryingballoons={
	var snd = BPF.ar(
		Saw.ar(
			freq: LFNoise2.kr([2, 3]).range(20, 1000),
			mul:0.01)
		, LFNoise2.kr([1, 2]).range(200,20000),
		0.1,
		mul: Line.kr(0, 70, 10 * 5)
);
	snd = Sanitize.ar(snd, 0);
}.play;
)

~klaxon = {var snd = PlayBuf.ar(2, ~honk, 1); snd = JPverb.ar(snd, 3) / 5}.play;


(
~klaxons.release(1);
~cryingballoons.release(1);
)

s.volume.gui;

/*(
~bassesobre.play;
~klaxons.free;
~cryingballoons.free;
~cryingballoons={
	BPF.ar(
		Saw.ar(
			freq: LFNoise2.kr([2, 3]).range(20, 1000),
		mul:0.01)
		, LFNoise2.kr([1, 2]).range(200,20000),
		0.1,
		mul: 70
	* LFPulse.kr(LFNoise0.kr(0.5, 0.5, 0.5), 0, 0.3))
}.play;
)*/


// (
// q.free;
// q = {Splay.ar(PlayBuf.ar([1,1], ~b2, rate:LFNoise2.kr([3, 1, 5, 7]).range(0.01,5), trigger: Impulse.kr(LFNoise2.kr(1, 2, 2)), loop:0), level:Line.kr(0.01, 0.5, 10))}.play;
// )

// test-tune following bass to speakers

(
~bassesobre.play;
~b2.play;
~klaxons.release;
~cryingballoons.release;
~saws1.release;
~bass2.release;
~impulses.free;
~bass.free;
p.free;

~verylow = {|gate 1|
	SinOsc.ar([50, 50]/2, mul:Env.asr(0.01, 0.5, 1).kr(2, gate))
}.play;
)

~verylow.release(10);

x.release(30);

(
~sawstonextpage = {
	arg gate = 1;
	Splay.ar(
		Resonz.ar(
			Saw.ar(
				LFNoise2.kr([1, 1.1, 1.2, 1.3]/1000, 200, 400),
				Line.kr(0, 0.1, 3)),
			LFNoise2.kr(0.5, 300, 600), 0.1, 2),
		1, 0.1)
	*
	Env.adsr(10, 0, 1, 20, 1).kr(2, gate)
	* 10;
}.play;
)


Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1])

Synth(\fml, [\freqA, 20, \freqB, [1697, 2753, 5688, 4910, 7378, 6287].choose, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1])


// collection of frequencies for above that produce strong sub-harmonics
[1697, 2753, 5688, 4910, 7378, 6287]