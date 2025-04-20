// or in routine form
(
~chords = Routine.run{{
(instrument: \pom, freq: [25.1750, 43.35, 38, 47].midicps, amp: 0.25, atk: 7, rel: 11, out: ~jpverb_bus).play;

	12.wait;

(instrument: \pom, freq: [40, 43.35, 50, 54].midicps, amp: 0.25, atk: 7, rel: 11, out: ~jpverb_bus).play;
}.loop}
)

// for comparison
Ndef(\chords1, Pbind(\instrument, \poom, \dur, 12, \atk, 7, \rel, 11, \freq, Pseq([[25.1750, 43.35, 38, 47], [40, 43.35, 50, 54] ], inf).midicps, \amp, 0.25)).play(fadeTime: 0);

Ndef(\chords1).fadeTime_(5).vol = 1.3;

Ndef(\chords1).stop(3);

// (instrument: \poom, atk: 7, rel: 11, freq: [25.1750, 43.35, 38, 47].midicps, amp: 0.25).play;
// (instrument: \poom, atk: 7, rel: 11, freq: [40, 43.35, 50, 54].midicps, amp: 0.25).play;