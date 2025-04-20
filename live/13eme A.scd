
Ndef(\brilliantradiator, {PlayBuf.ar(2, ~brilliantradiator, 1 * BufRateScale.ir(~brilliantradiator), 1, 0, \loop.kr(1))});

Ndef(\brilliantradiator).fadeTime_(30).play(fadeTime: 30);


play{var snd; snd = SinOsc.ar(126*8, 0, Env.perc(1, 0.3, 0.07).kr(2))};




Ndef(\trac, Pbind(*[instrument: \coloredechoes, buffer: Prand(C.get(\thanks, [5, 6]), inf), color: Prand([200, -200, 400, 1000, 2000], inf), loop: 0, fadetime: 5, \dur, Pkey(\fadetime) * 2, amp:1.5]));

Ndef(\trac).play;
Ndef(\trac).stop;

Pbindef(\n).stop;

// WITH PBINDEF OF PIPE SAMPLES ?


play{SinOsc.ar(126*8, 0, Env.linen(2, 3, 0.2, 1).kr(2) * SinOsc.kr(20).range(0, 0.07))}




(
x.release(10);
x = Synth(\pulsardm, [bufNum: ~resonancetoilette, rate: 1, overlap: 30000, trigRate: 30000, pos: 0.2, trigRateDev: 0.1, amp: 3])
)

(
x.release(30);
x = Synth(\pulsardm, [bufNum: ~resonancetoilette, overlap: 300, trigRate: 3000, pos: 0.2, trigRateDev: 0.1, amp: 1, pan: -1/3, atk: 30])
)

(
y.release(30);
y = Synth(\pulsardm, [bufNum: ~resonancetoilette, rate: 0.5, overlap: 30, trigRate: 300, pos: 0.2, atk: 30, trigRateDev: 0.1, amp: 1, pan: 0.3])
)





Ndef('rumble', 'bassbynathan').set(\freq, 126/2);
Ndef('rumble').lag(\freq, 3, \floor, 30);
Ndef('rumble').play(fadeTime:30, vol: 0.1);


Ndef(\rumble).set(\freq, 126/2);
// 90, 82, 45

Ndef(\rumble)[5] = nil;


Ndef(\brilliantradiator)[10] = \filter -> {|in| Resonator.ar(in, 90/4, structure: 1/2, brightness: 0.3, damping: 0.9)};

NdefMixer(s)

Ndef(\brilliantradiator)[10] = nil;

Ndef(\brilliantradiator)[20] = \filter -> {|in| Balance2.ar(in[0], in[1], LFDNoise3.kr(1)/2)}

Ndef(\brilliantradiator)[30] = \filter -> {|in| in * LFNoise2.kr(0.3, 0.2, 1)}

Ndef(\brilliantradiator).stop(30);


Ndef(\trac).clear(0);










-----------

(
var fade = 1;
// y.release(fade);
x.release(fade * 1.2);
Ndef('rumble').stop(fade);
Ndef('brilliantradiator').stop(fade);
)

(
var fade = 1;
Ndef('rumble').play(vol: 1/5, fadeTime: fade);
Ndef('brilliantradiator').play(fadeTime: fade);
// ~tabble.play(fadeTime:fade);
)


(
var dur = 5;
~melody.stop;
~melody = Routine.run({{
Ndef('rumble').set(\freq, 126/2);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 3);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 10);
	(dur*2).wait;
	}.loop

}
)
)

Ndef('rumble').fadeTime_(1).vol = 1/4;
Ndef('rumble').set(\freq, 126/2);
Ndef('rumble').set(\freq, 126/2 - 3);
Ndef('rumble').set(\freq, 126/2 - 10);
Ndef('rumble').set(\freq, 126/2 - 15);


Ndef('rumble')[10] = \set -> Pbind(\dur, Pseq([2, 2, 4], inf), \freq, Pseq([63, 60, 50], inf), \amp, 1);



(
Ndef('rumble').fadeTime=30;
Ndef('rumble').set(\floor, 1000);
Ndef('rumble')[10] = \filter -> {|in| LPF.ar(in, SinOsc.kr(10).exprange(20, 10000)) * 2};
)


Ndef('rumble')[10] = nil;


Ndef('rumble').play(10);
x.release(10);
y.release(10)



(
var fade = 30;
y.release(fade);
x.release(fade * 1.2);
Ndef('rumble').stop(fade);
Ndef('brilliantradiator').stop(30);
)
Ndef(\trac).stop;




(
Pdef(\pat1).stop;
Pdef(\pat2).stop;
)


Ndef(\brilliantradiator, {PlayBuf.ar(2, ~brilliantradiator, 1 * BufRateScale.ir(~brilliantradiator), 1, 0, \loop.kr(1))});

Ndef(\brilliantradiator).fadeTime_(30).play(fadeTime: 30);

Ndef(\brilliantradiator).stop(30);

m.release(30)
m.free;


play{var snd; snd = SinOsc.ar([126, 128]*8, 0, Env.perc(3, 0.3, 0.07).kr(2))};



Ndef(\trac, Pbind(*[instrument: \coloredechoes, buffer: Prand(C.get(\thanks, [5, 6]), inf), color: Prand([200, -200, 400, 1000, 2000], inf), loop: 0, fadetime: 5, \dur, Pkey(\fadetime) * 2, amp:1.5])).play;

Ndef(\trac).stop;

Pbindef(\n).stop;

// WITH PBINDEF OF PIPE SAMPLES ?


play{SinOsc.ar(126*8, 0, Env.linen(2, 3, 0.2, 1).kr(2) * SinOsc.kr(20).range(0, 0.07))}



(
x.release(10);
x = Synth(\pulsardm, [bufNum: ~resonancetoilette, rate: 1, overlap: 30000, trigRate: 30000, pos: 0.2, trigRateDev: 0.1, amp: 3, atk: 0]);
)


(
y.release(10);
y = Synth(\pulsardm, [bufNum: ~resonancetoilette, overlap: 300, trigRate: 3000, pos: 0.2, trigRateDev: 0.1, amp: 1, pan: -1/3, atk: 30]);
)

(
z.release(30);
z = Synth(\pulsardm, [bufNum: ~resonancetoilette, rate: 0.5, overlap: 30, trigRate: 300, pos: 0.2, atk: 30, trigRateDev: 0.1, amp: 1, pan: 0.3]);
);


(
Ndef('rumble', 'bassbynathan').set(\freq, 126/2);
Ndef('rumble').lag(\freq, 3, \floor, 30);
Ndef('rumble').play(fadeTime:30, vol: 0.2);
);


Ndef('rumble').vol=0.3;

-----------



(
var dur = 5;
~melody.stop;
~melody = Routine.run({{
Ndef('rumble').set(\freq, 126/2 - 3);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 10);
	(dur * 2).wait;
Ndef('rumble').set(\freq, 126/2);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 3);
	dur.wait;
Ndef('rumble').set(\freq, 126/2 - 10);
	(dur).wait;
Ndef('rumble').set(\freq, 126/2 - 15);
	(dur).wait;
Ndef('rumble').set(\freq, 126/2);
	dur.wait;
	}.loop;
}
)
)


Ndef(\wobl).stop;

~melody.stop; Ndef('rumble').xset(\freq, 126/2 - 20);
Ndef('rumble').xset(\freq, 126/2 - 25);

(
var fade = 50;
x.release(fade);
y.release(fade * 1.2);
z.release(fade * 1.2);
Ndef('brilliantradiator').stop(fade);
Ndef('rumble').stop(fade);
Ndef(\trac).stop;
)

~wsamples.play;
~wsamples.stop;

~ht.stop;
~sine.release


-------------
