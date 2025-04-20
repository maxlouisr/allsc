

(
~tabble.set(\midinotes, [ 55.349957715001, 61.842187552603, 68.194629649698, 54.552829374133, 63.486820576352 ]);
~tabble.vol_(1).fadeTime_(30).play;
)

MIDIdef.cc(\tcomb, {|val| ~tabble.set(\comb, val.linlin(0, 127, 0, 1))}, 0, 13, 1524111586);

MIDIClient.init;
MIDIIn.disconnectAll


~tabble.set(\comb, 0.3);

// ~tabble[10] = \filter -> {|in| FreeVerb.ar(in, mix: 0.5, room: 1/5)};
~tabble[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, 0.5)};


// increase tempo very gradually: 1.2, 1.5, etc 2, 3, 5, 8
~tabble.set(\tempo, 8);

s.scope;

(
~tabble.set(\transpose, [0.5, 1.0, 2]);
~tabble.set(\midinotes, [50, 52, 42, 54]);
);

~tabble[10] = \filter -> {|in| FreeVerb.ar(in, mix: 0.5, room: 1)};

~fx = "/Users/maxlouisraugel/Documents/sc/live/FX.scd"; ~fx.load;

~jpverb.play;

(
// 50, 49, 47, (46), 45, 44, 42
var freq = 49.midicps, rel = 15, gain = 1.7;

~moog.release(5);
~moog = Synth(\moogbass, [atk: 3, freq: freq, cutoff: 900, chorus: 1, amp: gain * 1]);
~moog2.release(5);
~moog2 = Synth(\moogbass, [atk: 3, freq: freq * 2, cutoff: 900, chorus: 0.3, amp: gain * 0.5]);
~moog3.release(5);
~moog3 = Synth(\moogbass, [atk: 3, freq: freq * 4, cutoff: 900, chorus: 0.3, amp: gain * 0.3]);
~moog4.release(5);
~moog4 = Synth(\moogbass, [atk: 3, freq: freq / 2, cutoff: 900, chorus: 0.1, amp: gain * 0.3]);
~sinesaw.release(5);
~sinesaw = Synth(\sinesaw, [freq: freq, amp: gain * 0.3]);
~sinesaw2.release(5);
~sinesaw2 = Synth(\sinesaw, [freq: freq *2, amp: gain * 0.3]);
~sinesaw3.release(5);
~sinesaw3 = Synth(\sinesaw, [freq: freq * 4, amp: gain * 0.3]);
~sinesaw4.release(5);
~sinesaw4 = Synth(\sinesaw, [freq: freq / 2, amp: gain * 0.3]);
// Pbind(\instrument, \poom, \dur, Pn(1, 1), \atk, [3, 3, 3, 3], \rel, rel!4, \freq, freq * [1, 2, 4, 1/2], \amp, 0.2, \out, 0).play;
Pbind(\instrument, \pom, \dur, Pn(1, 1), \atk, [3, 3, 3, 3], \rel, rel!4, \freq, freq * [1, 2, 4, 1/2], \amp, gain * 0.2, \out, ~jpverb_bus).play;
)



(
~tabble.fadeTime = 10; ~tabble[15] = \filter -> {|in| LPF.ar(in, 2000)}; ~tabble[10] = nil;

~tabble[15] = \filter -> {|in| LPF.ar(in, 10000)};


~tabble.fadeTime=10;
~tabble[20] = \filter -> {|in| var snd; snd = CombC.ar(in, 0.2, 1/100, 1) * 1/2; snd = LPF.ar(snd, 7000)};
)

~tabble[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, 3)};

// take volume back down
~tabble[5] = nil;



Synth(\poom, [freq: 250, atk: 3, rel: 7, amp: 2/3, pan: -0.7]);
// only run the routine when rolling through verse
(
Routine.run{
~tabble[20] = \filter -> {|in| var snd; snd = CombC.ar(in, 0.2, 1/100, 1) * 1; snd = LPF.ar(snd, 10000)};

	1.wait;

Synth(\pom, [freq: 250, atk: 3, rel: 7, amp: 2/5, pan: -0.7, out: ~jpverb_bus]);
}
)

~wsamples.play;
~wsamples.vol=0.7

~wsamples.stop;


Synth(\pom, [freq: 295, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);



(
~tabble.fadeTime=1;

Routine.run{
~tabble[20] = \filter -> {
		|in| var snd; snd = Resonator.ar(in, 92, structure: 0.5, brightness: 0.5, damping: 0.4);
		snd = BRF.ar(snd, 200, 3);
	};

1.wait;

Synth(\pom, [freq: 370, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);
}
)

Synth(\pom, [freq: 280, atk: 3, rel: 7, amp: 2/3, pan: 0.7, out: ~jpverb_bus]);


Pbind(*[instrument: \pom, dur: 1/2, freq: Pseq([250, 210] * [[2, 4]], 3), atk: 3, rel: 5, amp: Pseq([1/4, 1/3]*2), out:~jpverb_bus]).play;


(
~tabble.fadeTime = 10;
~tabble[15] = \filter -> {|in| LPF.ar(in, 2000)};
)


(
~tabble[20] = nil;
~tabble[10] = nil;
~tabble[15] = nil;

~tabble.set(\whitemul, 0);
Ndef(\pom).set(\feedback, 0.3);
)

~tabble.set(\tempo, 1);

Routine.run{~tabble.set(\tempo, 8); 5.wait; ~tabble.set(\tempo, 7); 5.wait; ~tabble.set(\tempo, 6); 4.wait; ~tabble.set(\tempo, 5); ~tabble.set(\tempo, 4); ~tabble.set(\tempo, 3); ~tabble.set(\tempo, 1)};



Routine.run{~tabble.stop(30); 30.wait;};

(
var fade = 30;
~moog.release(fade);
~moog2.release(fade);
~moog3.release(fade);
~moog4.release(fade);
~moog5.release(fade);
~sinesaw.release(fade);
~sinesaw2.release(fade);
~sinesaw3.release(fade);
~sinesaw4.release(fade);
~sinesaw5.release(fade);
)




// Maybe ?


Ndef(\stk).vol = 0.7;
Ndef(\stk)[10] = \xset -> Pbind(\dur, Pxrand([3, 7, 8], inf), \midinote, Pxrand([50, 52, 54, 49, 45], inf) + Pxrand([0, 12, 24], inf));
Ndef(\stk).stop(0);