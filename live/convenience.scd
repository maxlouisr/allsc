Convenience.crawl

Convenience.p;

Convenience.list;

Convenience.list(gui: true)

Convenience.s(\lay)

Convenience.properties.do{|property| property.key.postln}

(
Convenience.p(\lay,
    tempo: 8.0,
    index: Prand([19,102,30, 50, 8], inf),
    pos: Pwhite(0.2,0.7),
    dur: Pseq([1,3,Rest(2),2], inf),
    rate: Pwhite(0.9,1.0) * Pstep([0.4,0.9,0.2], Prand([3,5,8], inf), inf),
    pan: Pwhite(-0.65,0.65),
    amp: 0.4
);
)


Convenience.s(\lay)



(
Convenience.p(\psrand,
	tempo: 145/60*4,
	// tempo: 60,
	index: Pwhite(0, 200, inf),
    tuningOnOff: 1,
    degree: Pseq([1,4,6,9], inf),
    octave: Pseq([5,6,7], inf),
    pitchShiftOnOff: 1,
	// pitchRatio: Pwhite(2.2,4.5),
    formantRatio: Pwhite(0.8,5.2),
	folder: \buffers,
    cutoff: Pwhite(500,12000),
    res: 0.5,
    ftype: Prand([0,1], inf),
    pos: 0,
    dur: Pseq([1,1,Rest(17),1,1,1,1,Rest(10),1,1,1,Rest(50)], inf),
	// rate: Pwhite(0.9,1.0) * Pstep([0.4,0.9,0.2], Prand([3,5,8], inf), inf)+3,
    pan: Pwhite(-0.65,0.65),
    amp: 0.4,
	// release: 2
	release: Pwhite(0.1, 0.30)
);
)

Convenience.s(\psrand, 10)

Convenience.pp(\psrand, 'res', 0.96);
Convenience.pp(\psrand, 'res', Pseq([0.5,0.75,0.9,0.2], inf));
Convenience.pp(\psrand, 'degree', 1);
Convenience.pp(\psrand, 'tempo', 5);


(
Convenience.pfx(\lay, [\smear, \flanger],
	\wet1, 0.1,
	\mush, 1,
    \wet2, Pseq((1..50)/50, inf),
    \flangdelay, 0.99,
    \flangdepth, 0.1,
    \flangrate, 0.9,
    \flangfb, 0.6
);
)

!

Convenience.s(\psrand); // stop
Convenience.clear(\psrand); // house keeping -> free and clear all fxs associated with 'psrand'

// list all fxs in the Convenience system
Convenience.fxs;
// list all param arguments of a specific fx
Convenience.fxargs(\phaser)

_______

Convenience.crawl

(
Convenience.p(\organ,
	folder: \Ott_Orgel_Prinzipal_2,
	index: Pwhite(0, 55, inf).round(7),
	amp: 0.1,
	dur: Pwhite(5, 10)
);
)

(
Convenience.pfx(\fxorgan, [\phaser],
	\wet1, 10,
	\phaserrate, 0.1,
	\phaserdepth, 1
)
)


