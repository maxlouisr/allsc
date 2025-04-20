(
~dirt.addModule('normalizer', { |dirtEvent|
	dirtEvent.sendSynth('normalizer' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			norm: ~norm,
			out: ~out
		]

	)
}, { ~norm.notNil }); // play synth only if at least one of the two was given

SynthDef("normalizer" ++ ~dirt.numChannels, { |out, norm = 1|
	var snd;
	snd = In.ar(out, ~dirt.numChannels);
	snd = Normalizer.ar(snd, norm);
	ReplaceOut.ar(out, snd);
}).add;

// resonator algorithm ported to sc by Mads Kjelgaard

~dirt.addModule('resonator', { |dirtEvent|
	dirtEvent.sendSynth('resonator' ++ ~dirt.numChannels,
		[

			resf: ~resf,
			/*	res: ~res,
			damping: ~damping,
			bright: ~bright,*/
			out: ~out
		]

	)
}, { ~resf.notNil });


SynthDef("resonator" ++ ~dirt.numChannels, {
	|out, res = 0.5, resf = 440|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = Resonator.ar(dry, resf, \position.kr(0.0001), \resolution.kr(24), \structure.kr(0.5), \bright.kr(0.5), \damping.kr(0.3));
	ReplaceOut.ar(out, wet);
	// ReplaceOut.ar(out, dry.blend(wet, res));
}).add;


// combfilter

~dirt.addModule('comb', { |dirtEvent|
	dirtEvent.sendSynth('comb' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			combf: ~combf,
			combd: ~combd,
			combmix: ~combmix,
			/*	damping: ~damping,
			bright: ~bright,*/
			out: ~out
		]

)}, { ~combf.notNil });


SynthDef("comb" ++ ~dirt.numChannels, {
	|out, combf = 100, combd = 0.1|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = CombC.ar(dry, 0.2, 1/combf, combd);
	wet = dry.blend(wet, \combmix.kr(0.5));
	ReplaceOut.ar(out, wet);
}, [\ir]).add;


// band reject filter

~dirt.addModule('brf', { |dirtEvent|
	dirtEvent.sendSynth('brf' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			brf: ~brf,
			brq: ~brq,
			out: ~out
		]

)}, { ~brf.notNil });


SynthDef("brf" ++ ~dirt.numChannels, {
	|out, brf = 200, brq = 0|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = BRF.ar(dry, brf, brq);
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

// parametric EQ

~dirt.addModule('eq', { |dirtEvent|
	dirtEvent.sendSynth('eq' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			eqf: ~eqf,
			eqq: ~eqq,
			db: ~db,
			out: ~out
		]

)}, { ~eqf.notNil });


SynthDef("eq" ++ ~dirt.numChannels, {
	|out, eqf, eqq, db|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = BPeakEQ.ar(dry, eqf, eqq, db);
	ReplaceOut.ar(out, wet);
}, [\ir]).add;



// pitch

~dirt.addModule('pitchshift', { |dirtEvent|
	dirtEvent.sendSynth('pitchshift' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			pitchshift: ~pitchshift,
			window: ~window,
			out: ~out
		]

)}, { ~pitchshift.notNil });


SynthDef("pitchshift" ++ ~dirt.numChannels, {
	| out, pitchshift = 1, window = 0.2|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = PitchShift.ar(dry, window, pitchshift, 0, 0, 1);
	ReplaceOut.ar(out, wet);
}).add;

~dirt.addModule('jpverb', { |dirtEvent|
	dirtEvent.sendSynth('jpverb' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			jpverb: ~jpverb,
			out: ~out
		]

)}, { ~jpverb.notNil });


SynthDef("jpverb" ++ ~dirt.numChannels, {
	|out|
	var dry, wet, sig;
	dry = In.ar(out, ~dirt.numChannels);
	wet = JPverb.ar(dry, 1, 0);
	wet = XFade2.ar(dry, wet, \jpverb.kr(0.5) * 2 -1);
	ReplaceOut.ar(out, wet);
}, [\ir]).add;


~dirt.addModule('splay', { |dirtEvent|
	dirtEvent.sendSynth('splay' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			splay: ~splay,
			out: ~out
		]

)}, { ~splay.notNil });

SynthDef("splay" ++ ~dirt.numChannels, {
	|out|
	var dry, wet, sig;
	dry = In.ar(out, ~dirt.numChannels);
	wet = Splay.ar([dry, dry], \splay.kr(0));
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

~dirt.addModule('combs', { |dirtEvent|
	dirtEvent.sendSynth('combs' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		[
			combs: ~combs,
			decayt: ~decayt,
			out: ~out
		]

)}, { ~combs.notNil });

SynthDef("combs" ++ ~dirt.numChannels, {
	|out|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	wet = CombL.ar(dry, 0.2, 1/({LFNoise2.kr(0.1).exprange(20, 20000)}!30), \decayt.kr(0.5));
	wet = Splay.ar(wet);
	wet = XFade2.ar(dry, wet, \combs.kr(0) * 2 -1);
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

~dirt.addModule('splaz', { |dirtEvent|
	dirtEvent.sendSynth('splaz' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		[
			splaz: ~splaz,
			out: ~out
		]

)}, { ~splaz.notNil });

SynthDef("splaz" ++ ~dirt.numChannels, {
	|out|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	// wet = PanAz.ar(s.options.numOutputBusChannels, dry.sum, \panaz.kr(0).linlin(0, 4, 0, 2), 1, 2, 0);
	wet = SplayAz.ar(~numChannels, dry, 1, 1, \splaz.kr(~numChannels).linlin(0, 1, 0, ~numChannels - 1));
	// wet = SplayAz.ar(~numChannels, dry.sum, 1, 1, );
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

// check this example: {var snd; snd = SinOsc.ar(300); snd = PanAz.ar(16, snd, 0 / 8, 1, 2.0, 0)}.scope;

~dirt.addModule('panaz', { |dirtEvent|
	dirtEvent.sendSynth('panaz' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		[
			// panaz: ~panaz,
			panaz: ~panaz,
			panazwidth: ~panazwidth,
			panazlag: ~plag,
			out: ~out
		]

)}, { ~panaz.notNil });

// check this example: {var snd; snd = SinOsc.ar(300); snd = PanAz.ar(16, snd, 0 / 8, 1, 2.0, 0)}.scope;

SynthDef("panaz" ++ ~dirt.numChannels, {
	|out|
	var dry, wet;
	dry = In.ar(out, ~dirt.numChannels);
	// wet = PanAz.ar(s.options.numOutputBusChannels, dry.sum, \panaz.kr(0).linlin(0, 4, 0, 2), 1, 2, 0);
	wet = PanAz.ar(16, dry.sum, \panaz.kr(0, \panazlag.kr(0)) / 8, 1, \panazwidth.kr(2.0, \panazlag.kr(0)), 0);
	ReplaceOut.ar(out, wet);
}, [\ir]).add;


~dirt.addModule('tanh', { |dirtEvent|
	dirtEvent.sendSynth('tanh' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			tanh: ~tanh,
			out: ~out
		]

)}, { ~tanh.notNil });




SynthDef("tanh" ++ ~dirt.numChannels, {
	|out|
	var dry, wet, sig;
	dry = In.ar(out, ~dirt.numChannels);
	wet = (dry * \tanh.kr(1)).tanh;
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

~dirt.addModule('sin', { |dirtEvent|
	dirtEvent.sendSynth('sin' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			sin: ~sin,
			out: ~out
		]

)}, { ~sin.notNil });


SynthDef("sin" ++ ~dirt.numChannels, {
	|out|
	var dry, wet, sig;
	dry = In.ar(out, ~dirt.numChannels);
	wet = (dry * \sin.kr(1)).sin;
	ReplaceOut.ar(out, wet);
}, [\ir]).add;

~dirt.addModule('cos', { |dirtEvent|
	dirtEvent.sendSynth('cos' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			cos: ~cos,
			out: ~out
		]

)}, { ~cos.notNil });


SynthDef("cos" ++ ~dirt.numChannels, {
	|out|
	var dry, wet, sig;
	dry = In.ar(out, ~dirt.numChannels);
	wet = (dry * \cos.kr(1)).sin;
	ReplaceOut.ar(out, wet);
}, [\ir]).add;


~dirt.addModule('fatfold', { |dirtEvent|
	dirtEvent.sendSynth('fatfold' ++ ~dirt.numChannels,
		// OPTIONAL
		// passing this array of parameters could be left out,
		// but it makes it clear what happens
		[
			fatfold: ~fatfold,
			hi: ~hi,
			lo: ~lo,
			out: ~out
		]

)}, { ~fatfold.notNil ; ~lo.notNil });


SynthDef("fatfold" ++ ~dirt.numChannels, {|out|
	var  dry, wet, lag;

	dry = In.ar(out, ~dirt.numChannels);

	lag = \lag.kr(0.1);

	wet = dry.fold(SinOsc.kr(\hi.kr(0, lag)), SinOsc.kr(\lo.kr(0, lag)) );

	// wet = dry.fold(SinOsc.kr(seq * \ratio1.kr(0.5)), SinOsc.kr(seq * \ratio2.kr(2)) );
	// wet = dry.fold(\ratio1.kr(0.5), \ratio2.kr(2.0));

	wet = LeakDC.ar(wet);

	wet = (wet * 10).distort;

	// env = Env.perc(0.01, 3).kr(0, trig);

	wet = wet.tanh * 0.5;

	ReplaceOut.ar(out, wet);

}, [\ir]).add;


SynthDef("dirt_mono" ++ ~dirt.numChannels, { |out|
		var orig, signal, n;
		n = ~dirt.numChannels;
		orig = In.ar(out, n);
		signal = orig.sum.dup(n) * (1/n);
		ReplaceOut.ar(out, signal);
	}, [\ir]).add;

~dirt.addModule('mono',
	{ |dirtEvent|
		dirtEvent.sendSynth("dirt_mono" ++ ~numChannels,
			[
				out: ~out
		])

}, { ~mono.notNil });








/*~dirt.addModule('vocoder', { |dirtEvent|
dirtEvent.sendSynth("vocoder" ++ ~dirt.numChannels,
[
vocoder:~vocoder,
out: ~out,
chord:~chord
]
)
}, { ~vocoder.notNil});

SynthDef("vocoder" ++ ~dirt.numChannels, {
|out, vocoder=1|
var car, vcar ,mod, sig;
mod = In.ar(out,~dirt.numChannels);
vcar = Saw.ar((60+\chord.kr(0)).midicps);
car = SelectX.ar((ZeroCrossing.ar(mod).cpsmidi.lag(0.05) > 5000.cpsmidi).lag(0.05), [vcar, PinkNoise.ar]) ;
sig = Vocoder.ar(car,mod,96);
sig = SelectX.ar(vocoder, [mod*0.15, sig]);
ReplaceOut.ar(out, sig);
}, [\ir]).add;

~dirt.addModule('pvocoder', { |dirtEvent|
dirtEvent.sendSynth("pvocoder" ++ ~dirt.numChannels,
[
pvocoder:~pvocoder,
out: ~out,
chord:~chord
]
)
}, { ~pvocoder.notNil });

SynthDef("pvocoder" ++ ~dirt.numChannels, {
|out, pvocoder=1|
var car, vcar ,mod, sig,chain, chain2, size=512;
mod = In.ar(out);
vcar = Saw.ar((60+\chord.kr(0)).midicps);
car = SelectX.ar((ZeroCrossing.ar(mod).cpsmidi.lag(0.05) > 15000.cpsmidi).lag(0.05), [vcar, PinkNoise.ar]) ;
chain = FFT(LocalBuf(size),mod);
chain2 = FFT(LocalBuf(size),car);
chain = chain.pvcalc2(chain2, size,
{
arg mag, phs, mag2, phs2;
[mag,phs2];
});
sig = IFFT(chain)!2;
sig = SelectX.ar(pvocoder, [mod*0.15, sig]);
ReplaceOut.ar(out, sig);
}, [\ir]).add;*/

)


