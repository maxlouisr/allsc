pou
Ndef.clear;

NdefMixer(s)

Server.killAll;

MasterEQ.new;

Convenience.crawl;

// cagnar, buffers2, buffers3

SuperDirt.start;

~dirt.free;




// TARTINI

Ndef.clear;
~tartini.clear;
~tartini = Ndef(\tartini, {Tartini.kr(SoundIn.ar(0)).poll});
~tartini.play;
~tartini.pause;
~tartini.resume;








Convenience.p(\cagnarfolder, folder: \cagnar, index: Pwhite(0, 101), pos: Pwhite(0, 1.0), dur: Pwhite(1, 5)*10, release: Pkey(\dur), amp: 0.3);

Convenience.s(\cagnarfolder, 10);

Convenience.p(\buffers3, folder: \buffers3, index: Pwhite(0, 200), dur: Prand([5, 12], inf))

Convenience.s(\cagnarfolder);
Convenience.s(\buffers3, 5);




------------------




// transitions:

~brown = Ndef(\brownnoise, {BrownNoise.ar(0.1/2)!2}).fadeTime_(30);

~brown.play(fadeTime: 50);
~brown.stop(30);

(
~click1 = Ndef(\click1, {
	var snd;
	snd =
	Compander.ar({
		SinOsc.ar(
			845.345,
			mul:0.1,
		add: 0)
		/
		LFSaw.ar(
			35279.9 + LFNoise2.kr(0.1, 0.1),
			0,
			0.4,
			0.4
	)}, 0, 0.1, mul: 0.1);
	snd = PanAz.ar(2, snd, LFNoise2.kr(1).range(0, 2), 0.01);
	// snd = PitchShift.ar(snd, 0.01, 0.25);
	// snd = Compander.ar(snd); snd = MiVerb.ar(snd, 0.7, 0.1, 0.9, mul: 5);
	// snd = GVerb.ar(Limiter.ar(snd), LFNoise2.kr(1, 1, 2), 1); snd = Limiter.ar(HPF.ar(snd));

	// snd = snd.blend(JPverb.ar(LPF.ar(snd)), 0.5);
}).fadeTime_(1).play;
)

(
~click1.stop(0);
~click2.stop(0);
)

(
~click2 = Ndef(\click2, {
	var snd;
	snd =
	Splay.ar({
		SinOsc.ar(
		2634.69 + LFNoise2.kr(0.1, 100, 100),
			mul:0.1,
			add: 0)
	/
		LFSaw.ar(
		44099 + LFNoise2.kr(1, 1, 0),
			0,
			1,
			0.4
)},
1,
0.001);
	snd = RLPF.ar(snd, LFNoise2.kr(0.3).exprange(3000, 5000), 0.1);
	snd = FreeVerb.ar(snd, 1/2, 0.01, 0.9);
})
)

~click2.play(fadeTime: 0);
~click2.fadeTime_(10);
~click2.stop(0);

(
{
	10.do{
		|i| C.get(\bassdrums, i+10).play; Synth(\percsine, [freq: exprand(20, 20000), amp: 0.1]); (i/5).wait;
		}
}.fork
)



Synth(\percsine, [freq: 273 * 2, amp: 1/4, pan: -1, atk: 1/10, rel: 1/10])



~brown.play(fadeTime:30)
~brown.stop(10)



------------------------




Ndef(\iterationsvoix, {PlayBuf.ar(2, ~iterationsvoix)}).play(fadeTime: 30)

~threekicks = Pbind(\instrument, \kick, \freq, 50, \dur, Pseq(0.3!3, 1), \amp, 1.7);

~threekicks.play;


Pbind(\instrument, \kick, \freq, Pseq([50, 50, 100] /*+ 10*/, inf), \dur, Pseq(0.3!3, 1), \amp, 1.5).play;
Pbind(\instrument, \kick, \freq, Pseq([100, 50, 50], inf), \dur, Pseq(0.3!3, 1), \amp, 1.5).play;
Pbind(\instrument, \kick, \freq, Prand([100, 50], inf), \dur, Pseq(0.3!3, 1), \amp, 1.5).play;



Ndef(\ourvoices).clear(30);
Ndef(\ourvoices, {|loop 0 rate 1 amp 1.8| var snd = PlayBuf.ar(2, ~ourvoices, 1 * BufRateScale.ir(~ourvoices), 1, 0.9 * BufFrames.kr(~ourvoices), loop) * amp; snd = HPF.ar(snd, 200)}).play(fadeTime:30)

// EQ take out some bass


Ndef(\ground, {PlayBuf.ar(2, ~ground, 1 * BufRateScale.ir(~ground), 1, 0.3 * BufFrames.ir(~ground))}).play(vol: 1/2);
Ndef(\ground).stop(0);


// after voice is feminine:
Ndef(\iterationsvoix).clear(30)


C.crawl("/Users/maxlouisraugel/Documents/son/buffers2/")

Convenience.p(\buffers2, folder: \buffers2, index: Pwhite(0, 10).poll, dur: Prand([0.5, 1, 7], inf), attack:0, release: 0.1, amp: 0.3);


Convenience.s(\buffers2);


Ndef(\harmonies, {PlayBuf.ar(2, ~harmonies, 1 * BufRateScale.ir(~harmonies), 1, 0 * BufFrames.ir(~harmonies), doneAction: 2)}).play;

Ndef(\harmonies).clear(5);

Ndef(\harmonies, {PlayBuf.ar(2, ~harmonies, 1 * BufRateScale.ir(~harmonies), 1, 0.088 * BufFrames.ir(~harmonies), doneAction: 2)}).play;

Ndef(\harmonies).clear(5);

Ndef(\ourvoices).stop(0);

Ndef(\harmonies, {PlayBuf.ar(2, ~harmonies, 1 * BufRateScale.ir(~harmonies), 1, 0 * BufFrames.ir(~harmonies), doneAction: 2)}).play;


~sinesaw = Synth(\sinesaw, [freq: 66, atk: 10])
// ~sinesaw.set(\freq, 66)
~sinesaw.set(\freq, 69);
~sinesaw.release(10);



Ndef(\setting, {PlayBuf.ar(2, ~setting, 1 * BufRateScale.ir(~setting), doneAction: 2)}).play;

Ndef(\setting).play;


// after first whole 'cycle'

Ndef(\jevaistefrapper, {|amp 0.7| var buf = ~jevaistefrapper; var snd= PlayBuf.ar(2, buf, 1 * BufRateScale.ir(buf)) * amp; snd = HPF.ar(snd, 200);}).play;



Ndef(\fire, {|amp 3| var snd = PlayBuf.ar(2, ~fire, 1 * BufRateScale.ir(~fire)) * amp; snd = HPF.ar(snd, 200)}).play(fadeTime:30);


Ndef(\ici, {|rate 1| PlayBuf.ar(2, ~ici, rate * BufRateScale.ir(~ici))}).play;


~fan = Ndef(\play).copy(\fan);

~fan.set(\buffer, ~fanclose, \rate, 0.3, \loop, 1).play(fadeTime: 30)

~fan.set(\rate, 0.3)

~fan.stop(30);



Synth(\poom, [freq: 55 * 4, atk: 1, rel: 5, amp: 0.2]);
Synth(\sinesaw1, [freq: 55 * 4, atk: 3, rel: 7, amp: 1.2]);

Ndef(\ici).lag(\rate, 10);
Ndef(\ici).set(\rate, 1);


// nocturne

(
var fade = 0; ~wind.release(fade);
~wind = {
	|atk 60 rel 60|
	var sound;
	sound = WhiteNoise.ar(0.1!2);
	sound = LPF.ar(sound, LFNoise2.kr(0.3).range(500, 1000));
	sound = sound;
}.play(fadeTime: fade);
)


Ndef(\fire).stop(30);



Ndef(\electricite, {var snd; snd = PlayBuf.ar(2, ~electricite, 1 * BufRateScale.ir(~electricite), 1, 0, 1); snd = Mix(snd); snd = Mono(snd); snd = Pan2.ar(snd, LFNoise2.kr(\panspeed.kr(2)))});

Ndef(\electricite).play(vol: 1/2, fadeTime: 10);

Ndef(\electricite).clear(1);

Ndef(\ici).stop(fadeTime: 30);





Ndef(\saggingdirtholes, {|amp 1| PlayBuf.ar(2, ~saggingdirtholes, 1 * BufRateScale.ir(~saggingdirtholes), 1, 0, loop:1) * amp}).send.play(vol: 1/5, fadeTime: 30);
Ndef(\saggingdirtholes).clear(30);





Ndef(\brutobstruction, {|rate 1 amp 0.7| PlayBuf.ar(2, ~brutobstruction, rate * BufRateScale.ir(~brutobstruction)) * amp}).play(fadeTime: 30);

Ndef(\brutobstruction).stop;

Synth("kick", [freq: 76, amp: 2, rel: 0.9]);



/*(
~saws.free;
~saws = {
	arg gate =1, freq = rrand(20, 1000);
	Splay.ar(
		{
			Saw.ar(
				freq + LFNoise2.kr(0.1).range(0, 1000),
				mul:Env.asr(30, 1, 30).kr(2, gate)
		)}!10
)}.play;
)

~saws.release;*/


Ndef(\brutobstruction).clear(30);


// HORIZON

Ndef(\horizon, {|amp 1.7| PlayBuf.ar(2, ~horizon, 1 * BufRateScale.ir(~horizon), 1, 0) * amp}).play;

Ndef(\horizon).stop;




Ndef(\sc2, {|rate 1| var snd = PlayBuf.ar(2, ~sc2, rate * BufRateScale.ir(~sc2)); snd = HPF.ar(snd, 150)}).play(fadeTime:5);
Ndef(\sc2).stop(20);



Synth(\fml, [\freqA, 20, \freqB, 6432*1, \time, 0.1, \pan, rrand(-1, 1.0), \rel, 5, \amp, 0.2])

Synth(\fml, [\freqA, 20, \freqB, 6432*1.5, \time, 0.1, \pan, rrand(-1, 1.0), \rel, 5, \amp, 0.2]);

Synth(\fml, [\freqA, 20, \freqB, 6432*1.3, \time, 0.1, \pan, rrand(-1, 1.0), \rel, 5, \amp, 0.2])

Synth(\fml, [\freqA, 20, \freqB, 6432*1.2, \time, 0.1, \pan, rrand(-1, 1.0), \rel, 5, \amp, 0.2])


// second part etirements 1, 1.5, 1.2


Synth(\fml, [\freqA, 20, \freqB, rrand(3000, 7000).postln, \time, 0.1, \pan, rrand(-1, 1.0), \amp, 0.1]);

// after stop take EQ Mid/low down and over all volume up




// ETIREMENTS

Ndef(\etirements2, {|rate 1 amp 1.5| PlayBuf.ar(2, ~etirements, rate * BufRateScale.ir(~etirements), doneAction:2) * amp}).play;

Ndef(\etirements2).stop;


// Ndef(\sc1, {|rate 1| PlayBuf.ar(2, ~sc1, rate * BufRateScale.ir(~sc1))}).play;
// Ndef(\sc1).stop;

/*Ndef(\sc3, {|rate 1| PlayBuf.ar(2, ~sc3, rate * BufRateScale.ir(~sc3))}).play;
Ndef(\sc3).stop;*/


// Ndef(\vibrationgrave, {|amp 3| PlayBuf.ar(2, ~vibrationgrave, 0.62 * BufRateScale.ir(~vibrationgrave) loop: 1) * amp}).play(fadeTime: 0);
// Ndef(\vibrationgrave).stop(0);


Ndef(\etirements2).clear(0);


/*
Ndef(\rejets, {PlayBuf.ar(2, ~rejets, 1 * BufRateScale.ir(~rejets))}).play;

Ndef(\rejets).stop;*/


// ?







Ndef(\geometriezither, {PlayBuf.ar(2, ~geometriezither, 1 * BufRateScale.ir(~geometriezither), 0)}).play;

Ndef(\geometriezither).clear;


Ndef(\distortionsaida, {PlayBuf.ar(2, ~distortionsaida, 1 * BufRateScale.ir(~distortionsaida, 0))}).play;

Ndef(\distortionsaida).stop;









Ndef(\vibrationgrave, {|amp 1.5| PlayBuf.ar(2, ~vibrationgrave, 1 * BufRateScale.ir(~vibrationgrave) loop: 1) * amp}).play(fadeTime: 10);

Ndef(\vibrationgrave).set(\amp, 1)

Ndef(\vibrationgrave).fadeTime_(10);

Ndef(\vibrationgrave)[10] = \filter -> {|in| FreeVerb2.ar(in[0], in[1], 0.7, 1)}
Ndef(\vibrationgrave)[10] = nil;

Ndef(\vibrationgrave).clear(30);


// 7, 8


Ndef(\bleu, {PlayBuf.ar(2, ~bleu, 1 * BufRateScale.ir(~bleu))}).play;

Ndef(\bleu).stop(0);



Ndef(\ciel, {PlayBuf.ar(2, ~ciel, 1 * BufRateScale.ir(~ciel))}).play(fadeTime: 10);

// Ndef(\ciel).clear;


/*~noise = {|freq 10000 amp 0.1 atk 30 rel 30 gate 1| LFNoise0.ar(freq, Env.asr(atk, amp, rel).kr(2, gate))!2};

~noiseP = ~noise.play;

~noiseP.set(\freq, 250)

~noiseP.release;*/

Ndef(\aidaheadphoneopera, {PlayBuf.ar(2, ~aidaheadphoneopera, 1 * BufRateScale.ir(~aidaheadphoneopera), 1, 0.5 * BufFrames.ir(~aidaheadphoneopera))}).play;

// 0, 0.5 at second bass section before chorus

Ndef(\aidaheadphoneopera).stop;




Ndef(\joyeuxanniversaire, {PlayBuf.ar(2, ~joyeuxanniversaire, 1 * BufRateScale.ir(~joyeuxanniversaire))}).play(fadeTime: 10);

Ndef(\joyeuxanniversaire).stop(10);


Ndef(\marinero, {PlayBuf.ar(2, ~marinero, 1 * BufRateScale.ir(~marinero))}).play(fadeTime:1);

Ndef(\marinero).stop;


~wind.release(3)






Ndef(\matiereparticulaire, {PlayBuf.ar(2, ~matiereparticulaire, 1 * BufRateScale.ir(~matiereparticulaire))}).play(fadeTime: 30)

Ndef(\matiereparticulaire).stop(30);



// 5


Ndef(\effusions3, {|t_trig = 0| PlayBuf.ar(2, ~effusions3, 1 * BufRateScale.ir(~effusions3), t_trig, 0.1 * BufRateScale.ir(~effusions3))}).play(fadeTime: 1);

Ndef(\effusions3).stop(15);



Ndef(\effusions3).clear(0);



Ndef(\dramaticwine, {PlayBuf.ar(2, ~dramaticwine, 1 * BufRateScale.ir(~dramaticwine)) * 0.8}).play;


// PURPLE DUSK

Ndef(\purpledusk, {|t_trig = 0| PlayBuf.ar(2, ~purpledusk, 1 * BufRateScale.ir(~purpledusk), t_trig)}).play;

Ndef(\purpledusk).stop;




Ndef(\ground, {PlayBuf.ar(2, ~ground, 1 * BufRateScale.ir(~ground))}).play;


Ndef(\ondesnuit, {|loop 1 rate 1 amp 0.5| PlayBuf.ar(2, ~ondesnuit, rate, 1 * BufRateScale.ir(~ondesnuit), 0, loop) * amp}).play(fadeTime: 30)

Ndef(\ground).stop(10)

Ndef(\ondesnuit).stop(3);












Ndef(\closetexture).clear;


Ndef(\play).copy(\closetexture).set(\buffer, ~closetexture, \loop, 1);
Ndef(\closetexture).fadeTime_(10).play;

Ndef(\closetexture)[10] = \filter -> {|in| Resonator.ar(in, 1000 * {LFNoise2.ar(0.3, 0.1, 1)}, structure: 0.5, brightness: 0.3, damping: 0.4)/5};

Ndef(\closetexture)[10] = \filter -> {|in| Resonator.ar(in, [1000, 1200] * {LFNoise2.ar(0.3, 0.1, 1)}!2, structure: 0.5, brightness: 0.3, damping: 0.4)/5};

Ndef(\closetexture)[20] = \filter -> {|in| FreeVerb2.ar(in[0], in[1], 1/5, 1)}


Ndef(\closetexture)[20] = nil;

Ndef(\closetexture)[10] = \filter -> {|in| var snd; snd = Resonator.ar(in, Scale.mixolydian.cents + 500 * LFNoise2.kr(0.3!10, 0.1, 1), structure: 0.5, brightness: 0.3, damping: 0.4)/2; snd = Splay.ar(snd); snd = Balance2.ar(snd[0], snd[1], 0.2)};


Ndef(\closetexture)[30] = \filter -> {|in| BPeakEQ.ar(in, LFNoise2.kr(0.7).exprange(50, 2000), 1, 9)}





// attempt at envelope following:
\filter -> {|in| BPeakEQ.ar(in, EnvFollow.ar(in[0]).linexp(0, 0.1, 50, 20000).lag(1), 1, 12)}










Ndef(\pygmee, {|amp 1.2 rate 1| PlayBuf.ar(2, ~pygmee, rate * BufRateScale.ir(~pygmee)) * amp}).play(fadeTime: 30);

Ndef(\pygmee).stop(30);

// Ndef(\cygne, {PlayBuf.ar(2, ~cygne, 1 * BufRateScale.ir(~cygne))}).play;

(
Ndef(\gentle008, {|trig 0 rate 1 start 0 loop 1 amp 1| PlayBuf.ar(2, ~gentle008, rate * BufRateScale.ir(~gentle008), trig, start * BufFrames.ir(~gentle008), loop) * amp}).play(fadeTime: 10);
)

Ndef(\gentle008).stop;

// Ndef(\gentle008).lag(\rate, 100);

Ndef(\gentle008).xset(\rate, 0.5, \amp, 2);

Ndef(\gentle008).stop(100);

Ndef(\pygmee).clear(100);













Ndef(\eternal, {|trig 1 rate 1 start 0 loop 1 amp 1 lag 1| PlayBuf.ar(2, ~eternal, rate * BufRateScale.ir(~eternal), trig, start * BufFrames.ir(~eternal), loop) * amp}).play(fadeTime: 100)

Ndef(\eternal).lag(\rate, 30);
Ndef(\eternal).set(\rate, 0.5);

Ndef(\ondesnuit).stop(30);

Ndef(\ourvoices).stop(30);

Ndef(\eternal2, {|trig 1 rate 1 start 0 loop 1 amp 1 lag 1| PlayBuf.ar(2, ~eternal, rate * BufRateScale.ir(~eternal), trig, start * BufFrames.ir(~eternal), loop) * amp}).lag(\rate, 30);

Ndef(\eternal2).fadeTime = 15
Ndef(\eternal2).set(\rate, 1.7)
Ndef(\eternal2).play(fadeTime: 10);

(
Ndef(\eternal).stop(30);
Ndef(\eternal2).stop(30);
Ndef(\eternal3).stop(30);
)













Ndef(\cagnar, {PlayBuf.ar(2, ~cagnar, 1 * BufRateScale.ir(~cagnar), loop: 1)}).play(fadeTime:30);



Convenience.p(\buffers3, folder: \buffers3, index: Pwhite(0, 200), dur: Prand([1, 7], inf), attack:0, release: 0.1, amp: 0.2);

Convenience.p(\buffers2, folder: \buffers2, index: Pwhite(0, 200), dur: Prand([1, 7], inf), attack:0, release: 0.1, amp: 0.2);

Convenience.s(\buffers2).stop(15);

Convenience.s(\buffers3).stop(15);





(
Ndef(\howmuch, {PlayBuf.ar(2, ~howmuch, 1 * BufRateScale.ir(~howmuch), 0)}).play;
Ndef(\howmuch).clear(5);
)

Ndef(\cagnar).stop(fadeTime: 7);


Ndef(\howmuch, {PlayBuf.ar(2, ~howmuch, 1 * BufRateScale.ir(~howmuch), 0)}).play;


Ndef(\howmuch);



Ndef(\multidrums, {|rate 1 start 0 loop 0 amp 0.5| PlayBuf.ar(2, ~multidrums, rate * BufRateScale.ir(~multidrums), 0, start * BufFrames.ir(~multidrums), loop) * amp}).play;

Ndef(\multidrums).stop(0);














Ndef(\notimedraft, {|amp 1| PlayBuf.ar(2, ~notimedraft, 1 * BufRateScale.ir(~notimedraft), doneAction: 2) * amp}).play;

Ndef(\kindsof, {PlayBuf.ar(2, ~kindsof, 1 * BufRateScale.ir(~kindsof))}).play;

Ndef(\notimedraft).set(\amp, 0);

(
// Ndef(\kindsof).stop;
Ndef(\notimedraft).set(\amp, 1)
)

Ndef(\kindsof).stop(3);



// Ndef(\funny, {|trig 0 rate 1 start 0 loop 1 amp 1| PlayBuf.ar(2, ~funny, rate * BufRateScale.ir(~funny), trig, start * BufFrames.ir(~funny), loop) * amp}).fadeTime_(0).play;



// Ndef(\funny).stop(0);

Ndef(\kindsof).stop(5);

Ndef(\glitches).stop;

































(
~comb.release(10);
~comb = {
	|gate = 1, freq = 200, detune = 0, lag = 0, mix = 0, width = 0.3, amp = 0.5, reverbmix = 0|

	var sound, env, comb;

	env = Env.asr(3, 1, 3).kr(2, gate);
	sound = WhiteNoise.ar(0.03);
	sound = sound * env;
	// width = SinOsc.kr(1).unipolar;
	sound = PanAz.ar(s.options.numOutputBusChannels, sound, LFNoise2.kr(10), 1, width);
	// sound = Balance2.ar(sound, sound, LFNoise2.kr(1))
	comb = CombC.ar(sound, 0.2, 1/(freq + LFNoise2.kr(1, detune)).lag(lag), 1, 0.5);
	sound = XFade2.ar(sound, comb, mix * 2 - 1) * amp;
	// sound = FreeVerb.ar(sound, reverbmix);
}.play(fadeTime:20);
)

~comb.set(\freq, {Array.makeScaleCps(300, 'major', 100, 10000).choose}!10, \mix, 0.5);

------------

// ZONE


~zone = Pbind(\instrument, \sinesaw, \freq, Pseg([200, 300, 800, 300, 200], [3, 8, 8, 3], repeats:inf), \amp, 1).play;
~zone.stop;

(
~bass = {
	loop{
		~pm = play{|gate 1| PMOsc.ar(50!2, 50, 1, 0, Env.asr(10, 0.1, 10).kr(2, gate))};
		7.wait;
		~pm.release;
		15.wait;
	}
}.fork;
)

~jpverb100 = Synth(\jpverb, addAction: 'addToTail');

~attention = Pmono(\sinesaw, \dur, 0.1, \freq, Pseg([200, 300, 800, 300, 200], [3, 8, 8, 3], repeats:inf), \sawmul, Pseq([0.001, 0.1], inf), \stretch, Pseg([1, 3, 2, 3, 1, 2], [3, 2, 1, 3, 1], 'lin', inf), \out, 100).play;
~attention.stop;

d.stop;

~golden = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /golden stress.aiff");

play{var snd = PlayBuf.ar(2, ~golden, 1.cpsmidi.midiratio + [12, 50]) * Env([0.4, 0], [5]).kr(2); snd = Out.ar(100, snd)};


~bass.stop;





















(
~loop = {|gate 1|
	var env, snd;
	env = Env.asr(100, 1, 3).kr(2, gate);
	snd = PlayBuf.ar(2, ~djembefeedbackloop, 1 * BufRateScale.ir(~djembefeedbackloop), 1, 0, 1);
	snd = snd * env;
	}.play;
)

~loop.free;

C.crawl("/Users/maxlouisraugel/Documents/son/buffers3/");

(
Convenience.p(\fragments,
	0,
	2,
	'Convenience',
	0,
	\buffers3,
	// index: Pwhite(0, 200).poll
	index: Pseq([162, /*194,*/ 135, 55, 90, 170, 26, 121, 96, 88, 46, 153, 95, 139, 192, 136, 3, 96, 131, 74, 21], inf).poll,
	dur: PSinOsc(0.3, 0, 1, 1),
	amp: Pkey(\dur).poll / 10
	// dur: Prand([1, 2]*2, inf),
	// stretch: Pseg([1.9, 2, 0.1], [10, 2], 'exp', inf),
	// pos: Prand([0, 1], inf)
)
);



[162, 194, 135, 55, 90, 170, 26, 121, 96, 88, 46, 153, 95, 139, 192, 136, 3, 96, 131, 74, 21]

(instrument: \sinesaw, freq: 500/2, amp: 2).play;

(instrument: \sinesaw, freq: 630, amp: 2).play;

(instrument: \sinesaw, freq: 500, amp: 2).play;

(instrument: \sinesaw, freq: 1500, amp: 2).play;
(instrument: \sinesaw, freq: 1400, amp: 2).play;

Convenience.s(\fragments, 30)
~loop.release(10);




(
var freqs = [800, 200, 7000, 1000];
~arp.stop;
~arp2.stop;
~arp = Pbind(*[instrument: \sinesaw, freq: Pseg(freqs, [10, 10, 1], 'lin', inf), amp: 1, rel: Pseg([10, 1, 10], [10, 10], 'lin', inf)]).play;
~arp2 = Pbind(*[instrument: \percsine, freq: Pseg(freqs, [10, 10, 1], 'lin', inf), amp: 1/2]).play;
)




Ndef(\miracle, {PlayBuf.ar(2, ~miracle, 1 * BufRateScale.ir(~miracle))}).play;
Ndef(\miracle).stop;


Ndef(\rejets, {PlayBuf.ar(2, ~rejets, 1 * BufRateScale.ir(~rejets), 1, 0 * BufFrames.kr(~rejets), doneAction:2)});
Ndef(\rejets).vol_(0.5).play(fadeTime: 1);
Ndef(\rejets).stop(1);


Ndef.clear(30);


~partialsbass = Synth(\partialsbass, [freq: 200, atk: 1, rel: 10, amp: 1]);
~partialbass.free



Ndef(\absurdes, {PlayBuf.ar(2, ~absurdes, 1 * BufRateScale.ir(~absurdes))}).play(fadeTime: 0);

Ndef('absurdes').stop;


Synth(\percsine, [freq: 110, atk: 3, rel: 5]);
Synth(\percsine, [freq: 110/2, atk: 3, rel: 5]);

NdefMixer(s)

Ndef(\absurdes).fadeTime=10;

Ndef(\absurdes)[10] = \filter-> {|in| in * SinOsc.ar(5).abs}

Ndef(\absurdes)[10] = nil;


