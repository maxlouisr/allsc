~lightpop2 = "/Users/maxlouisraugel/Documents/ /lightpop2.wav".b;

(
Pbindef(\a, \instrument, \playlinen, \dur, 1/16, \buffer, ~lightpop2, \rate, Pxrand(Array.series(10, 1, 2.3), inf).midiratio, \amp, 1, \atk, 0, \sus, ~lightpop2.duration, \pan, Pwhite(-1, 1.0)).play;

Pbindef(\b, \instrument, \playlinen, \dur, 1/16, \buffer, ~lightpop2, \rate, Pxrand(Array.series(10, 1, Pseg([2.3, 0.4], 4, 'lin', inf)), inf).midiratio, \amp, 1, \atk, 0, \sus, ~lightpop2.duration, \pan, Pwhite(-1, 1.0)).play;
)

Pbindef(\b).stop;

(
Pbindef(\a, \rate, Pxrand(Array.series(10, 1, 2.3), inf).midiratio / 2, \sus, ~lightpop2.duration/5);
Pbindef(\b, \sus, ~lightpop2.duration/5);
)

(
Pbindef(\a, \rate, Pxrand(Array.series(10, 1, 2.3), inf).midiratio, \atk, 1, \sus, ~lightpop2.duration/5, \amp, 5);
Pbindef(\b, \atk, 1, \sus, ~lightpop2.duration/5, \amp, 5);
)


(
Pbindef(\a, \buffer, [C.get(\bassdrums, 5), C.get(\kalimba, 3)], \amp, [1/10, 0.5]);
Pbindef(\b, \buffer, [C.get(\bassdrums, 5), C.get(\kalimba, 3)], \amp, [1/10, 0.5]);
)











-----
Pbindef(\a, \instrument, \play, \dur, 1/16, \buffer, ~lightpop, \rate, Pseq([Pxrand([0, 2, 7, 12, 11], 64), Pxrand([-1, 2, 7, 3, 8], 32)], inf).midiratio/2, \amp, 1, \pan, Pwhite(-1, 1.0)).play;

// Pbindef(\a, \instrument, \play, \dur, 1/16, \buffer, ~lightpop, \rate, Pseq([Pxrand(\Em11sharp5.asNotes, 16), Pxrand(\Am11.asNotes, 16)], inf).midiratio/2, \amp, 1, \pan, Pwhite(-1, 1.0)).play;
