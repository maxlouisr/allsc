// Ndef.defaultReshaping = \elastic;
(
// Ndef(\dfam).clear
Ndef(\dfam, {
	var vco1Saw, vco1Pulse, vco1Mix, vco1Level, vco1Freq, vco1EnvAmt, vco1,
	vco2Saw, vco2Pulse, vco2Mix, vco2Sync, vco2Level, vco2Freq, vco2EnvAmt, vco2,
	vcoDecay, vcoDecayCurve,
	fmAmt,
	noise, noiseLevel,
	filterFreq, filterRes, filterMod, filterModAmt, filterNoise, filterDecay,
	envAttack, envDecay, envCurve, envLevel, trig, vel, amp, overdrive,
	sig, hisig, syncSkew;

	amp			= \amp.kr(spec:ControlSpec(-inf, 0, \db, 			default: 0)).dbamp;
	overdrive	= \overdrive.kr(spec:ControlSpec(-inf, 12, \db, 	default: 0)).dbamp;
	vco1Freq	= \vco1Freq.kr(spec:ControlSpec(1, 20000, \exp,		default: 50)).lag(0.0);
	vco1Mix 	= \vco1Mix.kr(spec:ControlSpec(0, 1, 				default: 0));
	vco1EnvAmt 	= \vco1EnvAmt.kr(spec:ControlSpec(-5, 5, 			default: 0));
	vco1Level 	= \vco1Level.kr(spec:\db).dbamp;

	vco2Freq 	= \vco2Freq.kr(spec:ControlSpec(1, 20000, \exp,		default: 50)).lag(0.0);
	vco2Mix 	= \vco2Mix.kr(spec:ControlSpec(0, 1, 				default: 0));
	vco2EnvAmt 	= \vco2EnvAmt.kr(spec:ControlSpec(-5, 5,			default: 0));
	vco2Sync	= \vco2Sync.kr(spec:ControlSpec(0, 1, step: 1,		default: 0));
	vco2Level 	= \vco2Level.kr(spec:\db).dbamp;

	vcoDecay 	= \vcoDecay.kr(spec:ControlSpec(0.1, 10, \exp, 		default: 1));
	vcoDecayCurve = \vcoDecayCurve.kr(spec:ControlSpec(-8, 8, 		default: 0));

	fmAmt 		= \fmAmt.kr(spec:ControlSpec(-2, 2, 				default: 0));
	noiseLevel 	= \noiseLevel.kr(spec:ControlSpec(-inf, 0, \db, 	default: -12)).dbamp;

	filterDecay = \filterDecay.kr(spec:ControlSpec(0.1, 10, \exp,	default: 1));
	filterModAmt= \filterModAmt.kr(spec:ControlSpec(-5, 5,			default: 0));
	filterNoise = \filterNoise.kr(spec:ControlSpec(0, 1,			default: 0));
	filterFreq 	= \filterFreq.kr(spec:ControlSpec(20, 20000, 		default: 1000)).lag(0.0);
	filterRes 	= \filterRes.kr(spec:ControlSpec(0.001, 4, 			default: 2));

	envAttack 	= \envAttack.kr(spec:ControlSpec(1/1000, 1/10, \exp, default: 1/50));
	envDecay 	= \envDecay.kr(spec:ControlSpec(0.1, 10, \exp,		default: 2));
	envCurve	= \envCurve.kr(spec:[-8, 8]);

	syncSkew = SinOsc.ar(1/40).range(-0.4, 0.4);
	syncSkew = 2.pow(syncSkew);

	trig = Impulse.ar(60) * LFDNoise3.ar(50).range(-5, 0).dbamp;
	// trig = \trig.tr(0);
	vel = Latch.ar(trig, trig > 0).lincurve(0, 1, 0.5, 1, -2);
	trig = Trig.ar(trig > 0, SampleDur.ir);

	vco1Level = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(vco1Level, trig),
		timeScale:vel
	);

	vco2Level = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(vco2Level, trig),
		timeScale:vel
	);

	noiseLevel = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(noiseLevel, trig),
		timeScale:vel
	);

	vcoDecay = EnvGen.ar(
		Env.perc(0, vcoDecay, curve:vcoDecayCurve),
		gate:trig,
		levelScale:vel,
		timeScale:vel
	);

	filterDecay = EnvGen.ar(
		Env.perc(0, filterDecay, curve:filterDecay),
		gate:trig,
		levelScale:vel,
		timeScale:vel
	);

	vco1EnvAmt = 2.pow(vco1EnvAmt * vcoDecay);
	vco1Freq = (vco1Freq * vco1EnvAmt);
	vco1Freq = vco1Freq.clip(1, SampleRate.ir/2-1);

	vco1Saw = SyncSaw.ar(vco1Freq, vco1Freq * syncSkew);
	vco1Pulse = vco1Saw > 0;
	vco1 = vco1Saw.blend(vco1Pulse, vco1Mix);

	vco2EnvAmt = 2.pow(vco2EnvAmt * vcoDecay);
	vco2Freq = vco2Freq * vco2EnvAmt;
	vco2Freq = vco2Freq * 2.pow(vco1 * fmAmt);
	vco2Freq = vco2Freq.clip(1, SampleRate.ir/2-1);

	vco2Saw = SyncSaw.ar((vco2Sync > 0).if(vco1Freq, vco2Freq), vco2Freq * syncSkew);
	vco2Pulse = vco2Saw > 0;
	vco2 = vco2Saw.blend(vco2Pulse, vco2Mix);

	noise = WhiteNoise.ar;

	sig = (vco1Level * vco1)
	+ (vco2Level * vco2)
	+ (noiseLevel * noise);
	sig = LeakDC.ar(sig);

	filterNoise = 2.pow(LPF.ar(filterNoise * noise, 9500));

	filterMod = 2.pow(filterModAmt * filterDecay);
	filterFreq = filterFreq * filterMod;
	filterFreq = filterFreq * filterNoise;
	filterFreq = filterFreq.clip(10, SampleRate.ir / 2 - 1);

	sig = MoogFF.ar(sig, filterFreq, filterRes);
	sig = SoftClipAmp8.ar(sig, overdrive);

	sig = amp * sig;
	sig = Compander.ar(sig, sig, (amp.ampdb - 3).dbamp, 1, 1/40);

	// sig = sig + LeakDC.ar(
	// 	(-16.dbamp * Pluck.ar(hisig, hisig, 1, (102 + [0, 3.1, 7.0]).midicps.reciprocal, 0.6, 0.05).sum)
	// );

	// [sig, trig] use this if using effect
	sig = Pan2.ar(sig, \pan.kr(0));
}).gui;
)

(
//Ndef(\postProc).clear
Ndef(\postProc, {
	var sig, hisig, trig;

	#sig, trig = Ndef(\dfam).ar(2);

	hisig = LeakDC.ar(BHiPass4.ar(sig, 500));

	sig = sig + (-20.dbamp * CombC.ar(sig, 8, 1.5 * Timer.ar(trig).min(4).max(0).lag(0.1), 3));

	sig = sig + (-22.dbamp * JPverb.ar(
		hisig,
		1.1,
		0.2,
		0.2,
		earlyDiff: 0.9
	));
}).play;

Ndef(\postProc).clear;

)

(
Pdef(\dfamDefault, Pbind(*Ndef(\dfam).controlNames.collect({arg ctrl; [ctrl.name, ctrl.defaultValue]}).flatten));
Pdef(\dfam, Pbind(
	\type, \set,
	\args, Ndef(\dfam).controlNames.collect({arg ctrl;ctrl.name}),
	\id, Pfunc({ Ndef(\dfam).group.nodeID }),
	\trig, Pkey(\velocity, inf) / 128,
));
)

(
Pdef(\dfam_play, Ppar([
	Pbind(
		\durMult,		 	Prand((1 ! 16) ++ [2, 3, 6, 4], inf),
		\dur,				Pkey(\durMult) * 0.1,
		\envAttack,         0.01,
		\envCurve,         -4.0,
		\velocity, 			Prand([ 0.5, 0.5, 0.75, 0.8, 1], inf),
		\envDecay,          Pkey(\durMult).pow(2) * Prand(0.125 * [1, 3, 3, 3, 6], inf),
		\fadeTime,          3,
		\filterDecay,       Pkey(\durMult) * 0.01,
		\filterFreq,    	Pfunc({ exprand(60, 19000) }),
		\filterModAmt,      Prand([-2, -2, -2, 2], inf),
		\filterNoise,       0.1,
		\filterRes,         0.2,
		\fmAmt,             Prand([0, 0, 0, 1, 2], inf),
		\noiseLevel,        Pseq([-40, -32, -24, 0], inf),
		\overdrive,         Penv([-10, 6, -10], [16, 16]).repeat,
		\vco1EnvAmt,        Prand([1.25, 2, 0.5, -4, -6], inf),
		\vco1Freq,         	Prand([
								Pfuncn({ rrand(30, 60) }, 15),
								700
							], inf).trace,
		\vco1Level,        -0,
		\vco1Mix,           Pfunc({ rrand(0.2, 0.9) }),
		\vco2EnvAmt,        1,
		\vco2Freq,         	Prand([300, 600, 1000, 200], inf),
		\vco2Level,        -0,
		\vco2Mix,           0,
		\vco2Sync,          Prand([0, 0, 0, 0, 1], inf),
		\vcoDecay,          Prand([0.1, 0.2, 0.1, 0.93, 2], inf),
		\vcoDecayCurve,     Pfunc({ rrand(-3, 3) }),
		\pan, Pwhite(-1, 1.0)
	)
]) <> Pdef(\dfam)).play
)

Ndef(\dfam).mold(2).play;

// SynthDef version



(
SynthDef(\dfam, {
	var vco1Saw, vco1Pulse, vco1Mix, vco1Level, vco1Freq, vco1EnvAmt, vco1,
	vco2Saw, vco2Pulse, vco2Mix, vco2Sync, vco2Level, vco2Freq, vco2EnvAmt, vco2,
	vcoDecay, vcoDecayCurve,
	fmAmt,
	noise, noiseLevel,
	filterFreq, filterRes, filterMod, filterModAmt, filterNoise, filterDecay,
	envAttack, envDecay, envCurve, envLevel, trig, vel, amp, overdrive,
	sig, hisig, syncSkew;

	amp			= \amp.kr(0).dbamp;
	overdrive	= \overdrive.kr(0).dbamp;
	vco1Freq	= \vco1Freq.kr(50).lag(0.0);
	vco1Mix 	= \vco1Mix.kr(0);
	vco1EnvAmt 	= \vco1EnvAmt.kr(0);
	vco1Level 	= \vco1Level.kr(1).dbamp;

	vco2Freq 	= \vco2Freq.kr(50).lag(0.0);
	vco2Mix 	= \vco2Mix.kr( 0);
	vco2EnvAmt 	= \vco2EnvAmt.kr( 0);
	vco2Sync	= \vco2Sync.kr(0);
	vco2Level 	= \vco2Level.kr(1).dbamp;

	vcoDecay 	= \vcoDecay.kr(1);
	vcoDecayCurve = \vcoDecayCurve.kr(0);

	fmAmt 		= \fmAmt.kr( 0);
	noiseLevel 	= \noiseLevel.kr(-12).dbamp;

	filterDecay = \filterDecay.kr(1);
	filterModAmt= \filterModAmt.kr(0);
	filterNoise = \filterNoise.kr(0);
	filterFreq 	= \filterFreq.kr(1000).lag(0.0);
	filterRes 	= \filterRes.kr(2);

	envAttack 	= \envAttack.kr(1/50);
	envDecay 	= \envDecay.kr(2);
	envCurve	= \envCurve.kr(0);

	syncSkew = SinOsc.ar(1/40).range(-0.4, 0.4);
	syncSkew = 2.pow(syncSkew);

	// trig = Impulse.ar(1) * LFDNoise3.ar(50).range(-5, 0).dbamp;
	trig = \trig.tr(0);
	vel = Latch.ar(trig, trig > 0).lincurve(0, 1, 0.5, 1, -2);
	trig = Trig.ar(trig > 0, SampleDur.ir);

	vco1Level = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(vco1Level, trig),
		timeScale:vel
	);

	vco2Level = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(vco2Level, trig),
		timeScale:vel
	);

	noiseLevel = EnvGen.ar(
		Env.perc(envAttack, envDecay, curve:envCurve),
		gate:trig,
		levelScale:vel * Latch.ar(noiseLevel, trig),
		timeScale:vel
	);

	vcoDecay = EnvGen.ar(
		Env.perc(0, vcoDecay, curve:vcoDecayCurve),
		gate:trig,
		levelScale:vel,
		timeScale:vel
	);

	filterDecay = EnvGen.ar(
		Env.perc(0, filterDecay, curve:filterDecay),
		gate:trig,
		levelScale:vel,
		timeScale:vel
	);

	vco1EnvAmt = 2.pow(vco1EnvAmt * vcoDecay);
	vco1Freq = (vco1Freq * vco1EnvAmt);
	vco1Freq = vco1Freq.clip(1, SampleRate.ir/2-1);

	vco1Saw = SyncSaw.ar(vco1Freq, vco1Freq * syncSkew);
	vco1Pulse = vco1Saw > 0;
	vco1 = vco1Saw.blend(vco1Pulse, vco1Mix);

	vco2EnvAmt = 2.pow(vco2EnvAmt * vcoDecay);
	vco2Freq = vco2Freq * vco2EnvAmt;
	vco2Freq = vco2Freq * 2.pow(vco1 * fmAmt);
	vco2Freq = vco2Freq.clip(1, SampleRate.ir/2-1);

	vco2Saw = SyncSaw.ar((vco2Sync > 0).if(vco1Freq, vco2Freq), vco2Freq * syncSkew);
	vco2Pulse = vco2Saw > 0;
	vco2 = vco2Saw.blend(vco2Pulse, vco2Mix);

	noise = WhiteNoise.ar;

	sig = (vco1Level * vco1)
	+ (vco2Level * vco2)
	+ (noiseLevel * noise);
	sig = LeakDC.ar(sig);

	filterNoise = 2.pow(LPF.ar(filterNoise * noise, 9500));

	filterMod = 2.pow(filterModAmt * filterDecay);
	filterFreq = filterFreq * filterMod;
	filterFreq = filterFreq * filterNoise;
	filterFreq = filterFreq.clip(10, SampleRate.ir / 2 - 1);

	sig = MoogFF.ar(sig, filterFreq, filterRes);
	sig = SoftClipAmp8.ar(sig, overdrive);

	sig = amp * sig;
	sig = Compander.ar(sig, sig, (amp.ampdb - 3).dbamp, 1, 1/40);

	// sig = sig + LeakDC.ar(
	// 	(-16.dbamp * Pluck.ar(hisig, hisig, 1, (102 + [0, 3.1, 7.0]).midicps.reciprocal, 0.6, 0.05).sum)
	// );

	Out.ar(\out.kr(0), [sig, trig]);
});
)

(
~postPatFor = {|synthDef=\dfam|
	var controls = SynthDescLib.global.synthDescs.at(synthDef).controls;
	"(
	Pdef(0,
	Pbind(
	%instrument, %%,".format("\\", "\\", synthDef.asSymbol).postln;
	controls.do{|control|
		var name = control.name;
		var val = control.defaultValue;

		// Check that synth doesn't have a duration of 0 by default (making sc explode)
		val = if(name == \dur && val == 0.0, { 1.0 }, { val });
		"\t%%, %,".format("\\", name, val).postln
	};
	")
	).play;
	)".postln;
};
~postPatFor.value(\dfam
)
)