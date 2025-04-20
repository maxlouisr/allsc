(// say you want to add a global low pass filter

// first you generate the synth defs for it
Routine.run{

	// jpverb

	(1..SuperDirt.maxSampleNumChannels).do {


		SynthDef("dirt_global_jpverb" ++ ~dirt.numChannels, { |dryBus, effectBus, gate = 1|
			var signal = In.ar(dryBus, ~dirt.numChannels);

			signal = XFade2.ar(signal, JPverb.ar(signal, \gpverbtime.kr(1.0), 0), \gpverb.kr(0.5) * 2 -1);
			signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(signal, graceTime:4);

			ReplaceOut.ar(effectBus, signal);
		}, [\ir, \ir]).add;

		SynthDef("custom_verb" ++ ~dirt.numChannels, { |dryBus, effectBus, gate = 1|
			var signal = In.ar(dryBus, ~dirt.numChannels);

			signal = FreeVerb.ar(signal, \freeverb.kr(0.33));
			signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(signal, graceTime:4);

			ReplaceOut.ar(effectBus, signal);
		}, [\ir, \ir]).add;


		// GVERB

		SynthDef("dirt_global_gverb" ++ ~dirt.numChannels, { |dryBus, effectBus, gate = 1, gverb = 0.5|


			var dry, fx, signal;
			dry = In.ar(dryBus, ~dirt.numChannels);

			fx = GVerb.ar(dry, \groom.kr(10) + 1, \gtime.kr(0) + 1, \gdamp.kr(0.5) + 0.001, drylevel: 0);
			fx = HPF.ar(fx, \ghp.kr(0));
			fx = XFade2.ar(dry, fx, gverb * 2 -1);

			signal = fx;

			signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(signal.sum, graceTime:4);

			Out.ar(effectBus, signal);
		}, [\ir, \ir]).add;

		// MI verb

		SynthDef("global_mi_verb" ++ ~dirt.numChannels, { |dryBus, effectBus, verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0, gate = 1|
			var snd = In.ar(dryBus, ~dirt.numChannels);
			snd = snd * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(snd.sum, graceTime:4);
			snd = MiVerb.ar(
				snd,
				verbtime,
				verbwet,
				verbdamp,
				verbhp,
				verbfreeze,
				verbdiff
			) * verbgain;

			snd = SplayAz.ar(~numChannels, snd, 1, 1, 2);

			Out.ar(effectBus,snd) ;
		}, [\ir, \ir]).add;

		SynthDef("global_hall" ++ ~dirt.numChannels, { |dryBus, effectBus, gate = 1|
			var in, wet;
			in = In.ar(dryBus, ~dirt.numChannels);

			wet = NHHall.ar(Splay.ar(in), \time.kr(1));
			wet = LPF.ar(wet, 10000);
			wet = XFade2.ar(in, wet, \hall.kr(0.5) * 2 -1);
			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(effectBus, wet);

		}, [\ir, \ir]).add;


		// COMBS changed combs to combg in parameters and below

		SynthDef("combg" ++ ~dirt.numChannels, {
		|dryBus, effectBus, gate = 1, out, combgf = 100, combgd = 0.1|
		var in, wet;
			in = In.ar(dryBus, ~dirt.numChannels);
	wet = CombC.ar(in, 0.2, 1/combgf, combgd);
	wet = in.blend(wet, \combgmix.kr(0.5));
			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(effectBus, wet);
	}, [\ir, \ir]).add;

		// COMBS RANDOM changed name to combs from combs_global and paramaters to combs (se line below)

		SynthDef("combs" ++ ~dirt.numChannels, {|dryBus, effectBus, gate = 1|
		var snd;
			snd = In.ar(dryBus, ~dirt.numChannels);
			// snd = snd.blend(CombC.ar(snd, 0.2, 1/({LFNoise2.kr(0.1).exprange(20, 20000)}!30), 0.5), \combsg.kr(0));
			snd = snd.blend(CombC.ar(snd, 0.2, 1/({LFNoise2.kr(0.1).exprange(20, 20000)}!30), \combsdecay.kr(0.5)), \combsmix.kr(0));
			snd = snd * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(snd.sum, graceTime:4);

			Out.ar(effectBus, snd);
		}, [\ir, \ir]).add;

		// FLANGER

		SynthDef("global_flanger" ++ ~dirt.numChannels, {arg flangefreq=0.1, flangefb = 0.1, dryBus, effectBus, gate = 1;

			var dry, input, effect;
			dry = In.ar(dryBus, ~dirt.numChannels);

			dry = dry + LocalIn.ar(2); //add some feedback

			effect= DelayN.ar(dry,0.02,SinOsc.kr(flangefreq,0,0.005,0.005));
			LocalOut.ar(flangefb*effect);

			effect = XFade2.ar(dry, effect, \flangermix.kr(0.5) * 2-1);
			//LocalOut.ar(fdback*BPF.ar(effect,MouseX.kr(1000,10000),0.1)); //alternative with filter in the feedback loop

			effect = effect * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(effect.sum, graceTime:4);

			Out.ar(effectBus, effect);

		}, [\ir, \ir]).add;


		SynthDef(\global_chorus ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);
			wet= Mix.fill(10, {
				var maxdelaytime= rrand(0.01,0.03);
				DelayC.ar(dry, maxdelaytime, LFNoise2.kr(0.5, 0.01,0.02) )

			});

			wet = dry.blend(wet, \chorus.kr(0));

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);
			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(effectBus, wet);
		}, [\ir, \ir]).add;

		SynthDef(\locut ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet= HPF.ar(HPF.ar(dry, \locut.kr(120)));

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(effectBus, wet);

		}, [\ir, \ir]).add;

		SynthDef(\multidelays0 ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet= CombL.ar(dry, 1, {LFNoise0.kr(0.3, 0.4999, 0.5)}!~numChannels, {LFNoise0.kr(0.3, 2, 2)}!~numChannels, \multidelays0.kr(0.5););

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			wet = Limiter.ar(wet);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(out, wet);

		}, [\ir, \ir]).add;

		SynthDef(\multidelays1 ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet= CombL.ar(dry, 1, {LFNoise1.kr(0.3, 0.4999, 0.5)}!~numChannels, {LFNoise1.kr(0.3, 2, 2)}!~numChannels, \multidelays1.kr(0.5););

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			wet = Limiter.ar(wet);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(out, wet);

		}, [\ir, \ir]).add;

		SynthDef(\multidelays2 ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet, snd;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet= CombL.ar(dry.sum, 1, {LFNoise2.kr(0.3, 0.4999, 0.5)}!~numChannels, {LFNoise2.kr(0.3, 2, 2)}!~numChannels, \multidelays2.kr(0.5););

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			wet = Limiter.ar(wet);

			wet = Sanitize.ar(wet);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(out, wet);

		}, [\ir, \ir]).add;

		SynthDef(\multicombs2 ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet= CombC.ar(dry, 1, {LFNoise2.kr(0.3, 2950, 3000).reciprocal}!~numChannels, 1, \multicombs2.kr(0.5, 0.1));

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			wet = Limiter.ar(wet);

			wet = Sanitize.ar(wet);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(out, wet);

		}, [\ir, \ir]).add;

		SynthDef(\splaz ++ ~dirt.numChannels, {arg out, dryBus, effectBus, gate = 1;

			var dry, wet;

			dry = In.ar(dryBus, ~dirt.numChannels);

			wet = SplayAz.ar(~numChannels, dry, \splaz.kr(1.0), 1, 2.0);

			wet = wet * EnvGen.kr(Env.asr, gate, doneAction:2);

			DirtPause.ar(wet.sum, graceTime:4);

			Out.ar(out, wet);

		}, [\ir, \ir]).add;


	};



	3.wait;

	// then add the effect to the orbits

	~dirt.orbits.do { |x|

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\dirt_global_jpverb, [\gpverb, \gpverbtime]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\custom_verb, [\freeverb]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\dirt_global_gverb, [\gverb, \groom, \gtime, \gdamp, \ghp]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\global_hall, [\hall, \time]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\combg, [\combgf, \combgmix, \combgd]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\combs, [\combsmix, \combsdecay]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\global_flanger, [\flangermix, \flangefreq, \flangefb]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\global_chorus, [\chorus]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\locut, [\locut]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\multidelays0, [\multidelays0]));
		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\multidelays1, [\multidelays1]));
		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\multidelays2, [\multidelays2]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\multicombs2, [\multicombs2, \mcd]));

		x.globalEffects = x.globalEffects.addFirst(GlobalDirtEffect(\splaz, [\splaz]));

		x.initNodeTree;
	};

	// ~dirt.orderModules(['jpverb', 'lpf', 'hpf', 'klm']);

}

)



// ~dirt.orbits.do { |x| x.globalEffects.postln; " ----------".postln; };



