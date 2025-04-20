
/*(
Ndef(\avion).clear;

Ndef(\avion, {|lag 10|
		var air, bass, snd;
		air = BrownNoise.ar({LFNoise2.kr(0.3, 0.02, 0.08).abs * \air.kr(1, 10)}!4); air = LPF.ar(air) * 3;
		air = BPeakEQ.ar(air, 50, 5, 15);
		snd = SplayAz.ar(~numChannels, air, 1, 1, 2, LFNoise2.kr(0.1).range(0, 1));
		snd = snd.blend((BPF.ar(snd, LFNoise2.kr(0.1).exprange(100, 200) * \height.kr(1, 10).linlin(0, 1, 0.01, 2), \rq.kr(0.01, 10), 30)*3).cos, \avion.kr(0.2, 30));
		snd = Limiter.ar(snd * 0.9, \limit.kr(0.9, 10));
		snd = HPF.ar(snd, \hpf.kr(30));
		snd = snd * \amp.kr(0);
	}).mold(~numChannels).fadeTime_(10);

~dirt.soundLibrary.addSynth(\avionon, (play: {
	Ndef(\avion).set(\amp, ~amp);
	Ndef(\avion).set(\height, ~height);
	Ndef(\avion).set(\avion, ~avion);

	Ndef(\avion).play;
}));

~dirt.soundLibrary.addSynth(\avionoff, (play: {
	Ndef(\avion).clear(fadeTime:7);
}));

);*/

(
Ndef(\tidal_rrr).clear;

Ndef(\tidal_rrr, {
	var snd, lag;
	lag = \lag.kr(1.0);
	snd =
	Splay.ar(
		BPF.ar(
			LFSaw.ar(
				// LFNoise2.kr(0.5).exprange(7, 17)
				LFNoise2.kr(0.5).exprange(1, \density.kr(10, lag))
				// LFNoise2.kr(0.5).exprange(10, [1000, 100])
			),
			Array.fib(12, LFNoise2.kr(0.1, 20, 30), 30),
			0.005,
			mul: Env.perc(1, LFNoise1.kr(1, 1, 5), level: 10, curve: -3).circle.kr(2)
		),
		spread: 0,
		level: 1);
	snd = Mix(snd);
	PanAz.ar(~numChannels, snd, LFNoise2.kr(\movement.kr(0.3, lag), 0.5, 1) * \spread.kr(1.0, lag)) * \amp.kr(0, lag);
});

~dirt.soundLibrary.addSynth(\rrr1, (play: {

	Ndef(\tidal_rrr).play;

}));

~dirt.soundLibrary.addSynth(\rrrmod, (play: {
	// Ndef(\tidal_rrr).set(\density, ~density);
	// Ndef(\tidal_rrr).set(\spread, ~spread);
	// Ndef(\tidal_rrr).set(\movement, ~movement);
	Ndef(\tidal_rrr).set(\amp, ~amp);
	// Ndef(\rrr).set(\width, ~width);
}));


~dirt.soundLibrary.addSynth(\rrr0, (play: {
	{Ndef(\tidal_rrr).stop(fadeTime:10); 10.wait; Ndef(\tidal_rrr).pause}
}));

);


(
Ndef(\ms).clear;

Ndef(\ms, {
	var snd, lag;
	lag = \lag.kr(1.0);
	snd = SinOscFB.ar({\fq.kr(1.0, lag) * exprand(20, 20000)}!~numChannels, \fb.kr(0, lag), \amp.kr(0, lag) * {LFNoise2.kr(1, \blur.kr(0), 1)}!~numChannels);
	snd = SplayAz.ar(~numChannels, snd, \spread.kr(1.0, lag), 1, \width.kr(2.0, lag));
});

~dirt.soundLibrary.addSynth(\ms1, (play: {
	Ndef(\ms).set(\fq, ~fq);
	Ndef(\ms).set(\fb, ~fb);
	Ndef(\ms).set(\amp, ~amp);
	Ndef(\ms).set(\spread, ~spread);
	Ndef(\ms).set(\width, ~width);
	Ndef(\ms).set(\lag, ~lag);
	Ndef(\ms).set(\blur, ~blur);
	// Ndef(\rrr).set(\width, ~width);
	Ndef(\ms).play(fadeTime:10);
}));

~dirt.soundLibrary.addSynth(\ms0, (play: {
	Ndef(\ms).clear(fadeTime:10);
}));

);

(
Ndef(\slin).clear;

Ndef(\slin, {
	var snd, lag, freq;
	lag = \lag.kr(1.0);
	freq = \freq.kr(100.0, lag);
	freq = {freq * exprand(20, 200) * LFNoise0.kr({rrand(0.1, 20.0)} * \lfospeed.kr(1) + 0.1, \lfowidth.kr(0.5), 1)}!~numChannels;
	snd = SinOscFB.ar(freq, \fb.kr(0, lag), \amp.kr(0, lag));
	// snd = SplayAz.ar(~numChannels, snd, \spread.kr(1.0, lag), 1, \width.kr(2.0, lag));
});

~dirt.soundLibrary.addSynth(\slin1, (play: {
	Ndef(\slin).set(\lfospeed, ~lfospeed);
	Ndef(\slin).set(\freq, ~freq);
	Ndef(\slin).set(\lfowidth, ~lfowidth);
	Ndef(\slin).set(\fb, ~fb);
	Ndef(\slin).set(\lag, ~lag);
	Ndef(\slin).set(\amp, ~amp);
	Ndef(\slin).play(fadeTime:0);
}));

~dirt.soundLibrary.addSynth(\slin0, (play: {
	Ndef(\slin).stop(fadeTime:1);
}));

~dirt.soundLibrary.addSynth(\slinkill, (play: {
	Ndef(\slin).clear(fadeTime:1);
}));


~dirt.soundLibrary.addSynth(\cmdp, (play: {
	CmdPeriod.run;
}));


);

// {var snd; snd = SinOsc.ar(100, 0, 0.1); snd = PanAz.ar(16, snd, 1, 1, 16)}.play;


// Ndef(\slin).resume;

// Ndef(\slin).play;


