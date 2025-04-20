

Safety(s).numChannels_(18);

(
Safety.addSynthDefFunc(\remapOutputs, {
    ReplaceOut.ar(9, Silent.ar(2));
    ReplaceOut.ar(12, In.ar(11, 6));
});
)




----


Safety(s).numChannels_(16);

Safety.synthDefFuncs;

(
Safety.addSynthDefFunc(\remapOutputs, {

	// ReplaceOut.ar(0, In.ar(0, 10));  // commented because does not change anything, just for reference
	ReplaceOut.ar(12, In.ar(11, 17));
});
)

(

Safety.addSynthDefFunc(\remapOutputs, {
    ReplaceOut.ar(12, In.ar(11, 17));
});
)


~outputs = (0..8)++(11..17);

~input = In.ar(~outbus,6); ~outputs.collect{|j, i| Out.ar(j,~input[i])};


(
SynthDef(\test, {|out 17|
	var snd;
	snd = SinOsc.ar(100, 0, Env.perc().kr(2));
	Out.ar(out, snd);
}).play;
)

(
t = Ndef(\test, {
	var snd;
	// snd = SinOsc.ar(100, 0, 0.1);
	snd = SinOsc.ar(100!37, 0, 0.1);
	snd = SplayAz.ar(~numChannels, snd, 1, 1, ~numChannels * 2);
}).mold(~numChannels);

t.play;
)

Ndef(\test).resume



-----

// establish a 16ch bus
~out = Bus.audio(server: s, numChannels: 16);

(
Ndef(\out, {
	// get signals of outbus - use InFeedback to not care about order within graph
	// but introduces a delay of the length of the server block size
	var sig = InFeedback.ar(~out, numChannels: 16);
	// split signal by splicing a Silent.ar in between
	// adjust to liking
	sig[0..7] ++ Silent.ar.dup(2) ++ sig[7..15];
// play this on the soundcard, starting from output 0
}).play(out: 0);
)


(
// some 16ch sig
Ndef(\foo, {
	SinOsc.ar(16.collect({|i| 200 + (i**2)})) * LFDNoise3.kr(0.5!16).exprange(-40.dbamp, -10.dbamp);
// output needs to be the ~out bus
}).play(out: ~out).scope;
)

(
// example how to apply to patterns to out
Pdef(\foo, Pbind(
	\dur, 0.5,
	\offset, Pwhite(0, 15),
	\out, ~out.index + Pkey(\offset),
	\pan, -1,
)).play;
)