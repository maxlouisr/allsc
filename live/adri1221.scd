C.crawl("/Users/maxlouisraugel/Documents/son/adri1221/");

C.p(\test1, dur: Pxrand([1, 0.1], inf), folder: \adri1221, seed: rrand(0, 500), index: Pxrand((0..123), inf), attack: 1, release: 16, degree: Pwhite(0, 10), scale: Scale.major);

C.s(\test1);



C.p(\test, dur: Pxrand([0.2, 0.1], inf), folder: \adri1221, seed: rrand(0, 500), index: Pxrand((0..123), inf), attack: 0.01, sustain: 0.1, release: 0.1, degree: Pwhite(0, 10), scale: Scale.major);

C.p(\test, dur: Pxrand([0.2, 0.1], inf), folder: \adri1221, seed: rrand(0, 500), index: Pxrand((0..123), inf), attack: 0.01, sustain: 0.1, release: 0.1, rate: Pstep([\Em, \Am7, \Bm].chordProg, [16, 16, 16], inf).midiratio);


C.p(\test, dur: Pxrand([1, 2], inf), folder: \adri1221, seed: rrand(0, 500), index: Pstep([10, 10, 10], [4, 4, 4], inf), attack: 0.01, sustain: 0.1, release: Pkey(\dur), rate: Pstep([\Em, \Am7, \Bm].chordProg, [4, 4, 4], inf).midiratio / Pstep([2, 4, 4], inf) / 2, quant: 4);


C.p(\2, dur: 0.1, folder: \adri1221, index: 72, quant: 4, rate: Pslide(Array.fib(7, 0.1, 0.5), 3), sustain: Pkey(\dur), release: 0.1)
C.s(\2)


