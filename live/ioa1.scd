(
Ndef('rongs', {
	var snd, trig, freq, arp;
	trig = Impulse.kr(\density.kr(1).linlin(0, 1, 0, 100) * LFNoise2.kr(1, \drift.kr(0), 1));
	freq = \freq.kr().linexp(0, 1, 20, 20000);
	arp = TWChoose.kr(trig, [0.5, 1, 2], [1, 3, 2], 1) *  Demand.kr(trig, 0, Dseq(Array.fib(10, 30, 20),inf)).lag(0.01);
	snd = Rongs.ar(trig,
		0,
		arp * LFNoise2.kr(0.1, \detune.kr(0), 1), \structure.kr(0.2),
		\brightness.kr(0.5),
		\damping.kr(0.75),
		\accent.kr(0.9),
		\stretch.kr(0.5),
		\position.kr(0.15),
		\loss.kr(0.15), 5, 3);
	snd = RLPF.ar(snd, \lpf.kr(12000).linexp(0, 1, 20, 20000), \lpq.kr(1));
	// snd = Pan2.ar(snd, \pan.kr(0).linlin(0, 1, -1, 1)) * \amp.kr(1);
	snd = snd.blend(Normalizer.ar(snd, 0.1), \normalize.kr(0));
	snd = Limiter.ar(snd, 1);
	snd = PanAz.ar(2, snd, 0, 4);
	// snd = CombL.ar(snd, 0.2, 0.3, 3);
	// snd = JPverb.ar(snd);
}).mold(2);
Ndef('rongs').set('onoff', 0.031496062992126, 'amp', 0.79527559055118, 'pan', 0.79527559055118, 'structure', 0.1259842519685, 'brightness', 0.96850393700787, 'lpf', 0.91338582677165, 'drift', 0.0, 'damping', 0.67716535433071, 'density', 0.005511811023622, 'freq', 0.05511811023622, 'lpq', 0.54330708661417);
Ndef('rongs').play;
);


MIDIFunc.new({|val| Ndef('rongs').set(\normalize, val.linlin(0, 127, 0, 1))}, 0, 0, \control);

(
MIDIdef.cc(\0, {|val| Ndef('rongs').set(\density, val.linlin(0, 127, 0, 0.1))}, 0);
MIDIdef.cc(\1, {|val| Ndef('rongs').set(\brightness, val.linlin(0, 127, 0, 1))}, 0);
MIDIdef.cc(\2, {|val| Ndef('rongs').set(\damping, val.linlin(0, 127, 0, 1))}, 1);
MIDIdef.cc(\3, {|val| Ndef('rongs').set(\accent, val.linlin(0, 127, 0, 1))}, 2);
MIDIdef.cc(\4, {|val| Ndef('rongs').set(\stretch, val.linlin(0, 127, 0, 1))}, 3);
)