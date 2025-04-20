(
~impacts = Array.new;
~buffers = [
"/Users/maxlouisraugel/Documents/ /brass impact 10.wav",
"/Users/maxlouisraugel/Documents/ /guitar scratch 3.wav",
"/Users/maxlouisraugel/Documents/ /pluck snare bead.wav"
];

~buffers.size.do({
	arg index;
	~impacts = ~impacts.add(Buffer.read(s, ~buffers[index]));
})
)

Pbindef(\n, \instrument, \play, \buffer, Pxrand(3.collect{|i| ~impacts[i]}, inf), \dur, Pxrand([1, 2, 5, 1/2, 1/5], inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1).play;

Pbindef(\j, \instrument, \playlinen, \buffer, Pxrand(3.collect{|i| ~impacts[i]}, inf), \dur, Pxrand([1, 2, 5, 50]/10, inf), \atk, 0.01, \sus, Pkey(\dur) * 8, \rel, 0.01, \rate, Pxrand(Array.fib(10, 0.02, 0.5), inf), \amp, 1, \out, 102).play;


Pbindef(\spectralmap, \instrument, \abstract_drums, \dur, Pbjorklund2(3, 8)/8, \buffer, Pxrand(10.collect{|i| w[i]}, inf), \norm, 0, \pan, Pshuf((-10..10)/5/2, inf), \amp, 1).play(quant: 1);


(instrument: \play, type: \notemap, buffer: (10.collect{|i| w[i]}).choose, loop: 0, rate: (instrument: \ctlEnv, env: Env([0.5, 20, 3, 7], [3, 2, 7].normalizeSum), time: 7, addAction: \addBefore)).play;

(instrument: \play, type: \notemap, doneAction: 0, buffer: (20.collect{|i| w[i]}).choose, trig: (instrument: \ctlEnv, env: Env(Array.fill(31, {[-1, 1].choose}), Array.fill(30, {rrand(0, 10)}).normalizeSum), time: 5, addAction: \addBefore), loop: 0, rate: (instrument: \ctlEnv, env: Env(Array.fill(11, {rrand(0.5, 10)}), Array.fill(10, {rrand(1, 10)}).normalizeSum), time: 30, addAction: \addBefore), amp: 1).play;


// (
// ~buffers = Array.new;
// ~folder = PathName("/Users/maxlouisraugel/Documents/son/thanks");
//
// ~folder.entries.do({
// 	arg path;
// 	~buffers = ~buffers.add(Buffer.read(s, path.fullPath));
// });
// )

(
~pipe = Array.new;
~folder = PathName("/Users/maxlouisraugel/Documents/son/adri_pipe_disto_reverb/");

~folder.entries.do({
	arg path;
	~pipe = ~pipe.add(Buffer.read(s, path.fullPath));
})
)



Pbindef(\n, \instrument, \play, \buffer, Pxrand(20.collect{|i| ~pipe[i]}, inf), \dur, Pxrand([2, 3, 5] * 2, inf), \rate, Pseq((\Em.asNotes - 6).midiratio, inf), \amp, 1, \pan, Pwhite(-1, 1.0)/2).play;




Pbindef(\n, \instrument, \playgverb, \buffer, Pxrand(100.collect{|i| w[i]}, inf), \dur, Pxrand([1, 2, 5, 1/2, 1/5], inf), \room, Pxrand((10..40)/10, inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5) + 10, inf), \amp, 1).play;

Pbindef(\n).stop;







Pbindef(\p, *[instrument: \fm, freq: Pxrand(105 * [1/2, 1, 2, 3, 4, 7, 11, 13], inf), [10, 10, 10], inf), dur: Pxrand([2, 3, 7], inf), seed: Pwhite(0, 60), seedDrift: 3, atk: 0.1, rel: Pkey(\dur), pan: Pwhite(-1, 1.0), amp: 1/2]).play;

Pbindef(\p).stop;

-------

~wsamples = Pbindef(\wsamples, \instrument, \play, \buffer, Pxrand(50.collect{|i| w[i]}, inf), \dur, Pxrand([1, 2, 5, 1/2, 1/5], inf), \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1/2);

~samples.play;
~samples.stop;

Pbindef(\n).stop;

Pbindef(\chord, \instrument, \percsine, \dur, 5, \atk, 3, \rel, 7, \amp, 0.1, \note, Pstep([\Em, \Am, \Bm].chordProg, [10, 10, 10], inf)).play;

Pbindef(\chord).stop;

// MATCH WITH THE FOLLOWING + PHYSICAL MODEL.SCD
~soundgrain = "/Users/maxlouisraugel/Documents/son/snd_30_Jan_2022_03h56.wav".b;
x = Synth(\play, [buffer: ~soundgrain]);
x.free;

Pbindef(\chord2, \instrument, \sinoscfbmod_rotate, \dur, 5, \atk, 3, \rel, 7, \amp, 0.1, \note, Pstep([\Em, \Am, \Bm].chordProg, [10, 10, 10], inf)).play;
Pbindef(\chord2).stop;



Pbind(\instrument, \whiteperc, \dur, Pseg([0.1, 0.1/2000, 0.1], [10, 10]), \atk, 0, \rel, Pkey(\dur), \pan, Pseg([-1, 1, -1], [3, 4], 'lin', inf)).play;

