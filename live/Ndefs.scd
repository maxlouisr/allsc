
// Ndef.clear;

NdefMixer(s);

(
~comb_bus = Bus.audio(s, 2);

Ndef('comb', {|freq| var detune, in; in = In.ar(~comb_bus, 2); detune = LFNoise2.kr(0.3).range(\detune.kr(0.98), \detune.kr().reciprocal);CombC.ar(in, 0.2, 1/freq * detune, \decaytime.kr(1.0), 0.5)}).mold(numChannels:2).addSpec(\detune, [0.0001, 2, \lin, 0, 0.0]).play(addAction: 'addToTail');
);



(
~magbelowbus = Bus.audio(s, 2);
~magelow = {|in|
    var chain;
	// in = PlayBuf.ar(2, w, LFNoise2.kr(10) + 1 * BufRateScale.ir(w), 1, 0, 1);
    //in = WhiteNoise.ar(0.2);
	in = In.ar(~magbelowbus, 2);
    chain = FFT({ LocalBuf(2048) } ! 2, in);
    chain = PV_MagBelow(chain, \threshold.kr(1));
    0.5 * IFFT(chain);
});



(
~brickwallbus = Bus.audio(s, 2);
Ndef(\brickwall, {
    var in, chain;
	// in = PlayBuf.ar(2, b, 0.5 * BufRateScale.ir(b), 1, 0, 1);
	in = In.ar(~brickwallbus, 2);
    chain = FFT({LocalBuf(2048)}!2, in);
	chain = PV_BrickWall(chain, \wipe.kr(0));
    IFFT(chain)
});
);

(
~brickwallbus = Bus.audio(s, 2);
~brickwall = {|in|
    var chain;
	// in = PlayBuf.ar(2, b, 0.5 * BufRateScale.ir(b), 1, 0, 1);
	in = In.ar(~brickwallbus, 2);
    chain = FFT({LocalBuf(2048)}!2, in);
	chain = PV_BrickWall(chain, \wipe.kr(0));
    IFFT(chain)
});

(
Ndef(\literalsine, {var snd;
	snd = SinOsc.ar(\freq.kr(#[100, 100, 100], 1), 0, \amp.kr(0.3));
	snd = Splay.ar(snd);
})
);

(
Ndef(\literalsinemidi, {var snd;
	snd = SinOsc.ar(\freq.kr(#[64, 64, 64], \lag.kr(1)).midicps, 0, 0.1);
	snd = Splay.ar(snd);
})
);






(
Ndef(\bowed, {arg amp=1, bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, bowvelocity = 100, loudness=128, pan = 0.5;
    var sig, freq;
	freq = VarLag.kr(\freq.kr(100), \gliss.kr(0));
    sig = StkInst.ar(
		Stk.at("Bowed"),
		\freq.kr(100),
		1,
		1,
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
	sig = Pan2.ar(sig, pan) * amp;
});
);

(
Ndef(\play, {|rate 1 pos 0 pan 0.5|
	var snd = PlayBuf.ar(2, \buffer.kr, rate * BufRateScale.ir(\buffer.kr), 1, pos * BufFrames.ir(\buffer.kr), \loop.kr(0)); snd = Balance2.ar(snd[0], snd[1], pan * 2 -1)})
);

(
Ndef(\playmono, {|rate 1 pos 0 pan 0|
	var snd = PlayBuf.ar(1, \buffer.kr, rate * BufRateScale.ir(\buffer.kr), 1, pos * BufFrames.ir(\buffer.kr), \loop.kr(0)); snd = Pan2.ar(snd, pan)})
);



(
Ndef(\blip, {var snd = Blip.ar(\freq.kr(100), \harms.kr(5), 0.1);
	snd = Pan2.ar(snd, \pan.kr * 2 - 1)
});
);


// FX / Filters

~freeverb = {|in| FreeVerb.ar(in, \mix.kr(0.5), \room.kr(1), \damp.kr(0.5))};


~distort = { |in, distort = 1|
	var signal, mod;
	mod = CrossoverDistortion.ar(in, amp: 0.2, smooth: 0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000 + SinOsc.ar(62,mul: 100)],nil,[0.1, 0.1, 0.05, 0.01]], in));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [in, mod]);
};

(
~datorro = {
	arg in,
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
}
);




Ndef(\lfsine).addSpec(\min, [-1.0, 1.0, \lin, 0, 0]);


Ndef(\lfnoise, {|freq = 0.1| LFNoise2.kr(\lfo.kr(1)).range(\min.kr(0), \max.kr(1))});

Ndef(\lfnoise).copy(\lfnoise1);


Ndef(\lfsine, {|freq = 0.1| SinOsc.kr(\lfo.kr(1)).range(\min.kr(-1), \max.kr(1))});

Ndef(\major, {Select.kr(MouseX.kr(0, 30), Array.makeScaleCps(300, 'major', 100, 1000)).lag(\lag.kr(6))});
