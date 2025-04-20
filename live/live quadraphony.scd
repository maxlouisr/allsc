(
MIDIClient.init;
// MIDIIn.disconnectAll;
MIDIIn.connect(0, 1524111586);
)


"/Users/maxlouisraugel/Documents/sc/instruments/quadraphony.scd".load;
"/Users/maxlouisraugel/Documents/sc/instruments/FX.scd".load;



(instrument: \k, amp: 1, freq: 24.midicps, rel: 3, distortion: 0.9, pan: 0.25, out:[0,2]).play;

Server.killAll;
s.volume.gui;

Pbind(\instrument, \mkick, \freq, Pseq((24..48)).midicps, \amp, 1.2, \atk, 0.01, \rel, 7, \dur, Pkey(\rel) + 1).play;

---------------------------

s.scope;

{var snd; snd = SinOsc.ar(100, 0, 0.5); snd = snd * Env.perc(0.01, 3).kr(2); snd = PanAz.ar(s.options.numOutputBusChannels, snd, 1.linlin(1, 4, -0.25, 1.25))}.play;

(
{var snd; snd = SinOsc.ar(MouseY.kr(20, 20000, 1).poll, 0, 0.1);
	// snd = snd * Env.perc().kr(2);
	snd = Out.ar([0, 1, 2, 3], snd);
}.play;
)



-------------------------------------------------













// LEKJZHRLKJZHLRKJZHLKRJH

~wsamples.play;

u.play(fadeTime:0);
u.vol=0.9;
u.stop(30);

u.fadeTime = 30; u.xset(\minfreq, 200, \maxfreq, 20000); u[10] = \filter -> {|in| Splay.ar(FreeVerb.ar(in, 0.3, 3))};

(
u.fadeTime=10;
u[10] = \filter -> {|in| Splay.ar(JPverb.ar(in,
	t60: 10,
	damp: 0,
	size: 1,
	earlyDiff: 0.7,
	modDepth: 0.2,
	modFreq: 2,
	low: -1,
	mid: 0.2,
	high: 0.3,
	lowcut: 100,
	highcut:1000);
)}
);



-----

~sinespulse.play(fadeTime: 50);

/*(
MIDIdef.cc(\rrange, {|val| ~sinespulse.set(\rrange, val.linlin(0, 127, 0.01, 0.99))}, 73, 0).fix;
MIDIdef.cc(\modspeed, {|val| ~sinespulse.set(\modspeed, val.linlin(0, 127, 0.1, 30))}, 74, 0);
MIDIdef.cc(\speed, {|val| ~sinespulse.set(\speed, val.linlin(0, 127, 0.01, 2))}, 75, 0);
)*/

~sinespulse.fadeTime=10; ~sinespulse[10] = \filter -> ~jpverb;

~sinespulse.stop(10);




-----




(
~filaments.release(1);
Ndef(\u).stop(10);
~arp.stop;
~arp2.stop;
~kickarp.stop;

~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf), amp: 1.3, rel: Pseg([10, 5, 10], [10, 10], 'lin', inf)]).play;

~arp2 = Pbind(*[instrument: \psine, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf), amp: (1/5)]).play;

~kickarp = Pbind(*[instrument: "kick", dur: Pseq((5!2)++(0.3!5)++(4.5)++(0.03!17)++(0), 3), freq: 50, amp: 1, rel: Pkey(\dur)/10]).play;
);

(
~filaments.release(1);
Ndef(\u).stop(10);
~arp.stop;
~arp2.stop;
~kickarp.stop;
)

-----


~fib.play(fadeTime:30);

~fib.set(\density, 0.1);
MIDIdef.cc(\fibdensity, {|val| ~fib.set(\density, val.linexp(0, 127, 0.01, 100))}, 72, 0).fix;

~fib.stop(30);



-------

~buzz.play(fadeTime: 40); ~buzz.fadeTime=20;

/*~buzz[20] = \filter -> ~panAz;
~buzz[20] = nil;*/

~buzz.stop(20);

------


~foursaw.play(fadeTime:20);
~foursaw.stop(10);

/*~foursaw.xset(\rate, 1);

r.stop;r = {{~foursaw.play(fadeTime:0.1); rrand(2, 7.0).wait; ~foursaw.stop(0.1); rrand(2, 7.0).wait;}.loop}.fork;
r.stop;

~foursaw[30] = \filter -> ~freeverb;~foursaw.xset(\damp, 0);
~foursaw[50] = \filter -> ~magAbove; ~foursaw.set(\threshold, 5, \gain, 2);
~foursaw[50] = nil;
~foursaw.stop(10);


~broken.play(fadeTime:0.1);
~broken.stop(10);*/


-----



(
~bounces = Ndef(\bounces, {
	var snd, rate, env, envlinen, buffer, t;
	t = Impulse.kr([1, 1.001, 0.999, 1.997]);
	buffer = \buffer.kr(d[\bells][2]);
	env = Env.perc(0.01, 0.1, 0.1).kr(0, gate: t);
	snd = PlayBuf.ar(2, buffer, BufRateScale.ir(\buffer.kr) * (\note.kr([0, 2, 7, 11]).midiratio), t, \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(0));
}).mold(4).fadeTime_(10).play;
)

/*~bounces[10] = \filter-> {|in| Greyhole.ar(in, 0.5, \damp.kr(0.9), \size.kr(1.0), 0.707, \fb.kr(0.4))}
~bounces[20] = \filter-> {|in| Pan4.ar(in.sum)};*/


----


// check
(
p.play(fadeTime:20);
p[10] = \filter -> {|in| var snd; snd = Greyhole.ar(in, \delay.kr(0.5, 10), \damp.kr(0, 10)); Pan4.ar(snd.sum)}; p.set(\wet10, 0.5);
)

p[10] = nil;

(
MIDIdef.cc(\delay, {|val| p.set(\delay, val.linlin(0, 127, 0, 2))}, 72, 0);
MIDIdef.cc(\damp, {|val| p.set(\damp, val.linlin(0, 127, 0, 1))}, 73, 0);
MIDIdef.cc(\wet10, {|val| p.set(\wet10, val.linlin(0, 127, 0, 1))}, 74, 0);
);



/*~perc.play(fadeTime:10);
~perc.set(\freq, 1900);
~perc.set(\pan, 0, \width, 2.0);
~perc.stop(20);*/


------


g.play(fadeTime:30);

/*g[10] = \filter -> {|in| var snd; snd = (in*30).cos * 0.1; snd = HPF.ar(snd, 50, 0.4)}
g[10] = nil;*/


-------


h.play(fadeTime:30);


/*h[50] = \xset -> Pbind(\pitch, Prand([1.05, 1.25, 0.95], inf), \dur, 7);
h[40] = \filter -> {|in| in * LFPulse.kr(MouseY.kr(1, [5, 6, 7, 8])).lag(0.3) * 2};
h[40] = nil;
h.fadeTime=0; h[40] = nil;
h.set(\rndpitch, 0.1);
h.set(\time, 1);
h[50] = \filter -> {|in| Pan4.ar(in.sum, 0, 0)};
h.stop(10);*/


-----
s.scope

(
~map1.free;
~map1 = {
	var snd, lfsaw;
	lfsaw = LFSaw.kr(\lfreq.kr(1), 0, \lamp.kr(1));
	snd = SinOscFB.ar(\freq.kr(100) + lfsaw, \sinamp.kr(1.0), \sinamp.kr(1.0));
	snd = snd * LFGauss.kr(\lfgauss.kr(3), \lfwidth.kr(1));
	snd = PanAz.ar(8, snd, lfsaw.range(0, 3));
}.play;

MIDIdef.cc(\64, {|val| ~map1.set(\freq, val.linexp(0, 127, 20, 1000))}, 64, 0);
MIDIdef.cc(\65, {|val| ~map1.set(\sinamp, val.linlin(0, 127, 0, 1))}, 65, 0);
MIDIdef.cc(\66, {|val| ~map1.set(\lfreq, val.linexp(0, 127, 0.01, 30))}, 66, 0);
MIDIdef.cc(\67, {|val| ~map1.set(\lamp, val.linlin(0, 127, 0, 1))}, 67, 0);
MIDIdef.cc(\68, {|val| ~map1.set(\lfgauss, val.linlin(0, 127, 1, 3))}, 68, 0);
MIDIdef.cc(\69, {|val| ~map1.set(\lfwidth, val.linlin(0, 127, 0.01, 3))}, 69, 0);
)



(
~fib.stop(50);
~buffer.stop(30);
~buzz.stop(30);
~sinespulse.stop(70);
~foursaw.stop(30);
~bounces.stop(50);
p.stop(80);
~perc.stop(30);
g.stop(50);
h.stop(50);
)


(
~arp.stop;
~arp2.stop;
~kickarp.stop;
)

~fib.stop;









// NEWNEWNENLZKUHRLKZJHLFKRJHZLKFJHZLKRJFHLKZJ
-----

// CRACK

(
~map1.release(20);

~crack_amp = 0.1;
MIDIdef.cc(\foo, {|val| ~crack_amp = val.linexp(0, 127, 0.001, 0.3) }, 64);
// ~bar = ~bar ?? MIDIFunc.cc({|val| ~foo = val.linlin(0, 127, 0, 0.5) }, 64);

~varispeed = 1;
MIDIdef.cc(\varispeed, {|val| ~varispeed = val.linlin(0, 127, 10, 1) }, 65);
// ~bar2 = ~bar2 ?? MIDIFunc.cc({|val| ~varispeed = val.linlin(0, 127, 1, 0.1) }, 65);

~crack.stop;
~crack = Pbindef(\crack,
	\instrument, \percsinefb,
	\freq, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf)
	// *Pfunc({~transposecrack})
	,
	// \dur, PSinOsc(0.28, 0, 0.1, 0.1)/4,
	\dur, PSinOsc(0.28, 0, 0.1, 0.1)/4 * Pfunc({~varispeed}),
	\atk, 0,
	\rel, 0.1,
	// \rel, Pkey(\dur),
	\amp, Pfunc({~crack_amp}),
	// \amp, 0.04,
	\feedback, Pseries(0, 0.12, inf),
	// \feedback, 0,
	\pan, Pxrand([1, 2, 3, 4], inf)
);

~crack.play;
)

----



s.scope

(
~cuves.release(3);
~cuves = {
	var snd, trig, lfo;
	lfo = LFNoise2.kr(3);
	trig = Impulse.kr(lfo.range(0.1, 0.5));
	snd = SinOscFB.ar(lfo.exprange(200, 220), 0.5, 0.1);
	snd = snd * Env.perc(0.01, \rel.kr(2)).kr(0, gate: trig);
	// snd = GVerb.ar(snd, 1, 3);
	snd = GVerb.ar(snd, 2, (lfo * lfo).range(0.5,1));
	snd = Limiter.ar(snd, 0.1);
	// snd = LPF.ar(snd, 800);
	// snd = Out.ar(TChoose.kr(Dust.kr(0.2), [0, 1, 2, 3]), snd);
	snd = PanAz.ar(4, snd.sum, LFNoise2.kr(1).range(-0.25, 1.75), \amp.kr(1));
	snd = Sanitize.ar(snd);
	// snd = Pan2.ar(snd, LFNoise2.kr(0.3));
}.play(fadeTime:10);

~bells.play(fadeTime: 20);
)

u.stop(10)


--------
// 48, 42, 35
(instrument: \k, amp: 0.9, freq: 47, rel: 5, pan: 0.25, out:[0, 2]).play;
(instrument: \k, amp: 0.9, freq: 42, rel: 10, pan: 0.25, out:0).play;



(instrument: \k, amp: 0.9, freq: 47, rel: 5, pan: 0.25, out:[0, 2]).play;
------------

s.scope;

(
~one.stop;
~one = Pbind(\instrument, \percsinefb_mono, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf), atk: 2, rel: 3, amp: 0.05, feedback: 1/2, dur: 5, out: Pxrand((0..3), inf) ]).play;
)

(
~two.stop;
~two = Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf), atk: 20, rel: 30, amp: 0.9, dur: 10, out: Pxrand((0..3), inf)]).play;
)

-----



~sub.play(fadeTime:10);
~sub.stop(30);

n.play;
n.set(\dur, 1);

n.stop(10);

s.scope;

(
~p1.stop; ~p2.stop;
~p1 = Pdef(\sinesaw_mono, Pbind(\instrument, \sinesaw, \dur, 7, \freq, Pxrand([200, 220, 500, 380], inf), \amp, 1, \out, Pxrand((0..3), inf))).play;
~p2 = Pbind(*[\instrument, \percsine_mono, dur: Pwhite(1, 3), freq: Pxrand([200, 220, 500, 380], inf), \amp, 0.1, \out, Pxrand((0..3), inf)]).play;
);


~wsamples.play;
~wsamples.stop;

Ndef(\x).clear;

(
x = Ndef(\x, {var snd, mc, lfo;
	mc = 10;
	lfo = LFNoise2.kr(\mod.kr(0.3)).range(0, 3.0);
	// lfo = \mod.kr(0.3).range(0, 3.0);
	// snd = SinOscFB.ar({exprand(20, 3000)}!mc, lfo.range(0, \fb.kr(1.0)), {LFNoise2.kr(3, 0.05, 0.1)}!mc);
	snd = SinOscFB.ar(([200, 220, 500, 380]*[[0.5, 0.25, 1, 2]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(1.0)), {lfo.range(0, 0.05)}!10);
	// snd = BPF.ar(snd, {exprand(20, 3000)});
	snd = HPF.ar(snd, 100);
	snd = SplayAz.ar(8, snd, 1, 1, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0);
	snd = snd.blend(JPverb.ar(snd, 6), \jpverb.kr(0));
}).play;

MIDIdef.cc(\xmod, {|val| Ndef(\x).set(\mod, val.linlin(0, 127, 0.1, 0.5))}, 12, 0).fix;
MIDIdef.cc(\xfb, {|val| Ndef(\x).set(\fb, val.linlin(0, 127, 0, 1.5))}, 13, 0).fix;
MIDIdef.cc(\xverb, {|val| Ndef(\x).set(\jpverb, val.linexp(0, 127, 0.1, 1.0))}, 14, 0).fix;
MIDIdef.cc(\xamp, {|val| Ndef(\x).set(\amp, val.linlin(0, 127, 0.01, 10))}, 15, 0).fix;
);

/*(
~kharm = Ndef(\kharm, Pbind(\instrument, \mkick,  [\freq, \dur], Pseq([[50, 7], [57, 9], [75, 3]], inf), \rel, 10, \amp, 0.9));
~kharm.play(fadeTime:0);
)*/

(
~kharmvolume = 0;
MIDIdef.cc(\kharmvolume, {|val| ~kharmvolume = val.linlin(0, 127, 0, 3) }, 73).fix;
~kharm = Pbindef(\kharm,\instrument, \mkick,  [\freq, \dur], Pseq([[50, 7], [57, 9], [75, 3]], inf), \rel, 10, \amp, Pfunc({~kharmvolume}), \hpf, 0, \out, [0, 2]);
~kharm.play;
)

Pbindef(\kharm, \hpf, 0);
Pbindef(\kharm, \brf, 0);


(
~wpyramid.play;
// ~washes.play(fadeTime:30);
)


(instrument: \epyramid, ampe: Env([0, 0.5, 0], [rrand(3, 30), rrand(3, 30)]), freqe: Env([exprand(300, 3000), exprand(300, 3000)], 6), x: Env([-1, 1], rrand(3, 30)), y: Env([-1, 1], rrand(3, 30))).play;



MIDIdef.cc(\rrramp, {|val| ~rrr.set(\amp, val.linlin(0, 127, 0, 1)) }, 74).fix;
~rrr.play(fadeTime:0);


(
~washes.stop(10);
~wpyramid.stop;
)
---


(
~one.stop;
~one = Pbind(\instrument, \percsinefb_mono, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf) * Pxrand([1, 2, 4, 8, 16], inf), atk: 2, rel: 3, amp: 0.02, feedback: 1/2, dur: 5, out: Pxrand((0..3), inf) ]).play;

~two.stop;
~two = Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.25, inf)* Pxrand([1, 2, 4], inf), atk: 20, rel: 30, amp: 0.7, dur: 10, out: Pxrand((0..3), inf)]).play;
);




------
~sub.stop(20);

(
a.play(fadeTime:0);

MIDIdef.cc(\avion, {|val| a.set(\avion, val.linlin(0, 127, 0.01, 1))}, 76).fix;
MIDIdef.cc(\height, {|val| a.set(\height, val.linlin(0, 127, 0.01, 2))}, 77).fix;
MIDIdef.cc(\air_amp, {|val| a.set(\amp, val.linlin(0, 127, 0, 1))}, 79).fix;
)


a.set(\avion, 1, \limit, 0.9, \rq, 0.0001, \height, 2);
a.set(\avion, 0.1, \limit, 0.9, \rq, 0.01, \height, 1);


-----

Synth(\fml4, [\freqA, exprand(2000, 1000), \freqB, ([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten.choose, \time, 0.1, \amp, 0.1/2, \atk, 0.01, \rel, 10, \pan, rrand(0, 3.0)]);


-----------------


(
~wpyramid.stop;
~crack.stop;
Ndef(\x).stop(60);
~bells.stop(20);
~washes.stop(10);
~sinpi.stop(10);
~one.stop;
~two.stop;
~p1.stop; ~p2.stop;
~cuves.release(30);
~wsamples.stop;
~rrr.stop(30);
~sub.stop(30);
);

a.stop(60);


~kharm.stop;













































-------


x.release(10);

s.scope

~vibes.play(fadeTime:10);

~vibesB.play;
~vibesB.stop(30);

~vibes[10] = \filter -> {|in| HPF.ar(in, XLine.kr(20, 20000, 30))};

(
~vibes.stop(1);
~vibesB.stop(1)
)


------


// check

(
x.release(10);
Routine.run{
	var snd, fall;
	fall = rrand(3, 7);
	x = {SinOsc.ar(Env([exprand(10000, 20000), exprand(200, 300), {rrand(90, 110)}!4], [fall, 7], 'exp').kr(0),0, 0.1)}.play(fadeTime:10);
	fall.wait;
	d[\kicks][7].play;
	x.release(10);
};
)

s.meter;

// check

~shifts.vol_(0.1).play(fadeTime:10);

~shifts.stop(2);

~shifts.set(\lag, 3, \freq, [370, 1900, 3100, 330]);

~shifts.set(\lag, 3, \freq, {[370, 1900, 3100, 330].choose}!4);

~shifts.set(\lag, 3, \freq, [120, 170, 140, 100]);
~shifts.set(\lag, 7, \freq, [170, 140, 100, 120]);
~shifts.set(\lag, 9, \freq, [140, 100, 120, 170]);

~shifts.set(\lag, 10, \freq, [310, 330, 370, 1900]);
~shifts.set(\lag, 1, \freq, [330, 370, 1900, 3100]);

~shifts.stop(3);


MIDIdef.cc(\shifts_freq, {|val| ~shifts.set(\freq, [val.linlin(0, 127, 200, 2000)])}, 0, 0);



d[\kicks][7].play;


b = Ndef(\ball, Pbind(\type, \dirt, \dirt, ~dirt, \s, \kicks, \n, 7, \pan, Pseg((0..10)/10, (10..1)/5, 'lin', inf), \legato, 1, \dur, Pseg((20..10)/10, (10..1)/5, 'lin', inf)));

b.play;

b.stop;

------

(
p.stop;
p = Pbind(\instrument, \stkBowed4,
	\bowposition, 10,
	\dur, Prand([3, 2], inf)/20,
	\bowpressure, Pwhite(20, 200),
	\vibfreq, Pwhite(10, 2000),
	\loudness, Pwhite(0, 128),
	\freq, Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf),
	\pan, Pwhite(0, 3),
	\loudness, Pwhite(20, 100);
).play
)


p.free;
-----
s.scope;

~leta = Pbindef(\leta, \instrument, \playAzComb, \buffer, Pxrand(40.collect{|i| d[\lilianeetandree][i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 4, \pan, Pwhite(0, 3.0), \note, -12, \combfreq, ([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, \combmix, 0.2, \combd, 3, \amp, 0.1); ~leta.play;

~leta.stop;


-------


~ssaw.play(fadeTime:10);
~ssaw.stop(30);


~boom.play;
~boom.stop;


// check

~pvwhite.fadeTime=10;~pvwhite.play;

~pvwhite.stop;



----

(
~p1[10] = \filter -> ~greyhole;
~p2[10] = \filter -> ~greyhole;
~p3[10] = \filter -> ~greyhole;

~p1.play(fadeTime:30);
~p2.play(fadeTime:30);
~p3.play(fadeTime:30);
)

(
var dur = 1;
~p1.clear(dur);
~p2.clear(dur);
~p3.clear(dur);
)


-----

~sinpi.play(fadeTime:2);

~sinpi[10] = \set -> Pbind(\pitch, Prand((([200, 220, 500, 380]*[[0.5, 0.25, 1, 2]]).flatten.cpsmidi-60).midiratio, inf), \dur, Pxrand([2, 3, 5], inf), \freq, Prand([100, 200], inf), \x, Pwhite(-1, 1.0)/2, \y, Pwhite(-1, 1.0)/2, \lag, 0.5, \amp, 0.5);

~sinpi.stop(10);

~exta = Ndef(\exta, Pbind(\instrument, \percsine, \dur, 1/8, \freq, Pshuf(Array.fib(10, 2, 100), inf), \amp, 0.1, \pan, Pseq((0..3), inf)));

~exta.play(fadeTime:3);
~exta.stop(0);


~sinpi.stop; ~buzz.stop; ~exta.stop; ~buffer.stop;



--------------


~sweeps.reset; ~sweeps.play;
~sweeps.stop;

~filaments.play;
~filaments.stop(10);



-----



s.scope
(
~harmonic.play;

	MIDIdef.cc(\72, {|val| ~harmonic.set(\freq, val.linexp(0, 127, 20, 20000))}, 72, 0).fix;
	MIDIdef.cc(\73, {|val| ~harmonic.set(\pitch, val.linlin(0, 127, 0.1, 10))}, 73, 0).fix;
	MIDIdef.cc(\74, {|val| ~harmonic.set(\rndpitch, val.linlin(0, 127, 0, 10))}, 74, 0).fix;
	MIDIdef.cc(\75, {|val| ~harmonic.set(\amp, val.linlin(0, 127, 0, 2))}, 75, 0).fix;

)

------------

(
~map1.free;
~map1 = {
	var snd;
	snd = SinOsc.ar(\freq.kr(100), 0, \sinamp.kr(1.0));
	snd = snd * LFSaw.kr(\lfreq.kr(1), 0, \lamp.kr(1));
	snd = PanAz.ar(4, snd, LFGauss.kr(\lfgauss.kr(3), \lfwidth.kr(1)));
}.play;

MIDIdef.cc(\64, {|val| ~map1.set(\freq, val.linexp(0, 127, 20, 1000))}, 64, 0);
MIDIdef.cc(\65, {|val| ~map1.set(\sinamp, val.linlin(0, 127, 0, 1))}, 65, 0);
MIDIdef.cc(\66, {|val| ~map1.set(\lfreq, val.linexp(0, 127, 0.01, 30ê))}, 66, 0);
MIDIdef.cc(\67, {|val| ~map1.set(\lamp, val.linlin(0, 127, 0, 1))}, 67, 0);
MIDIdef.cc(\68, {|val| ~map1.set(\lfgauss, val.linlin(0, 127, 1, 3))}, 68, 0);
MIDIdef.cc(\69, {|val| ~map1.set(\lfwidth, val.linlin(0, 127, 0.01, 3))}, 69, 0);
)


-----

~buffer.set(\b, d[\wd][7], \loop, 1); ~buffer.play; ~buffer[7] = \filter -> ~bpfgeom; ~buffer.set(\start, 100, \grow, 2, \rq, 0.01, \amp, 5);
~buffer[20] = \filter -> ~panAz;
~buffer.set(\drift, 3);
~buffer.stop(30);

