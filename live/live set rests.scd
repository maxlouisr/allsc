


(
Pbindef(\hey, \instrument,	\mkick,
	\freq, 50,
	\freq, Pxrand([100, 30, 120, 50], inf),
	\dur, Pxrand([1, 2, 4], inf) / PSinOsc(Pxrand([3, 2], inf), 0, 10, 10),
	\atk, Pkey(\dur)/2,
	\rel, Pkey(\dur),
	\resf, 100, \pan, Pwhite(),
		\amp, 1
).play;
)


(
Ndef(\Quadunison, {
	var snd, env, freq, trig, density, atk, rel, sus, f1, f2, f3, f4;
	atk = \atk.kr(7);
	rel = \rel.kr(7);
	sus = \sus.kr(7);
	density = 1/(atk + sus + rel);
	trig = Impulse.kr(density);
	env = Env.linen(atk, sus, rel).kr(0, trig);
	freq = {TRand.kr(20, 20000, trig);}
	freq = Env(
		[
			[\f1.kr(1000), \f2.kr(2000), \f3.kr(1300), \f4.kr(1700)],
			[\f1.kr(1000), \f2.kr(2000), \f3.kr(1300), \f4.kr(1700)],
			\f5.kr(200),
			\f5.kr(200)],
		[atk, sus, rel],
		'sine'

	).kr(0, gate: trig);
	snd = SinOscFB.ar(freq, \fb.kr(0.5), env * 0.1);
}).play;
)

Ndef.clear;


(
SynthDef(\quadtounison, {
	var snd, env, freq, unison, trig, density, atk, rel, sus, harmony, outputs;
	outputs = 2;
	atk = \atk.kr(7);
	rel = \rel.kr(7);
	sus = \sus.kr(10);
	trig = 1;
	env = Env([0, 1, 1, 0], [atk, sus, rel], 'lin').kr(0, gate: trig);
	// freq = {TRand.kr(20, 2000, trig)}!4;
	// unison = TRand.kr(100, 2000, trig) * {rrand(0.95, 1.05)}!4;
	harmony = ([43.35, 38, 47, 40, 50, 54] * [1, 2]).midicps;
	freq = {TChoose.kr(trig, harmony)}!2;
	unison = TChoose.kr(trig, harmony);
	freq = Env(
		[
			freq,
			freq,
			unison * ({TRand.kr(0.95, 1.05, trig)}!2).poll,
			unison],
		[atk, sus, rel],
		'sine'

	).kr(0, gate: trig);
	snd = SinOscFB.ar(freq, \fb.kr(1), env * 0.1);
	// snd = JPverb.ar(snd, modFreq: 0.1);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\quadtounison);

~quadunison = Pbindef (\quaduni, \instrument, \quadtounison, \dur, 30).play;

// MIDIdef.cc(\test, {|val chan src n| [val, chan, src].postln}); MIDIdef.cc(\test,  {arg ...args; args.postln});


~intro1 = Ndef(\intro_pads1, Pbind(\instrument, \percsinefb, *[freq: Pseq([Pxrand([43.35, 38, 47]), Pxrand([40, 50, 54])], inf).midicps * Prand([1, 2, 4], inf), atk: 6, rel: 6, amp: 0.07, feedback: 1/2, dur: 12, pan: Prand([-1, 1.0], inf)])).play(fadeTime:0);

~intro2 = Ndef(\intro_pads2, Pbind(\instrument, \moogbass, *[freq: Pseq([Pxrand([43.35, 38, 47]), Pxrand([40, 50, 54])], inf).midicps * Prand([1, 2], inf), atk: 6, rel: 6, amp: 1, feedback: 1/2, dur: 12, pan: Prand([-1, 1.0], inf)])).play(fadeTime:0);

// Ndef(\drone1).fadeTime=10; Ndef(\drone1)[10] = \filter->{|in| RLPF.ar(in, \lpfreq.kr(10000, 1), 1, 1)}; MIDIdef.cc(\lpfreq, {|val| Ndef(\drone1).set(\lpfreq, val.linlin(0, 127, 200, 20000))}, 16, 0)




// ~filaments.play(fadeTime:0);
// ~filaments.stop;



// Pbindef(\pp, \instrument, \poom, \atk, 0.1, \dur, Pseq([2, 1, 1/3, 1/3, 1/3], inf), \rel, Pkey(\dur) * 3, \amp, 0.2, \freq, Pxrand([47.midicps, 66.midicps, 64.midicps, 62.midicps, 59.midicps], inf)).play(quant:1);

// Pbindef(\1, \instrument, \fm, \atk, 0.2, \amp, 15, \rel, 0.1, \freq, (59 + 24).midicps, \dur, Pseg([1/2, 0.1, 1/2], 5, 'sine', inf), \seedDrift, 0.3, \seed, 50, \pan, PSinOsc(0.0011), \out, 0).play(quant:1);
// Pbindef(\1).stop;

// Pbindef(\riddim, \instrument, \playbuf, \dur, 4, \buffer, Pseq([d[\snares][31,57]], inf), \amp, 1/5, \pan, Pseq([-1, 1.0]/2, inf)).play(quant:4);
// Pbindef(\riddim).stop;


(
~microgaussian.release(0);
~microgaussian = {var snd;
	snd = {
		Splay.ar(
			SinOsc.ar(
				{LFNoise2.kr(0.01).range(100,1000)},
				mul: {LFGauss.kr(LFNoise2.kr(1).range(0.1,10)).range(0.001,0.2)} * Line.kr(0, 0.5, 10),
				add: Saw.kr(freq: (LFNoise1.kr(1)), mul:0.3))
		)
	}!3;
	// snd = HPF.ar(snd, 90);
	snd = snd.tanh;
	// snd = snd.cos;
	snd = HPF.ar(snd, 150);
}.play(fadeTime: 30);
)



/*(
Ndef(\m).fadeTime = 10;
Ndef(\m, {
	Splay.ar(
		{
			SinOsc.ar(
				exprand(20, 20000),
				mul:Line.kr(0, 0.03, 10)
				* {LFNoise2.ar(\amps.kr(0.5)) * \amp.kr(1)}
		)}!100
)});
Ndef(\m).play(fadeTime:30);
)*/

Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1, \rel, 10, \out, 0]);

Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1/2, \atk, 0.1, \rel, 10, \out, 0]);



(
Ndef(\buzz, { var snd;

	snd = Splay.ar(BPF.ar(
		LFSaw.ar(
			LFSaw.kr(
				682 + LFNoise2.kr(1, 1, 0),
				0,
				1000,
				// [1000] *8,
				[2000]
				// [2000]*4

),
			0,
			1.5
)));
	snd = BPF.ar(snd, 700);
	// snd = (snd * 10).clip * 0.5;
	// snd = HPF.ar(snd, 700);
	// [Mono(snd), DelayC.ar(Mono(snd), 0.2, Line.kr(0, 0.1, 10))];
}
).play(fadeTime:10);
)


(
~conv = EZConv("/Users/maxlouisraugel/Documents/ /ploc.wav");
~conv2 = EZConv("/Users/maxlouisraugel/Documents/ /fire bottle ..wav");
)


(
Ndef(\u)[10] = nil;
Ndef(\u, {
	var snd = Splay.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(200, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 2, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
	)}!3);
	snd = ~conv.ar(snd, \leak.kr(0), 0.3);
	snd = ~conv2.ar(snd, \leak.kr(0), 0.3);
	snd = Limiter.ar(snd, 0.3);
});
)

Server.killAll






--------------------------------------------



(
~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf).poll, amp: 1*1.3, rel: Pseg([10, 5, 10], [10, 10], 'lin', inf)]).play;

~arp2 = Pbind(*[instrument: \percsine, freq: Pseg([500/4, 1200 *2, 300, 250], [10, 10, 1], 'lin', inf), amp: (1/5)*1.3]).play;

~kickarp = Pbind(*[instrument: "k", dur: Pseq((5!2)++(0.3!5), 7), freq: 50, amp: 0.8]).play;
)

~kickarp.stop;


w = Synth(\blosc2randfm, [freq: 1030, atk: 30, rel: 30, amp: 1/10]);


~sine = Synth(\sine, [freq: 990 / 16, atk: 0.1, amp:1/5]);
~sine.release(1);



Ndef(\blosc2).play(fadeTime: 20);

Ndef(\wabble).play;

Ndef(\wabble).set(\density, 0.1);


var fade = 10;~blosc2.release(fade);

Ndef(\blosc2).stop(20);

~wsamples.stop;

(
~arp.stop;
~arp2.stop;
~kickarp.stop;
)

Ndef(\rongs).stop;
Ndef(\wabble).stop;

~samples.stop;
Ndef(\u).stop(30)

--------------------------------------------



-----------



(
C.s(\kick);
C.s(\snares);
)

~sweeps.stop;
~filaments.stop;


(
Ndef(\stk).clear;
Ndef(\stk, \stkBowed).vol_(0.5).play(fadeTime: 30);
Ndef(\stk).vol = 0.7;
Ndef(\stk)[20] = \filter -> {|in| JPverb.ar(in)};
Ndef(\stk).set(\wet20, 0.6);
)

Ndef(\stk)[40] = \xset -> Pbind(\dur, Pxrand([3, 7, 8], inf), \freq, Pxrand([50, 120, 230], inf), \amp, 2);
Ndef(\stk).stop(30);

(
~arp.clear;
~arp = Ndef(\arp, PbindProxy(\instrument, \sinesaw1, \dur, 0.1, \atk, 1/1000, \rel, Pkey(\dur), \freq, Pseq([50, 120, 230], inf), \detune, Pseg([0, -10, 10, 0], [30, 30, 30], 'lin', inf), \spread, 0, \pan, Pseq([-1, 1, -1]/2, inf), \amp, 2).quant_(1)); ~arp.play(fadeTime: 0);
);

~arp.vol = 1;

~arp.stop(0);

// \freq, Pseq([50, 120, 230], inf) * Pseq([1, 2, 1/2, 2, 1, 2], inf);

~dbass = Pbindef(\dbass, \instrument, \poom, \dur, Pxrand([3, Rest(4), 0.2, 0.2], inf), \freq, Pxrand([50, 120, 230], inf), \rel, Pkey(\dur), \amp, 1.2).play(quant:1);
~dbass.stop;


(
~beat.stop;
~beat = Routine.run({{
	C.p(\kick, folder: \bassdrums, index: 19, dur: 1/4, amp:2/3);
	C.p(\snares, folder: \snares, index: Pseq([1, 2], inf), rate: Pxrand([0.7, 0.9, 1], inf), dur: Pseq([Rest(1/8), 1/8], inf), amp: 2/5);

	rrand(3, 5).wait;

	C.s(\kick, 1/2);
	C.s(\snares, 1/2);

	rrand(3, 5).wait;

}.loop;

}, quant: 1);
);

Ndef(\stk).stop(30);

~arp.clear(0);

(
~beat.stop;
~dbass.stop;
)

x=Synth(\in);

-----------


(
~iter2.set(\freq, 202);
~iter2.lag(\freq, 10);
~iter2.play(fadeTime: 100);
)


(
~iter2.fadeTime=50;
~iter2.set(\freq, 202/4);
)

~iter2.stop(10);



------

Ndef(\wobl).stop;

(
~ticks1.release(1);
~ticks1 = {
	Splay.ar(
		SinOsc.ar(
			freq: Impulse.kr(10, mul:10000, add:10000),
			mul: Impulse.kr([LFNoise2.kr(1, 10, 3),
				LFNoise2.kr(1, 10, 3)],
			mul:Line.kr(0, 1, 30),
			add:0))
)}.play(fadeTime: 10);

~highsinefluctuating.release(10);
~highsinefluctuating = {
	var snd;
	snd = SinOsc.ar(
		10000 + LFNoise2.kr(1).range(-1000,5000),
		mul:0.01
);
	snd = LPF.ar(snd, 10000);
}.play(fadeTime: 30);
)



(
~ticks2.release(10);
~ticks2 = {
	Splay.ar(
		SinOsc.ar(
			freq: Impulse.kr(10, mul:10000, add:10000)/[2, 8, 8, 4],
			mul: Impulse.kr([LFNoise2.kr(1, 10, 3),
				LFNoise2.kr(1, 10, 3)],
			mul:0.1,
			add:0))
)}.play(fadeTime: 30);
);

NdefMixer(s)


(
~ticks1.release(10);

~ticks2.release(10);

~high.release(10);

~highsinefluctuating.release(10);
)


--------------



~comb2.vol_(2).play(fadeTime: 20);
~comb2.stop(10);


~tinnitus.vol_(1).play(fadeTime: 30);
~tinnitus.stop(30);
~tinnitus.clear


(
~combwhite.play(fadeTime: 30);

~whiteandcomb = Routine.run{
	loop{
		~combwhite.set(\freq, Array.makeScaleCps(300, 'major', 20, 10000).choose, \lag, 0, \mix, 1, \lag, 0, \amp, 2, \reverbmix, 0, \amp, 1);
		0.1.wait;
}}.quant_(5);
);


// ROUTINE

~routine = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/Routine.aiff");

Ndef(\routine).clear;

Ndef(\play, \play).copy(\routine);
Ndef(\routine).set(\buffer, ~routine);
Ndef(\routine).vol_(2);
Ndef(\routine).send.play(fadeTime: 50);



// wait for apparition of fm...

~rrr.play(fadeTime: 0);
~rrr.stop(30);

Ndef(\routine).fadeTime = 30; Ndef(\routine)[10] = \filter -> {|in| var snd; snd = GVerb.ar(in, 5, 10, drylevel:0) * 0.3;};

Ndef(\routine)[50] = \filter -> {|in| BRF.ar(in, 80, 1)}

Ndef(\routine)[10] = nil;

(
{
~combwhite.stop(50);
50.wait;
~whiteandcomb.stop;
}.fork;
)

~comb2.clear(20);

{var fadeout = 100; Ndef(\routine).stop(fadeout); ~rrr.stop(fadeout); fadeout.wait; Ndef(\routine).clear;}.fork; ~rrr.stop(0);

~tinnitus.stop;








---------------


// CLE

/*Ndef(\cle, {PlayBuf.ar(2, ~cle, 1 * BufRateScale.ir(~cle))}).play;

Ndef(\cle).stop(10);

// Master bass down important !

Ndef(\play).copy(\clefboucle);
Ndef(\clefboucle).set(\buffer, ~clefboucle, \loop, 1);
Ndef(\clefboucle).play(fadeTime: 10);
Ndef(\clefboucle).stop(10);*/



(
~add1 = Ndef(\add1, {
	var lfo, trig, snd;
	lfo = LFNoise2.kr(0.3, 5, 7);
	trig = Impulse.kr(lfo);
	snd = SinOsc.ar({exprand(20, 20000)}!10, 0, 0.1);
	snd = Splay.ar(snd);
	snd = snd * Env.perc(0.01, 1/LFNoise2.kr(0.3, 3, 5)).kr(0, Impulse.kr(lfo)) * 0.6;
	snd = Balance2.ar(snd[0], snd[1], TChoose.kr(trig, [-1, 1.0]))
});
)




~add1.play(fadeTime: 10);
~add1.stop(0);


~moan1.play(fadeTime: 30);
~moan1.stop(0);

Synth(\kick, [freq: rrand(55, 70), rel: 3]);
Synth(\percsine, [freq: 1000, rel: 0.1, amp: 0.1]);

~swish = "/Users/maxlouisraugel/Documents/ /swish.wav".b;

~swishes = Pbindef(\swishes, \instrument, \play, \buffer, ~swish, \dur, Pxrand([4, 6, 10, 0.1], inf), \rate, Pseq([1, 0.9, 0.7, 1.3], inf) * Pxrand([1, 1.01, 0.97], inf), \amp, 1/4, \pan, Pwhite(-1, 1.0));

~swishes.play;
~swishes.stop;

s.volume.gui
~sweeps.reset; ~sweeps.play;
~sweeps.stop;

~wsamples.play;
~wsamples.stop;

Pbindef(\mop, \instrument, \percsine, \dur, Pbjorklund2(3, 8)/8, \atk, 0.3, \rel, 0.5, \note, Pseq([1, 2, 7, 13], inf) - 12, \amp, 1/10, \brass, Pwhite(1, 3)).play;

Pbindef(\mop).stop;



~cdglitchs.play; ~cdglitchs.fadeTime = 3;

(
Routine.run{
	{
~cdglitchs[10] = \filter -> {|in| Greyhole.ar(in, rrand(0.1, 0.5), 0.5, 0.1, rrand(0.01, 0.2), 0.3)};
		10.wait;
~cdglitchs[10] = nil;
		10.wait;
}.loop

};

)
~cdglitchs.stop;

Pbindef(\k, \instrument, \mkick, \dur, Pbjorklund2(6, 16)/8, \freq, 40).play;

Pbindef(\k).stop;

----

Pbindef(\k, \instrument, \mkick, \dur, Pbjorklund2(6, 16)/8, \freq, Pstep([38, 35], [28, 12], inf), \quant,1).play(quant:1);

Pbindef(\k).stop;

~jpverb.play;

~scli = Ndef(\scli, Pbind(\instrument, \play, \buffer, Pseq([~sipclick[0], ~sipclick[1]], inf), \dur, 1, \amp, 1.5, \out, 0, \quant, 1));

~scli.play;
~scli.fadeTime=10;

~scli[10] = \filter-> {|in| FreeVerb.ar(in, 0.3, 1)}

~sloop1.play;

~orb50.play;

~scli.stop;


---

~drip.clear;
~drip = Ndef(\play).copy(\drip);

~drip.set(\buffer, ~drippyonplastic, \loop, 1);
~drip.vol_(1.2).play;

~drip.fadeTime =10;
~drip[10] = \filter -> {|in| Resonator.ar(in, 200, 0.01, 24, 0.5, 0.5, 0.3)}

~drip[10] = nil;

~drip[20] = \filter -> {|in| Pluck.ar(in, in.linlin(0, 1, -0.5, 1), 0.2, 1/200, 1, 0.9, 0.5)}; ~drip.set(\wet20, 0.5);

~drip.clear;



--------


(
Ndef(\stk, \stkBowed); Ndef(\stk).play(fadeTime: 30);
Ndef(\stk).vol = 1;
Ndef(\stk)[10] = \xset -> Pbind(\dur, Pxrand([3, 7, 8], inf), \midinote, Pxrand([50, 52, 54, 49, 45], inf) + Pxrand([0, -12], inf));
)

Ndef(\stk).stop(0);

~stks.clear;

(
~stks = Ndef(\stkS, \stkSaxofony); ~stks.vol_(0.6).fadeTime_(10).play(fadeTime:10);
~stks[10] = \xset -> Pbind(\dur,Pxrand([3, 7, 8], inf), \midinote, Pxrand([57, 59, 61], inf) + Pxrand([-12, -24], inf), \pan, Pwhite(-1, 1), \amp, 1/10);
~stks[100] = \filter->{|in| JPverb.ar(in)}; ~stks.set(\wet100, 0.7);
)

~stks[100] = \filter->{|in| GVerb.ar(in, 10, 3)}; ~stks.set(\mix100, 0.7);

~stks.stop(50);




Ndef(\play).copy(\sf);
~sf = Ndef(\sf).set(\buffer, ~subformant2, \rate, 1);
~sf[10] = \filter -> {|in| HPF.ar(in)}

~sf.play(fadeTime:30);


(
Ndef(\stk).clear(50);
~stks.clear(50);
);


~wsamples.play;
~wsamples.stop;

~sweeps.reset; ~sweeps.play;
~sweeps.stop;

~vpoints.stop;



-------



(type:\dirt, dirt: ~dirt, s: \bells, gain:1, gpverb:1).play;

Pbindef(\a, \type, \dirt, \dirt, ~dirt, \dur, Pbjorklund2(3, 8)/4, \s, Pseq([\bd, \bd, \kit11], inf), \norm, 1, \gain, 1.5).play(quant:1);

Pbindef(\b, \type, \dirt, \dirt, ~dirt, \dur, Pseq([Rest(1), 1], inf), \s, \bells, \gpverb, 1, \gain, 1.3).play(quant:1);

Pbindef(\3, \type, \dirt, \dirt, ~dirt, \dur, Pseq([1/4, 1/4, Rest(1/4)], inf), \s, \kit11, \n, 2).play(quant:1);

(
Pbindef(\a).stop;
Pbindef(\b).stop;
Pbindef(\3).stop;
)



-----


Synth(\mop, [freq: 500, brass: 2, feedback: 0])


Pbind(\instrument, \moogbass, \dur, 4, \freq, Pseq((24..108).midicps), \brass, Pwhite(0.1, 1.50), \feedback, Pwhite(0;1, 1.50), \amp, 5).play;






------


~dec = Pbindef(\dec, \instrument, \play, \buffer, Pxrand(d[\16].size.collect{|i| d[\16][i]}, inf), \dur, Pxrand([2, 5, 1/2], inf) * 5, \rate, Pxrand([1, 1.1, 0.77], inf), \amp, 2).play;


~wsamples.play;


(
a = Pbind(\instrument, \percsinefb, *[freq: Pxrand(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, inf), atk: 20, rel: 30, amp: 0.04, feedback: 1/2, dur: 5, pan: Pwhite(-1, 1.0)]).play;

b = Pbind(\instrument, \moogbass, *[freq: Pxrand([200, 250, 300, 500, 570, 600, 740] * 0.5, inf), atk: 20, rel: 30, amp: 1, dur: 10, pan: Pwhite(-1, 1.0)]).play;
)

(
a.stop;
b.stop;
)



(
~iter2.set(\freq, 202);
~iter2.lag(\freq, 10);
~iter2.play(fadeTime: 0, out: 0);
)


NdefMixer(s)

(
~iter2.fadeTime=50;
~iter2.set(\freq, 202/4);
)


Pbindef(\zz, \instrument, \sinesaw1, \freq, Pseq([150, 132], inf), \dur, 5, \amp, 0.5).play;


{~iterbuf[0].play; 1.5.wait; Synth(\play, [buffer: ~iterbuf[1], rate:1.09])}.fork;


~iter2.set(\freq, 125/4);

(
~iter2.stop(10);
Pbindef(\zz).stop;
)

Ndef(\u).stop(30);
Ndef(\u).clear;

(
~lines.stop;
Ndef(\sine).stop(30);
)






-------



(
~jpverb.play;

Pbind(
	\instrument, \sinesaw,
	\dur, Pseq([1, 0.5, 0.3], inf)/2,
	\freq, Pseq([100, 200, 300, Rest(3), 70, 700], inf),
	\amp, 1,
	\atk, 0.1,
	\rel, 1
).play;

Pbind(
	\instrument, \fm,
	\dur, Pseq([1, 0.5, 0.3], inf),
	\freqB, Pseq([100, 200, 300, Rest(3), 70, 700], inf)
).play;

Pdef(\toll,
	Pbind(\instrument, \fm,
	\dur, Prand([2, 1, 0.333], inf),
	\note, Prand([0, 2, -1], inf),
	\ctranspose, Prand([12, 0, -12], inf),
	\rel, 0.8,
	\amp, 2,
	\out, ~jpverb_bus
)
).play;
)

(
Pbind(
	\instrument, \pom,
	\dur, Pseg([1, 0.1], [10], 'lin', inf),
	\rel, Pseg([0.1, 0.0001], [10], 'exp', inf),
	\freqA, Pseg([100, 200], 10),
	\time, 1,
	\amp, 2,
	\out, ~jpverb_bus
).play;
)


--------

// PHASE RHYTHMS

// why this doesn't work like the following ?
(
Pbind(
	\instrument, \sinesaw,
	\dur, [0.08, 0.081, 0.083],
	\freq, Pseq(Array.fib(10, 20, [10, 5, 20]), inf),
	\atk, 0.1,
	\rel, 0.05,
	\amp, [1.2, 1, 1.5],
	\pan, [-1, 0, 1]
).play;
)


(
a = Pbind(
	\instrument, \sinesaw_mono,
	\dur, 0.08,
	\freq, Pseq(Array.fib(10, 20, 5), inf),
	\atk, 0.1,
	\rel, 0.05,
	\amp, 2,
	\pan, -1,
	\out, 0
).play;

b = Pbind(
	\instrument, \sinesaw_mono,
	\dur, 0.0805,
	\freq, Pseq(Array.fib(10, 20, 7), inf),
	\atk, 0.1,
	\rel, 0.05,
	\amp, 2,
	\pan, 0,
	\out, 1
).play;

c = Pbind(
	\instrument, \sinesaw_mono,
	\dur, 0.081,
	\freq, Pseq(Array.fib(10, 20, 20), inf),
	\atk, 0.1,
	\rel, 0.05,
	\amp, 3,
	\pan, 1,
	\out, 2
).play;

d = Pbind(
	\instrument, \sinesaw_mono,
	\dur, 0.0812,
	\freq, Pseq(Array.fib(10, 20, 20), inf),
	\atk, 0.1,
	\rel, 0.05,
	\amp, 3,
	\pan, 1,
	\out, 3
).play;
)

// or change to minor with 5 steps in fib ?

(
a.stop;
b.stop;
c.stop;

a = Pbind(
	\instrument, \sinesaw,
	\dur, 0.08,
	\degree, Pseq(Array.fib(7, 2, 0)++(Rest()!4), inf),
	\scale, Scale.iwato,
	\atk, 0.1,
	\rel, 0.1,
	\legato, 1,
	\amp, 1
).play;

b = Pbind(
	\instrument, \sinesaw,
	\dur, 0.0801,
	\degree, Pseq(Array.fib(7, 3, 0)++(Rest()!4), inf),
	\scale, Scale.iwato,
	\atk, 0.1,
	\rel, 0.1,
	\legato, 1,
	\amp, 1.2
).play;

c = Pbind(
	\instrument, \sinesaw,
	\dur, 0.082,
	\degree, Pseq(Array.fib(5, 5, 0)++(Rest()!4), inf),
	\scale, Scale.iwato,
	\atk, 0.1,
	\rel, 0.1,
	\legato, 1,
	\amp, 1.5
).play
)

Scale.directory;

Synth(\percsine, [\freq, 330])

(
Pbind(
	\instrument, \sinesaw,
	\dur, Pseg([0.1, 0.5, 1, 0.2], [5, 3, 7]),
	\degree, Pseries(rrand(-10, 0), 0.5, inf),
	\scale, Scale.iwato,
	\atk, 0.01, \rel, 0.5,
	\amp, 1,
	\pan, Pwhite(-1, 1.0);
).play;
)



(
~p1.stop; ~p2.stop;
~p1 = Pdef(\sinesaw, Pbind(\instrument, \sinesaw, \dur, 7, \freq, Prand([200, 220, 500, 380], inf), \amp, 1.2)).play;
~p2 = Pbind(*[\instrument, \percsine, dur: Pwhite(1, 3), freq: Prand([200, 220, 500, 380], inf), \amp, 0.4]).play;
)


(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.03, sustain), 1, doneAction: Done.freeSelf);
	3.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * \fm.kr(0), u, rrand(0.1,1.2) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));

}).add;
)



a = Pbind(\instrument, \Pdefhelp, \dur, 0.2, \degree, Pseq([0, 4, Prand([6, 8b],2)], inf), \fm, Pfunc{ ~fm }, \amp, 1).play;

(
~fm = 300;
MIDIdef.cc(\0, { |val| ~fm = val.linexp(0, 127, 20, 20000)},0);    // 1 means modwheel
)

(
~legato = 1;
c = MIDIFunc.cc({ |value, num, chan, src|
    ~legato = value.linlin(0, 127, 0.1, 2.5)
}, 1);    // 1 means modwheel
)

(
p = Pbind(
    \degree, Pwhite(-7, 12, inf),
    \dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
    \legato, Pfunc { ~legato }    // retrieves value set by MIDI control
).play;
)



MIDIClient.init;
MIDIIn.connectAll;

~wsamples.play;

MIDIClient.init;
MIDIIn.connectAll;


~harmony1 = {Array.makeScale("C3", 'major', 300, 1900).notemidi.midicps * \stretch.kr(1.0)};



(
~rrr2 = Ndef(\rrr2, {
	var snd =
	snd = LFSaw.ar(
		\density.kr(1)
	)  * \amp.kr(1);
	// Array.fib(12, \fibA.kr(10), \stretch.kr(1.0))
	snd = BPF.ar(
		snd,
		// Array.makeScale("C3", 'major', 300, 1900).notemidi.midicps * \stretch.kr(1.0),
		~harmony1,
		0.005,
		mul: Env.perc(1, LFNoise1.kr(1, 1, 5), level: 10, curve: -3).circle.kr(2)
	);
	snd = Splay.ar(snd,
		spread: \spread.kr(0),
		level: 1).lag(0.01) * 10;
	snd = snd.blend(JPverb.ar(snd, 6), \jpverb.kr(0.3));
	PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1));
});

~rrr2.play;
)



// chord impacts

(
~rchords = Ndef(\rchords, {
	var dust,env, snd;
	dust = Dust.kr(0.5);
	env = Env.perc(0.01,3, 0.5).kr(0, gate: dust);
	snd = SinOscFB.ar(
		~harmony1,
		LFNoise2.kr(0.3).abs * 3,
		env
	);
	snd = Splay.ar(snd);
	// PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1));
});

~rchords.play;
)


// SPECS
(
Ndef(\rrr2).addSpec(
	\amp, \amp,
	\freq, \freq,
	\stretch, [1.0, 16.0],
	\density, [1, 30],
	\jpverb, [0, 1.0],
	\spread, [0, 10]
	// \levB, [0.01, 3,\exp],
);

~ccControlled = Order.newFromIndices(
	[
		\amp, \density, \jpverb, \stretch,
	], (0..3);
);


MIDIdef.cc(
	( ~rrr2[\name] ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		Ndef(\rrr2).set(
			control,
			Ndef(\rrr2).getSpec(control).map(val/127)
		);

		// Ndef( ~grainsin_pulsar[\name] ).softSet(
		// 	control,
		// 	Ndef( ~grainsin_pulsar[\name] ).getSpec(control).map(val/127),
		// 	mapped: true,
		// 	spec: Ndef( ~grainsin_pulsar[\name] ).getSpec( control )
		// )

	},
	ccNum: ~ccControlled.indices,
	chan: 0,
	// srcID: nil
).fix;
)

~rrr2.stop;


