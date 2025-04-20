
(
		o = Array.new;
		~folder = PathName("/Users/maxlouisraugel/Documents/son/SONS/ /");

		~folder.entries.do({
			arg path;
			o = o.add(Buffer.read(s, path.fullPath));
		})
	);


Pbindef(\o, \instrument, \playAz, \buffer, Pxrand(1300.collect{|i| o[i]}, inf).poll, \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf)*1, \rate, Pxrand(Array.fib(5, 0.002, 0.5), inf), \amp, 1, \pan, Pwhite(0, 5.0)).play;

Pbindef(\o, \instrument, \play, \buffer, Pshuf({o.choose}!10, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf)/3, \rate, Pxrand(Array.fib(10, 0.002, 0.5), inf), \amp, 1).play;


// RANDOMNESS
Pbindef(\rand, \instrument, \play, \buffer, Pshuf(1300.collect{|i| o[i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 1, \rate, Pxrand([0.5, 1, 1.2], inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

// NESTED RANDOMNESS LOOP
(
var num = 3; Pbindef(\o, \instrument, \play, \buffer, Pshuf({o.choose}!num, inf), \dur, Pshuf({rrand(1/3, 3.0)}!num, inf), \rate, Pshuf({[1, 1.2, 2].choose}!num, inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

// Synth(\play, [buffer: o.choose]);
)

---------------


(
// UPDATING BOTH SIMULTANEOUSLY
~untitled.stop;
~untitled = Routine.run{{

	var num = 3;
	var pattern = ({rrand(1/3, 3.0)}!num);
	var duration = pattern.sum;


	// RANDOMNESS
	Pbindef(\rand, \instrument, \play, \buffer, Pshuf(1300.collect{|i| o[i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 4, \rate, Pxrand([0.5, 1, 1.2], inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

	// NESTED RANDOMNESS LOOP
	Pbindef(\o, \instrument, \play, \buffer, Pshuf({o.choose}!num, inf), \dur, Pshuf(pattern, inf), \rate, Pshuf({[1, 1.2, 2].choose}!num, inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

	(duration * 8).wait;

}.loop

}
)



// TWO LOOPS

(
var num = 3;

Pbindef(\o1, \instrument, \play, \buffer, Pshuf({o.choose}!num, inf), \dur, Pshuf({rrand(1/3, 3.0)}!num, inf), \rate, Pshuf({[1, 1.2, 2].choose}!num, inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;

Pbindef(\o2, \instrument, \play, \buffer, Pshuf({o.choose}!num, inf), \dur, Pshuf({rrand(1/3, 3.0)}!num, inf) * 2, \rate, Pshuf({[1, 1.2, 2].choose}!num, inf), \amp, 1, \pan, Pwhite(-1, 1.0)).play;
)



-------------------------- MULTI-------------------------

-- fibonacci rates

Pbindef(\o, \instrument, \playAz, \buffer, Pxrand(1300.collect{|i| o[i]}, inf).poll, \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf)*1, \rate, Pxrand(Array.fib(5, 0.002, 0.5), inf), \amp, 1, \pan, Pwhite(0, 5.0)).play;

-- simple rates

Pbindef(\rand, \instrument, \playAz, \buffer, Pshuf(1300.collect{|i| o[i]}, inf), \dur, Pxrand([2, 3, 5, 1/2, 1/5], inf) * 1, \rate, Pxrand([0.5, 1, 1.2], inf), \amp, 1, \pan, Pwhite(0, 5.0)).play;

(
var num = 3; Pbindef(\o, \instrument, \playAz, \buffer, Pshuf({o.choose}!num, inf), \dur, Pshuf({rrand(1/3, 3.0)}!num, inf), \rate, Pshuf({[1, 1.2, 2].choose}!num, inf), \amp, 1, \pan, Pwhite(0, 5.0)).play;
)


// WEAVING LONG FILES



(
		o = Array.new;
		~folder = PathName("/Users/maxlouisraugel/Desktop/longalias/");

		~folder.entries.do({
			arg path;
			o = o.add(Buffer.read(s, path.fullPath));
		})
	);


(
Ndef(\a, {var snd;
	snd = PlayBuf.ar(2, o.choose, LFNoise2.kr(0.3, \detune.kr(0.5), \pitch.kr(1)), \trig.kr(1), loop:\loop.kr(1));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(0.3));
}).play;
Ndef(\b, {var snd;
	snd = PlayBuf.ar(2, o.choose, LFNoise2.kr(0.3, \detune.kr(0.5), \pitch.kr(1)), 1, loop:\loop.kr(1));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(0.3));
}).play;
Ndef(\c, {var snd;
	snd = PlayBuf.ar(2, o.choose, LFNoise2.kr(0.3, \detune.kr(0.5), \pitch.kr(1)), 1, loop:\loop.kr(1));
	snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(0.3));
}).play;

Ndef(\a).set(\detune, 0.9, \pitch, 0.2); Ndef(\b).set(\detune, 0.5, \pitch, 0.6); Ndef(\c).set(\detune, 0.1, \pitch, 0.2);
)


(
Ndef(\a).set(\loop, 0, \trig, 1);Ndef(\b).set(\loop, 0, \trig, 1);Ndef(\c).set(\loop, 0, \trig, 1);
)




//
// (
// var num = 3;
// var rytm = {rrand(1/3, 3.0)}!num;
// var buf = {o.choose}!num;
// Ndef(\o, {var trig, snd;
// 	trig = Impulse.kr(Env([0, 1, 0], rytm).kr(0));
// 	snd = PlayBuf.ar(2, Demand.kr(trig, 0, Dseq(buf, inf)));
// }).play;
// )

