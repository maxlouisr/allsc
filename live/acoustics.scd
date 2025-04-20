MasterEQ.new

// ESSENTIALS

// very short 'dot'
Synth(\percsine, [freq: 138 *8*2*2*2, atk: 0.01, rel: 0.01, amp: 1.4])


// very short white dot

(instrument: \whiteperc, atk: 0.001, rel: 0.001, amp: 1.3).play;


// very short 'total' linear sweep
var time = 0.1; Synth(\sweep, [freq: Env([20, 20000], time, 'lin'), amp: Env([0, 1/2, 0], [time/2, time/2])]);

// very short 'total' linear sweep simultaneous
var time = 0.1; Synth(\sweep, [freq: Env([20, 20000], time, 'lin'), amp: Env([0, 1/2, 1/2, 0], [time/10, time/10 * 8, time/10])]);


// bass loop

r.stop;r = {{Synth(\percsine, [freq: 45, atk: 0.1, rel: 1, amp: 1/3]); 5.wait;}.loop}.fork;


// bass with micro-tuning variations
r.stop; r = {{Synth(\percsine, [freq: rrand(42, 47), atk: 0.1, rel: 1, amp: 1/3]); 5.wait;}.loop}.fork;





// percussive tones

Synth(\percsine, [freq: 55, atk: 1, rel: 2, amp: 1/3]);
Synth(\percsine, [freq: 60, atk: 3, rel: 2, amp: 1/4]);
Synth(\percsine, [freq: 5000*2, rel: 0.7, amp: 0.1/1]);
Synth(\percsine, [freq: 70, atk: 0.3, rel: 0.1, amp: 1])



Synth(\percsine, [freq: 300])
Synth(\percsine, [freq: 400])
Synth(\percsine, [freq: 500, amp: 0.1])
Synth(\percsine, [freq: 600])
Synth(\percsine, [freq: 700])
Synth(\percsine, [freq: 800])
Synth(\percsine, [freq: 900])

Ndef(\u).stop;

Synth(\percsine, [freq: 98 * 32, rel: 0.1, amp: 1/3]);
Synth(\percsine, [freq: 5000, rel: 0.1, amp: 0.1])

(

// very short impact
(instrument: \whiteperc, atk: 0.001, rel: 0.001, amp: 1.3).play;

Synth(\sinesawperc, [freq: 57 * [31, 4, 8, 13].choose, rel: 5, amp: 0.1]);

C.get(\snares, 3).play;

{SinOsc.ar(MouseX.kr(20, 20000), 0, MouseY.kr(0, 1))}.play;


// sustained tones

x=Synth(\percsine, [freq: 740, atk: 3, rel: 10, amp: 0.1/3, pan: 1])
x.release(10);


// detune
~detune = {var snd; snd = SinOsc.ar(138 * LFNoise2.kr(1, 0.05, 1), 0, 0.1)}.play;
~detune.release;



// SWEEP


// very short 'total' linear sweep
var time = 0.1; Synth(\sweep, [freq: Env([2000, 20000], time, 'lin'), amp: Env([0, 1, 0], [time/2, time/2])]);

// longer 'total' linear sweep
var time = 10; Synth(\sweep, [freq: Env([20, 20000], time, 'lin'), amp: Env([0, 1/10, 0], [time/2, time/2])]);

// longer linear sweep in high pitches ('white pitches' ?)
var time = 1; Synth(\sweep, [freq: Env([2000, 20000], time, 'lin'), amp: Env([0, 1/10, 0], [time/2, time/2])]);

Synth(\sweep, [freq: Env([20, 20000], 0.1, 'lin'), amp: Env([0, 1, 0], [1/2, 1/2])]);

// very short 'total' exponential sweep
Synth(\sweep, [freq: Env([20, 20000], 0.1, 'exp'), amp: Env([0, 0.4, 0], [0.1/2, 0.1/2])]);

Synth(\sweep, [freq: Env([20, 150], 0.9), amp: Env([0, 0.1, 0], [3, 3])]);

Synth(\sweep, [freq: Env([3000, 20], 6), amp: Env([0, 0.1, 0], [3, 3])]);

Synth(\sweep, [freq: Env([300, 3000], 6), amp: Env([0, 0.1, 0], [3, 3])]);

Synth(\sweep, [freq: Env([10000, 300], 6), amp: Env([0, 0.1, 0], [3, 3])]);

Synth(\sweep, [freq: Env([20000, 3000], 0.1), amp: Env([0, 0.6, 0], [3, 3])]);

~sweeps.play;

~sweeps.stop; ~sweeps = Routine.run({{var dur = rrand(0.7, 1.2); Synth(\sweep, [freq: Env([exprand(20, 200), exprand(20, 200)], dur), amp: Env([0, 0.1, 0], [dur/2, dur/2])]); 5.wait;}.loop});



// mouse


Ndef(\mousefreq, {SinOsc.ar(MouseX.kr(20, 20000, 1).poll, 0, MouseY.kr(0, 1/2))!2}).play;


~sweep = {|time 3| SinOsc.ar(Env([90, 2000], [time], 'sine').kr(2), 0, Env([0, 1/10, 0], [time/2, time/2], 'sine').kr(2))!2}.play

~sweep.release(1)


(
~sub.release;
~sub = {SinOsc.ar(LFNoise2.kr(3!2).range(20, 30), 0, LFNoise2.kr(1).abs * 0.05 + 0.2)}.play;
)

