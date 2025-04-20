SynthDef(\fm, {
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


	Out.ar(\out.kr, DirtPan.ar(sig, ~dirt.numChannels));
	}).add;