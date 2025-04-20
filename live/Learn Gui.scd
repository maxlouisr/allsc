
// CONNECT MIDI
MIDIClient.init;
MIDIIn.connectAll;








(
~poue = Ndef(\poue, {
	var tempo = \tempo.kr(1.0, 0.1).linlin(0, 1, 0.001, 20);
	// var trig = Impulse.kr(tempo.linlin(0, 1, 0, 100) * LFNoise2.kr(0.3, \drift.kr(0), 1));
	var whitecomb = \whitecomb.kr(0, 0.1);
	var feedback = \feedback.kr(1.1, 0.1);
	var dur = \dur.kr(0.91, 0.1).linlin(0.1, 10, 0, 127);

	var temp = tempo;

	// var rhythms_list = {{[1, 1/2, 1/3].choose}!4}!10;
	var rhythms_list = ({{{[1, 1/2, 1/3].choose}!4}!10}!2).sum;
	var rhythm = SelectX.kr(\rhythm.kr(0, 0.1).linlin(0, 1, 0, rhythms_list.size -1), rhythms_list);
	// var rhythm = 1;

	var trig = Impulse.kr(temp * Demand.kr(Impulse.kr(temp), 0, Dseq(rhythm, inf)));

	var trig_bass = Impulse.kr(temp/2 * Demand.kr(Impulse.kr(temp), 0, Dseq(rhythm, inf)));


	// var midinotes_list = [\note1.kr(0).linlin(0, 1, 24, 120), \note2.kr(0).linlin(0, 1, 24, 120), \note3.kr(0).linlin(0, 1, 24, 120), \note4.kr(0).linlin(0, 1, 24, 120), \note5.kr(0).linlin(0, 1, 24, 120), \note6.kr(0).linlin(0, 1, 24, 120), \note7.kr(0).linlin(0, 1, 24, 120), \note8.kr(0).linlin(0, 1, 24, 120)];
	// var midinotes = midinotes_list * LFNoise2.kr(0.3, \detune.kr(0), 1);

	var midinotes_list = [Scale.major.semitones, Scale.minor.semitones, Scale.mixolydian.semitones, Scale.iwato.semitones] + \root.kr(60).linlin(0, 1, 24, 96);
	var midinotes = SelectX.kr(\scale.kr(0).linlin(0, 1, 0, midinotes_list.size -1), midinotes_list);

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

	sig = sig + sig;

}).mold(2).quant_(1);
)

~poue.play;




~poue.play;
~poue.stop;



~poue_gui = "/Users/maxlouisraugel/Documents/sc/instruments/POUE_GUI.scd";~poue_gui.load;


"/Users/maxlouisraugel/Documents/sc/instruments/POUE_GUI.scd".openDocument



midinotelist = [57.1043, 82.687, 31.9784, 39.2878, 78.1187, 49.795, 71.2662, 56.6475]











(
Ndef(\rongs, {
	var snd, trig, freq, arp, pan, fft, ps;
	trig = Impulse.kr(\density.kr(1).linlin(0, 1, 0, 10) * LFNoise2.kr(1, \drift.kr(0), 1));
	freq = \freq.kr().linexp(0, 1, 20, 20000);


	arp = TWChoose.kr(trig, [0.5, 1, 2], [1, 3, 2], 1) *  Demand.kr(trig, 0, Dseq(Array.fib(10, 30, freq),inf)).lag(0.01);
	snd = Rongs.ar(trig,
		\onoff.kr(0).linlin(0, 1, -1, 1),
		arp * LFNoise2.kr(0.1, \detune.kr(0), 1), \structure.kr(0.2),
		\brightness.kr(0.5),
		\damping.kr(0.75),
		\accent.kr(0.9),
		\stretch.kr(0.5),
		\position.kr(0.15),
		\loss.kr(0.15), 5, 3);
	snd = RLPF.ar(snd, \lpf.kr(12000).linexp(0, 1, 20, 20000), \lpq.kr(1));
	// pan = \pan.kr(0).linlin(0, 1, -1, 1);
	// snd = Pan2.ar(snd, LFNoise2.kr(0.3, pan)\pan.kr(0).linlin(0, 1, -1, 1)) * \amp.kr(1);

	snd = Pan2.ar(snd, TRand.kr(\pan.kr(0).neg, \pan.kr(0), trig).linlin(0, 1, -1, 1));
	snd = Normalizer.ar(snd, \norm.kr(0.1));
	snd = Limiter.ar(snd, 1);
	snd * \amp.kr(1);


	// snd = snd.blend(CombL.ar(snd, 0.2, 1/freq, 1), 0.5);
	// snd = Resonator.ar(snd, freq);

	// fft = FFT(LocalBuf(2048), snd);  fft = PV_BinShift(fft, 4, 0.3);	snd = IFFT(fft).dup * 2;
	// fft = FFT(LocalBuf(2048), snd);  fft = PV_PitchShift(fft, MouseY.kr(2, 3));	snd = IFFT(fft).dup * 2;

	snd = snd.blend(JPverb.ar(snd), \jpverb.kr(0));
}).mold(2);
)







Ndef(\rongs).play;
Ndef(\rongs).stop;

// Load the LearnGUI


~rongs_gui = "/Users/maxlouisraugel/Documents/sc/instruments/RONGS_GUI.scd"; ~rongs_gui.load;







































---------







(
Ndef(\rongs, {
	var snd, trig, freq, arp, pan, fft, ps;
	trig = Impulse.kr(\density.kr(1).linlin(0, 1, 0, 10) * LFNoise2.kr(1, \drift.kr(0), 1));
	freq = \freq.kr().linexp(0, 1, 20, 20000);



	arp = TWChoose.kr(trig, [0.5, 1, 2], [1, 3, 2], 1) *  Demand.kr(trig, 0, Dseq(Array.fib(10, 30, freq),inf)).lag(0.01);
	snd = Rongs.ar(trig,
		\onoff.kr(0).linlin(0, 1, -1, 1),
		arp * LFNoise2.kr(0.1, \detune.kr(0), 1), \structure.kr(0.2),
		\brightness.kr(0.5),
		\damping.kr(0.75),
		\accent.kr(0.9),
		\stretch.kr(0.5),
		\position.kr(0.15),
		\loss.kr(0.15), 5, 3);
	snd = RLPF.ar(snd, \lpf.kr(12000).linexp(0, 1, 20, 20000), \lpq.kr(1));
	// pan = \pan.kr(0).linlin(0, 1, -1, 1);
	// snd = Pan2.ar(snd, LFNoise2.kr(0.3, pan)\pan.kr(0).linlin(0, 1, -1, 1)) * \amp.kr(1);

	snd = Pan2.ar(snd, TRand.kr(\pan.kr(0).neg, \pan.kr(0), trig).linlin(0, 1, -1, 1));
	snd = Normalizer.ar(snd, \norm.kr(0.1));
	snd = Limiter.ar(snd, 1);
	snd * \amp.kr(1);


	// snd = snd.blend(CombL.ar(snd, 0.2, 1/freq, 1), 0.5);
	// snd = Resonator.ar(snd, freq);

	// fft = FFT(LocalBuf(2048), snd);  fft = PV_BinShift(fft, 4, 0.3);	snd = IFFT(fft).dup * 2;
	// fft = FFT(LocalBuf(2048), snd);  fft = PV_PitchShift(fft, MouseY.kr(2, 3));	snd = IFFT(fft).dup * 2;

	snd = snd.blend(JPverb.ar(snd), \jpverb.kr(0));
}).mold(2);
)






Ndef(\rongs).gui;


Ndef(\rongs).play;
Ndef(\rongs).stop;

// Load the LearnGUI


~rongs_gui = "/Users/maxlouisraugel/Documents/sc/instruments/RONGS_GUI.scd"; ~rongs_gui.load;


-----

(
~poue = Ndef(\poue, {
		var tempo = \time.kr(1.0, 0.1);
	// var trig = Impulse.kr(tempo.linlin(0, 1, 0, 100) * LFNoise2.kr(0.3, \drift.kr(0), 1));
	var whitecomb = \whitecomb.kr(0, 0.1);
	var feedback = \feedback.kr(1.1, 0.1);
	var dur = \dur.kr(0.91, 0.1).linlin(0.1, 10, 0, 127);

	var temp = tempo;

	var rhythms_list = {{[1, 1/2, 1/3].choose}!4}!10;
	var rhythm = SelectX.kr(\rhythm.kr(0, 0.1).linlin(0, 1, 0, rhythms_list.size -1), rhythms_list);
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
	controlnames, (0.. controlnames.size -1);
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







----------








