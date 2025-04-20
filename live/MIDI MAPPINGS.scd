(
~poue = Ndef(\poue, {
	// var trig = Impulse.kr(tempo.linlin(0, 1, 0, 100) * LFNoise2.kr(0.3, \drift.kr(0), 1));
	var tempo = \time.kr(1.0, 0.1);
	var whitecomb = \whitecomb.kr(0, 0.1);
	var feedback = \feedback.kr(1.1, 0.1);
	var dur = \dur.kr(0.91, 0.1).linlin(0.1, 10, 0, 127);

	var temp = tempo;

	var rhythms_list = {{[1, 1/2, 1/3].choose}!4}!10;
	// var rhythm = SelectX.kr(\rhythm.kr(0, 0.1).linlin(0, 1, 0, rhythms_list.size -1), rhythms_list);
	var rhythm = 1;

	var trig = Impulse.kr(temp * Demand.kr(Impulse.kr(temp), 0, Dseq(rhythm, inf)));

	// var trig_bass = Impulse.kr(temp/2 * Demand.kr(Impulse.kr(temp), 0, Dseq(rhythm, inf)));


	// var trig = Impulse.kr(temp);
	var midinotes_list = [\note1.kr(0).linlin(0, 1, 24, 120), \note2.kr(0).linlin(0, 1, 24, 120), \note3.kr(0).linlin(0, 1, 24, 120), \note4.kr(0).linlin(0, 1, 24, 120), \note5.kr(0).linlin(0, 1, 24, 120), \note6.kr(0).linlin(0, 1, 24, 120), \note7.kr(0).linlin(0, 1, 24, 120), \note8.kr(0).linlin(0, 1, 24, 120)];
	var midinotes = midinotes_list * LFNoise2.kr(0.3, \detune.kr(0), 1);

	// var midinotes_list = [Scale.major.semitones, Scale.minor.semitones, Scale.mixolydian.semitones, Scale.iwato.semitones] + \root.kr(60).linlin(0, 1, 24, 96);
	// var midinotes = SelectX.kr(\scale.kr(0).linlin(0, 1, 0, midinotes_list.size -1), midinotes_list);

	var lfsaw = LFSaw.kr(0.1).range(0.0,0.2);
	var transpose = [0.5, 1.0];
	var transposition = TWChoose.kr(trig, transpose, [0.75, 0.125, 0.125]);
	var seq = transposition * Demand.kr(trig, 0, Dseq((midinotes+12).midicps * \stretch.kr(0),inf)).lag(\lag.kr(0.01));

	var sig = SinOscFB.ar(seq, feedback /*TRand.kr(0, 1.7, trig)*/) + CombC.ar(WhiteNoise.ar(SinOsc.kr(0.01).abs * whitecomb / 10 + 0.001), 0.2, 1/seq, SinOsc.kr(3).range(0, 100) + 1);
	var rand = TRand.kr(trig: trig);
	var env = Env.perc(0.01, \rel.kr(1.0)).kr(gate: trig, timeScale: dur/tempo);

	// var bass = SinOscFB.ar(seq/4, 1.5, Env.perc(0.01, 1, 0.5).kr(gate: trig_bass, timeScale: dur/tempo/2));
	// sig = sig + bass;

	sig = LPG.ar(
		input: sig,
		controlinput: env,
		controloffset: lfsaw,
		controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
		vca: LFNoise2.kr(1).unipolar,
		resonance:1.1,
		lowpassmode:1,
		linearity:1
	) * 0.25;

	sig = sig.blend(JPverb.ar(sig), \jpverb.kr(0, 0.1));
	sig = Balance2.ar(sig[0], sig[1], \panrnd.kr(0, 0.1) * TRand.kr(-1.0,1.0,trig)) * \amp.kr(0.4, 0.1);
	sig = Limiter.ar(sig);
}).mold(2).quant_(1);
)

~poue.play;

MIDIdef.freeAll

(
var ndef = ~poue;
var controlnames = [\amp, \time, \panrnd, \jpverb, \feedback, \whitecomb, \rel, \stretch, \note1, \note2, \note3, \note4, \note5, \note6, \note7, \note8];

ndef.addSpec(
	\amp, \amp,
	\time, [0.01, 8, \lin],
	\jpverb, [0, 1],
	\panrnd, [0, 1],
	\feedback, [0, 2],
	\whitecomb, [0, 1],
	\rel, [0.01, 1],
	\stretch, [0.5, 2],
	\note1, [0, 1],
	\note2,[0, 1],
	\note3,[0, 1],
	\note4,[0, 1],
	\note5,[0, 1],
	\note6,[0, 1],
	\note7,[0, 1],
	\note8,[0, 1]
);


~ccControlled = Order.newFromIndices(
	controlnames, (16.. 16 + controlnames.size -1);
);


MIDIdef.cc(
	( ndef.asSymbol ++ "_CC" ).asSymbol,
	{arg val, num;
		var control = ~ccControlled[ num ];

		ndef.set(
			control,
			ndef.getSpec(control).map(val/127)
		);

	},	ccNum: ~ccControlled.indices, chan: 0
).fix;
)
