(
SynthDef("plucking", {arg amp = 0.1, freq = 440, decay = 5, dampen = 0.1;
var env, snd;
env = Env.linen(0, decay, 0).kr(doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: dampen);
    Out.ar(0, Pan2.ar(snd, \pan.kr(0)));
}).add;
)

(0.1..0.9);



// Example 1
(
{Pbind(
    \instrument, "plucking",
    \degree, Pwhite(0, 12),
    \amp, 0.1,
    \decay, Pwhite(0.2,4.8),
	\dampen, Pwhite(0.3,0.8),
	\ctranspose, [-12,0, 12],
	\scale, Scale.mixolydian,
	\pan, Pwhite (-1,1),
	// \dur, Pxrand([0.51, 2, 10, 0.01, 0.1], inf)
	\dur, Pxrand([0.51, 2, 10, 0.01, 0.1], inf) * Prand([10, 1], inf)
).play;}!10;
)

// Example 2
(
Pbind(
    \instrument, "plucking",
    \scale, Scale.locrian,
    \degree, Pwhite(7, 15),
    \amp, Pwhite(0.1, 0.5),
    \decay, Pwhite(7, 12),
    \dampen, Pwhite(0.01, 0.1),
    \dur, Prand([0.1, 0.2, 0.4, 0.27, 0.13, 0.38], inf)
).play;
)


(
Pbind(
	\instrument, "plucking",
	\degree, Pseq([1,3,3,3,1,1,1,3,3,3,1,3,1,3,3,3,1,1,1,3,3,3,1,3,3,3,1,3,3,3,1,1,1,3,3,3,1,3,1,3,3,3,1,1,1,3,3,3,1,3,3,3,1,1,1,3,3,3,1,3,3,3], 10),
	\dur, 0.1,
	\amp, 0.2,
	\dampen, 0.5,
	\pan, 0
	// \pan, Pwhite (-1,1)
).play;

Pbind(
	\instrument, "plucking",
	\degree, Pseq([7, 18, 4, 2, 1]/2, 40), \dur, 0.9,
	\dampen, 0.1,
	\decay, 15
).play;
)


// Example 3
(
Pbind(
    \instrument, "plucking",
    \scale, Scale.lydian,
    \degree, Pseq([8, 17, 8, 9, 8, 17, 7], inf),
    \amp, Pwhite(0.1, 0.5),
    \decay, Pwhite(1, 2),
    \dampen, Pseq([0.7, 0.8, 0.4], inf),
    \dur, Prand([0.1, 0.2, 0.4], inf),
	\pan, Pwhite(-1, 1.0)
).play;
)

// Example 4
(
Pbind(
    \instrument, "plucking",
    \degree, Pseq([-5, -2, 1, 4, 6, 9], inf),
    \mtranspose, -7,
    \amp, Pwhite(0.2, 0.3),
    \decay, Pseq([7, 6, 6, 5, 4, 3], inf),
    \dampen, Pseq([0.45, 0.3, 0.3, 0.2, 0.2, 0.1], inf) * 2,
    \dur, Prand([0.9, 0.8, 0.7], inf),
	\pan, Pwhite(-1, 1.0)
).play;

Pbind(
    \instrument, "plucking",
    \degree, Prand([0, 1, 3, 4, 6, Pseq([7, 8, 9], 1), 9], inf),
	\mtranspose, 7,
    \amp, Pwhite(0.4, 0.5),
    \decay, Pwhite(6, 10),
    \dampen, Pseq([0.05, 0.1, 0.15], inf) * 2,
    \dur, Prand([0.1, 0.2, 0.4, Rest(0.3)], inf),
	\pan, Pwhite(-1, 1.0)
).play;

)

// Example 5


(
a = Pbind(
    \instrument, "plucking",
	\degree, Pseq([7, 8, 9, 10, 11, 12, 13], inf),
    \amp, 0.2,
    \decay, 4,
    \dampen, 0.05,
    \dur, Prand([0.51, 0.1, 0.1], inf)
);

b = Pbind(
    \instrument, "plucking",
	\degree, Pseq([
		[-7, 2, 4], // chord 1
		[0, 3, 5] // chord 2
	], inf),
    \amp, 0.1,
    \decay, 7,
    \dampen, 0.1,
    \dur, Prand([2, 4], inf)
);
)

// sequence in time
(
{
	~player1 = a.play;
	4.wait;
	~player2 = b.play;
	10.wait;
	~player1.stop;
	4.wait;
	~player2.stop;
}.fork
)