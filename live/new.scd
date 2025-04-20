

C.crawl("/Users/maxlouisraugel/Documents/son/violinclose/");
C.crawl("/Users/maxlouisraugel/Documents/son/violinclosemono/");

C.p(\til,0, numChannels: 2, folder: \violinclose, seed: 1234.rand, dur: Pxrand([1, 2, 5, 7, Rest(100), 12]/10, inf), attack: 0, sustain: 0.1, release: 0, index: Pwhite(0, 410), rate: Pxrand(Scale.major.semitones.midiratio, inf) * Prand([0.5, 1, 1.5], inf), pan: Pxrand([-1, 1], inf));



(
C.pp(\til, \dur, Prand([1, 7, Rest(50), 12]/10, inf));
C.pp(\til, \index, Pxrand((30!3)++(32!2)++(37!10), inf));
C.pp(\til, \rate, Pseq([1, 1.2, 1.7, 2.8, 3.9], inf));
C.pp(\til, \folder, \violinclose);
C.pp(\til, \pan, Pxrand([-1, 1], inf));
C.pp(\til, \amp, 0.1);
)

C.s(\til)


~grain = {GrainBuf.ar(2, Dust.kr(1), 0.1, C.get(\violinclosemono, 30), 1, pan: LFPulse.kr(1).range(-1, 1))}.play;

(
Pbindef(\alt, \instrument, \play,
	\dur, Pxrand([1, 7, Rest(100), 12]/10, inf),
	\buffer, Pxrand(C.get(\violinclose, (30!3)++(32!2)++(37!5)++(42!1)++(57!20)), inf),
	\amp, 1,
	\pan, Prand([-1, 1], inf)).play;
)


Pbindef(\alti, \instrument, \play, \buffer, Prand(C.get(\zither, [0, 6]), inf), \dur, Prand([1, 2, 5], inf), \rate, (0).midiratio, \amp, 0.2).play;

Synth(\playfx, [buffer: C.get(\violinclose, 42), rate: 0.midiratio, \freeverb, 0.7, \room, 1, \lpf, 700]);

Pbindef(\alt).clear;

(
Pbindef(\alt, \instrument, \grainbuf,
	\dur, Pxrand((1!10)++(7!3)++Rest(100), inf)/10,
	\buffer, Pxrand(C.get(\violinclosemono, (30!30)++(32!2)++(37!5)++(42!1)++(57!20)), inf),
	\grainDur, 0.1,
	\amp, 1,
	\pan, Prand([-1, 1], inf)
).play;
)






~djembefeedbackloop = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /djembé feedback loop o.wav");


(
~loop = {|gate 1|
	var env, snd;
	env = Env.asr(100, 1, 3).kr(2, gate);
	snd = PlayBuf.ar(2, ~djembefeedbackloop, 1 * BufRateScale.ir(~djembefeedbackloop), 1, 0, 1);
	snd = snd * env;
	}.play;
)

~loop.release(10);

Convenience.crawl

(Convenience.p(\fragments,
	0,
	2,
	'Convenience',
	0,
	// index: Pwhite(0, 200).poll
	index: Pseq([162, /*194,*/ 135, 55, 90, 170, 26, 121, 96, 88, 46, 153, 95, 139, 192, 136, 3, 96, 131, 74, 21], inf).poll,
	dur: PSinOsc(0.3, 0, 1, 1),
	amp: Pkey(\dur).poll / 10
	// dur: Prand([1, 2]*2, inf),
	// stretch: Pseg([1.9, 2, 0.1], [10, 2], 'exp', inf),
	// pos: Prand([0, 1], inf)
))

[162, 194, 135, 55, 90, 170, 26, 121, 96, 88, 46, 153, 95, 139, 192, 136, 3, 96, 131, 74, 21]

(instrument: \sinesaw1, freq: 500/2, amp: 2).play;

(instrument: \sinesaw, freq: 630, amp: 2).play;

(instrument: \sinesaw, freq: 500, amp: 2).play;

(instrument: \sinesaw, freq: 1500, amp: 2).play;
(instrument: \sinesaw, freq: 1400, amp: 2).play;

Convenience.s(\fragments)
~loop.release(3);



~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 500 * 2], 10, 'lin', inf), amp: 2]).play

(
~arp.stop;
~arp2.stop;
~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 1200 *2, 300], [10, 10], 'lin', inf), amp: 2, rel: Pseg([10, 0.1, 10], [10, 10], 'lin', inf)]).play;
~arp2 = Pbind(*[instrument: \percsine, freq: Pseg([500/4, 1200 *2, 300], [10, 10], 'lin', inf), amp: 2]).play;
)

(
~arp.stop;
~arp2.stop;
~kick.stop;
~arp = Pbind(*[instrument: \sinesaw, freq: Pseg([500/4, 1200 *2, 300], [10, 10], 'lin', inf), amp: 1, rel: Pseg([10, 0.1, 10], [10, 10], 'lin', inf)]).play;
~arp2 = Pbind(*[instrument: \percsine, freq: Pseg([500/4, 1200 *2, 300], [10, 10], 'lin', inf), amp: 1]).play;
~kick = Pbind(*[instrument: "kick", dur: Pseq((5!2)++(0.3!5), inf), freq: 50, amp: 1/2]).play;
)


