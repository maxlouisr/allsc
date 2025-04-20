(
r.release(10);
o.release(10);
l.release(10);
h.release(10);
)

(
a.release(10);

a = {
	arg detune = 0.01;
	Splay.ar(
		FreeVerb.ar(
			VarSaw.ar(
				100 *
				{LFNoise2.kr(0.01, detune, 1)}!3,
				{rrand(0.0, 1.0)}!3,
				[0.01, 0.05],
				0.1
			),
			0.4,
			1
	));
}.play(fadeTime: 10)
)

Ndef(\u).clear(30);

~bassnote = {VarSaw.ar(40!2, 0, 0.05, Env([0, 0.1, 0], [5, 30], 'welch').kr(2))}.play;

(
c.free;
c = {
	arg freq = 200;
	FreeVerb.ar(
		VarSaw.ar(
			Env(
				[0, 222, 222, freq!2, freq, 0],
				[0.01, 5, 0, 10]
			).circle.kr(2),
			0.2,
			mul: Env([0, 0.1, 0.1, 0], [2, 4.9, 7]).kr(2)
		)
	)
}.play;
)

y.free;


// (
// SynthDef(\help_dwgplucked, {
// 	arg out=0, freq=600, amp=0.2, gate=1, c3=900, pan=0;
// 	var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
// 	var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
// 	var son = DWGPlucked.ar(freq, amp, gate,0.1,1,c3,inp);
// 	DetectSilence.ar(son, 0.001, doneAction:2);
// 	Out.ar(out, Pan2.ar(son * 0.1, pan));
// }).play;
//
// d.free;
// d = {
// 	FreeVerb.ar(
// 		SinOsc.ar(
// 			[600, 600],
// 			0,
// 			mul: Env.perc(0.01, 3, 0.5).kr(2)
// 		), 0.5, 0.2
// 	)
// }.play;
// )


(
~ricercati = Array.new;
~folder = PathName("/Users/maxlouisraugel/Documents/ /ricercati/");

~folder.entries.do({
	arg path;
	~ricercati = ~ricercati.add(Buffer.readChannel(s, path.fullPath, channels:1));
});
)

(
SynthDef(\buffertwist, {
	arg
	rate = 1,
	start = 0,
	buf = ~ricercati,
	out = 0,
	trig = 1,
	loop = 1,
	lfspeed = 10,
	lfmul = 1,
	lfadd = 1;
	var sig, az;
	az = 4;
	sig = PlayBuf.ar(
		1,
		buf,
		BufRateScale.kr(buf)
		* rate
		* LFNoise2.kr(lfspeed, lfmul, lfadd),
		trig,
		start,
		loop,
		doneAction:0);
	sig = PanAz.ar(4, sig, SinOsc.kr(1, 1, 1));
	sig = sig * 0.25;
	Out.ar(out, sig);
}).add;
)


(
r.free;
r = Synth(
	\buffertwist,
	[
		\rate, 5,
		\buf, ~ricercati[2],
		\lfspeed, 10,
		\trig, Pwrand([0 , 0], [0.9, 0.3], inf),
		\loop, 0
	]
);

i.free;
i = Synth(
	\buffertwist,
	[
		\rate, 5,
		\buf, ~ricercati[5],
		\lfspeed, 10,
		\trig, Pwrand([0 , 0], [0.9, 0.3], inf),
		\loop, 0,
	]
))

(
r.release(10);
i.release(10);
)


(
Routine.run {

SynthDef(\iter2, {
	arg freq = 200, dev = 1.02, gate = 1;
	var temp, sum, env;
	env = Env.asr(30, 1, 30).kr(2, gate);
	sum = 0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * env * 0.05;
	Out.ar(0, sum);
}).add;

s.sync;

~iter2 = Synth(\iter2);
}
)




(
SynthDef(\iter, {
	arg freq = 100, rel = 5;
	var temp, sum, env;
	env = Env.perc(5, rel, 1, -1).kr(2);
	sum = 0;
	10.do{
		temp = Splay.ar(VarSaw.ar(
			freq * {Rand(0.99,1.01)}!2,
			0,
			0.05,
			0.1
		));
		sum = sum + temp;
	};
	sum = sum * env * 0.3;
	sum = Splay.ar(sum);
	Out.ar(0, sum);
}).add;
)

Synth(\iter, [\freq, 200]);
Synth(\iter, [\freq, 300]);
Synth(\iter, [\freq, 500]);
Synth(\iter, [\freq, 700]);
Synth(\iter, [\freq, 900]);
Synth(\iter, [\freq, 1120]);

// x = Synth(\iter, [\freq, 90, \rel, 30]);
x = Synth(\iter, [\freq, 80, \rel, 30, amp:5]);

#[100, 570, 80, 900, 1200, 1120, 80]

// bruit d'une chaise qui grince avec ça


(
b = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /ricercati/hic.wav");
k = {
	FreeVerb.ar(
	PlayBuf.ar(
		2,
		b,
		BufRateScale.kr(b),
		doneAction:0
	) * 5,
	0.5,
	0.5
)}.play;
)





















(
t.free;
t = {
	Splay.ar(
		{
			Saw.ar(exprand(100,2000).postln * LFNoise2.kr(0.01),
				mul:0.1)}!10,
		1,
		Env([0, 1, 0, 0], [0.01, 0.4, LFNoise2.kr(0.1, 1, 5)], -1).circle.kr(2) * 3

)}.play;
)


// for hard break:
714.13691328733
938.01238942777
210.92542285545
679.28874169132
1899.4319229777
1444.3166456998
158.5217331635
190.42283558286
480.42007139814
115.93765937064

//  or

409.26117277571
1229.2574061353
181.28265961646
914.72270209014
221.54552792369
618.66180121371
1226.2552240374
140.80793010011
228.02635953927
139.26543458662

//
122.01940378435
571.03892849274
1492.620441396
1901.2117576257
1724.2977263035
548.75328038974
1472.6550447847
844.8028825927
388.67578004697
365.41101948461

1037.7542864993
1918.345211817
120.28958554164
1822.4335752018
195.46066302598
628.48359797461
546.56103780154
229.24362086498
752.11674553906
591.14467967405

882.82695326673
1659.8792623073
243.75793508341
1229.0454979141
645.18502525341
1126.7951695939
223.49748504805
199.59919674044
568.45623129757
767.14107813709

316.13946659918
746.86144440866
1069.0439201377
578.69677054892
206.49369846074
524.01013952058
462.66210717983
569.65222942969
111.69069230627
194.36416125595


(
q.release(10);
q = Synth(
	\playbuf,
	[
		\rate, 1,
		\buf, ~ricercati[4],
		\lfspeed, 1,
		\lfmul, 10,
		\trig, 1]);
)


~ricercati[0].bufnum;



_____ then what??


(
SynthDef("InFeedback", { arg out=0, in=0, amp = 1;
	var input, sig, env;
	env = Env.asr(\atk.kr(10), amp, \rel.kr(100)).kr(2, \gate.kr(1));
	input = InFeedback.ar(in, 1);
	sig = SinOsc.ar(input * LFNoise2.kr(1, 800, 1000) + 100, 0, 0.193841);
	sig = BRF.ar(sig, 100);
	Out.ar(out, sig!2 * env);

}).add;
)




x = Synth("InFeedback")

x.release;

~rrr.play;

~woodcreak = Buffer.read(s, "/Users/maxlouisraugel/Desktop/wood creak.wav");

(
Routine.run {

	SynthDef(\iterb, {
		arg rate = 1, dev = 1.02, gate = 1, buffer;
		var temp, sum, env;
		env = Env.asr(30, 1, 30).kr(2, gate);
		sum = 0;
		100.do{
			arg count;
			temp = PlayBuf.ar(2, buffer, BufRateScale.ir(buffer) *
				rate *
				(count/10) *
				LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev),
				1,
				0,
				1
			);
			temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
			sum = sum + temp;
		};
		sum = sum * env * 0.05;
		Out.ar(\out.ar(0), sum);
	}).add;

	s.sync;

	// i = Synth(\iterb, [buffer: ~ricercati[8]]);
	i = Synth(\iterb, [buffer: w[8]]);
}
)

i.set(\buffer, ~ricercati[8])

i.release(30);



Synth('wavering', [freq: 500])

Synth('wavering', [freq: 44.midicps])
Synth('wavering', [freq: 86.midicps])
Synth('wavering', [freq: 81.midicps])

Synth(\fml, [freqA: 1000, freqB: 50, time: 15, atk: 3, rel: 20, amp: 0.3])



~wildsaw = {PanAz.ar(8, CombC.ar(LFSaw.ar(10, 0, 0.1), 0.2, (LFNoise0.kr(30).range(100, 1000)).reciprocal, 0.1), Saw.kr(0.3), 1, 2)}.play;

~wildsaw.release(0);
~wildsaw = {PanAz.ar(2, CombC.ar(LFSaw.ar(10, 0, 0.1), 0.2, 500.reciprocal, 0.1), Saw.ar(0.3), 1, 2)}.play;




t.release(10);

i.release(10);

(
x.release(10);
y.release(10);
z.release(10);
)

~iter2.release(30);

(
r.release(10);
i.release(10);
)

a.release;

k.release(30);


