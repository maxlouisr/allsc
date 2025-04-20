

~jpverb.play;

(
~grr = Pbindef(\resonhits, \instrument, \rresonrandom, \atk, 0.1, \rel, 4, \dur, 4, \density, 6, \freq, Pseq([100, 1000, 330, 330] /1.66, inf), \amp, 1, \out, ~jpverb_bus).play;
)


(
~chords.stop;
~chords = Pbind(\instrument, \vibratosinfb, \dur, 8, \rate, 6, \sus, 0, \atk, Pkey(\dur)/8, \rel, Pkey(\dur) - Pkey(\atk), \note, Pseq([\Dm7, \A7flat9, \Ab, \Dm11].chordProg, inf) - Pn([12, 24]), \depth, 0.01, \reverb, 0, \room, 3, \amp, 0.7, \out, 0).play(quant: 4);
)
