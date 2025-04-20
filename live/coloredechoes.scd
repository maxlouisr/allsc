
(
SynthDef(\coloredechoes, {|t_trig|
	var snd, buffer;
	buffer = \buffer.kr(C.get(\bassdrums, 88));
	snd = PlayBuf.ar(
		2,
		buffer,
		Array.series(20, 0.98, 0.0001 * \color.kr(1)) * BufRateScale.ir(buffer),
		loop: \loop.kr(1),
		doneAction:2

	) * 1/3;
	snd = Splay.ar(snd * 1).tanh;
	snd = snd * XLine.kr(1, 0.001, \fadetime.kr(10), doneAction:2);
	// snd = FreeVerb2.ar(snd[0], snd[1]);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;
)



Synth(\coloredechoes, [buffer: C.get(\thanks, 5), loop: 0, color: -200, fadetime: 3, pan: -1, amp: 2]);



Synth(\coloredechoes, [buffer: C.get(\thanks, 6), loop: 0, color: -200, fadetime: 3, pan: -1, amp: 2]);



// this one


Ndef(\trac, Pbind(*[instrument: \coloredechoes, buffer: Prand(C.get(\thanks, [5, 6]), inf), color: Prand([200, -200, 400, 1000, 2000], inf), loop: 0, fadetime: 3, \dur, Pkey(\fadetime), amp:1.5]))

Ndef(\trac).play;
Ndef(\trac).stop;










Ndef(\colors, Pbind(\instrument, \coloredechoes, \buffer, Pxrand(C.get(\minisax, [1, 5, 0]), inf), \fadetime, Pxrand([3, 1/2, 1, 2], inf);, \loop, 1, \dur, Pkey(\fadetime), \color, Pxrand([1, 30, 20, 200, 100, 1/2], inf).poll, \pan, Pwhite(-1/2, 1/2), \amp, 1))

Ndef(\colors).play(fadeTime: 0);

Ndef(\colors).stop(0);

Ndef(\colors2, Pbind(\instrument, \coloredechoes, \buffer, Pxrand(C.get(\minisax, [1, 0, 3, 6, 7]), inf), \fadetime, Pseg([0.03, 1], 10, 'lin', inf), \loop, 1, \dur, Pkey(\fadetime), \color, Pxrand([1, 10, 2, 5, 1/2, 100, 200, 50], inf).poll, \pan, Pwhite(-1/2, 1/2), \amp, 1)).play;

Ndef(\colors2).clear;




Ndef(\colors, Pbind(\instrument, \coloredechoes, \buffer, Pxrand((0..500), inf), \fadetime, Pxrand([3, 1, 2], inf), \loop, Pwrand([0, 1], [0.8, 0.2], inf), \dur, Pkey(\fadetime) / 2, \color, Pxrand([1, 3, 150, 2, 200, 100, 1/2, -200] * 30, inf).poll, \pan, Pwhite(-1/2, 1/2), \amp, 0.8));

Ndef(\colors).play;
Ndef(\colors).clear;

~jpverbus = Bus.audio(s, 2);

Synth(\jpverb, [in: ~jpverbus], s, 'addToTail');

(
~wavy = {
	|atk 3 sus 1 rel 1|
	var snd;
	snd = SinOsc.ar(LFNoise2.kr(5).range(100, 1000), 0, Env.linen(atk, sus, rel, 0.1).kr(2))!2;
}.play(outbus: ~jpverbus);
)

~wavy.free;


(
~pigeon = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/son/pigeon paris.WAV", channels:0);
~resonancetoilette = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /resonance toilette drive (even harmonics).wav", channels: 0);
)

// SYNTH FROM 'PULSAR SYNTHESIS' doc

(
y.release(0);
y = Synth(\pulsardm, [bufNum: ~resonancetoilette, overlap: 30000, trigRate: 30000, pos: 0.2, trigRateDev: 0.1, amp: 1])
)

(
var fade = 10;z.release(fade);
z = Synth(\pulsardm, [bufNum: ~pigeon, overlap: 5000, trigRate: 300, pos: 0.002, trigRateDev: 0.1, amp: 5, atk: fade])
)

Ndef(\colours).clear;






