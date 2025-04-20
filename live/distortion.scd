(
~dis = Ndef(\dis, {
	var snd, env;
	snd = SinOsc.ar(\freq.kr(100), 0, 0.1);
	snd = CrossoverDistortion.ar(snd, 0.01, 0.1);
	snd = Pan2.ar(snd, \pan.kr(0));
}).mold(2).play;
)

(

SynthDef(\dis, {
	var snd, env;
	snd = SinOsc.ar(\freq.kr(100), 0, 0.1);
	snd = CrossoverDistortion.ar(snd, 0.01, 0.1);
	snd = Pan2.ar(snd, \pan.kr(0));
}).mold(2).play;

)

~dis.clear;