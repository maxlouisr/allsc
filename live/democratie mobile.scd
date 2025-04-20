// Server.killAll

"/Users/maxlouisraugel/Documents/sc/live/buffers.scd".load;
"/Users/maxlouisraugel/Documents/sc/live/Ndef.scd".load;


Synth(\percsine, [pan: 1]);


NdefMixer(s)

MasterEQ.new;


Ndef(\play, {PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(1) * BufDur.ir(\buffer.kr), \loop.kr(0), \doneaction.kr(2))});


(
var ndef = ~subwave;

ndef.addSpec(
	\amp, \amp,
	\freq, [20, 150, \exp],
	\speed, [0.03, 3]
);

~ccControlled = Order.newFromIndices(
	[
		\amp, \freq, \speed,
	], (0..2);
);


MIDIdef.cc(
	( "ndef" ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		/*ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);*/

		ndef.softSet(
		control,
		ndef.getSpec(control).map(val/127),
		mapped: true,
		spec: ndef.getSpec( control )
		)

	},
	ccNum: ~ccControlled.indices,
	chan: 0,
	// srcID: nil
).fix;
)



-----

// x= {var snd; snd = SinOsc.ar({exprand(20, 20000)}!100, 0, {LFNoise2.kr(0.3, 0.1).abs}!20); snd = Splay.ar(snd); snd = LPF.ar(snd, MouseY.kr(200, 2000))}.play;


(
Ndef(\play).copy(\tingle);

Ndef(\tingle).set(\buffer, ~tingle, \loop, 1);
)

Ndef(\tingle).play(fadeTime: 0);

Ndef(\tingle).fadeTime= 10;

Ndef(\tingle).xset(\rate, rrand(0.5, 3));


~subwave.clear;
(
~subwave = Ndef(\subwave)[0] = ({|pan 0.5|
	var snd = SinOsc.ar(\freq.kr(62, 0.1), 0, 0.1);
	snd = Pan2.ar(snd);
	snd = snd.blend(HPF.ar(snd, SinOsc.ar(\speed.kr(0.3, 0.1)).range(20, 10000), 14.4), 0.7883);
	snd = Limiter.ar(snd * \amp.kr(1, 0.1));
});

~subwave.play;
);


(
var ndef, controlnames;
ndef = ~subwave;
controlnames = [\amp, \freq, \speed];

ndef.addSpec(
	\amp, \amp,
	\freq, [20, 150, \exp],
	\speed, [0.03, 3]
);

~ccControlled = Order.newFromIndices(
	controlnames,
	(0.. controlnames.size -1);
);


MIDIdef.cc(
	( "ndef" ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);

	},	ccNum: ~ccControlled.indices, chan: 0
).fix;
)


MIDIdef.freeAll

~warp


(
~warp0 = Ndef(\warp0, {
	var snd = Warp1.ar(2, \buffer.kr(d[\zither][1]), SinOsc.kr(\rate.kr(10, 0.1), 0, \length.kr(1, 0.1), \start.kr(0, 0.1)).unipolar, 1, \windowsize.kr(0.01, 0.1), overlaps: \overlaps.kr(8, 0.1), windowRandRatio: 0.0, interp: 1);
	snd = Limiter.ar(snd * 4 * \amp.kr(1, 0.1));
	snd = Pan2.ar(snd, \pan.kr(0, 0.1));
	snd = FreeVerb.ar(snd, \verb.kr(0.3), 0.8);
	// snd = if ( snd>0.3, {snd}, {0})
});

~warp0.play(fadeTime: 0);
)

(
var ndef = ~warp0;
var controlnames = [\amp, \start, \length, \rate, \windowsize, \overlaps, \pan, \verb];

ndef.addSpec(
	\amp, \amp,
	\start, [0, 1],
	\length, [0.0001, 1, \exp],
	\rate, [0.2, 20],
	\windowsize, [0.01, 0.2],
	\overlaps, [1, 12],
	\pan, \pan,
	\verb, [0, 1]
);


~ccControlled = Order.newFromIndices(
	controlnames, (0.. controlnames.size -1);
);


MIDIdef.cc(
	( ndef.asSymbol ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);

	},	ccNum: ~ccControlled.indices, chan: 0
).fix;
)


(
Ndef(\warp1, {
	var snd = Warp1.ar(2, C.get(\kalimba, 1), SinOsc.kr(7).unipolar, 1, 0.01, overlaps: \overlaps.kr(8), windowRandRatio: 0.0, interp: 1);
	snd = Limiter.ar(snd);
	snd = snd * \amp.kr(0.3);
	snd = Pan2.ar(snd, \pan.kr(0))
}).play(fadeTime: 0)
)

(
Ndef(\warp2, {
	var snd = Warp1.ar(2, C.get(\kalimba, 1), LFSaw.kr(LFNoise2.kr(3).range(1, 7)).unipolar, 1, 0.01, overlaps: \overlaps.kr(8), windowRandRatio: 0.0, interp: 1);
	snd = Limiter.ar(snd);
	snd = snd * \amp.kr(0.3);
	snd = Pan2.ar(snd, \pan.kr(0))
}).play(fadeTime: 10)
)

(
Ndef(\warp3, {
	var snd = Warp1.ar(2, \buffer.kr(6), SinOsc.kr(3).unipolar, \freqScale.kr(1), \windowsize.kr(0.01), overlaps: \overlaps.kr(8), windowRandRatio: 0.0, interp: 1);
	snd = Limiter.ar(snd);
	snd = snd * \amp.kr(0.3);
	snd = Pan2.ar(snd, \pan.kr(0))
}).play(fadeTime: 20);
)


(
~speeds.release(0);
~speeds = {
	var snd, lfo;
	lfo = LFNoise2.kr(0.3).range(0, 15);
	snd = Impulse.ar(lfo)!2;
	snd = BPF.ar(snd, Array.fib(12, 5, 50), 0.07, 100);
	snd = HPF.ar(snd, 500) * \amp.kr(0.5);
	snd = Splay.ar(snd) * 1/2;
}.play(fadeTime: 0);
)


(
Ndef(\warp0).stop(fadeTime: 30);
Ndef(\warp1).stop(fadeTime: 40);
)


(
Ndef(\warp0).stop(fadeTime: 30);
Ndef(\warp1).stop(fadeTime: 40);
Ndef(\warp2).stop(fadeTime: 15);
Ndef(\warp3).stop(fadeTime: 42);
)


(
Ndef(\sinevibrato, {
	var snd = SinOsc.ar(\freq.kr(60, 1), 0, SinOsc.kr(\vibrato.kr(0.5)).unipolar / 5);
	snd = Pan2.ar(snd, \pan.kr);
}).play(fadeTime: 0)
)


Ndef(\sinevibrato).stop(fadeTime: 20);




(
~percsine = PbindProxy(\instrument, \percsine, \freq, Pwhite(15000, 17000).round(10), \atk, 0.01, \rel, 0.1);
~kick = PbindProxy(\instrument, \kick, \freq, Pwhite(20, 40).round(10), \amp, 0.5);

~durs = Prand([1, 2, 5]*2, inf);

~percsine.set(\dur, ~durs);
~kick.set(\dur, 1, \amp, 1, \freq, Prand([30, 30 * 1.2, 30 * 1.5, 30 * 1.7], inf));

~percsine.play;
~kick.play;
)


~kick.set(\dur, 0.2, \freq, Pseq([100, 120, 140, 160, 170, 190, 220], inf));
~kick.set(\dur, 0.2, \freq, Pseq([ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 ]/4, inf));

(
~percsine.clear;
~kick.clear;
)






~kick = PbindProxy(\instrument, \kick, \dur, Pbjorklund(7, 8) * Pxrand([1, 1/2], inf))
~kick.play;
~kick.set(\freq, 60, \amp, 1);
~kick.set(\dur, Pbjorklund(7, 8) * Prand([1, 1/3], inf));
~kick.set(\freq, Prand([50, 52, 54, 49, 45].midicps / 2, inf));
~kick.set(\atk, Prand([0.1, 0.01, 1/2, 1/3], inf), \rel, Pxrand([1, 2, 0.7], inf))
~kick.clear;



// ligne imaginaire ? simple saw with lfnoise pan / freq

(
~sschord.clear;
~sschord = PbindProxy(\instrument, \sinesaw, \freq, Prand([ [ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 ], [ 450, 810, 1530, 360, 1170, 1350, 1620, 1440, 540, 1080 ] ], inf), \dur, 10, \amp, 0.2);
Ndef(\sschord, ~sschord);
)

Ndef(\sschord).play(fadeTime: 30);

Ndef(\sschord).fadeTime=10;
Ndef(\sschord)[10] = \filter->{|in|FreeVerb.ar(in, 0.3, 1)}
Ndef(\sschord)[20] = \filter->{|in| RLPF.ar(in, 200, 0.5, 5)}




(
~pointillism.stop(3);
~pointillism = {
	var snd, combfreq;
	combfreq = {exprand(20, 10000).round(100) * LFNoise2.kr(\detune.kr(0.1)).range(1, 2)};
	snd = {Dust.ar(\density.kr(0.2))};
	snd = CombC.ar(snd!10, 0.2, 1/combfreq!10, 0.5);
	snd = Pan2.ar(Mix(snd!10), {rrand(-1, 1.0)}!5);
	// snd = snd.softclip;
	snd = snd * \amp.kr(0.3);
}.play(outbus: ~jpverbus, fadeTime: 0);
)

~jpverb.play;

(
~pointillism.release(3);
~pointillism = Ndef(\pointillism, {
	var snd, combfreq;
	combfreq = {exprand(20, 10000).round(100) * LFNoise2.kr(\detune.kr(0.1)).range(1, 2)};
	snd = {Dust.ar(\density.kr(0.2))};
	snd = CombC.ar(snd!10, 0.2, 1/combfreq!10, 0.5).sum;
	snd = PanAz.ar(~numChannels, Mix.ar(snd!10), LFNoise2.kr(0.3), 1, 2.0);
	snd = LPF.ar(snd, 7000);
	// snd = snd.softclip;
	snd = snd * \amp.kr(0.3);
}).mold(~numChannels).play(fadeTime: 0);
)

(
~jpverbus = ~jpverbus ?? Bus.audio(s, 2);

~jpverb = Synth(\jpverb, [in:~jpverbus, time: 1, damp: 0.3], s, 'addToTail');
)

// ~pointillism.set(\density, 0.5, \detune, 10)
// ~pointillism.set(\density, 0.5, \detune, 1)


// ~jpverb.set(\time, 1, \damp, 0.9)
~jpverb.set(\time, 1, \damp, 0.3)



~pointillism.set(\density, 0.3, \detune, 0.1);



Ndef(\sschord).xset(\out, ~jpverbus);

Ndef(\sschord).xset(\freq, 40);

~jpverb.set(\time, 10);


// ~datorro.set(\damping, 0.3, \shimmerPitch, 100, \bandwidth, 0.99, \decayRate, 0.3)

// play{var snd; snd = SinOsc.ar({rrand(100, 10000)}!10, 0, 0.1); snd = Splay.ar(snd)}

(
~spiral.release(20);
~spiral = {
	|time 30|
	var curve, snd, inwards;
	inwards = Line.kr(0.3, 1, time);
	snd = SinOsc.ar(SinOsc.kr(inwards, 0, Line.kr(450, 0, time), 550));
	snd = PanAz.ar(snd, SinOsc.kr(inwards, 0, Line.kr(1, 0, time)));
	// snd = MoogFF.ar(snd, 1000);
	snd = snd / 10;
}.play(outbus: ~jpverbbus, fadeTime: 3)
)

(
~spiral.release(20);
~spiral = {
	|time 30|
	var curve, snd, inwards;
	inwards = Line.kr(0.3, 1, time);
	snd = SinOsc.ar(SinOsc.kr(inwards, 0, Line.kr(450, 0, time), 550));
	snd = PanAz.ar(~numChannels, snd, SinOsc.kr(inwards, 0, Line.kr(2.0, 0, time)));
	// snd = MoogFF.ar(snd, 1000);
	snd = snd / 10;
}.play(fadeTime: 3)
)



~spiral.release(30);


~pointillism.release(0);


Ndef(\sinesaw, (instrument: \sinesaw));

Ndef(\sinesaw).set(\freq, {rrand(90, 900)}!10, \atk, 5, \amp, 0.2, \rel, 10).send.play;





-- THIS
(
var fade = 0; ~algae.release(fade);

~algae = {
	var snd, roots, ondulation;
	roots = {(50..400).choose}!5;
	// ondulation = roots + LFNoise2.kr(0.3).bipolar(30) + {LFNoise2.kr(0.5).bipolar(30)};
	ondulation = roots + LFNoise2.kr(0.3).bipolar(30);
	snd = SinOsc.ar(ondulation, 0, 0.05);
	// snd = SplayAz.ar(~numChannels, snd, 1, 2, ~numChannels);
}.play(fadeTime: fade)
)


--- algae bleep

(
// ~algae.free;

var fade = 0; ~algae.release(fade);

~algae = {
	var snd, roots, ondulation, pulse;
	pulse = {(5..20).choose/10}!5;
	roots = {(50..600).choose}!5;
	// ondulation = roots + LFNoise2.kr(0.3).bipolar(30) + {LFNoise2.kr(0.5).bipolar(30)};
	ondulation = roots + LFNoise2.kr(0.3).bipolar(30);
	snd = SinOscFB.ar(ondulation, 0.5, 0.1) * LFPulse.kr(pulse * SinOsc.kr(0.3, 0, 1)).lag(0.01);
	// snd = SplayAz.ar(~numChannels, snd, 1, 2, ~numChannels);
}.play(fadeTime: fade)
)




(
~whiteshuffle.release(3);
~whiteshuffle = {SplayAz.ar(~numChannels,
	WhiteNoise.ar(
		Saw.kr(freq:{LFNoise1.kr(1).range(0.01,1)}!5, mul:0.1)
), 1, 1, ~numChannels)}.play(fadeTime: 10);
)



(
~cloud.release(1);
~cloud = {
	var snd, chord, density;
	// density = SinOsc.ar(0.3, 0, 50, 100);
	density = 10;
	// chord = Drand(Array.makeScaleCps(300, 'major', 100, 1000), inf);
	// chord = Drand([300, 400, 810, 309], inf);
	chord = Drand([100, 310, 800, 1002, 414], inf);
	// snd = Impulse.ar(density);
	snd = Dust.ar(density);
	// snd = Env.perc(0.1, 1, 1).kr(0, gate: snd);
	// snd = CombC.ar(snd, 0.2, 1/Demand.ar(snd, 0, chord).lag(0.2), Demand.ar(snd, 0, chord.reciprocal) * 100);
	// snd = Resonator.ar(snd, Demand.ar(snd, 0, chord).lag(MouseY.kr(0.00001, 0.1, 1)), 0.001, 24, Demand.ar(snd, 0, chord.reciprocal), 0.5);
	// snd = Resonator.ar(snd, Demand.ar(snd, 0, chord).lag(0.001), 0.001, 24, Demand.ar(snd, 0, chord.reciprocal), 0.5);
	// snd = Resonator.ar(snd, Demand.ar(snd, 0, chord).lag(0.01), 0.001, 24, 0.5, 0.5);
	// snd = snd.blend(JPverb.ar(snd, 0.1, 0.9, 0.1) * 10, 0.2);
	snd = HPF.ar(snd, 20) * 10;
	// snd = PanAz.ar(~numChannels, snd, LFNoise0.kr(density)) * 1/2;
}.play(fadeTime: 10);
)



~pointillism.release(0);



(
~teasingsaws.release(10);
~teasingsaws = {Saw.ar(LFNoise2.kr([2, 3]).range(1000, 20000), LFPulse.kr([10, 5]) * 0.1)}.play(fadeTime: 30);
)


Routine.run({Ndef(\sschord).stop(50); 50.wait; Ndef(\sschord).clear});



Ndef(\wove).stop(30);

Ndef(\sinevibrato).stop(30);

~algae.release(30);








---------
(
~microgaussian.release(3);
~microgaussian = {
	{SplayAz.ar(~numChannels, SinOsc.ar({LFNoise2.kr(0.01).range(100,1000)}, mul: {LFGauss.kr(LFNoise2.kr(1).range(0.1,10)).range(0.001,0.2)} * Line.kr(0, 0.5, 10), add: Saw.kr(freq: (LFNoise1.kr(1)), mul:0.3)), 1, 1, ~numChannels)
}}.play(fadeTime: 2);
)


(
~whiteshuffle.release(30);
~whiteshuffle = {Splay.ar(
	WhiteNoise.ar(
		Saw.kr(freq:{LFNoise1.kr(1).range(0.01,1)}!5, mul:0.1)
))}.play(fadeTime: 100);
);



(
Ndef(\m).fadeTime = 10;
Ndef(\m, {
	Splay.ar(
		{
			SinOsc.ar(
				exprand(20, 20000),
				mul:Line.kr(0, 0.02, 10) * {LFNoise2.ar(\amps.kr(0))}
)}!100
)});
Ndef(\m).play(fadeTime:10);
)

Ndef(\m).xset(\amps, 0.5)

(
~filaments.release;
~filaments =
{SplayAz.ar(~numChannels,
	{SinOsc.ar(
		LFNoise2.kr(0.1).range(2000,20000),
		mul:Env([0, 1, 0, 0, 1, 0, 0]*2,
			[0.1,
				0.1,
				LFNoise2.kr(1).range(1, 3),
				0.1,
				0.1,
				LFNoise2.kr(1).range(1,3)
			]*5

		).circle.kr(2) * XLine.kr(0.00001, 0.05, 15)
)}!10)}.play(fadeTime:30);
)


Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1, \rel, 10]);

~kicks.stop;

// the void


~speeds.release(10)

(
Ndef(\u, {var snd;
	snd = Splay.ar(BPF.ar(
		LFSaw.ar(
			LFSaw.kr(
				682 + LFNoise2.kr(1, 1, 0),
				0,
				[1000],
				// [1000] *8,
				[2000]
				// [2000]*4

),
			0,
			0.7
)));
	snd = BPF.ar(snd, 700);

}
);

Ndef(\u).play(fadeTime: 10);
)



Synth(\fml, [\freqA, 20, \freqB, rrand(300, 700).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.02, \atk, 0.1, \rel, 10, out: rrand(0, ~numChannels)]);



Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1, \atk, 0.1/2, \rel, 1]);

(
Synth(\poom, [freq: 311/4, atk: 3, rel: 5, amp: 0.2]);
x = Synth(\sinesaw1, [freq: [311, 311 * 2], atk: 3, rel: 7, amp: 1]);
)

(
Ndef(\u).fadeTime = 0;
Ndef(\u, {
	Splay.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(20, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 1, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
	)}!3)
})
)


Ndef(\m).clear(50);

// add reverb:

(
Ndef(\u).fadeTime = 100;
Ndef(\u, {
	Splay.ar(
		FreeVerb.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(200, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 2, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
)}!3,
			mix: 0.3,
			room: 3,
			damp: 0.5
		)

)});
Ndef(\u).play;
)


(
Ndef(\u, {
	Splay.ar(
		JPverb.ar(
		{
			SinOsc.ar(LFNoise0.kr(1).exprange(200, 20000),
				mul: Env(
					[0, 1, 0, 0],
					[0, LFNoise2.kr(0.1, 0.2, 0.2), LFNoise2.kr(0.1, 2, 3)],
					-1
				).circle.kr(2)
				* Line.kr(0, 0.5, 0)
)}!3,
			10,
			damp: 0,
			size: 1,
			earlyDiff: 0.7,
			modDepth: 0.2,
			modFreq: 2,
			low: -1,
			mid: 0.2,
			high: 0.3,
			lowcut: 100,
			highcut:1000
		)

)});
Ndef(\u).play;
)




(
~conv = EZConv("/Users/maxlouisraugel/Documents/ /ploc.wav");
~conv2 = EZConv("/Users/maxlouisraugel/Documents/ /fire bottle ..wav");
)

// Ndef(\u).fadeTime_(0)

(
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

Ndef(\u).play;
)



---- new algae


Ndef(\iter2).clear;


(
~iter2 = Ndef(\iter2, {
	arg freq = 200, dev = 1.02;
	var temp, sum, mod;

	mod = LFNoise2.ar(0.2);

	sum = 0;

	50.do{

		arg count;

		temp = SinOsc.ar(
			freq *
			(4/count) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));

		temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);

		sum = sum + temp;

	};

	sum = sum * 0.05;
	sum = SplayAz.ar(~numChannels, sum, mod.linlin(-1, 1, 0.5, 10), 1, mod.linlin(-1, 1, 1, 4), mod.linlin(-1, 1, 0, 1.0), mod.linlin(-1, 1, 0.5, 4.0));
}).mold(~numChannels);

~iter2.set(\freq, 200);
~iter2.lag(\freq, 30);
~iter2.play(fadeTime: 1);
)

(
~iter2.fadeTime=50;
~iter2.xset(\freq, 202/4);
)

~iter2.set(\freq, 400/4);




~teasingsaws.release(30)

~whiteshuffle.release(30);

Ndef('wove').stop(30);

~cloud.release(10)

~algae.release(30);

Ndef('sschord').stop(20)



(
~harmonies.release(30);
~harmonies ={arg vin=0.1;
	var snd;
	snd = Splay.ar(
		BPF.ar(
			Saw.ar(
				Array.geom(10, 32.1, 1.5)),
			LFNoise2.kr(vin).range(100,1000),
			0.05, 5

		), 1, 1/2

	);
	BRF.ar(snd, 1000);
}.play(fadeTime: 30);
)


// ~frivolous.set(\vin, 0.4);


(
~speeds.release(3);
~speeds = {
	var snd, lfo;
	lfo = LFNoise2.kr(0.3).range(0, 15) * LFNoise0.kr(0.3, 1/2, 1);
	snd = Impulse.ar(lfo)!2;
	snd = BPF.ar(snd, Array.fib(12, 5, 50), 0.07, 100);
	// snd = HPF.ar(snd, 500);
	snd = PanAz.ar(~numChannels, snd, 1, 1/2, 2.0);
}.play(fadeTime: 1);
)

~algae.release(30);

Ndef(\sinevibrato).play(fadeTime: 10);

~speeds.release(10);

~pointillism.release(10);


// a poetic story of the universe

(
~monteealeatoire.release(10);
~monteealeatoire = {SplayAz.ar(~numChannels, SinOsc.ar(LFSaw.kr(LFNoise2.kr(rrand(1, 9)).range(20, 5000), mul:0.01)) * 0.1, 1, 1, ~numChannels)}.play(fadeTime: 1);
)


// 9.20 la graine

Ndef(\wove).stop(30);

Ndef(\sinevibrato).stop(30)

Ndef(\warp3).stop(10);


(
~microgaussian.release(3);
~microgaussian = {var snd;
	snd = SinOsc.ar(
				{LFNoise2.kr(0.01).range(100,1000)},
				mul: {LFGauss.kr(LFNoise2.kr(1).range(0.1,10)).range(0.001,0.2)} * Line.kr(0, 0.5, 10),
				add: Saw.kr(freq: (LFNoise1.kr(1)), mul:0.3));
	// snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels);
	snd = {snd}!3;
	snd = PanAz.ar(~numChannels, snd.sum, LFNoise2.kr(0.3, 1, 1));
	// snd = HPF.ar(snd, 100);
}.play(fadeTime: 3);
)


Ndef(\u).clear(30);

~whiteshuffle.release(30);

~microgaussian.release(30);

~harmonies.release(10);

(
~middle.release(30);
~middle = {Splay.ar(SinOsc.ar({LFNoise2.kr(0.01).range(100,1000)}!10, mul: {LFNoise2.kr(1).range(0.001,0.2)}!10) * \amp.kr(1))}.play(fadeTime: 30);
)


// ~middle.free;

Ndef(\wove).stop(10);
Ndef(\wove).clear;

Ndef(\sinevibrato).play(10)


~monteealeatoire.release(30);


/*

~sine = {SinOsc.ar(440, 0, 1)}.play(fadeTime: 10);

~sine.release*/



~clouds.release(30)

(
~percsine.clear;
~kick.clear;
)

~middle.release(30);

~pointillism.release;


Ndef('u').stop(0)


Ndef(\m).stop(30);

Ndef(\sinevibrato).stop;

// !!!
~spiral.release(20);

~middle.release(20)


// continu / discontinu

~kick.clear;


~whiteshuffle.release(30);

Ndef(\soubresaut, {SinOsc.ar(freq: Saw.kr(freq: [0.2, 0.1], mul:[LFNoise2.kr(0.1, mul:100, add:300), LFNoise2.kr(0.1, mul:200, add:300)], add:150), mul:0.2)}).play(fadeTime: 50);

Ndef(\soubresaut).stop(30);


~microgaussian.release(10);
~middle.release(10);
~speeds.release(20);
~harmonies.release(30);

// ~12


--- maybe do clean multiples in pulse

(
{
~bleep1 = {SinOsc.ar(freq: LFPulse.kr([11, 13]).range(200, 400).lag(0.01), mul:0.1)}.play(fadeTime: 15);
30.wait;
~bleep2 = {SinOsc.ar(freq: LFPulse.kr([17, 19]).range(500, 1000).lag(0.01), mul:0.1)}.play(fadeTime: 10);
20.wait;
~bleep3 = {SinOsc.ar(freq: LFPulse.kr([7, 11]).range(400, 750).lag(0.01), mul:0.1)}.play(fadeTime: 0);
}.fork;
)

~filaments.release(3)


// (
// ~bleep4.release(3);
// ~bleep4 = {SinOsc.ar(freq: LFPulse.kr([7, 11]).range(400, 750), mul:0.1)}.play(fadeTime: 3);
// )

~whiteshuffle.release(3);

// extend harmony?

--- emptyful

(
~gausslr.release(10);
~gausslr = {SinOscFB.ar(freq: [800, 880], feedback: 0.1, mul: LFGauss.ar([3,2]
	// * {LFNoise2.kr(0.3, 0.5, 1)}!2
)
) * \amp.kr(1.5) * 0.2}.play(fadeTime:10);
)

(
~gausslr.release(10);
~gausslr = {SinOscFB.ar(freq: [1000, 750], feedback: 0.5, mul: LFGauss.ar([3,2]
)
) * \amp.kr(1.5) * 0.2}.play(fadeTime:10);
)

(
~freeverbBus = Bus.audio(s, 2);
~freeverb = {FreeVerb.ar(In.ar(~freeverbBus, 2), mix: 0.5, room: 0.9, mul: 0.4)}.play;
)


(
~beeping.release(20);
~beeping = {|freq1 800 freq2 880| SinOsc.ar([freq1, freq2], mul: LFPulse.ar(2) * \amp.kr(1))}.play(outbus: ~freeverbBus, fadeTime: 50);
)

~filaments.release(20)
~gausslr.release(30);

Ndef(\soubresaut).stop(30);


~beeping.set(\freq1, 780, \freq2, 990);

~beeping.set(\freq1, 1300, \freq2, 900);

~beeping.set(\freq1, 1490, \freq2, 990);

~beeping.set(\freq1, 1130, \freq2, 700);



~beeping.set(\freq1, 780, \freq2, 990);

~beeping.set(\freq1, 800, \freq2, 880);


Ndef(\neoformant).stop(30);

(
~bleep1.release(30);
~bleep2.release(40);
~bleep3.release(50);
~beeping.release(50);
)

~hesitantsaw = {Saw.ar(freq: 350, mul: LFNoise2.kr(10, 0.05, 0.1)) * 0.1}.play(fadeTime: 30);
~hesitantsaw.release(10);

~hesitantsaw2 = {Saw.ar(freq: [440, 570], mul: Line.kr(0, [0.4, 0.2], [10,15])) * 0.1}.play;
~hesitantsaw2.release(10);

Server.killAll

~softwaver = {Pan2.ar(SinOsc.ar(400), pos: LFGauss.kr(0.1, width: 0.5), level:0.1)}.play(fadeTime: 30);


// {Splay.ar(SinOsc.ar([100, 300, 500, 700, 900, 1100], mul: 0.1)) }.play;


Ndef(\soubresaut).stop(30);
~gausslr.release(30);
~whiteshuffle.release(10);

~softwaver.release(20);


(
~hesitantsaw.release(30);
~hesitantsaw2.release(30);
)


~whiteshuffle.stop(20)



// chapitre langage - blip ?



~pointillism.release;



(
~comb2.release(10);
~comb2 = {
	|freq = 200, mix = 1|
	var sound, env, width, comb;
	sound = WhiteNoise.ar(0.03);
	sound = sound + SinOsc.ar(50, 0, 0.2);
	sound = sound + LFTri.ar(LFNoise2.kr(10).range(5000, 5020), 0, 0.1);
	// width = SinOsc.kr(1).unipolar;
	sound = PanAz.ar(s.options.numOutputBusChannels, sound, LFNoise2.kr(10), 1, 0.3);
	// sound = Balance2.ar(sound, sound, LFNoise2.kr(1))
	comb = CombC.ar(sound, 0.2, 1/freq, 1, 0.1);
	sound = XFade2.ar(sound, comb, mix);
}.play(fadeTime: 20);
)


------ MAKE A ROUTINE WITH TINNITUS SO THAT IT COMES IN AN OUT WITH EMPTYFUL
------ Emptyful

(
~tinnitus.release(3);
~tinnitus = {
	|bassfreq = 50|
	var sound, env, width;
	sound = WhiteNoise.ar(0.03);
	sound = CrossoverDistortion.ar(sound, 1, 0.99);
	sound = sound + SinOsc.ar(bassfreq, 0, 0.2);
	sound = sound + LFTri.ar(LFNoise1.kr(10).range(10000, 10100), 0, 0.1);
	sound = LPF.ar(sound, 3000);
	sound = Limiter.ar(sound, 0.5);
	sound = SplayAz.ar(~numChannels, sound, 1, 1, ~numChannels);
}.play(fadeTime: 5);
)



(
~combwhite.release;
~combwhite = {
	|freq = 200, detune = 0, lag = 0, mix = 0, width = 0.3, amp = 1, reverbmix = 0|
	var snd, env, comb;
	// env = Env.asr(3, 1, 3).kr(2, gate);
	snd = WhiteNoise.ar(0.03);
	// snd = snd * env;
	// width = SinOsc.kr(1).unipolar;
	snd = PanAz.ar(s.options.numOutputBusChannels, snd, LFNoise2.kr(10), 1, width);
	// snd = Balance2.ar(snd, snd, LFNoise2.kr(1))
	comb = CombC.ar(snd, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
	snd = XFade2.ar(snd, comb, mix * 2 - 1) * amp;
	// snd = FreeVerb.ar(snd, reverbmix);
}.play(fadeTime: 30);

~whiteandcomb.stop;
~whiteandcomb = {
	loop{
		~combwhite.set(\freq, Array.makeScaleCps(300, 'major', 20, 10000).choose, \lag, 0, \mix, 1, \lag, 0, \amp, 2, \reverbmix, 0, \amp, 1);
		0.1.wait;
}}.fork
)


~pointillism.release(20)
~softwaver.release(30);


// ROUTINE

Ndef(\routine).clear;
Ndef(\play, \play).copy(\routine);
Ndef(\routine).set(\buffer, ~routine);
Ndef(\routine).send.play(fadeTime: 50);




~tinnitus.release(30);

// wait for apparition of fm...


(
~rrr.release(20);
~rrr = {|gate = 1|
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
		level: Env.asr(30, 1, 20).kr(2, gate));
	snd = Mix(snd);
	PanAz.ar(2, snd, LFNoise2.kr(0.3, 0.5, 1)) * \amp.kr(1/2);
}.play;
)



~rrr.set(\amp, 1/3)



~comb2.release(30);


(
{
~combwhite.release(50);
50.wait;
~whiteandcomb.stop;
}.fork;
)


Ndef(\routine).stop(50); ~rrr.release(50);


Ndef(\routine).clear;



~filaments.release(10)
~percsine.clear;


----- WITH BEEP ^


FormantTable.keys
FormantTable.get(\altoU)
FormantTable.get(\counterTenorI)

(
~fwind.release(3);
~fwind = {|mul 20|
	var snd;
	snd = WhiteNoise.ar(0.5); snd = BPF.ar(snd, [ 325, 700, 2530, 3500, 4950 ] * LFNoise2.kr(1/3).range(1.2, 1.2.reciprocal), [ 1.0, 0.25118864315096, 0.031622776601684, 0.01, 0.00063095734448019 ] * 1/mul, [ 0.15384615384615, 0.085714285714286, 0.067193675889328, 0.051428571428571, 0.04040404040404 ] * mul);
	snd = Mix(snd) * 3;
	snd = LPF.ar(snd, 3000);
	// snd = JPverb.ar(snd, 5);
	snd = PanAz.ar(~numChannels, snd, LFNoise2.ar(0.3).range(0.0, 2.0), 1.5, ~numChannels/2);
	// snd = Splay.ar(snd) * 3;
}.play(fadeTime: 1);
)



(

~notes = [50.0, 56.123102415469, 62.996052494744/*, 66.741992708502*/, 74.915353843834, 84.089641525371, 94.387431268169, 100.0, 112.24620483094, 125.99210498949, 149.83070768767, 188.77486253634] * [1, 2, 4, 8];

~dusk = {
	// var notes = Array.makeScaleCps(100, 'major', 50, 200);
	var sound;
	sound = VarSaw.ar(({~notes.choose}!5).postln, 0, Line.kr(0.5, 0, 1.3), Env.perc(1, 5, 0.1).kr(0));
	// sound = Splay.ar(sound * 3);
	// sound = Limiter.ar(sound);
	sound = JPverb.ar(sound, 5);
	DetectSilence.ar(sound, 0.00001, doneAction:2);
	sound = MoogLadder.ar(sound, 2000) * 12;
	sound = HPF.ar(sound, 300);
	// sound = PanAz.ar(~numChannels, sound, 0, 0.2, ~numChannels);
	sound = SplayAz.ar(~numChannels, sound, 1, 1.2, ~numChannels);

}.play;

)


[ 400.0, 84.089641525371, 251.98420997898, 251.98420997898, 897.96963864752 ]

[ 299.66141537534, 299.66141537534, 400.0, 188.77486253634, 251.98420997898 ]

[ 400.0, 188.77486253634, 299.66141537534, 84.089641525371, 84.089641525371 ]

// from Demo Mobile II
// ~notes = [25.1750, 43.35, 38, 47, 40, 43.35, 50, 54].midicps;


-------




Pdef(\fm).stop;

(
Pdef(\fm, Pbind(
\instrument, \fm,
\dur, Pxrand([1, 2, 5, 7], inf),

\freq, Pxrand(~notes, inf),
\ctranspose, 0,

// \seed, Pxrand((0..3)++(13..27)++(40..49), inf).poll,
\seed, 22,
// \seed, Pxrand((0..53), inf).poll,

\seedDrift, Pxrand((0..5), inf),
\seedDriftCurve, -4,

\freqMin, -2,
\freqMax, 3,
\freqRound, 0,

\feed, Prand([1, 1.5], inf),

\partialMax, Pwrand([1, 30], [0.9, 0.1], inf) + 20,
\legato, 1,
\lpf, 3000,
\amp, 2,
\pan, Pwhite(-1/2.0, 1.0/2),

)
).play;
)
---------

(
~pluck.stop;
~pluck = Pbindef(\pl, \instrument, \pluck, \dur, Pseq([1/2, 1/8, 1/8, 1], inf), \freq, Pxrand(~notes, inf) * Prand([2, 4], inf) * 2, \amp, 0.1).play;
)

(
~moog.release(30);
~moog = Synth(\moogbass, [freq: 599.32283075067, atk: 100, amp: 1])
)


(
~moog.release(30);
~moog = Synth(\moogbass, [freq: ~notes.choose.postln, atk: 30, amp: 1])
)

Synth(\poom, [freq: ~notes.choose / 4, rel: 7]);


(
~rotate.release(30);
~rotate = {var snd;
	snd= SinOsc.ar(({Select.kr(LFNoise2.kr(0.1).range(0, 15), ~notes)}!1).lag(2), 0, 0.1);
	snd = Pan2.ar(snd, Array.fill(~notes.size, {1.0.rand2}));
	snd = Mix.new(snd) * 1/7;
	snd = Rotate2.ar(snd[0], snd[1], LFSaw.kr(1));
}.play(fadeTime:30);
)


(
~rotate.release(10);
~rotate = {var snd;
	snd= SinOsc.ar(Array.fill(10, {Rand(100, 1000)}) * LFNoise2.kr(0.3, 0.5, 1), 0, 0.1);
	snd = Pan2.ar(snd, Array.fill(~notes.size, {1.0.rand2}));

	// snd = Mix.new(snd);
	snd = Rotate2.ar(snd[0], snd[1], LFSaw.kr(1));
}.play;
)



Synth(\sinoscfbmod_rotate, [freq: ~notes.choose, atk: 30/2, rel: 30/2, detune: rrand(0, 0.01), feedbackMod: rrand(1.0, 3.0), speed: rrand(2.0, 4.0), pan: rrand(-1, 1.0)])


(
p = Panola.new("c_8 d_4 <e b4> f_3 g_9 a3 b4");
p.asPbind(\percsine, true, Dictionary.newFrom(["amp", 0.1/10])).play;
p.asPbind(\sinesaw1).play;
)



(
~testpan.release(10);
~testpan = {var snd; snd= SinOsc.ar(100, 0, 0.1); snd = Pan2.ar(snd, LFSaw.kr(1))}.play(fadeTime:10);
)


b = SoundFile.collectIntoBuffers("/Users/maxlouisraugel/Documents/son/boxharp/*");

b[9].play;

Synth(\sinoscfbmod_rotate, [freq: (Scale.iwato.semitones + [[48, 60, 72, 84]]).choose.midicps, atk: 30, rel: 30/2, detune: rrand(0, 0.1), feedbackMod: rrand(1.0, 3.0), speed: rrand(2.0, 4.0), pan: rrand(-1, 1.0)])


























~tinnitus.release(20)

-----

(
~deepbass.release(0);
~deepbass = {|freq 65| var snd; snd = LFSaw.ar(freq, 0, 0.1) * LFPulse.ar(freq, 0, 0.5, 0.1); snd = RLPF.ar(snd, freq * SinOsc.ar(0.1, 0, 1/2, 1) * 1, 0.1); snd = (snd * 100).tanh * 0.1; snd.dup * 3}.play;
)


Pbind(\instrument, \play, \buffer, C.get(\thanks, 10), \dur, 1, \rate, Pseq([0.95, 1.02, Rest(5), 0.95, 0.95, Rest(3), 1.02, 0.95, 1.1, Rest(5)], 1)).play;

(
~rrrmelodic.release(1);
~rrrmelodic = {
	var chord, snd;
	chord = SelectX.kr(0, [(\Cm7.asNotes + [[60, 72, 84]]).flatten.midicps, (\DM.asNotes + [[48, 60]]).flatten.midicps]);
	snd=
	Splay.ar(
	BPF.ar(
		LFSaw.ar(
				LFNoise2.kr(0.5).exprange(7, 17)
				// LFNoise2.kr(0.5).exprange(10, [1000, 100])
			),
		chord,
		0.005,
		mul: Env.perc(1, LFNoise1.kr(1, 1, 5), level: 10, curve: -3).circle.kr(2)
),
		spread: 0,
		level: 1.9);
	snd = Mix(snd);
	snd = snd + (snd * WhiteNoise.ar(0.1).lag(0.1));
	snd = (snd * 5).tanh;
	PanAz.ar(~numChannels, snd, LFNoise2.kr(0.3, 0.5, 1)) * \amp.kr(1/3);

}.play(fadeTime: 10);
)

~rrrmelodic.set(\amp, 1/5)

(
~deepbass.release(0);
~deepbass = {|freq 48| var snd; snd = LFSaw.ar(freq, 0, 0.1) * LFPulse.ar(freq, 0, 0.5, 0.1); snd = RLPF.ar(snd, freq * SinOsc.ar(0.1, 0, 1/2, 1) * 1, 0.1); snd = (snd * 100).tanh * 0.1; snd.dup * 3}.play;
)

~freeverbus = ~freeverbus??Bus.audio(s, 2);
f = Synth(\freeverb, [in: ~freeverbus, out: 0, mix: 0.3, room: 1/2 ], s, 'addToTail')

(
~sen.stop;
~sen = Pbind(\instrument, \play, \buffer, C.get(\thanks, 3), \dur, Pxrand([4, 4], inf), \rate, Pxrand([1, 1.12], inf) * 1/2, \amp, 1/2, \out, ~freeverbus).play;
)


------

~rrrmelodic.release(30)



~deepbass.release(30)










































































C.p(\demo, seed: rrand(0, 300), bus: ~jpverbbus/*, folder: Pwhite(0, 10)*/, index: Pwhite(0, 20), dur: Pxrand([30, 3], inf), release:10, amp: 0.1)
C.s(\demo)


Ndef(\tingle).stop(20)

/*(
Ndef(\pitch, {Pitch.kr(\in.ar).poll}).play;

Ndef(\pitch).set(\in, Ndef(\u))
)*/


(
Ndef(\wavering, 'wavering');
Ndef(\wavering).set(\freq, 1077);

Ndef(\wavering).play(fadeTime: 30);
)


Ndef(\wavering2, 'wavering').set(\freq, 1077/2).play(fadeTime: 30)

Ndef(\wavering3, 'wavering').set(\freq, 132, \dev, 1.01).play(fadeTime: 30)

// Ndef(\wavering2).set(\freq, 1077)

Ndef(\wavering4, 'wavering').set(\freq, 1600).play(fadeTime: 10)

Ndef(\wavering4).fadeTime_(10)

(
Ndef(\wavering5, 'wavering').set(\freq, 1330/2);
Ndef(\wavering5).play(fadeTime: 5);
)

Ndef(\wavering6, 'wavering').set(\freq, 1330/4).play(fadeTime: 20);

Ndef(\wavering3).fadeTime = 30;

Ndef('wavering3').xset(\dev, 2);

~pointillism.release(20)

(
Ndef('wavering').stop(30);
Ndef('wavering2').stop(30);
Ndef('wavering3').stop(30);
Ndef('wavering4').stop(30);
Ndef('wavering5').stop(30);
Ndef('wavering6').stop(30);
)

(
Ndef('wavering').play(3);
Ndef('wavering2').play(3);
Ndef('wavering3').play(3);
Ndef('wavering4').play(3);
Ndef('wavering5').play(3);
)





(
Ndef('wavering').lag(\freq, 10);
Ndef('wavering2').lag(\freq, 10);
Ndef('wavering3').lag(\freq, 10);
Ndef('wavering4').lag(\freq, 10);
Ndef('wavering5').lag(\freq, 10);
)

(
Ndef('wavering').xset(\freq, 100);
Ndef('wavering2').set(\freq, 2000);
Ndef('wavering3').set(\freq, 500);
Ndef('wavering4').set(\freq, 700);
Ndef('wavering5').set(\freq, 800);
)




~iter2.release;



~tinnitus.release(30)




Ndef('wove').play
Ndef('sinevibrato').play;





Ndef('propellerfan', \playmono).set(\buffer, ~propellerfan, \loop, 1, \rate, 1).play(fadeTime: 30);


~combbus = Bus.audio(s, 2);

Ndef('comb', {|freq| var detune, in; in = In.ar(~combbus, 2); detune = LFNoise2.kr(0.3).range(\detune.kr(0.98), \detune.kr().reciprocal);CombC.ar(in, 0.2, 1/freq * detune, \decaytime.kr(1.0), 0.5)}).mold(numChannels:2).addSpec(\detune, [0.0001, 2, \lin, 0, 0.0]);



Ndef(\comb).lag(\freq, 1);

Ndef(\comb).set(\freq, 115.59 * 1);

Ndef(\comb).play;

Ndef('propellerfan').play(~combbus);


Ndef('propellerfan').clear(30);


~formant.release(50);


(
Ndef(\sinevibrato).stop(10);
Ndef(\tingle).stop(20);
Ndef('wove').stop(30);
Ndef('propellerfan').stop(10)
)



------




(
// ~staying.clear(10);
~staying = PbindProxy(\instrument, \sinesaw, \dur, Pseq([3!3, 6, 3!2, 6].flatten, inf), \amp, 1, \freq, Pseq([60, 57, 62, 53, 52, 48/*, 45*/].midicps, inf)*[1, 2], \rel, 5);
Ndef('staying', ~staying);
Ndef('staying').play(fadeTime: 30);
)

Ndef('staying').stop(10)


(
~sinewaver.release(10);
~sinewaver = {SinOsc.ar(SinOsc.kr(0.15).range(57, 60).midicps, 0, 0.2)!2}.play(fadeTime: 100)
)

Ndef('staying').clear(fadeTime: 30);


Tempo.bpm = 60


// phone tone
~phonetone = "/Users/maxlouisraugel/Documents/ /phone tone.wav".b;
~euphoniumbrass = "/Users/maxlouisraugel/Documents/ /euphonium brass 5.wav".b;

Pbindef(\p1, \instrument, \play, \buffer, ~phonetone, \dur, ~phonetone.duration).play;


C.crawl("/Users/maxlouisraugel/Desktop/small instruments/", 1);

C.p(\one, bus: ~jpverbbus, folder: \minisax, index: Pseq([5, 5], inf), rate: Pseq([0, -3], inf).midiratio, dur: 10, amp: 0.1);
// C.p(\one, bus: ~jpbus, folder: Pseq([3, 0], inf), index: Pseq([5, 4], inf), rate: Pseq([0, -3], inf).midiratio, dur: 6);

C.s(\one)

















------

// ZONE

(
var durs = 1;
~zone.stop;
~zone = Pbind(\instrument, \sinesaw, \dur, durs, \freq, Pseg([200, 300, 800, 300, 200], [3, 8, 8, 3]*durs, repeats:inf), \rel, Pseg([10, 7, 7, 10], [3, 8, 11] * durs, repeats: inf), \amp, 0.5, \sawmul, 1/2000);

Ndef(\zone, ~zone).play(fadeTime: 0);
)

Ndef(\zone).stop(30);
Ndef(\zone).clear;




(
~lowmarimba.stop;
~lowmarimba = Pbind(\instrument, \lowmarimba, *[dur: 0.1, freq: Pseg([200, 300, 800, 300, 200], [3, 8, 8, 3]/10, repeats:inf), amp: 0.01, pan: Pseg([-1, 1, -1], [3, 3], 'lin', inf)]);
Ndef('lowmarimba', ~lowmarimba).play(fadeTime: 30);
)

Ndef(\lowmarimba).clear(30);


(
~bass.stop;
~bass = {
	loop{
		~pm = play{PMOsc.ar(50!2, 50, 1, 0, Env.asr(15, 0.1, 10, -4).kr(2))};
		15.wait;
		~pm.release(15);
		14.wait;
	}
}.fork;
)

~bass.stop; ~pm.release(30);


~pm.release;

~jpverb.play;

Pbindef(\p, \instrument, \kick, \dur, Pseq([1/3, 1/3, 1/3], inf), \amp, 0.2).play;
Pbindef(\p).stop;

~attention = Pmono(\sinesaw, \dur, 0.1, \freq, Pseg([200, 300, 800, 300, 200], [3, 8, 8, 3], repeats:inf), \sawmul, Pseq([0.001, 0.1], inf), \stretch, Pseg([1, 3, 2, 3, 1, 2], [3, 2, 1, 3, 1], 'lin', inf), \out, ~jpverb_bus).play;

~attention.stop;

~jpverbus = ~jpverbus ?? Bus.audio(s, 2);
Synth(\jpverb, [in: ~jpverbus], s, 'addToTail');


~golden = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /golden stress.aiff");


(
var stream = Pxrand([[12, 50], [12, 7], [3, 12], [8, 30]], inf).asStream;

play{var snd = PlayBuf.ar(2, ~golden, 1.cpsmidi.midiratio + stream.next) * Env([0.5, 0], [5]).kr(2); snd = Out.ar(~jpverb_bus, snd)};
)


Ndef(\zone).clear(fadeTime: 30);



--------



(
~drone.release(30);
~drone = {var snd; snd = PlayBufCF.ar(2, \b.kr(C.get(\Gedackt8, 8)), ([1, 1.2, 0.5, 0.9]).flatten, Impulse.kr(1/2 * LFNoise2.kr(0.3, 0.1, 1)), 3000 * BufDur.ir(C.get(\Gedackt8, [8, 16])), 1, 10, 12) * 0.2; snd = Splay.ar(snd, 0.3, 1, 1); snd = FreeVerb2.ar(snd[0], snd[1], 0.3, 3)}.play(fadeTime: 10);
)


(
~drone2.release(30);
~drone2 = {var snd; snd = PlayBufCF.ar(2, \b.kr(C.get(\Gedackt8, 8)), ([1, 1.2, 0.5, 0.9] * 2).flatten, Dust.kr(1/10 * LFNoise2.kr(0.3, 0.1, 1)), 3000 * BufDur.ir(C.get(\Gedackt8, [8, 16])), 0, 10, 12) * 0.2; snd = Splay.ar(snd, 0.3, 1, 1); snd = FreeVerb2.ar(snd[0], snd[1], 0.3, 3)}.play(fadeTime: 10);
)




(
~resonatedsticks.release(10);
~resonatedsticks = {
	var snd; snd = Splay.ar(
		WhiteNoise.ar(
			{Saw.ar(freq: LFNoise1.kr(1).range(0.1,0.3))}!3),
		level:0.05) * LFNoise2.kr(0.3).unipolar;

	snd = Resonator.ar(snd, 130, damping: 0.4) / 10;
	snd = FreeVerb.ar(snd, 0.3, 1);
	snd = RLPF.ar(snd, 3000);
}.play(fadeTime:10);
)

~whiteshuffle2.release(10)



// LIVESET


(
~eli1.release(1);
~eli1 = {
	var snd, freq, trig, rate;
	// trig = Dust.kr(1);
	// freq = TRand.kr(100, 1000, trig);
	rate = \rate.kr(1/2) * LFNoise2.kr(0.3, 0.1, 1);
	trig = LFNoise2.kr(rate);
	freq = TChoose.kr(trig, [400, 570]/2).lag(1/2);
	snd = SinOsc.ar(freq) * VarSaw.kr(rate, 0, 0.5).exprange(0.01, 1.0) * 0.1;
	snd = JPverb.ar(snd);
	// snd = FreeVerb.ar(snd, 1/2, 3)!2;
}.play(fadeTime: 10);
)








---------

~ressortpitched = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /ressort pitched.wav");

(
~eli1.release(1);
~eli1 = {
	var snd, freq, trig, rate;
	// trig = Dust.kr(1);
	// freq = TRand.kr(100, 1000, trig);
	rate = \rate.kr(1/2) * LFNoise2.kr(0.3, 0.1, 1);
	trig = LFNoise2.kr(rate);
	freq = TChoose.kr(trig, [400, 500, 570]/2).lag(1/2);
	snd = SinOsc.ar(freq) * VarSaw.kr(rate, 0, 0.5).exprange(0.01, 1.0) * 0.1;
	snd = JPverb.ar(snd);
	// snd = FreeVerb.ar(snd, 1/2, 3)!2;
}.play(fadeTime: 10);
)


(
~brownwave = Ndef(\wave, {
	|freq 300|
	var snd;
	snd = Pulse.ar([freq, freq * 1.01], 0.02, 0.03);
	snd = snd + SinOsc.ar([freq*1.5, freq*1.5*1.01], 0, 0.01);
	snd = snd + BrownNoise.ar(0.03!2);
	snd = snd * SinOsc.kr(0.1, pi);
	snd = FreeVerb.ar(snd, 0.3, 5);
}).play(fadeTime: 30);
)

~brownwave.stop(30);
~brownwave.fadeTime=30;
~brownwave[10] = \filter->{|in| LPF.ar(in, 1500)}
~brownwave[10] = nil;



Pbind(\instrument, \sinesaw1, \dur, 2, \atk, 1/2, \rel, 3, \freq, Pseq([400, 500, 500/2]), \spread, 0, \pan, Pseq([-1, 1, -1]), \amp, 1).play;



// THIS


~ressortpitched = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /ressort pitched.wav");

(
~ress.stop;
~ress = Pbind(\instrument, \play, \buffer, ~ressortpitched, \dur, Prand([10, 30, 20], inf), \amp, 1, \pan, Pwhite(-1/2, 1/2)).play;
)

// >< IOA


(
// 500, 400, 300, 250
~resonatedsine = Ndef(\resonatedsine, {|freq 100| var snd; snd = SinOsc.ar(freq, 0, 0.1); snd = Resonator.ar(snd, freq / 2) * 2; snd = snd.blend(BRF.ar(snd, freq), 0.8); snd = FreeVerb.ar(snd, 0.3, 1); snd = Pan2.ar(snd, \pan.kr(0), 2 * \amp.kr(1));});

~resonatedsine[100] = \set -> Pbind(\dur, 5, \freq, Pseq([500, 400, 300, 250], inf), \amp, 2);


~resonatedsine.vol=0.7;
~resonatedsine.play(fadeTime: 30);
)

~resonatedsine.stop(10);

(
~squine = Ndef(\squine, {|freq 100 clip 0 skew 0.0 sync 0.0 amp 0.5 iminsweep 0 initphase 1.25 pan 0|
	var snd;
	snd = Squine.ar(freq: freq * {LFNoise2.kr(0.3!3).range(0.99, 1.01)}, clip: clip * SinOsc.ar(freq, 0, 1, freq), skew: skew, sync: sync, mul: amp, add: 0,iminsweep: iminsweep, initphase: initphase);
	snd = Splay.ar(snd);
	snd = FreeVerb2.ar(snd[0], snd[1], \mix.kr(0), \room.kr(1));
	// snd = Pan2.ar(snd, pan);
}).mold(2)
)

~squine.play;

(
~squine.fadeTime_(1);
~squine.lag(\freq, 3);
~squine.lag(\clip, 10);
~squine.lag(\skew, 10);
~squine.vol=0.3;
~squine.play(fadeTime: 30);
)

~squine.vol=0.3; ~squine[10] = \set -> Pmono(\squine, \dur, 5, \freq, Pseq([500, 400, 300, 250], inf), \clip, Pseg([0, 1, 0], [10, 10], 'lin', inf), \skew, Pseg([1, 0, 1], [10, 10], 'lin', inf));

~squine[10] = nil;

~squine.stop(30)

~samples.play;

(
Ndef(\squine).copy(\squine2);
Ndef(\squine2).play;
Ndef(\squine2)[10] = \set -> Pmono(\squine2, \dur, 5, \freq, Pseq([500, 400, 300, 250], inf) * 1.5, \clip, Pseg([0, 1, 0], [10, 10], 'lin', inf), \skew, Pseg([1, 0, 1], [10, 10], 'lin', inf));
Ndef(\squine2).play;
)


~fm = Pbindef(\fm, \instrument, \fm, \freq, Pxrand([500, 400, 300, 250], inf), \dur, Pxrand([1, 2], inf), \amp, 1/2);
~fm.play;


(
~eli1.free;
~eli2.free;
~eli3.free;
)

~whiteshuffle.vol_(0.5).play(fadeTime:20)
~whiteshuffle.vol = 0.5;

(
Pdef(\fournotes,
	Pbind(
		\instrument, \percsinefb,
		\freq, Pseq([500, 400, 300, 250], inf),
		\dur, 5,
		\rel, 5,
		\amp, 1/10
	)
)
)

Pdef(\fournotes).play;
Pdef(\fournotes).stop;


Synth(\poinwhitecomb, [freq: rrand(50, 150), rel:0.3, pitchenv: 20, pan: rrand(-1, 1.0), amp: 1/10, verb: 0.1]);

~ressortpitched = ~ressortpitched ?? Buffer.read(s, "/Users/maxlouisraugel/Documents/ /ressort pitched.wav");

// delay modulation ?

(
~dm = Ndef(\dm, {
	var snd, env, buffer, trig;
	buffer = \buffer.kr(~ressortpitched);
	// trig = Dust.kr(\density.kr(1));
	trig = 1;
	snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.kr(buffer), 1, 0, \loop.kr(0));
	snd = CombC.ar(snd, 0.2, 1/SinOsc.ar(\freq.kr(200), 0, \mul.kr(10), \add.kr(100)), 1);
	snd = HPF.ar(snd, 30);
	snd = snd * 0.2;
	// snd = FreeVerb.ar(snd);
})
)



~synco.stop; ~synco = Routine.run{{~dm.send.play; (3/3).wait; ~dm.send.play; (5/3).wait;}.loop}

~dm.clear;

~dm.set(\buffer, C.get(\bassdrums, 80), \freq, 100, \mul, 1, \add, 100);
~dm.set(\buffer, ~ressortpitched, \freq, 100, \mul, 1, \add, 100);

// 150, 190, 150, 100
Synth(\percsine, [freq: 150, rel: 3]);

~dm.set(\buffer, C.get(\thanks, 6), \freq, 606, \mul, 5, \add, 600);

~dm.set(\buffer, C.get(\thanks, 6), \freq, 310, \mul, 5, \add, 300);

~dm.set(\buffer, C.get(\thanks, 9), \freq, 310, \mul, 5, \add, 300);

~dm[100] = \set-> Pbind(\dur, Prand([1, 2], inf), \buffer, Pseq(C.get(\thanks, [6, 6, 9, 6, 9, 6]), inf), \freq, Pseq([606, 310, 310, 606, 310, 310], inf), \mul, 5, \add, Pseq([600, 300, 300, 600, 300, 300], inf))


~theaterkicks = Pbind(\instrument, \kick, \freq, 66, \dur, Pseq([1/3], {rrand(2, 5)}), \amp, 1/2);
~theaterkicks.play;




Tempo.bpm = 60


Pbindef(\b, \instrument, \play, \buffer, C.get(\thanks, [3]), \dur, Pseq(geom(10, 0.1, 1.1), inf), \rate, Pseq(geom(10, 50, 1.2).cpsmidi.midiratio, inf), \atk, 0.01, \rel, Pkey(\dur) * 3, \amp, 1, \pan, Pstep([-1, 1], [3, 3], inf)).play;


(
Pbindef(\gauss,
	\instrument, \percsinefb,
	\freq, Pgauss(mean: 200, dev:100, length:inf).poll,
	\rel, 0.5,
	\dur, 0.1,
	\pan, Pgauss();
).play;
)




Ndef(\rhythm1, \playbuf).set(\buffer, ~rhythm1);
Ndef(\rhythm1).play(fadeTime: 30);
Ndef(\rhythm1).stop(fadeTime: 30);



//
// Ndef('propellerfan')[999] = \xset -> Pbind(\out, 0, \rate, 115.59 * Pseq([0.8, 1, 1.1, 1.5, 2], inf)/Pseq([2,3], inf)/10, \amp, 0.1, \freq, Pseq([1000, 1200, 500, 300, 7000]/10, inf))
// Ndef('propellerfan')[999] = nil;
//
//
// Ndef('propellerfan').xset(\rate, 1)



Convenience.crawl

Convenience.p(\test, 0, index: Prand((1..20), inf), dur: 0.1, pos: Pwhite(0, 1.0), sustain: Prand([0.001, 0.01, 0.02], inf), attack: 0.01, release: 0.01, pan: Pwhite(0, 1.0), tuningOnOff: 1, degree: Pwhite(0, 12), scale: Scale.major);


Convenience.s(\test, 30);

Tempo.bpm = 60;

(
Ndef(\sinkick,
	Pbind(\instument, \kick, \freq, 50)
).quant_(5).play(fadeTime:30);
)

Ndef(\kick, {SinOsc.ar(50!2, 0, Env.perc.kr(0, \trig.kr(0)))})

Ndef(\kick).set(\trig, 1).send.play;



(
~routine.stop;
~routine = {
	loop{

		{
			var notes, snd;
			notes = [31.533615572014, 35.395286725564, 37.5, 42.092326811602, 47.247039371058, 50.056494531376, 56.186515382876, 63.067231144029, 70.790573451127];
			// snd = SinOsc.ar((notes.choose), 0, Env.perc(0.01, 2).kr(2));
			// snd = SinOsc.ar((notes.choose*[1, 2, 4, 8, 16]), 0, Env.perc(0.01, 2).kr(2));
			// snd = Splay.ar(snd);
			snd = SinOsc.ar(50, 0, Env.perc.kr(2));
			snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels);
		}.play;

		~clavecins.release(0.1);
		~clavecins = {
			var chord, sound, sound2;
			chord = Array.makeScaleCps(300, 'major', 100, 10000);
			sound = LFSaw.ar(({chord.choose}!30).postln, 0, Env.perc(0.01, Env([0.01, {rrand(3, 3.3)}!10, 0.01], [10, 10]).kr(0), 0.1).circle.kr(0));
			// sound = SplayAz.ar(~numChannels, sound, Env([0, 1], 5).kr(0), 1.5, Env([-1, 1], 5).kr(0));
			// sound = Splay.ar(sound, Env([0, 1], 5).kr(0), 1.5, Env([-1, 1], 5).kr(0));
			// sound = XFade2.ar(sound, NHHall.ar(sound, 1, 2), Line.kr(-1, 1, 5));

		}.play;

{
			// var notes = Array.makeScaleCps(100, 'major', 50, 200);
			var notes, sound;
			notes = [50.0, 56.123102415469, 62.996052494744/*, 66.741992708502*/, 74.915353843834, 84.089641525371, 94.387431268169, 100.0, 112.24620483094, 125.99210498949, 149.83070768767, 188.77486253634];

			sound = VarSaw.ar(notes.choose, 0, Line.kr(1, 0, 5), Env.perc(0.01, 7, 0.3).kr(2));
			sound = JPverb.ar(sound, 0.007);
			// sound = JPverb.ar(sound, 0.007) + sound;
			// sound = MoogLadder.ar(sound, 2000);
			sound = SplayAz.ar(~numChannels, sound, 1, 1, ~numChannels);
		}.play;

		4.5.wait;

		// Synth(\kick, [freq: Array.makeScaleCps(300, 'major', 1000, 2000).choose, amp: 1.5]);

		0.5.wait;

	}
}.fork(quant: 5);
)



~clavecins.stop;

Tdef(\x, {loop { (instrument: \fml, freqA: Array.makeScaleCps(300, 'major', 50, 1000).choose, freqB: Array.makeScaleCps(300, 'major', 50, 1000).choose, time: 3.0.rand).play; 5.rand.wait }}).play;

Tdef(\x).stop;






Ndef(\filaments, \playbuf).set(\buffer, ~filaments, \loop, 1).play(fadeTime: 30);

Ndef(\zither, \playbuf).set(\buffer, C.get(\zither, 0), \loop, 1).play;



C.p(\thanks, 0, 2, folder: \thanks, index: Pwhite(0, 20), dur: Pxrand([20, 2], inf), sustain: 5)
C.s(\thanks)


Ndef(\battements, \battement).play(fadeTime: 30);
/*Ndef(\i).set(\freq, 100, \amp, 3)*/
Ndef(\battements).clear(20);



Ndef(\filaments).stop(10);

Ndef(\zither).clear;

C.s(\thanks)







(
~ecla1.release;
~ecla1 = {
	|density 3|
	var snd, env,freq, trig, dust, lfo;
	// trig = Dust.kr(\density.kr(1));
	lfo = LFNoise2.kr(0.3, density);
	trig = Impulse.kr(lfo.abs);
	// dust = Dust.kr(0.3);
	freq = SelectX.kr(TRand.kr(0, 3, trig.lag(10)), (\Em7.asNotes + 24).midicps).lag(TChoose.kr(trig.lag(10), [0, 5]));
	// freq = [101, 102, 400, 200, 800, 250, 380];
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.1) / density, 1/2).kr(0, trig);
	snd = WhiteNoise.ar(env);
	snd = snd.lag(0.1) * 50;
	// snd = LPF.ar(snd, 5000);
	snd = HPF.ar(snd, 300);
	snd = CombC.ar(snd, 0.2, 1/SinOsc.ar(freq, 0, LFNoise2.kr(0.1, 2).abs, freq - (freq * 0.01)), 1);
	snd = snd * \amp.kr(1);
	snd = LPG.ar(snd, LFSaw.ar(lfo), 0.3, 1, 0.1);
	// snd = snd.fold2;
	snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels);
}.play;
)



(
~ecla.release;
~ecla = {
	|density 3|
	var snd, env,freq, trig, dust, lfo;
	// trig = Dust.kr(\density.kr(1));
	lfo = LFNoise2.kr(1, 5);
	trig = Impulse.kr(LFNoise2.kr(0.3, density).abs);
	dust = Dust.kr(0.3);
	freq = XFaderN.kr((\Em7.asNotes + 60).midicps, lfo, 10);
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.1) / density, 1/2).kr(0, trig);
	snd = WhiteNoise.ar(env);
	snd = snd.lag(0.1) * 50;
	// snd = LPF.ar(snd, 5000);
	snd = HPF.ar(snd, 300);
	snd = CombC.ar(snd, 0.2, 1/SinOsc.ar(freq, 0, LFNoise2.kr(0.1, 2).abs, freq - (freq * 0.01)), 1);
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, TRand.kr(-1, 1, trig)/2);
	snd = snd.blend(Resonator.ar(snd, brightness: 0.3, damping: 0.3), 0.3);
	snd = FreeVerb.ar(snd);
}.play;
)


---------


Pbindef(\n).stop;


Pbind(\instrument, \sinesaw1, \atk, 0.3, \rel, 3, \note, Pseq([3, 6, -2]), \spread, 0, \pan, Pseq([-1, 1, -1]), \amp, 2).play;


Pbind(\instrument, \sinesaw1, \atk, 1, \rel, 3, \note, Pseq([-4, 3, 6]), \spread, 0, \pan, Pseq([-1, 1, -1]), \amp, 1).play;

Pbind(\instrument, \sinesaw1, \atk, 1, \rel, 3, \note, Pseq([-2, 3, 6]), \spread, 0, \pan, Pseq([-1, 1, -1]), \amp, 1).play;


----


(
SynthDef(\klang, {
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1), \amp.kr(1.0)).kr(2);
	snd = LFSaw.ar(\freq.kr(100) * Array.geom(10, 1, 1.3) * {LFNoise2.kr(0.3, 0, 0.02, 1)});
	snd = Resonator.ar(snd.sum * 0.1);
	snd = FreeVerb.ar(snd, 0.9);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env);
}).add;
)




~jpverb.play;
~jpverb.stop;

Pbindef(\say, \instrument, \sinesaw1, \dur, Pxrand([1, 1, 1, 1, 0.9, 1, 0.2], inf), \freq, Pseg([100, 300, 700, 1900], [1, 2, Pxrand([4, 5, 7], inf)], 'lin', inf), \atk, 0.1, \rel, Pkey(\dur) * 2, \amp, 1/2, \pan, Pseq((-10 .. 10)/10, inf), \out, ~jpverb_bus).play;

Pbindef(\say).stop;


-----


(
Pdef(\threenotes,
	Pbind(
		\instrument, \percsinefb,
		\freq, Pxrand([570, 400, 500], inf),
		\dur, 5,
		\rel, 5,
		\amp, 1/10
	)
)
)