"/Users/maxlouisraugel/Documents/sc/instruments/buffers.scd".load;
"/Users/maxlouisraugel/Documents/sc/instruments/synthdefs.scd".load;
"/Users/maxlouisraugel/Documents/sc/instruments/Ndefs.scd".load;

C.crawl("/Users/maxlouisraugel/Documents/son/SONS/small instruments/", 1);

MIDIdef.cc(\air_amp, {|val| a.set(\amp, val.linlin(0, 127, 0, 1.2))}, 10).fix;

~notes = [ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 , 450, 810, 1530, 360, 1170, 1350, 1620, 1440, 540, 1080 ];


(
~sschord.clear;
~sschord = PbindProxy(\instrument, \sinesaw, \freq, Prand([ [ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 ], [ 450, 810, 1530, 360, 1170, 1350, 1620, 1440, 540, 1080 ] ], inf), \dur, 3, \amp, 1, \pan, Pwhite(-1, 1));
Ndef(\sschord, ~sschord);
Ndef(\sschord).play(fadeTime: 1);
)

// chords or individuals notes

(
~sschord.clear;

~sschord = PbindProxy(\instrument, \sinesaw, \freq, Prand([ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 , 450, 810, 1530, 360, 1170, 1350, 1620, 1440, 540, 1080 ], inf),
	// \dur,Pxrand([3, 7, 12, 18], inf),
	\dur, 3,
	\amp, 2,
	\pan, Pwhite(-1, 1));

Ndef(\sschord, ~sschord);

Ndef(\sschord).play(fadeTime: 1);
);




(

x = Ndef(\x, {var snd, mc, lfo;

	mc = 10;

	lfo = LFNoise2.kr(0.1); snd = SinOscFB.ar({exprand(20, 9000)}!mc, lfo.range(0, \fb.kr(0.0)), {LFNoise2.kr(3, 0.05, 0.05) * 0.5}!mc); snd = LPF.ar(snd, 3000);
	lfo = LFNoise2.kr(0.3); snd = SinOscFB.ar(~notes/2, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	// lfo = LFNoise2.kr(0.3);snd = SinOscFB.ar(([200, 250, 300, 500, 570, 600, 740] * [[1, 0.5]]).flatten, lfo.range(0, \fb.kr(0.0)), {lfo.range(0, 0.05)}!10);
	snd = HPF.ar(snd, 100);
	// snd = Splay.ar(snd);

	// snd = SplayAz.ar(8, snd, 1, 1, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0); // FOR STEREO
	snd = SplayAz.ar(~numChannels * 2, snd, 1, 2, 2, lfo.range(0, 3.0)) * 0.3 * \amp.kr(0);
	// snd = SplayAz.ar(~numChannels * 2, snd, 1, 2, 2, lfo.range(0, ~numChannels / 2)) * 0.3 * \amp.kr(0);
	// snd = SplayAz.ar(~numChannels, snd, 1, 1, 2, lfo.range(0, ~numChannels - 1)) * 0.3 * \amp.kr(0);


	snd = snd.blend(JPverb.ar(snd, 6, 0, 1.0, modFreq: 0.3), \jpverb.kr(0).range(0.3, 1));

}).fadeTime_(3).mold(~numChannels);

Ndef(\x).play(fadeTime:30);

MIDIdef.cc(\xamp, {|val| Ndef(\x).set(\amp, val.linexp(0, 127, 0.01, 50))}, 12, 0).fix;
// MIDIdef.cc(\xmod, {|val| Ndef(\x).set(\xmod, val.linlin(0, 127, 0.01, 0.5))}, 13, 0).fix;
// Ndef(\x).set(\mod, 0.3);
MIDIdef.cc(\xfb, {|val| Ndef(\x).set(\fb, val.linlin(0, 127, 0, 2))}, 13, 0).fix;
MIDIdef.cc(\xverb, {|val| Ndef(\x).set(\jpverb, val.linexp(0, 127, 0.01, 0.5))}, 13, 0).fix;

);

(
~rrrmelodic.release(30);
~rrrmelodic = {
	var chord, snd;
	chord = Select.kr(LFNoise2.kr(0.3).range(0, 10), ~notes/2);
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
	snd = (snd * 3).tanh;
	PanAz.ar(~numChannels, snd, LFNoise2.kr(0.3, 0.5, 1)) * \amp.kr(0.1);

}.play(fadeTime: 30);
)




(

~chording.stop;

~chording = Routine.run({{

~notes = [ 720, 810, 270, 630, 630, 180, 720, 810, 900, 630 , 450, 810, 1530, 360, 1170, 1350, 1620, 1440, 540, 1080 ];

~dusk = {
	// var notes = Array.makeScaleCps(100, 'major', 50, 200);
	var sound;
	sound = VarSaw.ar(({~notes.choose}!5).postln, 0, Line.kr(0.5, 0, 1.3), Env.perc(1, 1, 0.1).kr(0));
	sound = JPverb.ar(sound, 5, 0, 1, 0.707, 0.1, rrand(0.3, 2.0));
	DetectSilence.ar(sound, 0.0001, doneAction:2);
	sound = MoogLadder.ar(sound, 2000) * 12;
	sound = HPF.ar(sound, 300);
	sound = PanAz.ar(~numChannels, sound.sum, 0, 0.2, ~numChannels);
	// sound = SplayAz.ar(~numChannels, sound, 1, 1.2, ~numChannels);

}.play;

	24.wait;
}.loop;

}))



(
~pointillism.release(30);
~pointillism = Ndef(\pointillism, {
	var snd, combfreq, trig;
	trig = {Dust.ar(\density.kr(0.1))};
	combfreq = {exprand(20, 10000).round(100) * LFNoise2.kr(\detune.kr(0.1)).range(1, 2)}/2;
	// combfreq = TChoose.kr(trig, ~notes);
	snd = CombC.ar(trig!10, 0.2, 1/combfreq!10, 0.5).sum;
	snd = PanAz.ar(~numChannels, Mix.ar(snd!10), LFNoise2.kr(0.3), 1, 2.0);
	snd = LPF.ar(snd, 5000); HPF.ar(snd, 400);
	// snd = snd.softclip;
	snd = snd * \amp.kr(0.1);
	// snd = JPverb.ar(snd);
}).mold(~numChannels).play(fadeTime: 30);
)

(
~spiral.release(20);
~spiral = {
	|time 30|
	var curve, snd, inwards;
	inwards = Line.kr(0.3, 1, time);
	snd = SinOscFB.ar(SinOsc.kr(inwards, 0, Line.kr(450, 0, time), 550), 1);
	snd = LPF.ar(snd, 2000);
	snd = PanAz.ar(~numChannels, snd, SinOsc.kr(inwards, 0, Line.kr(2.0, 0, time)));
	// snd = MoogFF.ar(snd, 1000);
	snd = snd / 30;
}.play(fadeTime: 20);

{30.wait; ~spiral.release(20);}.fork;

)

(
// ~algae.free;

var fade = 30; ~algae.release(fade);

~algae = {
	var snd, roots, ondulation, pulse;
	pulse = {(5..20).choose/10}!5;
	roots = {(50..600).choose}!5;
	// ondulation = roots + LFNoise2.kr(0.3).bipolar(30) + {LFNoise2.kr(0.5).bipolar(30)};
	ondulation = roots + LFNoise2.kr(0.3).bipolar(30);
	// snd = SinOscFB.ar(ondulation, 0.5, 0.1);
	snd = SinOsc.ar(ondulation, 0.5, {LFNoise2.kr(0.2,0.1).abs}!10);
	// snd = Splay.ar(snd);
	snd = SplayAz.ar(~numChannels, snd, 1, 1.5, ~numChannels);
}.play(fadeTime: fade)

)



(
~whiteshuffle.release(30);
~whiteshuffle = {SplayAz.ar(~numChannels,
	WhiteNoise.ar(
		Saw.kr(freq:{LFNoise1.kr(0.1).range(0.01,1)}!5, mul:\amp.kr(0)/10).lag(\lag.kr(5))
), 1, 1, ~numChannels)}.play(fadeTime: 10);

MIDIdef.cc(\wsamp, {|val| ~whiteshuffle.set(\amp, val.linlin(0, 127, 0, 1))}, 4).fix;
MIDIdef.cc(\wslag, {|val| ~whiteshuffle.set(\lag, val.linlin(0, 127, 0, 5))}, 5).fix;
)



(
~reson.release(30);
~reson = {
	var snd, chord, density;
	// density = SinOsc.ar(0.3, 0, 50, 100);
	density = 0.2;
	// chord = Drand(Array.makeScaleCps(300, 'major', 100, 1000), inf);
	// chord = Drand([300, 400, 810, 309], inf);
	chord = Drand([100, 310, 800, 1002, 414], inf);
	// snd = Impulse.ar(density);
	snd = Dust.ar(density);
	// snd = Env.perc(0.1, 1, 1).kr(0, gate: snd);
	// snd = CombC.ar(snd, 0.2, 1/Demand.ar(snd, 0, chord).lag(0.2), Demand.ar(snd, 0, chord.reciprocal) * 50);
	snd = Resonator.ar(snd, Demand.ar(snd, 0, chord).lag(MouseY.kr(0.00001, 0.1, 1)), 0.001, 24, Demand.ar(snd, 0, chord.reciprocal), 0.5) * 0.5;
	// snd = Resonator.ar(snd, Demand.ar(snd, 0, chord).lag(0.01), 0.001, 24, 0.5, 0.5);
	snd = snd.blend(JPverb.ar(snd, 0.1, 0.9, 0.1) * 2, 0.2);
	snd = HPF.ar(snd, 20) * 10;	snd = LPF.ar(snd, LFNoise2.kr(0.2, 3000, 3000));
	snd = Sanitize.ar(snd);
	snd = PanAz.ar(~numChannels, snd.sum, LFNoise2.kr(density)*2) / 2;
}.play(fadeTime: 30);
)

(
~teasingsaws.release(10);
~teasingsaws = {Saw.ar(LFNoise2.kr([2, 3]).range(1000, 20000), LFPulse.kr([10, 5]) /20)}.play(fadeTime: 30);

{30.wait; ~teasingsaws.release(30)}.fork;
)



---------


(
~microgaussian.release(3);
~microgaussian = { var snd;
	snd = {SplayAz.ar(~numChannels, SinOsc.ar({LFNoise2.kr(0.01).range(100,1000)}, mul: {LFGauss.kr(LFNoise2.kr(1).range(0.1,10)).range(0.001,0.2)} * Line.kr(0, 0.5, 10), add: Saw.kr(freq: (LFNoise1.kr(1)), mul:0.3)), 1, 1, ~numChannels)
};
	snd = Sanitize.ar(snd);
	snd = HPF.ar(snd.tanh);
}.play(fadeTime: 2);
)


(
Ndef(\m).fadeTime = 10;
Ndef(\m, {
	Splay.ar(
		{
			SinOsc.ar(
				exprand(20, 20000),
				mul:Line.kr(0, 0.02, 10) * {LFNoise2.ar(\amps.kr(0.5))}
)}!100
)});
Ndef(\m).play(fadeTime:10);
);




Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 1/20, \atk, 0.1, \rel, 10]);

Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 1/20, \atk, 0.1/2, \rel, 1]);

Synth(\fml, [\freqA, 20, \freqB, (~notes/2).choose, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 1/20, \atk, 0.1, \rel, 10, \pan, rrand(-1.0, 1.0)]);


(
Synth(\poom, [freq: 311/4, atk: 12, rel: 12, amp: 0.2]);
x = Synth(\sinesaw1, [freq: [311, 311 * 2], atk: 12, rel: 12, amp: 1]);
)

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
);

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

(
Ndef(\u).fadeTime = 30;
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


// CONVOLUTION BETWEEN SIGNALS -

(
~conv = EZConv("/Users/maxlouisraugel/Documents/son/SONS/ /ploc.wav");
~conv2 = EZConv("/Users/maxlouisraugel/Documents/son/SONS/ /fire bottle ..wav");
)



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
Ndef(\sschord).stop(100);

~iter2 = Ndef(\iter2, {
	arg freq = 400, dev = 1.02;
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
	// sum = SplayAz.ar(~numChannels, sum, mod.linlin(-1, 1, 0.5, 10), 5, mod.linlin(-1, 1, 1, 4), mod.linlin(-1, 1, 0, 1.0), mod.linlin(-1, 1, 0.5, 4.0));
		sum = SplayAz.ar(~numChannels, sum, mod.linlin(-1, 1, 0.5, 4), 5, mod.linlin(-1, 1, 1, 2), mod.linlin(-1, 1, 0, 1.0), mod.linlin(-1, 1, 0.5, 4.0));
}).mold(~numChannels);

~iter2.set(\freq, 200);
~iter2.lag(\freq, 30);
~iter2.play(fadeTime: 30);
);


(
~monteealeatoire.release(10);
~monteealeatoire = { var montee, snd, lfo;
	snd = SplayAz.ar(
		~numChannels,
		SinOsc.ar(
		LFSaw.kr(
			LFNoise2.kr(rrand(1, 9)).range(20, 5000)
			, mul:0.01)
	) * 0.1, 1, 1, ~numChannels);
}.play(fadeTime: 1);
)

(
~risset_alea.release(10);
~risset_alea = { var snd, lfo;
	lfo = LFNoise2.kr(rrand(1, 9));
	snd = SplayAz.ar(~numChannels, SinOsc.ar(
		LFSaw.kr(
			lfo.range(20, 5000)
			, mul:0.01) / Array.fib(8, 1, 1);
	) * 0.1, 1, 1, ~numChannels);
	snd = HPF.ar(snd, 20); snd = LPF.ar(snd, 500);
}.play(fadeTime: 1);
)


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
	snd = HPF.ar(snd, 100);
}.play(fadeTime: 3);
)


(
~middle.release(30);
~middle = {
	Splay.ar(
	SinOsc.ar(
			{LFNoise2.kr(0.01).range(100,1000)}!10,
			mul: {LFNoise2.kr(1).range(0.001,0.2)}!10) * \amp.kr(1)
	)
}.play(fadeTime: 30);

a.play(fadeTime:0);

MIDIdef.cc(\air_amp, {|val| a.set(\amp, val.linlin(0, 127, 0, 1.2))}, 10).fix;
// MIDIdef.cc(\avion, {|val| a.set(\avion, val.linlin(0, 127, 0.01, 1))}, 9).fix;
a.set(\avion, 0.2);
MIDIdef.cc(\height, {|val| a.set(\height, val.linlin(0, 127, 0.01, 2))}, 11).fix;
)


(
~iter2.release(30);

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




Ndef(\soubresaut, {SinOsc.ar(freq: Saw.kr(freq: [0.2, 0.1], mul:[LFNoise2.kr(0.1, mul:100, add:300), LFNoise2.kr(0.1, mul:200, add:300)], add:150), mul:0.2)}).play(fadeTime: 50);



// END (Release nodes / functions)

Routine.run({Ndef(\sschord).stop(50); 50.wait; Ndef(\sschord).clear});

~middle.release(30);

~iter2.stop(30);

~chording.stop;





(
Ndef(\x).stop(60);
~middle.release(50);
Ndef(\soubresaut).stop(30);
~rrrmelodic.release(30);
~chording.stop;
~pointillism.release(30);
 ~algae.release(10);
~whiteshuffle.release(30);
~reson.release(30);
~filaments.release(30);
Ndef(\u).stop(30);
~risset_alea.release(10);
~monteealeatoire.release(10);
~middle.release(30);

~microgaussian.release(10);
~middle.release(10);
~speeds.release(20);
~harmonies.release(30);
)


