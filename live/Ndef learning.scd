

C.p(\smallinstruments, 0, folder: Pseq([0, 1, 3, 2, 4, 5], inf).poll, index: 1, rate: Pseq([[0.5, 1, 0.25]], inf), dur: Pseq([1, 2, 2, 1, 2], inf), quant: 4);

C.s(\smallinstruments);

(
~kick = PbindProxy(\instrument, \kick, \freq, 50, \amp, 1, \dur, Pseq([0.2, 0.5, 0.3, Rest(3)], inf));
~kick.quant = 4;
~kick.play;
)

C.pp(\smallinstruments, 'folder', 5);

C.p(\smallinstruments, 0, folder: 5, index: 1, tuningOnOff: 1, degree: Pseq((0..12), inf) + 12, octave: Pn([3, 5], inf), scale: Scale.shawqAfza, dur: Pseq([1, 2, 2, 1, 2], inf) / 5, quant: 4);

Scale.directory;

C.pfx(\smallinstruments, \spectraldelay, \tsdelay, 1)

C.fxargs(\spectraldelay)
C.fxs

(
C.p(\grain, 0, 2, folder: 3, index: 1, dur: 0.1, attack: 0, release:0.01, sustain: 0.01, tuningOnOff:1, degree: Prand((0..24), inf), scale: Scale.iwato, amp: 0.5, stretch: Pseg([0.5, 2, 0.5], [5, 5], 'lin', inf));
C.fade(\grain, 10);
)

C.s(\grain)

C.pp(\grain, \bus, ~jpverbbus);

C.pp(\grain, \folder, 1)


x = {SinOsc.ar(270, 0, 0.1)}.play(fadeTime: 10)


(
C.p(\test1, 0, folder: 5, index: 1, dur: 0.1, rate: Prand((0..10)/10, inf));
C.repeat(\test1, 10, 30);
)








(
Ndef(\sineliteral, {var snd; snd = SinOsc.ar(\freq.kr(#[100, 100, 100]) * LFNoise2.ar(0.3, 0.02, 1), 0, \amp.kr(0.3));
	snd = Splay.ar(snd);
})
)



Ndef(\pluck, \pluck)

(
Ndef('pluck').set(\freq, 175);

Ndef(\pluck).play.send;
)





/*
Ndef(\withzone, \playbuf).set(\buffer, ~withzone, \loop, 1, \amp, 0.3);

Ndef(\withzone).play(fadeTime: 30);

Ndef(\withzone).stop(fadeTime: 30);*/

(
Ndef(\zone).stop(10);
Ndef(\withzone).stop(10);
)





(
(
Ndef(\play, {|rate 1 pos 0 pan 0.5|
	var snd = PlayBuf.ar(2, \buffer.kr, rate * BufRateScale.ir(\buffer.kr), 1, pos * BufFrames.ir(\buffer.kr), \loop.kr(0)); snd = Balance2.ar(snd[0], snd[1], pan * 2 -1)})
).play;
)


Ndef(\clef, \playbuf).set(\buffer, ~clef);
Ndef(\clef).play;
Ndef(\clef).fadeTime = 5;



Ndef(\pmosc, {var snd = PMOsc.ar(\car.kr(100), \mod.kr(200), \index.kr(0.0), \modphase.kr(0.0), 0.1); snd = Pan2.ar(snd, \pan.kr)});


(
	Ndef(\pmosc)[10] = \xset -> Pbind(
		\dur, Prand([5, 7, 12], inf),
		\car, Pwhite(50, 200).round(10),
		\mod, Pwhite(50, 2000).round(10),
	)
)


Ndef(\pmosc).fadeTime_(5).play;


















(
Ndef(\test, {|pan 0.5|
	var snd = SinOsc.ar(\freq.kr(300), 0, 0.1);
	snd = Pan2.ar(snd, pan* 2 -1);
}).play;
)


Ndef(\test).fadeTime =10;

Ndef(\test)[2] = \filter -> {|in| HPF.ar(in, SinOsc.ar(\speed.kr(10, 7)).range(20, 10000), \hpfmul.kr(1))};

Ndef(\test).set(\wet1, 1/2, \speed, rrand(1.0, 5.0), \hpfmul, 3);

Ndef(\test)[2] = nil;

Ndef(\test)[10] = \filter -> {|in| JPverb.ar(in, \t.kr(1), \damp.kr(0.5, 5))}


NdefMixer(s)





s.latency = 0.05

(
Ndef(\sines, {|pan 0.5|
	var snd = SinOsc.ar(\freq.kr({rrand(300, 700)}!10), 0, 0.02);
	snd = Mix(snd);
	snd = Pan2.ar(snd, pan* 2 -1);
}).play;
)

Ndef(\sines).fadeTime_(10);

Ndef(\sines)[1] = \filter -> {|in| JPverb.ar(in, \t.kr(1), \damp.kr(0.5, 5))}

Ndef(\sines).xset(\wet1, 0)

Ndef(\sine).lag(\freq, 10);

(
var chord = Array.makeScaleCps(300, 'major', 50, 3000);
Synth(\kick, [freq: chord.at([0, 1, 2, 3]).choose, amp: 1.2]);
Ndef(\sines).set(\freq, {chord.choose}!10)
)

Ndef(\sines).clear;

NdefMixer(s)









Ndef(\sinesaw, \sinesaw1).set(*[freq: 100, amp: 5]);
Ndef(\test).fadeTime = 10;

Ndef(\test).play;


Ndef(\test).set(\freq, 50.midicps, \amp, 0.1)
Ndef(\test).stop(3);

Ndef(\test2, \sinesaw).play;
Ndef(\test2).set(\freq, 59.midicps, \gliss, 1)





Ndef(\battements, \battement);
/*Ndef(\i).set(\freq, 100, \amp, 3)*/
Ndef(\battements).clear(20);








Ndef(\play).set(\buffer, ~pitchfollow2, \loop, 1, \rate, 3, 'pan', 0.5);

Ndef(\play).lag(\rate, 10);


Ndef(\play).set(\rate, 1);

Ndef(\play).fadeTime_(30);

Ndef(\play).play;
Ndef(\play).stop;

Ndef.clear;



Ndef(\lfnoise, {|lfnoisefreq = 0.1| LFNoise2.kr(lfnoisefreq).range(\min.kr(0), \max.kr(1))})

Ndef(\lfnoise).copy(\lfnoiserate)

Ndef(\lfnoiserate).xset(\min, 0.1, \max, 30)

Ndef(\play).xmap(\rate, Ndef(\lfnoiserate))

// Ndef(\play).xset(\buffer, ~firebottle)

(
Ndef(\lfnoiserate)[999] = \pset -> Pbind(
	\dur, Pwhite(1.0, 10.0),
	\lfnoisefreq, Pwhite(0.001, 10)
)
)

Ndef(\play).map(\pan, nil)

Ndef(\lfnoise).set(\lfnoisefreq, 1)

(
Ndef(\play)[10] = \filter -> { |in, distort = 1|
	var signal, mod;
	mod = CrossoverDistortion.ar(in, amp: 0.2, smooth: 0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000 + SinOsc.ar(62,mul: 100)],nil,[0.1, 0.1, 0.05, 0.01]], in));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [in, mod]);
}
)


// Ndef(\play)[20] = \filter -> {}

Ndef(\play).set(\wet10, 1)



Ndef(\play).set(\rate, 3);

Ndef(\play).stop;














// with babble blip and bowed + other synths

Ndef(\play).set(\buffer, ~firebottle)

(
Ndef(\play)[20] = \pset -> Pbind(
	\dur, Pwhite(0.1, 3.0),
	\rate, Prand([3, 30, 15, 3 * 1.2], inf),
	\distort, -0.7,
	\legato, 1,
	\pan, Pwhite(0, 1.0),
	\amp, Pwhite(0, 1.0)
)
)


Ndef(\play).send.play;



Ndef(\play)[30] = \filter-> {|in| LPF.ar(in, SinOsc.ar(10).exprange(20, 20000))}


















Ndef(\ibuf).set(\buffer, ~firebottle)

(
Ndef(\ibuf, {arg atk = 0.01, time = 0, rel = 1, channels = 2, buffer, rate = 1, pos = 0, amp = 0.5, pan = 0, out, loop = 0;
	var sig, env, trigger;
	// env = Env.perc(atk, rel, 1).kr(2, gate);
	trigger = Impulse.ar(\trig.kr(1));
	sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trigger, pos * BufFrames.ir(buffer), loop);
	// sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], pan * 2 - 1);
	Out.ar(out, sig * amp);
}).play;
)

Ndef(\ibuf).set(\loop, 1, \trig, 100, \pos, 0.57075881958008, \rel, 7, \amp, 2, \pan, rrand(-1.0, 1.0)).play;

Ndef(\ibuf).set(\loop, 1, \trig, 100, \pos, 0.03, \rel, 7, \amp, 2, \pan, rrand(-1.0, 1.0)).play;

Ndef(\ibuf).lag(\pos, 10);
Ndef(\ibuf).lag(\pan, 10);

Ndef(\ibuf).set(\pos, rrand(0.7, 0.9), \pan, 0)

Ndef(\lfnoise, {|lfnoisefreq = 0.1| LFNoise2.kr(lfnoisefreq).range(\min.kr(0), \max.kr(1)).poll})

Ndef(\ibuf).map(\pos, Ndef(\lfnoise))

(
Ndef(\ibuf).map(\pos, Ndef(\lfnoise));
Ndef(\ibuf).map(\pan, Ndef(\lfnoise));
Ndef(\ibuf).xset(\amp, 0.3)
);


Ndef(\ibuf).set(\buffer, ~firebottle);
Ndef(\ibuf).set(\buffer, b);

















(
~rand = rrand(0, 200);
play{Out.ar(10, PlayBuf.ar(2, C.get(\buffers3b, ~rand), 1, 1, doneAction:2))};
play{Out.ar(0, PlayBuf.ar(2, C.get(\buffers3b, ~rand), 1, 1, doneAction:2))}
)





















// reminder: Blip with lfnoise 0<10 in harms + major in freq



// bowed physical model with comb major
// freq - 200 later, thins it a bit

Ndef(\bowed).fadeTime = 20;
Ndef(\bowed)[2] = \filter -> {|in| RHPF.ar(in, 1000, 0.1)}
Ndef(\bowed)[2] = nil;


Ndef(\comb)[200] = \filter -> {|in| JPverb.ar(in, 3).tanh}

Ndef(\distort, \distort);

Ndef(\comb)[300] = \filter -> Ndef(\distort)



C.crawl;
C.p(\sound, 0, index: Pwhite(0, 158))

Ndef(\sound, C.p(\sound))

Ndef(\combkr, {CombC.kr(\in.ar(100), delaytime: \delaytime.kr(1/\freq.kr(100)), decaytime: \decaytime.kr(0.1))})











Ndef(\filaments, \playbuf).set(\buffer, ~filaments, \loop, 1).play(fadeTime: 30);

Ndef(\zither, \playbuf).set(\buffer, C.get(\zither, 0), \loop, 1).play;



Ndef(\sinesaw, \sinesaw)

Ndef(\sinesaw).fadeTime = 10;

Ndef(\sinesaw).xset(\freq, 58.midicps, \amp, 1, \atk, 10).play;

Ndef(\sinesaw).xset(\freq, 52.midicps)

Ndef(\sinesaw).release(10);

/*Ndef(\sinesaw, \bowed)


(
Ndef(\sinesaw)[10] = \pset -> Pbind(
	\dur, 3,
	\gliss, 1,
	\freq, Pseq([51, 52, 54, 52].midicps, inf),
	\amp, 0.1
)
)*/


Ndef(\sinesaw)[11] = \filter -> {|in| BPFStack.ar(in, SinOsc.kr(0.1).range(300, 2000))}



Ndef(\sinesaw, \sinesaw)


Ndef(\lfnoise, {|lfnoisefreq = 0.1| LFNoise2.kr(lfnoisefreq).range(\min.kr(0), \max.kr(1))})

Ndef(\lfnoise).set(\max, 1)

Ndef(\sinesaw).xmap(\pan, Ndef(\lfnoise))

Synth(\sinesaw, [pan: 0])



Ndef(\bowed).play;
Ndef(\bowed).fadeTime_(10)


(
Ndef(\bowed)[10] = \pset -> Pbind(
	\dur, 3,
	\gliss, 0.3,
	\freq, Pseq([51, 52, 54, 52].midicps, inf),
	\pan, PSinOsc(0.3, 0, 0.5),
	\amp, 0.5
)
)

NdefMixer(s)

Ndef(\bowed)[11] = \filter ->{|in| FreeVerb.ar(in, 1)}

(
Ndef(\bowed)[10] = nil;
Ndef(\bowed).stop(30);
)











NdefMixer(s)

Ndef(\play).set(\buffer, ~firebottle, \rate, 3, \loop, 1).play;


(
Ndef(\play)[20] = \pset -> Pbind(
	\dur, Pwhite(0.1, 3.0),
	\rate, Prand([3, 30, 15, 3 * 1.2], inf),
	\distort, -0.7,
	\legato, 1,
	\pan, Pwhite(0, 1.0),
	\amp, Pwhite(0, 1.0)
)
)

// Ndef(\play).set(\buffer, xxxx)

Ndef(\play).lag(\rate, 1)


Ndef(\play)[30] = \filter-> ~freeverb

Ndef(\play).stop(30);























(
Ndef('lfnoise').set(\min, 2, \max, 20);
Ndef('bowed').set('bowvelocity', 258.83642657995, 'vibgain', 1.3514232155628, 'vibfreq', Ndef('lfnoise'), 'bowposition', Ndef('lfnoise'), 'amp', 0.1, 'bowpressure', 47.357481552031, 'freq', 1000, 'loudness', 130.04502013423);
Ndef('bowed').play(fadeTime:10);
);



Ndef(\blip).set(\freq, Ndef(\lfnoise))

Ndef(\blip).play;

(
Ndef('lfnoise').set(\min, 200, \max, 20);
Ndef(\bowed).fadeTime = 10;
)

Ndef(\bowed).set(\gliss, 100, \freq, 300, \amp, 0.3)
Ndef(\bowed).copy(\bowed2);

Ndef(\bowed2).play(fadeTime: 30);

Ndef(\bowed2).set(\gliss, 10, \freq, 170, \amp, 0.3);
(
Ndef(\bowed).stop(50);
Ndef(\bowed2).stop(50);
)

























// example routing synthdef through ndef

(
SynthDef(\s1, {
	var freq = \freq.kr(220);
	var cutoff = \cutoff.kr(100);
	var fvel = \fvel.kr(8);
	var res = \res.kr(0.5).linlin(0, 1, 1, 0.001);
	var aeg = Env.asr.ar(doneAction:Done.freeSelf, gate:\gate.kr(1));
	var sig = RLPF.ar(Saw.ar(freq), aeg.linlin(0, 1, cutoff, cutoff * fvel), res);
	sig = sig * aeg * \amp.kr(0.3);
	sig = Splay.ar(sig);
	Out.ar(\out.kr(0), sig);
}).add;
)

// monitor - output to speakers
Ndef(\s1).play(vol:1);

// play the synthdef routed through the ndef
(
Pdef(\s1,
	Pbind(
		\instrument, \s1,
		\out, Pfunc({ Ndef(\s1).bus.index }),
		\group, Pfunc({ Ndef(\s1).group }),
		\degree, Ppatlace([Pseq([0, 4], inf), Pseq([-1, 1, -2, 2], inf)], inf),
		\legato, 0.1,
		\dur, 0.25
	)
)
)
Pdef(\s1).play;

// route the ndef through a delay - output to speakers
Ndef(\delay).play;
Ndef(\delay)[0] = \mix -> {Ndef(\s1).ar};
Ndef(\delay).set(\mix0, 1);
(
Ndef(\delay).filter(10, {|in|
	var sig;
	var fb = LocalIn.ar(2);
	fb = DelayC.ar(fb.reverse, 1, [3/8, 5/8]);
	sig = fb * 0.7 + in;
	LocalOut.ar(sig);
	sig;
})
)

// route the delay through a pitchshift - output to speakers
Ndef(\ps).play;
Ndef(\ps)[0] = \mix -> {Ndef(\delay).ar};
Ndef(\ps).set(\mix0, 1);
(
Ndef(\ps).filter(10, {|in|
	PitchShift.ar(in, 2, 2, 0.01, 0.01)
})
)

// route the dry signal, delay, and pitchshift through reverb - output to speakers
Ndef(\verb).play(vol:0.5);
Ndef(\verb)[0] = \mix -> {Ndef(\s1).ar};
Ndef(\verb)[1] = \mix -> {Ndef(\delay).ar};
Ndef(\verb)[2] = \mix -> {Ndef(\ps).ar};
Ndef(\verb).filter(10, {|in| GVerb.ar(in, 10, 5, 1, 1) } );
// adjust mix
Ndef(\verb).set(\mix0, 1, \mix1, 1, \mix2, 1);
// adjust wet/dry
Ndef(\verb).set(\wet10, 1)

Ndef(\ps)[3] = \filter->{|in| FreqShift.ar(in, Line.kr(0, 200, 10))}


Ndef.clear;

NdefMixer(s)

Ndef(\bowed).play(fadeTime:30);

Ndef(\bowed)[1] = \filter -> ~freeverb

Ndef(\bowed)[1] = nil;

Ndef(\bowed).fadeTime = 10;

Ndef(\bowed).xset(\freq, 40);

Ndef(\bowed).stop;



s.reboot;





Ndef(\xxx)[10] = \filter -> {|in| PitchShiftPA.ar(in, \freq.kr(100), \pitch.kr(1), \formant.kr(1), grainsPeriod: \grains.kr(2), timeDispersion: \timedispersion.kr(1))}

Ndef(\xxx)[10] = \filter -> {|in| PitchShift.ar(in, \window.kr(0.2), \pitch.kr(1), \formant.kr(1), \grains.kr(2), \timedispersion.kr(1))}






(
Ndef(\gorge, {|lag 3|
	var snd, auto, freq, trig;
	trig = Dust.ar(9/lag);
	trig = ToggleFF.ar(trig).lag(lag);
	freq = \freq.kr(40);
	freq = freq * SinOsc.ar(10, 0, trig.linlin(0, 1, 0, 0.1/2), 1);
	auto = trig.lagud(0.1, 0.3);
	snd = Saw.ar(freq);
	snd = Splay.ar(snd);
	snd = (snd * 3).fold2;
	snd = RLPF.ar(snd, freq * 10, 0.1);
	// snd = (snd * 5).fold2;
	// snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
	// snd = (snd * 5).fold2;
	snd = MoogFF.ar(snd, auto.linexp(0, 1, \floor.kr(100), 20000), 0, 0, 2);
	snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
	snd = (snd * 3.dbamp).tanh;
	snd = HPF.ar(snd, 100);
	snd = LPF.ar(snd, SinOsc.ar(trig.linlin(0, 1, 0, 7)).exprange(100, 20000));
	Out.ar(\out.kr(0), snd * \amp.kr(0.5));
}).play;
)

Ndef(\gorge).set(\lag, 10)

Ndef(\gorge).stop;


/*Ndef(\play).copy(\bouillie);

Ndef(\bouillie).set(\buffer, ~bouillie);

Ndef(\bouillie)[10] = \filter -> {|in| var snd; snd = BPF.ar(in, [60, 57, 62, 53, 52, 48, 45].midicps * [2, 4, 8], \rq.kr(0.1)); snd = Splay.ar(snd, 1, \level.kr(1))};

Ndef(\bouillie)[10] = nil;

Ndef(\bouillie).play(fadeTime: 30);*/


// C.p(\ratios, folder: \zither, rate: Pseq([[0, 2], [-1, 8], [-3, 9]].midiratio, inf))






