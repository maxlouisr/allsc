(
s.waitForBoot;
b = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/foley_balloon_punching_balloon.wav");
c = Buffer.read(s, "/Users/maxlouisraugel/Desktop/zapsplat_foley_drink_can_cola_squash_in_hand_gently_001_11869.wav");
w = Buffer.read(s, "/Users/maxlouisraugel/Desktop/wood creak.wav");
)




(
SynthDef("magshift", {
	var chain, in , sound;
	in = PlayBuf.ar(1, \buffer.kr(b), \rate.kr(1, 3), loop:\loop.kr(1));
	chain = FFT(Buffer.alloc(s, 2048), in);
	sound = PV_MagShift(chain, \stretch.kr(1.0, 1), \shift.kr(0, \lag.kr(1)));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2 * \amp.kr(1))
}).add
)

~magshift = Synth(\magshift, [buffer: ~testfolder[30], amp:0.5, stretch:0.4])
~magshift.set(\buffer, 7, \stretch, 0.7, \shift, 100)
~magshift.free;

(
SynthDef("magfreeze", {
	var chain, in , sound;
	in = PlayBuf.ar(1, \buffer.kr, \rate.kr(1, 3), loop:\loop.kr(1));
	chain = FFT(Buffer.alloc(s, 2048), in);
	sound = PV_MagFreeze(chain, \freeze.kr(0));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2 * \amp.kr(1))
}).add
)

~magfreeze = Synth("magfreeze", [buffer: 2])
~magfreeze.set(\buffer, 28, \amp, 0.1)
~magfreeze.set(\freeze, 1)

trigger


(
SynthDef("freeze", {
	var chain, in , sound;
	in = PlayBuf.ar(1, \buffer.kr, \rate.kr(1, 3), loop:\loop.kr(1));
	chain = FFT(Buffer.alloc(s, 2048), in);
	sound = PV_Freeze(chain, \freeze.kr(0));
	sound = IFFT(sound);
	sound = Pan2.ar(sound, MouseX.kr(-1, 1));
	Out.ar(\out.kr, sound * \amp.kr(1))
}).add
)


~freeze = Synth("freeze", [buffer:rrand(0, 30), \amp, 0.1])
~freeze.set(\buffer, rrand(0, 30), \amp, 0.1, \freeze, 0)
~freeze.set(\freeze, 1)

~freeze2 = Synth("freeze", [buffer:rrand(0, 30), \amp, 0.1])

~freeze2.free;

(
SynthDef("magminus", {
	var chain1, chain2, in1, in2, sound;
	in1 = PlayBuf.ar(1, \buffer1.kr, \rate.kr(1, 3), loop:\loop.kr(1));
	chain1 = FFT(Buffer.alloc(s, 2048), in1);
	in2 = PlayBuf.ar(1, \buffer2.kr, \rate.kr(1, 3), loop:\loop.kr(1));
	chain2 = FFT(Buffer.alloc(s, 2048), in2);
	sound = PV_MagMinus(chain1, chain2, \remove.kr(1));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2 * \amp.kr(1))
}).add
)

~magminus = Synth(\magminus)
~magminus.set(\buffer1, rrand(0, 30), \buffer2, rrand(0, 30), \amp, 0.1)
~magminus.set(*[buffer1: rrand(0, 30), buffer2: rrand(0, 30), amp: 0.1])
~magminus.set(\remove, 10)












































-----

(
SynthDef("magmul", {
	var chain1, chain2, in1, in2, sound;
	in1 = PlayBuf.ar(1, \buffer1.kr(320), \rate.kr(1, 3) * BufRateScale.ir(\buffer1.kr), loop:\loop.kr(1));
	chain1 = FFT(Buffer.alloc(s, 2048), in1);
	in2 = PlayBuf.ar(1, \buffer2.kr, \rate.kr(1, 3) * BufRateScale.ir(\buffer1.kr), loop:\loop.kr(1));
	chain2 = FFT(Buffer.alloc(s, 2048), in2);
	sound = PV_MagMul(chain1, chain2, \remove.kr(1));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2 * \amp.kr(0.1))
}).add
)

~magmul = Synth("magmul", [amp: 0.2])
~magmul.set(*[buffer1: rrand(0, 30), buffer2:rrand(0, 30), amp: 0.1])

~magmul.free;

Buffer.freeAll;

~screc = BufFiles(s,"/Users/maxlouisraugel/Music/SuperCollider Recordings/", channel:0)

~magmul = Synth("magmul", [buffer1: rrand(0, 30), buffer2: rrand(0, 30), amp: 0.1])
b = d[\thanks][0]

.play;

b.bufnum

~fiminco = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/test parler.WAV");

(
{
    var in, chain;
	in = PlayBuf.ar(2, ~testparler, LFNoise2.kr(10) + 1 * BufRateScale.ir(~testparler	), 1, 0, 1);
    //in = WhiteNoise.ar(0.2);
	// in = SoundIn.ar([0, 1]);
    chain = FFT({ LocalBuf(2048) } ! 2, in);
    chain = PV_MagBelow(chain, MouseY.kr(0, 100));
    0.5 * IFFT(chain);
}.play;
)


(
~brickwall.free;
~brickwall = {
    var in, chain;
	in = PlayBuf.ar(2, b, 1 * BufRateScale.ir(b), 1, 0, 1);
	// in = SoundIn.ar([0, 1]);
    chain = FFT({LocalBuf(2048)}!2, in);
    chain = PV_BrickWall(chain, LFNoise2.kr(10));
    IFFT(chain)
}.play;
)

// original
(
~brickwall.free;
~brickwall = {
    var in, chain;
	in = PlayBuf.ar(2, b, 0.5 * BufRateScale.ir(b), 1, 0, 1);
	// in = SoundIn.ar([0, 1]);
    chain = FFT({LocalBuf(2048)}!2, in);
    chain = PV_BrickWall(chain, LFNoise2.kr(10));
    IFFT(chain)
}.play;
);





(
~brickwall.free;
~brickwall = {|buffer, rate = 1, wipe = 0.5, amp = 1|
    var in, chain, sig;
	in = PlayBuf.ar(2, buffer, rate * BufRateScale.ir(buffer), 1, 0, 1);
	// in = SoundIn.ar(0);
    chain = FFT({LocalBuf(2048)}!2, in);
	chain = PV_BrickWall(chain, wipe * 2 - 1);
    sig = IFFT(chain) * amp;
}.play;
);

~brickwall.set(\wipe, 0.55, \amp, 1.3)
~brickwall.set(\buffer, ~recent[rrand(0, 30)])

~brickwall.set(\buffer, b)




(
~randcomb.free;
~randcomb = {
	|amp = 2, buffer|
    var in, chain, gate;
	gate = KeyState.kr(2, -1, 1, 0);
	// 2 = d
	in = PlayBuf.ar(2, b, 0.5 * BufRateScale.ir(buffer), 1, 0, 1) * amp;
	// in = SoundIn.ar(0);
	chain = FFT(LocalBuf(2048 *2), in);
	chain = PV_RandComb(chain, 0.9, gate)!2;
    IFFT(chain) * 3;
}.play;
);


~recent = BufFiles(s,"/Users/maxlouisraugel/Desktop/testrecent/");

(
~win = Window.new;
~win.front;
)
~randcomb.set(\amp, 0.8);

(
~randcomb2 = {
	|amp = 10, buffer, wipe = 0.92|
    var in, chain, gate, snd;
	gate = KeyState.kr(2, -1, 1, 0);
	// 2 = d
	in = PlayBuf.ar(2, b, 0.5 * BufRateScale.ir(b), 1, 0, 1) * amp;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_RandComb(chain, wipe, Dust.kr(1))!2;
    snd = IFFT(chain);
}.play;
)






(
{
    var in, chain;
	in = PlayBuf.ar(2, b, 100, 1, 0, 1) * 0.1;
	in = SoundIn.ar(0);
    chain = FFT({LocalBuf(2048)}!2, in);
    chain = PV_RectComb(chain, 8, LFTri.kr(0.097,0,0.4,0.5),
        LFTri.kr(0.24,0,-0.5,0.5));
    IFFT(chain)
}.play;
)


(
~freeze.free;
~freeze = {
    var in, chain;
	in = PlayBuf.ar(2, b, 1, 1, 0, 1) * MouseY.kr(0, 1);
	// in = SoundIn.ar(0);
    chain = FFT({ LocalBuf(2048) } ! 2, in); // we need two buffers for stereo input.
    // moves in and out of freeze
	chain = PV_Freeze(chain, MouseX.kr(1, -1) );
    0.5 * IFFT(chain);
}.play;
)

















(
SynthDef(\spectralenhance, {
	arg ratio = 2, partials = 8, loop = 1, buffer = b;
    var chain, snd;
	snd = PlayBuf.ar(2, b, 1 * BufRateScale.ir(buffer), 1, 0, loop);
	// snd = SoundIn.ar(0);
	chain = FFT({LocalBuf(2048)}!2, snd);
    // MouseX controls strength
    chain = PV_SpectralEnhance(chain, partials, ratio, MouseX.kr(0, 0.99));
    snd = IFFT(chain);
    Out.ar(0, snd.dup);
}).add
)

~enhance = Synth(\spectralenhance)

~enhance.set(\partials, 100, \ratio, 3, \buffer, 2)




(
/*s.waitForBoot;*/
b = Buffer.read(s, "/Users/maxlouisraugel/Documents/son/foley_balloon_punching_balloon.wav");
c = Buffer.read(s, "/Users/maxlouisraugel/Desktop/zapsplat_foley_drink_can_cola_squash_in_hand_gently_001_11869.wav");
w = Buffer.read(s, "/Users/maxlouisraugel/Desktop/wood creak.wav");
)



(
~fftbuffer1 = Buffer.alloc(s, 2048);
~fftbuffer2 = Buffer.alloc(s, 2048);
// s.sync;

SynthDef(\xfade, {
	|buffer1 = 0, buffer2 = 1, rate = 1|
	var chain1, chain2, snd, morph;
	morph = MouseX.kr;
	chain1 = SinOsc.ar(MouseY.kr(20, 20000, 1), 0, 0.1);
	chain1 = PlayBuf.ar(1, buffer1, rate * BufRateScale.ir(buffer1), 1, 0, 1);
	chain2 = PlayBuf.ar(1, buffer2, rate * BufRateScale.ir(buffer2), 1, 0, 1);
	chain1 = FFT(~fftbuffer1, chain1);
	chain2 = FFT(~fftbuffer2, chain2);
	snd = PV_XFade(chain1, chain2, morph);
	snd = IFFT(snd);
	Out.ar(0, snd!2);
}).add;
)

~xfade = Synth(\xfade)

~xfade.set(\buffer1, w, \buffer2, b)

~xfade.free;



~audio = BufFiles.new(s, "/Users/maxlouisraugel/Desktop/buffers/", channel:0);


~audio[4].play;

(
SynthDef(\magsmooth, {
	|out = 0, rate = 1, buffer = 0, speed = 0.1, smooth = 0.1|
	var chain, snd, trigger;
	// trigger = Impulse.ar(speed);
	chain = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer));
	// chain = SoundIn.ar(0);
	chain = FFT(Buffer.alloc(s, 2048), chain);
	chain = PV_MagSmooth(chain, smooth);
	snd = IFFT(chain);
	Out.ar(out, snd!2);
}).add
)

~magsmooth = Synth(\magsmooth, [buffer: b, smooth:0.99])

(
SynthDef(\magsmear, {
	|out = 0, rate = 1, buffer = 0, speed = 0.1, smear = 0.1|
	var chain, snd, trigger;
	// trigger = Impulse.ar(speed);
	chain = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer));
	chain = FFT(Buffer.alloc(s, 2048), chain);
	chain = PV_MagSmear(chain, smear * 1000);
	snd = IFFT(chain);
	Out.ar(out, snd!2);
}).add
)

x = Synth(\magsmear, [buffer:b, smear: 0.3]);

Ndef(\magsmear).clear;


(
Ndef(\magsmear, {
	|rate = 1, speed = 0.1|
	var chain, in, snd, trigger, buffer;
	// trigger = Impulse.ar(speed);
	buffer = d[\thanks][3];
	in = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer), 1, 0, \loop.kr(1));
	chain = FFT(Buffer.alloc(s, 2048), in);
	chain = PV_MagSmear(chain, 1 * Line.kr(200, 1/10, 1));
	snd = IFFT(chain);
	snd!2 * \amp.kr(1);
}).play;
)


(
Ndef(\magsmear, {
	|rate = 1, speed = 0.1|
	var chain, in, snd, trigger, buffer;
	trigger = Impulse.kr(\density.kr(1));
	buffer = \buffer.kr(C.get(\kalimba, 6));
	in = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer), trigger, 0, \loop.kr(1), doneAction:2);
	chain = FFT(Buffer.alloc(s, 2048), in);
	chain = PV_MagSmear(chain, \smear.kr(10));
	snd = IFFT(chain);
	snd!2 * \amp.kr(1);
}).play.gui;
)



Ndef(\magsmear).gui



(
SynthDef(\partialsynth, {
	|out = 0, rate = 1, buffer = 0, speed = 0.1, threshold = 0.1, amp 1, numFrames 2|
	var chain, snd, trigger;
	// trigger = Impulse.ar(speed);
	chain = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer));
	chain = FFT(Buffer.alloc(s, 2048), chain);
	chain = PV_PartialSynthF(chain, threshold, numFrames);
	snd = IFFT(chain);
	Out.ar(out, snd!2 * amp);
}).add
)

~partialsynth = Synth(\partialsynth, [buffer:b, threshold:0.5])

~partialsynth = Synth(\partialsynth, [buffer: d[\thanks][1], threshold:1, numFrames: 4])

~mousebus = Bus.control(s, 1);
~mouse = Synth(\mouseY, [min: 0, max: 1]);
~mouse.set(\max, 2)

~partialsynth.set(\threshold, ~mousebus.asMap, \amp, 5, \numFrames, 10);



a = Buffer.readChannel(s, "/Users/maxlouisraugel/Documents/son/armoire.WAV",channels:1);

(
SynthDef(\noisesynth, {
	|out = 0, rate = 1, buffer = 0, speed = 0.1, threshold = 0.1|
	var chain, snd, trigger;
	// trigger = Impulse.ar(speed);
	chain = PlayBuf.ar(1, a, rate * BufRateScale.ir(buffer));
	chain = FFT(Buffer.alloc(s, 2048), chain);
	chain = PV_NoiseSynthF(chain, threshold);
	snd = IFFT(chain);
	Out.ar(out, snd!2);
}).add
)

~noisesynth = Synth(\noisesynth, [buffer: a, threshold: 1])

Synth(\mouseX, [min:1, max: 10, out: 101])

~noisesynth.map(\threshold, 101)
~partialsynth.map(\threshold, 101)

~mouserate = Synth(\mouseX, [min: 0.5, max:2, out:102])
~noisesynth.map(\rate, 102)






(
SynthDef("softwipe", {
	|out = 0, buffer1, buffer2, rate = 1, loop = 0, wipe = 0, wipetime = 2|
	var in1, in2, chain1, chain2, snd, line;
	line = Line.kr(-1, 1, wipetime, doneAction:2);
	in1 = PlayBuf.ar(1, buffer1, rate, loop:loop);
	in2 = PlayBuf.ar(1, buffer2, rate, loop:loop);
	chain1 = FFT(Buffer.alloc(s, 2048), in1);
	chain2 = FFT(Buffer.alloc(s, 2048), in2);
	snd = PV_SoftWipe(chain1, chain2, line);
	snd = IFFT(snd);
	Out.ar(out, snd!2);
}).add;
)

~testfolder = BufFiles(s, "/Users/maxlouisraugel/Desktop/testrecent/", channel:0)

~soft = Synth("softwipe", [buffer1: ~testfolder[rrand(0, 20)], buffer2: ~testfolder[rrand(0, 30)], wipetime:rrand(1, 5)])
~soft.free;

~testfolder.buffers;



(
SynthDef("maxmag", {
	var chain, in , sound;
	in = PlayBuf.ar(1, \buffer.kr, \rate.kr(1, 3), loop:\loop.kr(1));
	chain = FFT(Buffer.alloc(s, 2048), in);
	sound = PV_MaxMagN(chain, \bins.kr(10));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2)
}).add
)


~maxmag = Synth(\maxmag, [buffer: ~testfolder[4]])
~maxmag.set(buffer: ~testfolder[7])

~maxmag2 = Synth(\maxmag, [\buffer, ~testfolder[4], \bins, 1])




-----


(
SynthDef("spectralmap", {
	var chain1, chain2, in1, in2, sound;
	in1 = PlayBuf.ar(1, \buffer1.kr, \rate.kr(1, 3) * BufRateScale.ir(\buffer1.kr), loop:\loop.kr(1));
	// in1 = LFSaw.ar(300, 0, 0.1);
	chain1 = FFT(Buffer.alloc(s, 2048), in1);
	in2 = PlayBuf.ar(1, \buffer2.kr, \rate.kr(1, 3) * BufRateScale.ir(\buffer1.kr), loop:\loop.kr(1));
	chain2 = FFT(Buffer.alloc(s, 2048), in2);
	sound = PV_SpectralMap(chain1, chain2, \floor.kr(0), \mode.kr(0));
	sound = IFFT(sound);
	Out.ar(\out.kr, sound!2 * \amp.kr(0.1))
}).add
)

x = Synth("spectralmap", [buffer1: b, buffer2: C.get(\thanks, 10), floor: 0.5, mode: 0.99]);

x.set(\buffer1, C.get(\thanks, 3), \buffer2, C.get(\snares, 4))


~short = BufFiles(s, "/Users/maxlouisraugel/Desktop/short/", channel:0)

~spectralmap = Synth(\spectralmap, [buffer1: 0, buffer2:1, floor: 0.1, mode: 0.99, amp: 10])

~mouseYspectral = Synth(\mouseY, [out: 101, min:0, max:1])
~spectralmap.map(\floor, 101)

