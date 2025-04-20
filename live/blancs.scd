~harshresmono = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/ /note harsh resonance ..wav", channels:0);
~guitarHmono = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/son/Ableton Projects/2021/Samples/Imported/guitar harmonics.WAV", channels:0);



Pbindef(\blanc1, \instrument, \singlegrainbuf, \buffer, ~guitarHmono, \dur, Pseg([0.3, 0.3, 0.1], [50, 60], 'lin', inf), \grainDur, Pkey(\dur), \pos, [0.34, 0.13, 0.91], \strum, 0.1, \rate, [0].midiratio, \amp, [5, 1, 1] * 1).play;

Pbindef(\blanc1, \instrument, \singlegrainbuf, \buffer, ~guitarHmono, \dur, Pseg([0.3, 0.3, 0.1], [50, 60], 'lin', inf), \grainDur, Pkey(\dur), \pos, [0.34, 0.13, 0.91], \strum, 0.1, \rate, Pseq([\Em, \Am], inf).midiratio, \amp, [5, 1, 1] * 1).play;

Pbindef(\blanc, \instrument, \singlegrainbuf, \buffer, ~guitarHmono, \dur, 0.1, \grainDur, Pkey(\dur), \pos, 0.34, \rate, Pseq([\Em, \Am], inf).midiratio, \amp, 1 * 3, \pan, 0).play;

Pbindef(\blanc5, \instrument, \singlegrainbuf, \buffer, ~guitarHmono, \dur, 0.05, \grainDur, Pkey(\dur), \pos, 0.34, \rate, Pseq([\Am, \Gm7].chordProg + 4, inf).midiratio / 2, \amp, 1 * 2, \pan, Pseg([1, -1], 30, 'lin', inf)).play;


Pbindef(\grain, \instrument, \singlegrainbuf, \buffer, ~harshresmono, \dur, 0.1/5, \grainDur, 0.5, \rate, 0.98, \pos, Pseg([0.1, 0.35, 0.1], [5, 5], 'lin', inf), \amp, 1, \pan, Pseg([-1, 1, -1], [5, 5], 'lin', inf)).play;

Pbindef(\grain2, \instrument, \singlegrainbuf, \buffer, ~guitarHmono, \dur, Pseg([0.1, 0.4, 0.01, 0.2, 0.05, 1], [5, 3, 10], 'exp', inf)/10, \grainDur, 1, \rate, 1, \pos, Pseg([18, 17], 10, 'lin', inf)/100, \amp, 0.2, \pan, Pseg([-1, 1, -1], [3, 3], 'lin', inf)).play;




