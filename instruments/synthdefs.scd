

// changed pos * bufdur to bufframes + trigger.kr to trig.kr
SynthDef(\play, {
	var snd, rate, env, envlinen, buffer;
	buffer = \buffer.kr;
	env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
	// envlinen = Env.linen(\atk.kr(0), \sus.kr(1) * BufDur.kr(\buffer.kr), \rel.kr(3)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trig.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\playpitch, {
	var snd, rate, env, envlinen, buffer;
	buffer = \buffer.kr;
	env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
	// envlinen = Env.linen(\atk.kr(0), \sus.kr(1) * BufDur.kr(\buffer.kr), \rel.kr(3)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(2));
	snd = PitchShiftPA.ar(snd, Pitch.kr(snd).lag(0.01), \pitch.kr(1), \formantRatio.kr(1), 10, 10, \grainsPeriod.kr(2), \timeDispersion.kr(0));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	snd = snd.blend(BPF.ar(snd, \bpf.kr(440), \rq.kr(1)), \bpfmix.kr(0));
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\playgverb, {
	var snd, buffer, done;
	buffer = \buffer.kr;
	snd = PlayBuf.ar(2, buffer, \rate.kr(1) * BufRateScale.kr(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(0));
	snd = GVerb.ar(snd, \room.kr(10), \time.kr(3), \damping.kr(0.5), \inputdamping.kr(0.5), \spread.kr(15), \drymix.kr(1), \earlyreflectionlevel.kr(0.7), \taillevel.kr(0.5), 300);
	// done = Done.kr(snd);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	snd = snd.blend(BPF.ar(snd, \bpf.kr(440), \rq.kr(1)), \bpfmix.kr(0));
	DetectSilence.ar(snd, 1/10000, 0.1, 2);
	Out.ar(\out.kr(0), snd * \amp.kr(1))
}).add;

SynthDef(\playenvgverb, {
	var snd, rate, env, buffer;
	buffer = \buffer.kr;
	env = Env.linen(\atk.kr(0), \sus.kr(1), \rel.kr(0)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(buffer), \loop.kr(0), \doneAction.kr(0));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	snd = GVerb.ar(snd);
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;


/*SynthDef(\playbufloop, {
var snd, rate, env, envlinen, buffer;
buffer = \buffer.kr;
env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
// envlinen = Env.linen(\atk.kr(0), \sus.kr(1) * BufDur.kr(\buffer.kr), \rel.kr(3)).kr(2);
rate = \rate.kr(1);
snd = PlayBufLoop.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr),\startPos.kr(0), \endPos.kr(1), \loop.kr(0), \keepLoop.kr(0));
snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;
*/
SynthDef(\playlinen, {
	var snd, rate, env, buffer;
	buffer = \buffer.kr;
	env = Env.linen(\atk.kr(0), \sus.kr(1), \rel.kr(0)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(buffer), \loop.kr(0), \doneAction.kr(0));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\playpitchlinen, {
	var snd, rate, envlinen, buffer;
	buffer = \buffer.kr;
	envlinen = Env.linen(\atk.kr(0), \sus.kr(1), \rel.kr(3)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufFrames.kr(buffer), \loop.kr(0), \doneAction.kr(0));
	snd = PitchShiftPA.ar(snd, Pitch.kr(snd), \pitch.kr(1), \formantRatio.kr(1), 10, 10, \grainsPeriod.kr(2), \timeDispersion.kr(0));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	Out.ar(\out.ar(0), snd * envlinen * \amp.kr(1))
}).add;

SynthDef(\playfshift, {
	var snd, rate, env, envlinen, buffer;
	buffer = \buffer.kr;
	env = Env.asr(\atk.kr(0), 1, \rel.kr(3)).kr(2);
	// envlinen = Env.linen(\atk.kr(0), \sus.kr(1) * BufDur.kr(\buffer.kr), \rel.kr(3)).kr(2);
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(buffer), \loop.kr(0), \doneAction.kr(2));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = FreqShift.ar(snd, \freq.kr(100), 0, 1);
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;

// changed name from 'grainbuf' to single graingbuf

SynthDef(\normalize, {
	var snd;
	snd = \buffer.kr(0);
	snd = PlayBuf.ar(2, snd, \rate.kr(1) * BufRateScale.kr(snd), 1, 0, \loop.kr(0), doneAction: 2);
	snd = Normalizer.ar(snd, \level.kr(1.0));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\singlegrainbuf, {
	var snd, buffer;
	buffer = \buffer.kr;
	snd = GrainBuf.ar(2, \trigger.kr(1), \grainDur.kr(1), buffer, \rate.kr(1) * BufRateScale.kr(buffer), \pos.kr(0), \interp.kr(2), \pan.kr(0));
	DetectSilence.ar(snd, doneAction:2);
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;

// took jpverb out

SynthDef(\playfx, {
	var snd, rate, done;
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(\buffer.kr), \loop.kr(0), \doneAction.kr(0));

	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	// snd = XFade2.ar(snd, JPverb.ar(snd, \time.kr(1), \damp.kr(0)), \jpverb.kr(0) * 2 -1);
	snd = FreeVerb.ar(snd, \freeverb.kr(0) * 2 - 1, \room.kr(0.5), \damp.kr(0));
	snd = RLPF.ar(snd, \lpf.kr(20000), \rq.kr(1));
	DetectSilence.ar(snd, doneAction:2);
	Out.ar(\out.ar(0), snd * \amp.kr(1))
}).add;

SynthDef(\record, { arg out = 0, buffer;
	var in;
	in = SoundIn.ar([0, 1]);
	RecordBuf.ar(in, buffer, loop: \loop.kr(0), doneAction: 2);
}).add;

SynthDef(\whiteperc, {
	var snd, env = Env.perc(\atk.kr(0.1), \rel.kr(0.1), \amp.kr(1.0), \curve.kr('sine')).kr(2);
	snd = WhiteNoise.ar(env);
	Out.ar(\out.kr(0), snd.dup)
}).add;

// from synthDEFAULTS pool

SynthDef(\piano, {
	//Piano synth based on Mda Plugin
	|out = 0, freq= 440, gate= 1, vel= 80, decay= 0.8, release= 0.8, hard= 0.4, velhard= 0.8, muffle= 0.8, velmuff= 0.8, velcurve= 0.8, stereo= 0.2, tune= 0.5, random= 0.1, stretch= 0.1, sustain= 0, mul= 1, add= 0, amp = 0.5|
	var snd;
	snd = MdaPiano.ar(freq, gate, vel, decay, release, hard, velhard, muffle, velmuff, velcurve, stereo, tune, random, stretch, sustain, mul, add);
	snd = snd * EnvGen.kr(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	Out.ar(out, snd * amp);
	//by ????

}).add;

SynthDef(\rhodes1, {
	//FM Rhodes Synthethizer
	|
	// standard meanings
	out = 0, freq = 1203, gate = 1, pan = 0, amp = 0.1,
	// all of these range from 0 to 1
	vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
	|
	var env1, env2, env3, env4;
	var osc1, osc2, osc3, osc4, snd;

	lfoSpeed = lfoSpeed * 12;

	freq = freq * 2;

	env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
	env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
	env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
	env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

	osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
	osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
	osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
	osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
	snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

	// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
	snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	snd = Pan2.ar(snd, pan, amp);

	Out.ar(out, snd);
	//By Nathan Ho aka Snappizz
	//http://sccode.org/1-522
}).add;

SynthDef(\harp1, {
	|amp=0.1, freq= 200, pan=0, atk=0.0001, rel=1, trig= 1, maxdelaytime= 0.2, decaytime= 7, coef= 0.1|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(atk, decaytime, rel), doneAction: Done.freeSelf);
	// sig = LFNoise2.ar(freq, amp);
	sig = PinkNoise.ar(amp);//Can use white noise here, but Pink is more realistic
	delay = freq.reciprocal;
	sig = Pluck.ar(sig, trig, maxdelaytime , delay , decaytime , coef ) //fundamental
	+ Pluck.ar(sig, trig, maxdelaytime , delay/2 , decaytime , coef ); //octave higher
	Out.ar(0, Pan2.ar(sig * env, pan, 10));
	//Harpsichord based on Pluck Ugen
	//By Zé Craum

}).add;

SynthDef(\cheaporgan, {
	//additive tonewheel organ with few CPU usage

	arg freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 1, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
	vrate = 3, vdepth = 0.008; //vibrato arguments
	var sig, env, vibrato;

	vibrato = SinOsc.kr(DC.kr(\vibrato.kr(0.1))).range(1 - DC.kr(vdepth), 1+ DC.kr(vdepth));
	// vibrato = 1;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato * freq);

	sig = sig * env;
	Out.ar(0, Pan2.ar(sig, pan, amp));
	//By Zé Craum
}).add;

SynthDef("flute", { arg scl = 0.2, freq = 440, ipress = 0.9, breath = 0.01, mode= 0,ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 0.4;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc, snd;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );


	asum1 = ( (breath - (mode/100)) * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	signalOut = signalOut.blend(HPF.ar(BRF.ar(signalOut, freq), freq/2, 3), mode);

	signalOut = Pan2.ar(signalOut * kenv2, \pan.kr(0), 4);
	// signalOut = [ signalOut * kenv2, signalOut * kenv2 ];


	Out.ar( 0, signalOut);

	// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html
	//by Wilson, Cottle and Collins
	//also available at Bruno Ruviaro Collection https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/flute.scd
}).add;

// end synthDEFAULTS pool

/*	SynthDef(\fm, {
var sig, env, gate, freqs, freqEnv, freqCurve, octs, phases, amps, matrix, freq;
var seed, seedA, seedB, seedBlend, sigA, sigB, params;
var freqMin, freqMax, partialMin, partialMax, freqRound, matrixMin, matrixMax, matrixCurve;
var attack, feed, sustain, inputFreq, pan;
var rand;

sustain = \sustain.kr(1);
seed = \seed.kr(0);
seed = seed + (\seedDrift.kr(0.05) * Env([0, 1], [sustain], [\seedDriftCurve.kr(0)]).kr(gate:1));
// seed = seed + MouseX.kr(-3, 3);

rand = {
|seed, name, count|
count.collect {
|i|
Hasher.kr(
seed + i + ("name".hash % 1000.nthPrime)
)

}
};

freqMin = \freqMin.kr(-1);
freqMax = \freqMax.kr(1);
freqRound = \freqRound.kr(0);

partialMin = \partialMin.kr(-1);
partialMax = \partialMax.kr(1);

inputFreq = \freq.kr;
freq = inputFreq; // * (ExpRand(0.01, 48) * Env([1, 0], [Rand(0.03, 0.2)], [-10]).kr(gate:1)).midiratio;

matrixMin = \matrixMin.kr(-1);
matrixMax = \matrixMax.kr(1);
matrixCurve = \matrixCurve.kr(0);

feed = \feed.kr(0);

gate = \gate.kr(1);
attack = \atk.kr(0.001).linlin(0, 1, 0.001, 1 - 0.001);
env = Env.adsr(attack, 1 - attack, \sustainLevel.kr(0.4), \rel.kr(0.3), curve: \curve.kr(-9)).kr(gate:gate, timeScale:sustain, doneAction:2);

freqs = seed.fadeSteps({
|seed|
rand.(seed, "freqs", 6)
}, warp:\sin);
freqCurve = \freqCurve.kr(20);
freqEnv = Env.adsr(
attack, 1 - attack, 0, 0.3, curve:freqCurve * [1, -1, -1]
).kr(gate:gate, timeScale:sustain, doneAction:2);
freqs = freqs.linlin(-1, 1, freqMin, freqMax).round(freqRound);

amps = seed.fadeSteps({
|seed|
[
rand.(seed, "ampsScale", 6),
rand.(seed, "ampsEnv", 6),
rand.(seed, "ampsSustain", 6)
]
}, warp:\sin);
amps = [
amps[0].linexp(-1, 1, 0.001, 1),
amps[1],
amps[2].lincurve(-1, 1, 0, 1, \ampSustainCurve.kr(-4)),
];
amps[1] = ((amps[1] > 0) * (attack.pow(1 + (amps[1].linlin(0, 1, 0, 2)))))
+ ((amps[1] < 0) * (attack.pow(1 / (1 + (amps[1].linlin(0, 1, 0, 2))))));

amps = amps.flop.collect {
|amp|
amp[0] * Env.adsr(
amp[1], 1 - amp[1], amp[2], 0.3
).kr(gate:gate, timeScale:sustain);
};

matrix = seed.fadeSteps({
|seed|
rand.(seed, "matrix", 6*6)
* (rand.(seed, "matrixCut", 6*6) < \matrixCut.kr(1))
}, warp:\sin);
matrix = matrix.lincurve(-1, 1, matrixMin, matrixMax, matrixCurve);

feed = feed * (1 + (env * 0.2));
(7 * [0, 1, 2, 3, 4, 5]).do {
|i|
matrix[i] = matrix[i] + feed;
};

sig = seed.fadeSteps({
|seed|
var partial;

partial = rand.(seed, "partial", 6);
partial = partial.linlin(-1, 1, partialMin, partialMax).round(1);
partial = (1 + ((partial > 0) * partial))
+ ((partial < 0) * (1 / (1 + partial.abs)));

// octs = [0, 0, 0, (0.188.ratiomidi), 0, 0];

phases = rand.(seed, "phases", 6);
phases = phases.linexp(-1, 1, 0.001, 3);

FM7.ar(
[
(freq * partial) + freqs,
phases,
amps
].flop,
matrix.clump(6)
).sum;
}, warp:\sin);

sig = env * sig;

pan = \pan.kr(0);
sig = RLPF.ar(sig, \lpf.ar(20000), \rq.kr(1));
// sig = sig + CombC.ar(sig, 0.2, 1/(\freq.kr * 2), \comb.kr(1), \combmix.kr(0));
sig = Pan2.ar(sig, pan);
// sig = 24.dbamp * PanBin.ar(sig, 1.0, pan);
sig = Balance2.ar(sig[0], sig[1], pan * 0.3);
sig = \amp.kr(1) * sig;
sig = Limiter.ar(sig, 0.5);
// sig = Normalizer.ar(sig, 0.1);


OffsetOut.ar(\out.kr(0), sig);
}).add;*/

SynthDef(\fm12,
	{ arg out=0, freq=440, rel=0.05;
		var env, snd;
		env = EnvGen.kr(Env.perc(0.01, rel, 0.3), doneAction: Done.freeSelf);
		snd = SinOsc.ar(freq * SinOsc.ar(freq, 0, 1, 3) * SinOsc.ar(freq/2, 0, 1, 0) * SinOsc.ar(freq/2, 0, 1, 3), 0, env);
		Out.ar(out, snd!2)
}).add;

SynthDef(\fm13,
	{ arg out=0, freq=440, rel=0.05;
		var env, snd;
		env = EnvGen.kr(Env.perc(0.01, rel, 0.2), doneAction: Done.freeSelf);
		snd = SinOsc.ar(freq * SinOsc.ar(freq, 0, 1, 3) * SinOsc.ar(freq*10, 0, 1, 0) * SinOsc.ar(freq/2, 0, 1, 3), 0, env);
		Out.ar(out, snd!2)
}).add;

SynthDef(\mop, {
	var lfsaw = LFSaw.kr(0.1).range(0.0,0.2);
	var freq = \freq.kr(100);
	var snd = SinOscFB.ar(freq, \feedback.kr(1.1)) + CombC.ar(WhiteNoise.ar(\brass.kr(0.3) / 10 + 0.001), 0.2, 1/freq, SinOsc.kr(3).range(0, 100) + 1);
	var env = Env.perc(\atk.kr(0.01), \rel.kr(1), \amp.kr(1.0), \curve.kr(-4)).kr(2, gate: 1, timeScale: \dur.kr(1)/2);

	snd = LPG.ar(
		input: snd,
		controlinput: env,
		controloffset: lfsaw,
		controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
		vca: LFNoise2.kr(1).unipolar,
		resonance:1.1,
		lowpassmode:1,
		linearity:1
	) * 0.25;

	// snd = FreeVerb.ar(snd, 0.1);
	// snd = BRF.ar(snd, LFNoise2.kr(10).range(20, 1000), 10);
	// snd = BPeakEQ.ar(snd, 200, 1, -6);
	snd = Pan2.ar(snd, \pan.kr(0)) * 0.4;
	// DetectSilence.ar(snd, doneAction:2);
	// snd = Normalizer.ar(snd, 0.5);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\playloop, {
	var snd, rate;
	rate = \rate.kr(1);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(\buffer.kr), \loop.kr(1), \doneAction.kr(2));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.kr(0), snd * \amp.kr(1))
}).add;


SynthDef(\playenv, {
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0), 1, \curve.kr(-4)).kr(2);
	snd = PlayBuf.ar(2, \buffer.kr, \rate.kr(1) * BufRateScale.ir(\buffer.kr), \trigger.kr(1), \pos.kr(0) * BufDur.kr(\buffer.kr), \loop.kr(0), \doneAction.kr(2));
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.ar(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\tambour, {|out=0, pan=0, sustain=0, rel = 0.01, trig=1, amp=1, freq=100, accent=0.9, structure = 0.5, brightness=0.5, damping=0.5|
	// var env = Env.perc(0.01, 0.1).kr(2, gate: trig, timeScale:dur+sustain, doneAction: 2);
	var sig = StringVoice.ar(Trig.kr(trig, rel), infsustain: 0, freq: freq, accent: accent, structure: structure, brightness: brightness, damping: damping);
	sig = LPF.ar(sig, \lpf.kr(10000));
	DetectSilence.ar(sig, 1/100000, 0.001, doneAction:2);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * 100/freq * amp)
}).add;

SynthDef(\bassline, {
	|freq 50 rel 1.0|
	var snd;
	snd = WhiteNoise.ar(Env.perc(\atk.kr(0.01), rel).kr(0))!2;
	snd = Streson.ar(snd, 1/freq, \res.kr(0.99), 1/2);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	// snd = FreqShift.ar(snd, 10000, 0, 1);
	snd = LPF.ar(snd, \lpf.kr(1000));
	snd = Sanitize.ar(snd);
	DetectSilence.ar(snd, doneAction:2);
	snd = PitchShiftPA.ar(snd, freq, 1, \formant.kr(1/10), 1) * 6;
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;


SynthDef(\meddis, {
	var snd, env;
	env = Env.linen(\atk.kr(1), \sus.kr(1.0), \rel.kr(3), \amp.kr(0.1)).kr(2);
	snd = SinOsc.ar(\freq.kr(100));
	snd = Meddis.ar(snd);
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\dis, {
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1)).kr(2);
	snd = SinOsc.ar(\freq.kr(100), 0, 0.1);
	snd = CrossoverDistortion.ar(snd, \disto.kr(1) * 0.1, 0.5);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env)
}).add;


SynthDef(\whitenoise, {
	var snd, env;
	env = Env.asr(0.01, 1, 3).kr(2, \gate.kr(1));
	snd = WhiteNoise.ar(0.1)!2;
	Out.ar(\out.kr(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\whitenoisep, {
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2);
	snd = WhiteNoise.ar(0.1);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = HPF.ar(snd, \hpf.kr(20));
	snd = LPF.ar(snd, \lpf.kr(20000));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1))
}).add;

SynthDef(\wavering, {
	arg out = 0, freq = 200, dev = 1.02, gate = 1, num;
	var temp, sum, env;
	env = Env.asr(\atk.kr(30), 1, 30).kr(2, gate);
	sum = 0;
	num.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise2.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * env * 0.05;
	Out.ar(out, sum);
}).add;


SynthDef(\combsaw, {
	var snd, env;
	env = Env.asr('atk'.kr(10), 1, 'rel'.kr(10)).kr(2, 'gate'.kr(1));
	snd = LFSaw.ar(10, 0, 0, 0.1);
	snd = CombC.ar(snd, 0.2, LFNoise0.kr('bordel'.kr(30)).range(\bordelmin.kr(100), \bordelmax.kr(1000)).reciprocal, 0.1);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = HPF.ar(snd, 'hpf_freq'.kr(200));
	snd = snd * env;
	Out.ar('out'.ar(0), snd * 5  *'amp'.kr(1));
}).add;

SynthDef(\battement, {|gate 1 out 0|
	var snd, env, freqs;
	env = Env.asr(\atk.kr(1), 1, \rel.kr(1)).kr(2, gate);
	freqs = Array.series(10, \freq.kr(100), \speed.kr(5));
	snd = SinOsc.ar(freqs, 0, 0.1);
	snd = Splay.ar(snd * \amp.kr(1));
	snd = snd * env;
	Out.ar(out, snd);
}).add;


SynthDef(\sine, {|gate = 1, out = 0, phase = 0, amp = 0.1|
	var env, snd,freq;
	// freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	env = Env.asr(\atk.kr(0.1), 1, \rel.kr(1)).kr(2, gate);
	snd = SinOsc.ar(\freq.kr(100), phase, amp);
	snd = env * snd * amp;
	Out.ar(out, snd!2);
}).add;


/*SynthDef(\sinechord, {|out 0|
var snd, env;
env = Env([0, 1, 0], [\atk.kr(3), \rel.kr(7)], \curve.kr('lin')).kr(2);
snd = SinOsc.ar(\freq.kr(Array.fill(10, 0), \lag.kr(0)), 0, 0.3);
snd = Select.ar(\mixdown.kr(0), [Splay.ar(snd), Mix(snd)!2 / 10]);
// snd = Pan2.ar(snd, \pan.kr(0));
Out.ar(out, snd * env * \amp.kr(Array.fill(10, 1)));
}).add;*/

// Synth(\sinechord, [freq: [100, 3800, 3820, 084, 729], amp: [1, 0.1, 0.1, 1.2, 1], mixtype: 0])

SynthDef(\lfsaw, {|gate = 1, out = 0, freq = 100, phase = 0, amp = 0.01|
	var env, snd;
	env = Env.asr(\atk.kr(0.1), 1, \rel.kr(1)).kr(2, gate);
	snd = LFSaw.ar(freq, phase, amp);
	snd = env * snd;
	Out.ar(out, snd!2);
}).add;

SynthDef(\varsaw, {|gate = 1, out = 0, phase = 0, amp = 0.1|
	var env, snd, freq;
	env = Env.asr(\atk.kr(0.1), 1, \rel.kr(1)).kr(2, gate);
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(1));
	snd = VarSaw.ar(freq, phase, \width.kr(0.5, \lagwidth.kr(0)), amp);
	snd = snd * env;
	Out.ar(out, snd!2);
}).add;

SynthDef(\varsawcomb, {
	|freq 50|
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \dur.kr(1));
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(1).abs}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \combratio.kr(1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0), 0.5);
	Out.ar(\out.kr(0), snd * \amp.kr(1) * env);
}).add;

SynthDef(\resonantcs, {
	|freq 50|
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \dur.kr(1));
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \combratio.kr(1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	snd = Resonator.ar(snd, \resonatorf.kr(100), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = (2 * snd).tanh;
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd * \amp.kr(1) * env);
}).add;


SynthDef(\resonantcsverb, {
	|freq 50|
	var snd, env;
	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).kr(2, timeScale: \dur.kr(1));
	snd = VarSaw.ar(freq, 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * \combratio.kr(1)), \decaytime.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	snd = Resonator.ar(snd, \resonatorf.kr(100), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = (2 * snd).tanh;
	snd = JPverb.ar(snd, \time.kr(1.0), \damp.kr(0.0));
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd * \amp.kr(1) * env);
}).add;

SynthDef(\blip, { |freq = 400, out = 0, pan = 0, gate = 1, curve = -4, amp = 1, harms = 5|
	var sig, env;
	sig = Pan2.ar(Blip.ar(freq, harms), pan);
	// sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5));
	env = EnvGen.ar(Env.perc(\atk.kr(0.01), \rel.kr(0.1), amp, curve), gate, doneAction:2);
	Out.ar(0, sig * env);
}).add;

SynthDef(\deepbass, {
	var snd, freq, env;
	freq = VarLag.kr(\freq.kr(50), \lag.kr(0.1));
	env = Env.perc(\atk.kr(0.01), \rel.kr(1), \amp.kr(1), \curve.kr(-4)).kr(2);
	snd = LFSaw.ar(freq, 0, 0.1) * LFPulse.ar(freq, 0, 0.5, 0.1);
	snd = RLPF.ar(snd, freq * SinOsc.kr(\lpfreq.kr(0.1), 0, 1/2, 1) * 1, 0.1);
	snd = (snd * 100).tanh * 0.1;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env * 3);
}).add;


SynthDef(\gendy1, {
	var snd, env;
	env = Env.linen(\atk.kr(0.01), \sus.kr(1.0), \rel.kr(1.0)).kr(2);
	snd = Gendy1.ar(\ampdist.kr(1), \durdist.kr(1), \adparam.kr(1.0), \ddparam.kr(1.0), \minfreq.kr(440), \maxfreq.kr(660), \ampscale.kr(0.5), \durscale.kr(0.5), \initCPs.ir(12), \knum.kr(12), \amp.kr(1.0));
	snd = Pan2.ar(snd, snd.range(-1, 1));
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\gendy1m, {
	var snd;
	snd = Gendy1.ar(\ampdist.kr(1), \durdist.kr(1), \adparam.kr(1.0), \ddparam.kr(1.0), \minfreq.kr(440), \maxfreq.kr(660), \ampscale.kr(0.5), \durscale.kr(0.5), \initCPs.ir(12), \knum.kr(12), \amp.kr(1.0));
	snd = Pan2.ar(snd, snd.range(-1, 1));
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\deepbassmono, {
	var snd, freq;
	freq = VarLag.kr(\freq.kr(50), \lag.kr(0.1));
	snd = LFSaw.ar(freq, 0, 0.1) * LFPulse.ar(freq, 0, 0.5, 0.1);
	snd = RLPF.ar(snd, freq * SinOsc.kr(\lpfreq.kr(0.1), 0, 1/2, 1) * 1, 0.1);
	snd = (snd * 100).tanh * 0.1;
	Out.ar(\out.kr(0), snd.dup * 2);
}).add;

SynthDef(\poin, {
	|atk 0.01 rel 1.0 lpfmin 50 lpfmax 10000|
	var snd, env, freq;
	freq = \freq.kr(100);
	env = Env.perc(atk, rel, \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = LFSaw.ar(Env([freq, freq * \pitchenv.kr(10), freq], [atk, rel], 'exp').kr(0), 0, 0.5);
	snd = RLPF.ar(snd, Env([lpfmin, lpfmax, lpfmin], [\lpfatk.kr(0.03), \lpfrel.kr(1)], 'exp').kr(0), \rq.kr(0.3));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\poinwhitecomb, {
	|atk 0.01 rel 1.0 lpfmin 50 lpfmax 10000|
	var snd, env, freq;
	freq = \freq.kr(100);
	freq = Env([freq, freq * \pitchenv.kr(10), freq], [atk, rel], 'exp').kr(0);
	env = Env.perc(atk, rel, \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = LFSaw.ar(freq, 0, 0.5);
	snd = snd + CombC.ar(WhiteNoise.ar(0.1), 0.2, 1/(freq *2), 1);
	snd = RLPF.ar(snd, Env([lpfmin, lpfmax, lpfmin], [\lpfatk.kr(0.03), \lpfrel.kr(1)], 'exp').kr(0), \rq.kr(0.3));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd.tanh;
	snd = FreeVerb.ar(snd, \verb.kr(0), \room.kr(1));
	Out.ar(\out.kr(0), snd * env * 1/2);
}).add;

SynthDef(\plum, {
	|atk 0.01 rel 1.0 lpfmin 50 lpfmax 10000|
	var snd, env, freq;
	freq = \freq.kr(100);
	env = Env.perc(atk, rel, \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = LFSaw.ar(freq, 0, 0.5);
	snd = RLPF.ar(snd, Env([lpfmin, lpfmax, lpfmin], [\lpfatk.kr(0.03), \lpfrel.kr(1)], 'exp').kr(0), \rq.kr(0.3));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\sawtouch, {
	|atk 0.01 rel 1.0 lpfmin 50 lpfmax 10000|
	var snd, env, freq;
	freq = \freq.kr(100);
	env = Env.perc(atk, rel, \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = LFSaw.ar(Env([freq, freq*10, freq], [atk * 2, rel /2], 'exp').kr(0), 0, 0.5);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * env;
	Out.ar(\out.kr(0), snd);
}).add;

// changed name from 'fm' fo fmeli

SynthDef(\fmeli, {
	arg mRatio=1, cRatio=1,
	index=0.2, iScale=5, ic_atk=4, ic_rel=(-4),
	amp=0.2, atk=0.01, rel=3, pan=0;
	var freq, car, mod, env, iEnv, mod2;
	iEnv = EnvGen.kr(
		Env(
			[index, index*iScale, index],
			[atk, rel],
			[ic_atk, ic_rel]
		)
	);
	freq = VarLag.kr(\freq.kr, \gliss.kr(0.1));
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	mod2 = SinOsc.ar(freq/10, mul:freq/10 * iEnv);
	mod = SinOsc.ar(freq * mRatio + mod2, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;

SynthDef(\rresonrandom, {
	var snd, env;
	env = Env.linen(\atk.kr(3), \sus.kr(1.0), \rel.kr(7.0), \amp.kr(1), 'sine').kr(2);
	snd = LFClipNoise.ar(\density.kr(10), 0.125);
	snd = Resonator.ar(snd, \freq.kr(100) * 1.66, 0.00001, 24, 0.5, 0.3, 0.3);
	snd = Pan2.ar(snd, SinOsc.kr(5, 0, 0.7));
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\vibratosinfb, {
	|atk 3 sus 1 rel 7 amp 1 relv 6 rate 6 depth 0.02|
	var snd, vibrato, env;
	vibrato = Vibrato.ar(\freq.kr(100), rate, Env.linen(atk, 1, relv, depth, 'sine').kr(0), \delay.kr(0), \onset.kr(0.0));
	env = Env.linen(atk, sus, rel, amp, 'sine').kr(2);
	snd = SinOscFB.ar(vibrato, \feedback.kr(1/2), 0.1);
	snd = RLPF.ar(snd, \lpf.kr(10000), \rq.kr(1.0));
	snd = FreeVerb.ar(snd, \reverb.kr(0), \room.kr(0.5));
	snd = Pan2.ar(snd * env, \pan.kr(0));
	Out.ar(\out.kr, snd);
}).add;

SynthDef(\fml, {
	arg out = 0, freqA = 100, freqB = 100, time = 0, mRatio=1, cRatio=1,
	index1 = 20, index2 = 20, index0 = 0, iScale=0.05, cAtk=4, cRel=(-4),
	amp=0.2, atk=0.01, rel=3, pan=0;
	var freq, car, mod, env, iEnv, index;
	index = Line.kr(index1, index2, index0);
	iEnv = EnvGen.kr(
		Env(
			[index, index*iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	freq = Line.kr(freqA, freqB, time, 1, 0, 0);
	env = EnvGen.kr(Env.perc(atk,rel, curve:[cAtk,cRel]),doneAction:2);
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

SynthDef(\fmgrain, {
	var snd, env;
	env = Env.perc(\atk.kr(0.1), \rel.kr(3.0), \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = FMGrain.ar(Dust.ar(\density.kr(1)), \grainDur.kr(1.0), \freq.kr(100), \freq.kr(100), \index.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\fmgrainmono, {
	var snd, env;
	// env = Env.perc(\atk.kr(0.1), \rel.kr(1.0), \amp.kr(1.0), \curve.kr(-4)).kr(2);
	snd = FMGrain.ar(Dust.kr(\density.kr(1)), \grainDur.kr(1.0), \carfreq.kr(100), \modfreq.kr(100), \index.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bpfwhite, {
	var snd, env, freq;
	freq = \freq.kr(400);
	env = Env.linen(\atk.kr(0.01), \sus.kr(1), \rel.kr(3), 1, \curve.kr('sine')).kr(2);
	snd = WhiteNoise.ar(0.1).lag(\smooth.kr(0.1/2));
	snd = BPF.ar(snd, freq, \rq.kr(0.00001), 300000);
	// snd = CombC.ar(snd, 0.2, 1/(freq * 2), 0.1);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1));
}).add;

SynthDef(\bpfwhitecomb, {
	var snd, env, freq;
	freq = \freq.kr(400);
	env = Env.linen(\atk.kr(0.01), \sus.kr(1), \rel.kr(3), 1, \curve.kr('sine')).kr(2);
	snd = WhiteNoise.ar(0.1).lag(\smooth.kr(0.1/2));
	snd = BPF.ar(snd, freq, \rq.kr(0.00001), 300000);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), \comb.kr(0.1));
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1));
}).add;

// changed freq from variable to arg for use of lag in ndef
SynthDef(\bassbynathan, {
	var snd, auto, trig, freq;
	freq = \freq.kr(40, 1);
	trig = Dust.ar(3);
	trig = ToggleFF.ar(trig).lag(\lag.kr(3));
	auto = trig.lagud(0.1, 0.3);
	snd = Saw.ar(freq);
	snd = Splay.ar(snd);
	snd = (snd * 3).fold2;
	snd = RLPF.ar(snd, freq * 10, 0.1);
	/*	snd = (snd * 5).fold2;
	snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
	snd = (snd * 5).fold2;*/
	snd = MoogFF.ar(snd, auto.linexp(0, 1, \floor.kr(100), 20000), 0, 0, 2);
	snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
	snd = (snd * 3.dbamp).tanh;
	snd = HPF.ar(snd, 100);
	Out.ar(\out.kr(0), snd * \amp.kr(0.5));
}).add;

SynthDef(\erowd, {
	|freq 40|
	var snd, auto, trig, env;
	env = Env.linen(\atk.kr(0.01), \sus.kr(0), \rel.kr(1.0), 1.0, \curve.kr(-4)).kr(2);
	trig = Dust.ar(3);
	trig = ToggleFF.ar(trig).lag(\lag.kr(3));
	auto = trig.lagud(0.1, 0.3);
	snd = Saw.ar(freq);
	snd = Splay.ar(snd);
	snd = (snd * 3).fold2;
	snd = RLPF.ar(snd, freq * 10, 0.1);
	/*	snd = (snd * 5).fold2;
	snd = RLPF.ar(snd, freq * 8 * TRand.ar(1, 4, trig), 0.5);
	snd = (snd * 5).fold2;*/
	snd = MoogFF.ar(snd, auto.linexp(0, 1, \floor.kr(100), 20000), 0, 0, 2);
	snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(0.5, [0, pi]).range(0, 0.001));
	snd = (snd * 3.dbamp).tanh;
	snd = HPF.ar(snd, 100);
	Out.ar(\out.kr(0), snd * env * \amp.kr(0.5));
}).add;

SynthDef(\pulsardm, { |out, gate = 1, bufNum, pos = 0.5, trigRate = 100, trigRateOsc = 100,
	trigRateDev = 0, overlap = 0.3,
	atk = 0.005, rel = 0.005, // attack and release of overall envelope, not grain envelope
	susLevel = 1, amp = 0.1|
	var env, sig, trig = Impulse.ar(
		trigRate * LFDNoise3.ar(trigRateOsc).range(1 / (1 + trigRateDev), (1 + trigRateDev))
	);
	sig = TGrains.ar(
		numChannels: 2,
		trigger: trig,
		bufnum: bufNum,
		rate: \rate.kr(1),
		centerPos: pos * BufDur.kr(bufNum),
		dur: overlap / trigRate,
		pan: Dseq([-1, 1], inf)
	);
	// sig = BPF.ar(sig, 2000);
	// env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0));
	env = EnvGen.ar(Env.adsr(atk, atk, susLevel, rel, 1), gate, doneAction: 2);
	OffsetOut.ar(out, sig * env * amp)
}).add;

SynthDef(\coloredechoes, {|t_trig|
	var snd, buffer;
	buffer = \buffer.kr(0);
	snd = PlayBuf.ar(
		2,
		buffer,
		Array.series(20, 0.98, 0.0001 * \color.kr(1)) * BufRateScale.ir(buffer),
		loop: \loop.kr(1),
		doneAction:2

	) * 1/3;
	snd = Splay.ar(snd * 1).tanh;
	snd = snd * XLine.kr(1, 0.001, \fadetime.kr(10), doneAction:2);
	// snd = FreeVerb2.ar(snd[0], snd[1]);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;

// feedback donkey

SynthDef(\feedbus, {arg in = 100, out = 0, amp = 40;
	var sig;
	sig = In.ar(in, 2);
	sig = BLowShelf.ar(sig, 1200, 1, -50);
	// sig = Formant.ar(sig, [MouseY.kr(1000, 2000), MouseX.kr(1000, 2000)], 800, 0.1);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;

SynthDef(\sinesawperc, {arg out, t_trig = 1, pan = 0, atk = 0.01, rel = 1.0, amp = 1, curve = 'lin', sawmul = 0.001;
	var sig, sine, saw, env, freq;
	// gate = KeyState.kr(5, 0, 1);
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	// sawmul = VarLag.kr(\sawmul.kr(0.001), \gliss2.kr(0));
	env = Env.perc(atk, rel).kr(2, t_trig);
	sine = SinOsc.ar({freq* rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
	saw = LFSaw.ar({freq * rrand(0.99, 1.01)}!3, 0, sawmul);
	sig = sine + saw;
	sig = Splay.ar(sig * env * 100, 1, 1, pan).tanh;
	sig = Out.ar(out, sig * amp);
}).add;


SynthDef(\donkey, { arg out=100, gate = 1, in=100, atk = 3, level = 1, rel = 3, brf = 100, brq = 10, hpf = 1000;
	var input, sig, env;
	env = Env.asr(atk, level, rel).kr(2, gate);
	input = InFeedback.ar(in, 1);
	sig = SinOsc.ar(input * SinOsc.kr(MouseX.kr(0, 3), 1, 300) + MouseY.kr(0, 100), 0, 1);
	Out.ar(out, sig!2 * env);

}).add;

SynthDef("pluk", {arg out, pan, amp = 0.1, freq = 440, decay = 5, dampen = 0.1;
	var env, snd;
	// env = Env.linen(0, decay, 0).kr(doneAction: 2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: dampen);
	snd = Pan2.ar(snd, pan);
	DetectSilence.ar(snd, doneAction: 2);
	snd = LPF.ar(snd, \lpf.kr(10000));
	Out.ar(out, snd);
}).add;

SynthDef(\sweep, {|gate 1|
	var snd, freq, amp;
	freq = \freq.kr(Env.newClear(3).asArray);
	freq = EnvGen.kr(freq, gate, doneAction:2);
	amp = \amp.kr(Env.newClear(3));
	amp = EnvGen.kr(amp, gate);
	snd = SinOsc.ar(freq, 0, amp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bwing, {
	arg
	add = 1000,
	freq = 10000,
	phase = 0,
	pan = 0,
	amp = 0.3,
	rel = 0.1;
	var sig, env;
	env = Env.perc(0.01,rel).kr(2);
	sig = SinOsc.ar(1, 1, add);
	sig = SinOsc.ar(sig, 1, 10000);
	sig = SinOsc.ar(sig, 0.1);
	sig = sig * env;
	// sig = FreeVerb.ar(sig, 0.7, 0.9);
	sig = Pan4.ar(sig);
	Out.ar(0, sig * amp);
}).add;


// gated version
SynthDef(\stkBowed,{arg out=0,freq=220,rel =0.1,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
	var sig,env;
	env = EnvGen.kr(Env.asr(0,1,rel),gate,doneAction:2);
	sig = StkInst.ar(
		Stk.at("Bowed"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,
			bowpressure,
			4,
			bowposition,
			11,
			vibfreq,
			1,
			vibgain,
			128,
			loudness

	])*env;
	Out.ar(out, sig.dup);
}).add;

SynthDef(\stkSaxofony,{arg out=0, rel = 0.1, freq=220,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
	var sig,env;
	env = EnvGen.kr(Env.asr(0,1,rel),gate,doneAction:2);
	sig = StkInst.ar(
		Stk.at("Saxofony"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,
			bowpressure,
			4,
			bowposition,
			11,
			vibfreq,
			1,
			vibgain,
			128,
			loudness

	])*env;
	sig = Pan2.ar(sig, \pan.kr(0)) * 1.3;
	Out.ar(out, sig);
}).add;



// envelope one-shot version
SynthDef(\stkbowed, {arg gate = 1, amp=1, bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, bowvelocity = 100, loudness=128, pan = 0;
	var sig, freq, env;
	env = Env.linen(\atk.kr(0.1), \sus.kr(1), \rel.kr(5),1, \curve.kr('sine')).kr(2);
	freq = \freq.kr(100, \glissando.kr(0));
	sig = StkInst.ar(
		Stk.at("Bowed"),
		freq,
		gate,
		amp,
		0.5,
		[
			2,
			bowpressure,
			4,
			bowposition,
			11,
			vibfreq,
			1,
			vibgain,
			100,
			bowvelocity,
			128,
			loudness

	]);
	sig = Pan2.ar(sig * env, pan);
	Out.ar(\out.kr(0), sig);
}).add;


SynthDef("hypersaw1", {
	arg freq = 180, atk=0.01, sus=0.7, rel=4, out;
	var snd, env;
	env = Env.linen(atk, sus, rel).kr(2);
	snd = Splay.ar(Saw.ar(freq + (0, 0.1..1)));
	// snd = Splay.ar(Saw.ar(freq + Array.geom(10, 0.1, 1.1)));
	snd = snd * env;
	Out.ar(out, snd * env * 0.5);
}).add;

SynthDef(\synpi, {
	|stringdecay 10 out 0|

	Mix.ar(Array.fill(1, {	// mix an array of notes

		var delayTime, pitch, detune, strike, hammerEnv, hammer, snd, env;



		pitch = \freq.kr(1000).cpsmidi;

		snd = Mix.ar(Array.fill(3, { arg i;

			detune = #[-0.05, 0, 0.04].at(i);

			delayTime = 1 / (pitch + detune).midicps;

			hammer = LFNoise2.ar(\harm.kr(1).linlin(0, 1, 3000, 20000), Env.perc(0.008, 0.1).kr(0));

			CombC.ar(hammer,

				delayTime,

				delayTime,

				stringdecay)

		}));

		snd = Pan2.ar(snd,\pan.kr(0));
		env = Env.linen(\atk.kr(0.01), \sus.kr(1.0), stringdecay).kr(2);
		snd = snd * env * 0.1;
		Out.ar(out, snd);

	}))

}).add;

SynthDef(\perconvol, {
	arg frequencies = #[ 2408.1393930766, 67.381566708784, 141.76650188961, 4379.2612701457, 387.24758031496, 422.57985140667, 206.26147638206, 127.96288310263, 1352.752004142, 616.80948042647 ],
	rate = 0.7,
	ratelfo = 0.5,
	rateDev = 0.5,
	ampcd = 0.05,
	start =  96000*4,
	hpf = 50,
	rel = 0.5,
	amp = 2;

	var input, kernel, sig, env, buffer;
	buffer = \buffer.kr;
	env = Env.perc(0.01, rel).kr(2);
	kernel = PlayBuf.ar(
		2,
		buffer,
		rate: rate * LFNoise2.kr(ratelfo, rateDev, 1),
		startPos: start,
		loop:1);
	input = SinOsc.ar(frequencies) * 0.5;

	// must have power of two framesize
	sig = Convolution.ar(input, kernel, 512 * 4, 2);
	sig = BRF.ar(sig, frequencies, 0.1, 1);
	sig = BRF.ar(sig, 150, 2) * 2;
	sig = HPF.ar(sig, hpf);
	sig = Splay.ar(sig * env);
	sig = CrossoverDistortion.ar(sig, ampcd, 1);
	Out.ar(0, sig * amp);
}).add;

SynthDef(\play3, {
	arg
	lfmul = 0.1,
	lfspeed= 0.1,
	ratemax = 3.8,
	rate = 1,
	rel = 0.5,
	ampcd = 0.05,
	start =  1,
	hpf = 50;

	var sig, env, buffer;
	buffer = \buffer.kr(~armoire);
	env = Env.perc(0.01, rel).kr(2);
	sig = PlayBuf.ar(
		2,
		buffer,
		rate: rate * LFNoise2.kr(lfspeed, lfmul, ratemax),
		// rate,
		startPos: start,
		loop:0);
	sig = BRF.ar(sig, \brf.kr(20), \brq.kr(1));
	sig = HPF.ar(sig, hpf);
	// sig = Pan2.ar(sig);
	sig = CrossoverDistortion.ar(sig, 0.05, \smooth.kr(1));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), 2);
	sig = sig * env;
	Out.ar(0, sig * \amp.kr(1));
}).add;

SynthDef(\play11, {
	var snd, env, buffer, trig, done;
	buffer = \buffer.kr;
	env = Env.perc(\atk.kr(0), \rel.kr(2)).kr(2);
	snd = PlayBuf.ar(2, buffer, \rate.kr(1) * BufRateScale.kr(buffer), 1, 0, \loop.kr(0), doneAction:0);
	snd = CombC.ar(snd, 0.2, 1/SinOsc.ar(\freq.kr(200), 0, \mul.kr(10), \add.kr(100)), 1);
	snd = snd * 0.1 * env * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\saw2, {
	arg freq = 440, mul = 0.1, rel = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, combf = 50;
	var env, sig;
	env = Env.perc(\atk.kr(0.5), rel, 1, curve).kr(2);
	sig = LFSaw.ar(freq, 0, mul);
	// sig = CombC.ar(sig, 0.2, 1/combf, 10);
	sig = sig.blend(CombC.ar(sig, 0.2, 1/combf, 10), 1);
	sig = FreeVerb.ar(sig, mix, room);
	sig = BRF.ar(sig, 50, 2);
	// sig = BRF.ar(sig, 100, 2);
	// sig = BRF.ar(sig, 3000, 5);
	sig = Pan2.ar(sig, pan);
	Out.ar(\out.kr(0), sig * env * amp);
}).add;

SynthDef(\csaw1, {
	arg freq = 440, mul = 0.1, release = 1, curve = -4, pan = 0, mix = 0, room = 0.5, amp = 1, legato, comb = 0.02;
	var env, sig;
	env = Env.perc(0.5, release, 1, curve).kr(2);
	sig = LFSaw.ar(freq, 0, mul);
	sig = CombC.ar(sig, 0.2, comb, 10);
	// sig = FreeVerb.ar(sig, mix, room);
	// sig = GVerb.ar(sig);
	sig = BRF.ar(sig, 50, 2);
	sig = Pan2.ar(sig, pan);
	Out.ar(\out.kr(0), sig * env * amp);
}).add;

SynthDef(\ixxbass, {
	| freq = 110, index  = 10, lpfreq = 500, sindex = 3.84, amp = 0.8, out = 0, gate = 1|
	var o = Pulse.ar(freq),
	e  = \env.kr(Env.newClear(4).asArray),
	ee = EnvGen.kr(e,gate,doneAction:2),
	cf = ee.exprange(55,lpfreq);
	o  = [ o,
		PitchShift.ar(o,0.3,1.0001,1e-4,0.2),
		PitchShift.ar(o,0.3,0.995,1e-4,0.2)
	].sum/3;
	o = o + Pulse.ar(freq/2,0.5,0.1);
	o = o + SinOsc.ar(freq/2,0,0.1);
	o = RLPF.ar(o, cf);
	o = tanh(sin(sindex*o));
	o = GVerb.ar(0.3*o,99,7).mean;
	o = RLPF.ar(o,(4*cf).clip(20,20000));
	o = o + LPF.ar(tanh(4*o),80,1.0);
	3.do { o = HPF.ar(o, 35) };
	o = BLowShelf.ar(o, 110, 1,6.0.neg);
	o = BPeakEQ.ar(o,3169,0.8,7.neg);
	o = Compander.ar(o,o,16.neg.dbamp,1,1/6,0.1,0.2,1.0);
	o = Pan2.ar(o, \pan.kr(0));
	Out.ar(out, ee*(amp*Limiter.ar(LeakDC.ar(o),0.9)));
}).add;


SynthDef(\percsine, {arg out = 0, t_trig = 1, pan = 0, atk = 0.01, rel = 1, curve = -3, amp = 1;
	var sig, env, freq;
	freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
	env = Env.perc(atk, rel, 1, curve).kr(2, t_trig);
	sig = SinOsc.ar(freq);
	sig = LPF.ar(sig, \lpf.kr(2e4));
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\envsine, {
	var snd, ea, eea, ef, eef;
	ea = \amp.kr(Env.newClear(3).asArray);
	ef = \freq.kr(Env.newClear(5).asArray);
	eea = EnvGen.kr(ea, 1, doneAction:2);
	eef = EnvGen.kr(ef, 1);
	snd = SinOsc.ar(eef, 0, eea) * 0.1;
	Out.ar(\out.kr(0), snd!2);
}).add;

// changed to percsinefb from percsinfb + feedback 1->1/2

SynthDef(\percsinefb, {arg out = 0, t_trig = 1, pan = 0, atk = 0.01, rel = 1, curve = -3, amp = 1;
	var sig, env, freq;
	freq = VarLag.kr(\freq.kr(200), \gliss.kr(0), \cruve.kr(0));
	env = Env.perc(atk, rel, 1, curve).kr(2, t_trig);
	sig = SinOscFB.ar(freq, \feedback.kr(1/2));
	sig = LPF.ar(sig, \lpf.kr(2e4));
	sig = Pan2.ar(sig, pan);
	// sig = PanAz.ar(s.options.numOutputBusChannels, sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\percsaw, {arg out = 0, atk = 0.01, rel = 1, level = 0.5, curve = -3, amp = 1;
	var sig, env, freq;
	freq = VarLag.kr(\freq.kr(200), \gliss.kr(0));
	env = Env.perc(atk, rel, level, curve).kr(2);
	sig = LFSaw.ar(freq, 0, 0.1);
	sig = sig * env * amp;
	sig = PanAz.ar(2, sig, \pan.kr(0) + 1.5);
	Out.ar(out, sig);
}).add;

SynthDef(\supersaw, {
	var saw = LFSaw.ar(\freq.kr(100, \lag.kr(0)), 1);
	var trig = ToggleFF.ar(Trig.ar(saw.neg, 2/SampleRate.ir));
	a = saw.range(0,2pi).sin;
	b = saw.range(0,pi).sin;
	z = Select.ar(trig, [a,b]).dup*0.1;
	Out.ar(\out.kr(0), z)
}).add;

SynthDef(\playbuf, {arg atk = 0.1, trigger = 1, time = 0, rel = 7, gate = 1, channels = 2, buffer, rate = 1, pos = 0, amp = 1, pan = 0, out, loop = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trigger, pos * BufFrames.ir(buffer), loop);
	// sig = VarLag.ar(sig, time);
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(out, sig * amp);
}).add;

SynthDef(\playmono, {arg atk = 0.1, trigger = 1, time = 0, rel = 7, gate = 1, channels = 2, buffer, rate = 1, pos = 0, amp = 1, pan = 0, out, loop = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate, trigger, pos * BufFrames.ir(buffer), loop);
	// sig = VarLag.ar(sig, time);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
}).add;

SynthDef(\ibuf, {arg atk = 0.01, time = 0, rel = 1, gate = 1, channels = 2, buffer, rate = 1, pos = 0, amp = 0.5, pan = 0, out, loop = 0;
	var sig, env, trigger;
	env = Env.perc(atk, rel, 1).kr(2, gate);
	trigger = Impulse.ar(\trig.kr(1));
	sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trigger, pos * BufFrames.ir(buffer), loop);
	sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(out, sig * amp);
}).add;

SynthDef(\sinesaw, {arg out, pan = 0, gate = 1, legato, atk = 3, rel = 10, amp = 1, curve = 'lin', sawmul = 0.001;
	var sig, sine, saw, env, freq;
	// gate = KeyState.kr(5, 0, 1);
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	// freq = \freq.kr(100);
	// sawmul = VarLag.kr(\sawmul.kr(0.001), \gliss2.kr(0));
	env = Env.asr(atk, 2, rel, curve).kr(2, gate);
	sine = SinOsc.ar({freq* rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
	saw = LFSaw.ar({freq * rrand(0.99, 1.01)}!3, 0, sawmul);
	sig = sine + saw;
	sig = sig * env;
	sig = Splay.ar(sig, 1, 1, pan);
	Out.ar(out, sig * amp);
}).add;

// pushed amp from 1 to 5

SynthDef(\sinesaw1, {arg out, pan = 0, legato, atk = 3, rel = 10, amp = 5, curve = 'lin', sawmul = 0.001;
	var sig, sine, saw, env, freq;
	// gate = KeyState.kr(5, 0, 1);
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
	// sawmul = VarLag.kr(\sawmul.kr(0.001), \gliss2.kr(0));
	env = Env.perc(atk, rel, 2, curve).kr(2);
	sine = SinOsc.ar({freq* rrand(0.99, 1.01)}!3, 0, 0.1) * 0.5;
	saw = LFSaw.ar({freq * rrand(0.99, 1.01)}!3, 0, sawmul);
	sig = sine + saw;
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(1), 1, pan);
	Out.ar(out, sig * amp);
}).add;


SynthDef("pluck", {arg out = 0, pan = 0, amp = 0.1, freq = 440, decay = 5, dampen = 0.1;
	var env, snd;
	// env = Env.linen(0, decay, 0).kr(doneAction: 2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: dampen);
	snd = PanAz.ar(2, snd, pan);
	Out.ar(out, snd);
}).add;

// changed from sv

SynthDef("sevensaws", {arg out, gate=1, freq = 32.1, att=0, rel=2, amp = 0.5;
	var snd, env;
	env = Env.adsr(att, 0.4, amp, rel).kr(2, gate);
	snd = Splay.ar(BPF.ar(Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1));
	snd = snd * env;
	OffsetOut.ar(out, snd);
}).add;

SynthDef("sevenSaw", {arg out, gate=1, freq = 32.1, att=0, rel=2, amp = 0.5;
	var snd, env;
	env = Env.adsr(att, 0.4, amp, rel).kr(2, gate);
	snd = Splay.ar(BPF.ar(Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1));
	snd = snd * env;
	OffsetOut.ar(out, snd);
}).add;

SynthDef("10sines", {arg out, gate = 1, lo = 20, hi = 20000, pan = 0, att = 0.01, amp = 0.1, rel = 1;
	var snd, array, env;
	env = Env.asr(att, amp, rel).kr(2, gate);
	array = {exprand(20,20000)}!100;
	snd = Splay.ar(SinOsc.ar(array, mul:0.1));
	snd = snd * env;
	OffsetOut.ar(out, snd);
}).add;

SynthDef(\blosc2randfm, {|freq #[100, 1000] mul 1|
	var snd, lfo, sine, env;
	env = Env.linen(\atk.kr(30), 0, \rel.kr(30)).kr(2);
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	snd = FreqShift.ar(snd, freq);
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100);
	// snd = XFade2.ar(snd, JPverb.ar(snd, 0.01, 07), \wet.kr(-0.7));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1));
}).add;

SynthDef(\tinnitus, {
	|out = 0, gate = 1, atk = 3, bassfreq = 50|
	var sound, env, width;
	env = Env.asr(atk, 1, 7).kr(2, gate);
	sound = WhiteNoise.ar(0.03);
	sound = CrossoverDistortion.ar(sound, 1, 0.99);
	sound = sound + SinOsc.ar(bassfreq, 0, 0.2);
	sound = sound + LFTri.ar(LFNoise1.kr(10).range(10000, 10100), 0, 0.1);
	sound = Limiter.ar(sound, \limiter.kr(0.1));
	sound = sound * env;
	Out.ar(out, sound!2);
}).add;

SynthDef("kick", {arg out = 0, amp = 0.3, freq = 50, gliss = 0.9, atk = 0.01, rel = 0.45, pan = 0;
	var env, snd, ramp;
	env = Env.perc(atk, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: freq,
		end: freq * gliss,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

SynthDef("k", {arg out = 0, amp = 0.5, freq = 60, p_env = 5, atk = 0.01, rel = 1;
	var env, snd, ramp;
	env = Env.perc(atk, rel, amp).kr(doneAction: 2);
	ramp = Env([
		freq * p_env,
		freq,
		freq,
		freq * 0.9
	],
	[
		1/100,
		rel/8,
		rel

	]).kr(0);
	snd = SinOscFB.ar(freq: ramp, feedback: \fb.kr(0.0),  mul: env);
	snd = Select.ar(\distortion.kr(0), [snd, snd.clip, snd.tanh, snd.sin, snd.cos, snd.clip2, snd.fold, snd.distort]);
	snd = Pan2.ar(snd);
	Out.ar(out, snd);
}).add;

SynthDef("fmk", {arg out = 0, amp = 0.5, freq = 60, p_env = 5, atk = 0.01, rel = 1;
	var env, snd, ramp;
	env = Env.perc(atk, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: freq * p_env,
		end: freq,
		dur: 1/50
	);
	snd = FM7.ar(freq: ramp,  mul: env);
	snd = Pan2.ar(snd);
	Out.ar(out, snd);
}).add;

SynthDef("mkick", {
	var snd, trig, env, freq, disto, sustain;

	freq = \freq.kr(50) * Line.kr(2, [1.01, 0.99], 0.01);
	snd = SinOsc.ar(freq);

	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0), 1).kr(2);
	snd = snd * env;

	disto = snd * (\d.kr(0) * 100 + 10);
	disto = Select.ar(\mode.kr(0), [disto.sin, disto.cos, disto.tanh, disto.distort, disto.softclip]);

	snd = snd.blend(disto * 0.2, 0.4);
	snd = LeakDC.ar(snd);

	// snd = Balance2.ar(snd[0], snd[1], \pan.kr(0.5) * 2 -1);
	Out.ar(\out.kr(0), snd * \amp.kr(1));
}).add;



// Changed previous line to manually update resonator frequency + took out Gverb
/*SynthDef(\resk, {
var snd, trig, freq, freqs, space;
freq = \freq.kr(40) * Line.kr(10, [1, 1.01], 0.01);
snd = SinOsc.ar(freq, 0);
snd = Env.perc(0.01, 1, 0.5).ar(2) * snd;
// snd = snd.blend(Resonator.ar(snd, freq * 8, resolution: 24, damping: MouseY.kr(0.7, 0.3)));
snd = snd.blend(Resonator.ar(snd, \resf.kr(100), resolution: 24;, damping: 0.3));
// snd = GVerb.ar(snd, 1, 0.1, drylevel: 1);
snd = LeakDC.ar(snd);
Out.ar(\out.kr(0), snd);
}).add;*/

SynthDef(\resk, {
	var snd, trig, freq, freqs, space;
	freq = \freq.kr(40) * Line.kr(10, [1, 1.01], 0.01);
	snd = SinOsc.ar(freq, 0);
	snd = Env.perc(0.01, 1, 0.5).ar(2) * snd;
	snd = snd.blend(Resonator.ar(snd, freq * 8, resolution: 24, damping: MouseY.kr(0.7, 0.3)));
	// snd = snd.blend(Resonator.ar(snd, \resf.kr(100), resolution: 24;, damping: 0.3));
	snd = GVerb.ar(snd, 1, 0.1, drylevel: 1);
	snd = LeakDC.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef("hh", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, freq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: freq, mul: env);
	snd = RLPF.ar(snd, \lpf.kr(20000), \lpq.kr(1));
	Out.ar(out, Pan2.ar(snd, pan));
}).add;


SynthDef("wobble", {arg gate=1, freq = 32.1, att=1, sus=0.7, rel=2;
	var snd, env;
	env = Env.adsr(att, 0.4, sus, rel);
	snd = Splay.ar(BPF.ar(Saw.ar(freq + ((0, 0.1..6))), LFNoise2.kr(3).range(100,1000), 1, 1));
	Out.ar(0, snd * env.kr(doneAction: 2, gate: gate));
}).add;
/*
SynthDef(\majorchord, {
var chord = Array.makeScaleCps(300, 'major', 100, 10000);
var notes = {chord.choose}!30;
var env = Env.perc(\atk.kr(0.01), \rel.kr(3), 0.1).kr(2);
var sound = SinOsc.ar(notes, 0);
sound = Splay.ar(sound, \spread.kr(1), 1, \pan.kr(0));
Out.ar(\out.kr(0), sound * env);
}).add;*/


SynthDef("moogbass", {
	arg out = 0, pan = 0, freq = 440, amp = 1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, atk = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

	var osc, filter, env, filterenv, snd, chorusfx, envperc, envasr;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.asr(0.2, 1, 0.2),
		gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	envasr = EnvGen.ar(
		envelope: Env.adsr(atk, dec, sus, rel, amp * 0.1),
		gate: gate,
		doneAction: 2);

	// envperc = Env.perc(atk, rel, amp * 0.1).ar(2, gate);

	snd = (0.7 * filter + (0.3 * filter.distort)) * envasr;

	chorusfx = Mix.fill(7, {

		var maxdelaytime = rrand(0.005, 0.02);
		DelayC.ar(
			in: snd,
			maxdelaytime: maxdelaytime,
			delaytime: LFNoise1.kr(
				freq: Rand(5, 10),
				mul: 0.25 * maxdelaytime,
				add: 0.75 * maxdelaytime)
		)
	});

	snd = snd + (chorusfx * chorus);

	Out.ar(out, Pan2.ar(snd, pan));

}).add;

SynthDef("moogbassl", {
	arg out = 0, pan = 0, freq = 440, amp = 1, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, atk = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

	var osc, filter, env, filterenv, snd, chorusfx, envperc;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.asr(0.2, 1, 0.2),
		gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	env = EnvGen.ar(
		envelope: Env.linen(atk, sus, rel, amp * 0.1),
		gate: gate,
		doneAction: 2);

	// envperc = Env.perc(atk, rel, amp * 0.1).ar(2, gate);

	snd = (0.7 * filter + (0.3 * filter.distort)) * env;

	chorusfx = Mix.fill(7, {

		var maxdelaytime = rrand(0.005, 0.02);
		DelayC.ar(
			in: snd,
			maxdelaytime: maxdelaytime,
			delaytime: LFNoise1.kr(
				freq: Rand(5, 10),
				mul: 0.25 * maxdelaytime,
				add: 0.75 * maxdelaytime)
		)
	});

	snd = snd + (chorusfx * chorus);

	Out.ar(out, Pan2.ar(snd, pan));

}).add;

SynthDef(\buffercombmodulation, {
	var snd, env, buffer, trig, done;
	buffer = \buffer.kr;
	// trig = Dust.kr(\density.kr(1));
	trig = 1;
	env = Env.perc(\atk.kr(0), \rel.kr(3)).kr(2);
	snd = PlayBuf.ar(2, buffer, \rate.kr(1) * BufRateScale.kr(buffer), 1, 0, \loop.kr(0), doneAction:0);
	snd = CombC.ar(snd, 0.2, 1/SinOsc.ar(\freq.kr(200), 0, \mul.kr(10), \add.kr(100)), 1);
	snd = snd * 0.1 * env * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\lowmarimba, {|gate 1 out 0 freq 100 amp 0.1|
	var snd, env;
	env = Env.perc(0, 1, 1, 10).kr(2, gate);
	snd = GrayNoise.ar(Env.perc(0, 0.01).kr(0));
	snd = Ringz.ar(snd, freq, \decay.kr(1.0)) / 10;
	snd = snd * env * amp;
	snd = PanAz.ar(2, snd, \pan.kr(0));
	Out.ar(out, snd)
}).add;

SynthDef(\sinoscfbmod, {
	var snd, env;
	env = Env.linen(\atk.kr(1), \sus.kr(1), \rel.kr(7), \amp.kr(1), \curve.kr('sine')).kr(2);
	snd = SinOscFB.ar(\freq.kr(100) * (LFSaw.kr(\speed.kr(3), 0, \detune.kr(0.05), 1).abs * (-1)), LFSaw.kr(\feedbackMod.kr(0.3)).abs * 1.5, 0.1);
	snd = LPF.ar(snd, \lpfreq.kr(1000));
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\sinoscfbmod_rotate, {
	var snd, env;
	env = Env.linen(\atk.kr(1), \sus.kr(1), \rel.kr(7), \amp.kr(1), \curve.kr('sine')).kr(2);
	snd = SinOscFB.ar(\freq.kr(100) * (LFSaw.kr(\speed.kr(3), 0, \detune.kr(0.05), 1).abs * (-1)), LFSaw.kr(\feedbackMod.kr(0.3)).abs * 1.5, 0.1);
	snd = LPF.ar(snd, \lpfreq.kr(1000));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = Rotate2.ar(snd[0], snd[1], SinOsc.kr(0.01));
	Out.ar(\out.kr(0), snd * env);
}).add;

~partialsbass = SynthDef(\partialsbass, {
	var sig, sig2, env, stereo, partials, amps;
	// partials = Array.series(16, 0.2, 0.05);
	partials = Array.series(16, 1, \stretch.kr(0.05) * (-1)).mirror;
	amps = Array.series(16, 0.5, -0.04).mirror;
	sig  = SinOsc.ar(\freq.kr(100)*partials, 0, 0.15*amps);
	env = Env.linen(\atk.kr(0.1), \sus.kr(0), \rel.kr(3), \amp.kr(1), \curve.kr('sine')).kr(2);
	sig = Splay.ar(sig);
	Out.ar(0, sig * env * 3);
}).add;

SynthDef(\partials, {
	var sig, sig2, env, stereo, partials, amps;
	// partials = Array.series(16, 0.2, 0.05);
	partials = Array.series(16, 1, -0.05).mirror;
	amps = Array.series(16, 0.5, -0.04).mirror;
	sig  = SinOsc.ar(\freq.kr(500)*partials, 0, 0.15*amps);
	env = EnvGen.kr(Env.perc(\atk.kr(0.01), \rel.kr(3)), doneAction: 2);
	sig = Splay.ar(sig);
	Out.ar(0, sig * env * 5 * \amp.kr(1));
}).add;

SynthDef(\in, {
	var snd;
	snd = SoundIn.ar(\channel.kr(0), \amp.kr(1));
	Out.ar(\out.ar(0), snd!2)
}).add;

SynthDef(\superharm, {|out = 0, sustain = 1, pan = 0, accelerate = 0, freq = 400, voice = 1, lfo=0.5, decay = 0.1, pitch1=1, pitch2=1|
	var sound, menv, env, es, os, as, fenv;
	menv = EnvGen.ar(Env.perc(0.05, 1.5), timeScale:sustain, doneAction:2);
	env = Array.fill(7, {EnvGen.ar(Env.perc(ExpRand(0.01, 0.05), ExpRand(0.5, 1.5)), timeScale:sustain)});
	freq = freq * XLine.ar(1, exp(accelerate), sustain);
	es = freq * [2,4,6,8,12,16,22] * pitch1;
	os = freq * [3,5,7,11,17,19,29] * pitch2;
	as = [10, 7, 5, 4, 3, 2, 1, 1]/100;
	es = SinOsc.ar(es, mul:as);
	es = BLowPass4.ar(es, 5*freq, 0.3) * env;
	os = SinOsc.ar(os, mul:as);
	os = BLowPass4.ar(os, 5*freq, 0.3) * env;
	sound = SinOsc.ar(freq, mul:menv*0.5) + Mix.ar( SelectX.ar(voice*SinOsc.kr(5, mul:0.5, add:0.5), [es, os]) );
	Out.ar(out, sound!2)
}).add;


SynthDef(\poom, {
	var sound, done;
	sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), Env.perc(\atk.kr(0.01), \rel.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0));
	// DetectSilence.ar(sound, doneAction:2);
	sound = Pan2.ar(sound, \pan.kr(0));
	sound = JPverb.ar(sound, \reverbTime.kr(0.00007), \damp.kr(0));
	sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
	DetectSilence.ar(sound, doneAction:2);
	Out.ar(\out.ar(0), sound)
}).add;

SynthDef(\pom, {
	var sound, done, mul;
	mul = Env.perc(\atk.kr(0.01), \rel.kr(3), 1, \curve.kr([-4.0, -4.0])).kr(0);
	sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), mul);
	DetectSilence.ar(sound, doneAction:2);
	sound = Pan2.ar(sound, \pan.kr(0));
	sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
	sound = RHPF.ar(sound, \hpf.kr(20));
	// sound = BPeakEQ.ar(sound, 150, 1, -6);
	sound = BPeakEQ.ar(sound, 150, \thin.kr(-6).linlin(-6, -32, 1, 5), \thin.kr(-6));
	Out.ar(\out.kr(0), sound)
}).add;

SynthDef(\poomdry, {
	var sound, done;
	sound = VarSaw.ar(\freq.kr(100), 0, Line.kr(1, 0, \atk.kr(0.01) + \rel.kr(3)), Env.perc(\atk.kr(0.01), \rel.kr(3), 1).kr(0));
	done = Done.kr(sound);
	sound = Pan2.ar(sound, \pan.kr(0));
	done = TDelay.kr(done);
	FreeSelf.kr(done);
	Out.ar(\out.ar(0), sound * \amp.kr(1))
}).add;

SynthDef(\poomono, {
	var sound, done;
	sound = VarSaw.ar(\freq.kr(100), 0, 0);
	DetectSilence.ar(sound, doneAction:2);
	sound = Pan2.ar(sound, \pan.kr(0));
	sound = JPverb.ar(sound, \reverbTime.kr(0.00007));
	sound = MoogLadder.ar(sound, \cutoff.kr(2000)) * \amp.kr(1);
	Out.ar(\out.ar(0), sound)
}).add;

// put back envelope

SynthDef(\analogbassdrum, {var snd, trig, env;
	env = Env.perc(0.01, 5, 1).kr(2);
	snd = AnalogBassDrum.ar(1, 0, \accent.kr(0.5), \freq.kr(50), \tone.kr(0.5), \decay.kr(0.5), \attackfm.kr(0.1), \resonance.kr(3))!2;
	snd = BPeakEQ.ar(snd, \freq.kr(50), 1, 30) * 3;
	DetectSilence.ar(snd, doneAction:2);
	snd = LPF.ar(snd);
	Out.ar(\out.kr(0), snd * env);
}).add;

SynthDef(\analogbassdrumdust, {var snd, trig;
	trig = Dust.kr(\density.kr(1));
	snd = AnalogBassDrum.ar(trig, 0, \accent.kr(0.5), \freq.kr(50), \tone.kr(0.5), \decay.kr(0.5), \attackfm.kr(0.1), \resonance.kr(3))!2;
	snd = BPeakEQ.ar(snd, 50, 1, 30) * 3;
	snd = LPF.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\blosc, {|freq 1030 mul 1|
	var snd, lfo, sine, env;
	env = Env.perc(\atk.kr(30), \rel.kr(30)).kr(2);
	lfo = LFNoise2.kr(0.3);
	sine = SinOsc.ar(freq, 0, mul);
	sine = sine * sine.range(\min.kr(20), \max.kr(2000));
	snd = BLOsc.ar(sine.lag(0.1), 0.5, \waveform.kr(0));
	snd = AnalogPhaser.ar(snd, sine, 1, 0.9, 0.1).tanh;
	// snd = HPF.ar(snd, 500);
	snd = Pan2.ar(snd, lfo / 2);
	snd = CombC.ar(snd, 0.2, 1/(freq * 2), 1, 0.2);
	snd = snd / (freq/100);
	// snd = XFade2.ar(snd, JPverb.ar(snd, 0.01, 07));
	Out.ar(\out.kr(0), snd * env * \amp.kr(1));
}).add;


// FXs

SynthDef(\resonator, {
	var snd = Resonator.ar(In.ar(\in.ar), \freq.kr(100), position: 0.0001, resolution: 24, structure: 0.5, brightness: 0.5, damping: \damping.kr(0.3));
	Out.ar(\out.ar, snd!2);
}).add;

SynthDef(\comb, {
	|out = 0, in = 100, freq = 100, decay = 1.0, atk = 0.1, rel = 100, amp = 1, mix = 1|
	var bus, snd, env;
	bus = In.ar(in);
	snd = CombC.ar(In.ar(in), 0.2, 1/freq, decay, amp);
	snd = XFade2.ar(bus, snd, mix*2-1);
	Out.ar(out, snd!2);
}
).add;

SynthDef(\freeverb, {
	var snd;
	snd = In.ar(\in.ar, 2);
	snd = FreeVerb.ar(snd, \mix.kr(0.3), \room.kr(0.5), \damp.kr(0.5), \amp.kr(1));
	Out.ar(\out.kr, snd);
}
).add;

SynthDef(\gverb, {
	var snd;
	snd = In.ar(\in.kr, 2);
	snd = GVerb.ar(snd, \room.kr(10), \time.kr(3), \damping.kr(0.5), \inputdamping.kr(0.5), \spread.kr(15), \drymix.kr(1), \earlyreflectionlevel.kr(0.7), \taillevel.kr(0.5), 300);
	Out.ar(\out.kr, snd);
}
).add;

SynthDef(\freqshift, {
	var snd;
	snd = In.ar(\in.ar, 2);
	snd = FreqShift.ar(snd, \freqshift.kr(0));
	Out.ar(\out.kr, snd);
}).add;

SynthDef(\pitchshiftpa, {
	var in;
	in = In.ar(\in.ar, 2);
	in = PitchShiftPA.ar(in, \freq.kr(300), \pitch.kr(1), \formantRatio.kr(1), \minFreq.kr(10), \maxFormantRatio.kr(10), \grainsPeriod.kr(2));
	Out.ar(\out.kr, in);
});


SynthDef(\decimator, {
	var input, snd;
	input = In.ar(\in.ar(100));
	snd = Decimator.ar(input, \rate.kr(100, \lag.kr(1)), \bits.kr(24));
	Out.ar(\out.kr(0), snd!2);
}).add;

SynthDef(\sineshaper, {
	var input, snd;
	input = In.ar(\in.ar(100));
	snd = SineShaper.ar(input, \limit.kr(0.1, \lag.kr(0)), \amp.kr(1, \lag.kr(0)));
	Out.ar(\out.kr(0), snd!2);
}).add;

SynthDef(\disintegrate, {
	var input, snd;
	input = In.ar(\in.ar(100));
	snd = Disintegrator.ar(input, \probability.kr(0.5, \lag.kr(0)), \multiplier.kr(0, \lag.kr(0)));
	Out.ar(\out.kr(0), snd!2);
}).add;

// Ben Gold

SynthDef(\distort, { |out = 0, distort = 1|
	var signal, mod;
	signal = In.ar(\in.kr(100));
	mod = CrossoverDistortion.ar(signal, amp: 0.2, smooth: 0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000 + SinOsc.ar(62,mul: 100)],nil,[0.1, 0.1, 0.05, 0.01]], signal));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [signal, mod]);
	Out.ar(out, mod!2);
}).add;

SynthDef(\nhhall, {
	var snd;
	snd = In.ar(\in.ar(100), 2);
	snd = NHHall.ar(snd, \time.kr(1), \stereo.kr(2));
	Out.ar(0, snd);
}).add;

SynthDef(\jpverb, {
	var dry, wet, sig;
	dry = In.ar(\in.kr(100), 2);
	wet = JPverb.ar(dry, \time.kr(1), \damp.kr(0));
	sig = XFade2.ar(dry, wet, \mix.kr(0.5) * 2 -1);
	sig = Limiter.ar(sig);
	Out.ar(\out.kr(0), sig);
}).add;

// used to be jp2

SynthDef(\jpverblpf, {
	var in, sig;
	in = In.ar(\in.ar(100), 2);
	sig = JPverb.ar(in, \time.kr(0.00007), \damp.kr(0));
	sig = MoogLadder.ar(sig, \cutoff.kr(2000)) * \amp.kr(1);
	// sig = Limiter.ar(sig);
	Out.ar(\out.ar(0), sig);
}).add;






/*SynthDef(\datorro, {
arg in = 99,
processMode = 0, // 0 uses Control values, 1 uses Bus for any param suffix Bus.
gain = 0, mix = 0.35,
processGain = 0, processGainBus = 99,
preDelay = 0.001, bandwidth = 0.998,
decayRate = 0.9, decayRateBus = 99,
tailDensity = 0.7, damping = 0.0005,
excursionDepth = 0.2, excursionRate = 2,
shimmerPitch = 1, shimmerPitchBus = 99,
out = 0;

// funcs
var sampleRate		= Server.default.sampleRate;
var equalPower        = {
arg mix = 0.5;
[(1-mix).sqrt, mix.sqrt];
};
var sampSec           = {
arg numSamp, sampRate;
numSamp / sampRate;
};

var gFacT60           = {
arg delay, gFac;
gFac.sign * (-3 * delay / log10(gFac.abs));

};
// some constant values
// dSR = datorroSampleRate, sampleRate used in the paper.
var dSR = 29761;
var maxExcursion    = 32; // samples

// values for prep part
var preTankVals = [
[0.75, 0.75, 0.625, 0.625], // gFacs
sampSec.value([142, 107, 379, 277], dSR) // times
].flop;

// values for tank part
// note that Dattorro flipped the sign of gFacs for the decaying APs,
// I do that here so I don't worry about the signs later.
var tankAP1GFac = -1 * tailDensity;
var tankAP1Time = 672;
var tankDel1    = sampSec.value(4453, dSR);
var tankAP2GFac = (decayRate + 0.15).min(0.5).max(0.25);
var tankAP2Time = sampSec.value(1800, dSR);
var tankDel2    = sampSec.value(3720, dSR);

var tankAP3GFac = tankAP1GFac;
var tankAP3Time = 908;
var tankDel3    = sampSec.value(4217, dSR);
var tankAP4GFac = tankAP2GFac;
var tankAP4Time = sampSec.value(2656, dSR);
var tankDel4    = sampSec.value(3163, dSR);

// Signals
var dry     = In.ar(in, 2);
var preTank = Silent.ar;
var tank    = Silent.ar;
var wetL    = Silent.ar;
var wetR    = Silent.ar;
var wet     = Silent.ar;
var outs    = Silent.ar;

// Params
var pGain = Select.kr(processMode, [processGain.dbamp, Lag.kr(In.kr(processGainBus), 0.05)]);
var sPitch = Select.kr(processMode, [shimmerPitch, Lag.kr(In.kr(shimmerPitchBus), 0.05)]);

var fback;

var dryAmp, wetAmp;
#dryAmp, wetAmp = equalPower.value(mix);

// proper mappings for params
damping = (damping + (1 + (8 * damping))).log / (10.log); // somewhat better than linear
bandwidth = 3.pow(bandwidth) - (1 + bandwidth);


// ROUTINGS
// make it mono
preTank = (dry[0] + dry[1]) / 2;
// pregain
preTank = preTank * pGain;
// predelay
preTank = DelayC.ar(preTank, preDelay, preDelay);
// lowpass
preTank = LPF.ar(preTank, sampleRate / 2 * bandwidth);

// 4 All-passes to diffuse inputs
preTankVals.do({ arg pair; // 0: gFac, 1: time
preTank = AllpassC.ar(preTank, pair[1], pair[1], gFacT60.value(pair[1], pair[0]));
});

fback = LocalIn.ar(1);

// // Tank starts here
// first branch
tank  = AllpassC.ar(preTank + (decayRate * fback),
maxdelaytime: sampSec.value(tankAP1Time + maxExcursion, dSR),
delaytime: sampSec.value(tankAP1Time, dSR)
+ (sampSec.value(maxExcursion, dSR) * excursionDepth * SinOsc.ar(excursionRate)),
decaytime: gFacT60.value(sampSec.value(tankAP1Time, dSR), tankAP1GFac)
);

wetL = -0.6 * DelayC.ar(tank, sampSec.value(1990, dSR), sampSec.value(1990, dSR)) + wetL;
wetR = 0.6 * tank + wetR;
wetR = 0.6 * DelayC.ar(tank, sampSec.value(3300, dSR), sampSec.value(3300, dSR)) + wetR;
tank = DelayC.ar(tank, tankDel1, tankDel1);
tank = LPF.ar(tank, sampleRate / 2 * (1 - damping)) * decayRate;
wetL = -0.6 * tank + wetL;
tank = AllpassC.ar(tank, tankAP2Time, tankAP2Time, gFacT60.value(tankAP2Time, tankAP2GFac));
wetR = -0.6 * tank + wetR;
tank = DelayC.ar(tank, tankDel2, tankDel2);
wetR = 0.6 * tank + wetR;

// // second branch
tank  = AllpassC.ar((tank * decayRate) + preTank,
maxdelaytime: sampSec.value(tankAP3Time + maxExcursion, dSR),
delaytime: sampSec.value(tankAP3Time, dSR)
+ (sampSec.value(maxExcursion, dSR) * excursionDepth * 0.8 * SinOsc.ar(excursionRate * 0.8)),
decaytime: gFacT60.value(sampSec.value(tankAP3Time, dSR), tankAP3GFac)
);

wetL = 0.6 * tank + wetL;
wetL = 0.6 * DelayC.ar(tank, sampSec.value(2700, dSR), sampSec.value(2700, dSR)) + wetL;
wetR = -0.6 * DelayC.ar(tank, sampSec.value(2100, dSR), sampSec.value(2100, dSR)) + wetR;
tank = DelayC.ar(tank, tankDel3, tankDel3);
tank = LPF.ar(tank, sampleRate / 2 * (1 - damping)) * decayRate;
tank = AllpassC.ar(tank, tankAP4Time, tankAP4Time, gFacT60.value(tankAP4Time, tankAP4GFac));
wetL = -0.6 * tank + wetL;
wetR = -0.6 * DelayC.ar(tank, sampSec.value(200, dSR), sampSec.value(200, dSR)) + wetR;

tank = DelayC.ar(tank, tankDel4, tankDel4);
wetL = 0.6 * tank + wetL;

tank = tank * decayRate;
// // Sloppy Shimmering
tank = PitchShift.ar(tank, pitchRatio: sPitch, mul: Select.kr(sPitch > 1, [1, 2.dbamp]));
// // Tank ends here
LocalOut.ar(tank);

wet = [wetL, wetR];
wet = HPF.ar(wet, 40); // Prevent lows from blowing up.

outs = (dry * dryAmp) + (wet * wetAmp);
outs = outs * gain.dbamp;

Out.ar(out, outs);
}).add;*/



SynthDef(\rlpf, {
	|out = 0, freq = 440, rq = 1, in|
	var snd;
	snd = RLPF.ar(In.ar(in), freq, rq);
	Out.ar(out, snd!2);
}).add;

SynthDef(\rhpf, {
	|out = 0, freq = 440, rq = 1, in|
	var snd;
	snd = RHPF.ar(In.ar(in), freq, rq, \amp.kr(1));
	Out.ar(out, snd!2);
}).add;



// CONTROL BUSES


SynthDef(\tartini, {
	|out in|
	Out.kr(out, Tartini.kr(in, \threshold.kr(0.93))[0].poll);
}).add;

SynthDef(\tartinisoundin, {
	|out|
	Out.kr(out, Tartini.kr(SoundIn.ar(0), \threshold.kr(0.93))[0]);
}).add;

SynthDef(\amplitude, {var amp;
	amp = Amplitude.kr(In.ar(\in.ar, 2));
	Out.kr(\out.kr, amp)
}).add;

SynthDef(\amplitudesoundin, {var amp;
	amp = Amplitude.kr(SoundIn.ar(0)).lag(0.1);
	Out.kr(\out.kr, amp * \amp.kr(1))
}).add;

SynthDef(\lfnoise2, { |freq = 0.1, min = 0, max = 1|
	Out.kr(\out.kr, LFNoise2.kr(freq).range(min, max))
}).add;

SynthDef.new(\mouseX, { Out.kr(\out.kr, MouseX.kr(\min.kr, \max.kr)) }).add;

SynthDef.new(\mouseY, { Out.kr(\out.kr, MouseY.kr(\min.kr, \max.kr)) }).add;

SynthDef.new(\sinekr, { Out.kr(\out.kr, SinOsc.kr(\freq.kr, 0).range(\min.kr, \max.kr))}).add;

SynthDef.new(\line, { Out.kr(\out.kr, Line.kr(\start.kr(0), \end.kr(1), \dur.kr(1), doneAction: \da.kr(0)))}).add;



SynthDef(\pitch, {var pitch;
	pitch = Pitch.kr(In.ar(\in.ar(100), 2));
	Out.kr(\out.kr(0), pitch)
}).add;

SynthDef(\bus, {
	Out.ar(\out.ar(0), In.ar(\in.ar(100), 2));
}).add;

SynthDef(\ctlEnv, { |out, levelScale = 1, levelBias = 0, time = 1, connect = 1|
	var env = \env.kr(Env.newClear(12).asArray);
	var init = In.kr(out, 1);
	var start = Select.kr(connect, [env[0], init]);
	Out.kr(out, EnvGen.kr(env, 1, levelScale, levelBias, time, doneAction: 2));
}).add;


SynthDef(\throat, {
	|dur 10|
	var snd, envperc, envlinen, trig, freq;
	trig = Impulse.kr(XLine.kr(20, 5, dur, doneAction:2));
	freq = Line.kr(rrand(300, 500), rrand(100, 70), dur);
	envperc = Env.perc(\atk.kr(0.0), \rel.kr(0.01), \amp.kr(1)).kr(0, trig, timeScale: dur);
	snd = VarSaw.ar(Line.kr(rrand(50, 100), rrand(130, 320), dur), 0, {LFNoise2.kr(0.3).abs/2 + 0.5}, 0.1);
	snd = CombC.ar(snd, 0.2, 1/(freq * Line.kr(1/2, 2, dur)), \decaytime.kr(1));
	// snd = Pan2.ar(snd, \pan.kr(0), 1/2);
	// snd = Resonator.ar(snd, Line.kr(rrand(20, 100), rrand([1000, 1003], [500, 505]), 10), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = Resonator.ar(snd, Line.kr(\freqA.kr(70), \freqB.kr(1000), 10), 0.001, 24, \structure.kr(0.5), \brightness.kr(0.5), \damping.kr(0.5));
	snd = snd * Line.kr(0.0, 1.5, dur) * 2 * envperc;
	envlinen = Env.linen(dur/6, 0, dur/3, 3, 'sine').kr(2);
	snd = BRF.ar(snd, 200, 2);
	snd = LPF.ar(snd, \lpf.kr(400));
	snd = PanAz.ar(2, snd, \pan.kr(0));
	snd = Limiter.ar(snd);
	// snd = snd.tanh;
	Out.ar(\out.kr(0), snd * envlinen);
}).add;