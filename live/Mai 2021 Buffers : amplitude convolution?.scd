

a = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /soft wind.wav")

b = Buffer.read(s, "/Users/maxlouisraugel/Desktop/wood creak.wav");

c = Buffer.read(s, "/Users/maxlouisraugel/Desktop/smartsound_ATMO_NATURE_Underground_Cave.wav")

d = Buffer.read(s,"/Users/maxlouisraugel/Documents/ /click right.wav" )

e = Buffer.read(s,"/Users/maxlouisraugel/Desktop/zapsplat_human_male_voice_pirate_shiver_me_timbers_002_19884.wav");

(
{var snd, trig;
	trig = Dust.kr(0.5);
	snd = SinOsc.ar({TRand.kr(100, 5000, trig)}!5, 0, 0.1) * PlayBuf.ar(2, b, BufRateScale.ir(b) * 1, trig) * 5;
	snd = Splay.ar(snd);
}.play;
)

(
{var snd, trig;
	trig = Dust.kr(0.1);
	snd = SinOsc.ar({TRand.kr(100, 5000, trig)}!3, 0, 0.1) * PlayBuf.ar(2, d, BufRateScale.ir(d) * 1, trig) * 5;
	snd = Splay.ar(snd);
}.play;
)


{PlayBuf.ar(2, a, 1, loop:0) * PlayBuf.ar(2, b, 1, loop:0) * 10}.play;

(
{
	var trig, snd;
	trig = {Dust.kr(1)};
	snd = PlayBuf.ar(1, a, 1, trig) * PlayBuf.ar(1, b, 1, trig) * 10;
	snd = PanAz.ar(s.options.numOutputBusChannels, snd, LFNoise2.kr(0.5));
}.play;
)


(
x = {
	var sound, env;
	env = Env([1, 1, 0], [BufDur.ir(c)/1.3 - 10, 10], 'lin').kr(2);
	sound = PlayBuf.ar(2, c, Line.kr(0.1, 2, BufDur.ir(c) / 1.3, doneAction:2), loop:0);
	sound = sound * env;

}.play;

)

x.free;