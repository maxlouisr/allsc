
C.crawl("/Users/maxlouisraugel/Documents/son/randomop/");
(
~elastic = EZConv("/Users/maxlouisraugel/Documents/ /elastic convolution ..wav");
~elasticstroke = EZConv("/Users/maxlouisraugel/Documents/ /elastic stroke ..wav");
~elasticIP = EZConv("/Users/maxlouisraugel/Documents/ /elastic IP ..wav");
~random = EZConv("/Users/maxlouisraugel/Documents/ /zapsplat_cartoon_stretch_pull_elastic_005_40892.wav";)
)

C.p(\rapodom, dur: Pxrand([1, 2, 5], inf), folder: \randomop, index: Pxrand((0..247), inf), rate: Pxrand(Scale.major.semitones.midiratio, inf));

(
SynthDef(\elasticband, {
	var snd, done;
	snd = Trig.ar(Line.kr(0, 1, 0.1), 0.1);
	snd = CombC.ar(snd, 0.2, 1/(\freq.kr(50) * LFNoise2.kr(0.1, 0.01, 1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0)) * 2;
	// snd = SelectX.ar(LFNoise2.kr(7).range(0, 2), [~elastic.ar(snd), ~elasticstroke.ar(snd), ~elasticIP.ar(snd), ~random.ar(snd)]);
	snd = ~elastic.ar(snd);
	// snd = ~elasticIP.ar(snd);
	snd = HPF.ar(snd, \hpf.kr(100));
	// snd = PitchShiftPA.ar(snd, Pitch.kr(snd).lag(0.1), 4, 4) * 0.2;
	DetectSilence.ar(snd, 0.00001, 0.01, doneAction:2);
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;
)

Pbindef(\rhythm, \instrument, \elasticband, \dur, Pseq([0.3, 0.2], inf) * PSinOsc(0.3, 0.1, 0.1, 1), \freq, Pseq([100, 150], inf), \amp, 2, \decaytime, Pseq([Prand([0.05, 1/2], 1), 0.2], inf), \pan, Pn([-1, 1])).play;

Pbindef(\rhythm).stop;

// HAHA
(
~pulses.release;
~pulses = {
	var snd, freq;
	freq = LFPulse.ar([3, 2, 7, 0.1, 0.3, 0.5]).range(100, 150).lag(0);
	snd = VarSaw.ar(Mix.new(freq).poll, 0, 1);
	snd = CombC.ar(snd, 0.2, 1/(Array.fib(7, 10, 50) * LFPulse.kr(3, 0, 0.5, 1, 1)), 1/2, ({rrand(0.03, 0.09)}!7).scramble);
	snd = Splay.ar(snd) * 1/2;
	// snd = snd * 1/10
}.play;
)

(
~pulses.release(1);
~pulses = {
	var snd, freq;
	freq = LFPulse.ar(\bizarre.kr(#[3, 2, 1.2])).range(100, 150).lag(0)/2;
	snd = VarSaw.ar(Mix.new(freq), 0, 1).lag(0.001);
	snd = CombC.ar(snd, 0.2, 1/(Array.fib(7, 10, 50) * LFPulse.kr(3, 0, 0.5, 1, 1)), 1/2, {rrand(0, 0.10)}!7);
	snd = Splay.ar(snd, 1, 1, SinOsc.kr(0.1)/2) * 0.5;
}.play(fadeTime:1);
)

~pulses.set(\bizarre, [1, 0.5, 0.3])

(
~pulses.release(1);
~pulses = {
	var snd, freq, pulse;
	pulse = LFPulse.ar([3, 2, 1.2]);
	freq = pulse.range(100, 150).lag(0);
	snd = VarSaw.ar(Mix.new(freq), 0, 1).lag(0.001);
	snd = CombC.ar(snd, 0.2, 1/(Array.fib(7, 10, 50) * pulse.range(1, 4)), 1/2, {rrand(0, 0.10)}!7);
	snd = Splay.ar(snd, 1, 1, SinOsc.kr(0.1)/2) * 0.5;
}.play(fadeTime:1);
)