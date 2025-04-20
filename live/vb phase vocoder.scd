// load a soundfile into a buffer and create a buffer that will hold the spectral data

b = Buffer.loadDialog(s, action: {c = VBPVoc.createBuffer(s, 2048, b) });

// do the pvoc analysis and store spectral data
c.pvocAnal(b, 2048);

// or
~windowsize = 2048/2;

(
b.free;
c.free;
)

(
Routine.run({
	b = "/Users/maxlouisraugel/Documents/ /kick.wav".b;
	// b = "/Users/maxlouisraugel/Documents/son/adrianpipe I.wav".b;
s.sync;
c = VBPVoc.createBuffer(s, ~windowsize, b);
c.pvocAnal(b, 2048/4);
})
)



// play the pvoc data with mouse
(
x.free;
x = {VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 1), ~windowsize, MouseY.kr(0, 1))}.play;
)



// with pan

(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 0.2), 2048, 1/2); snd =  Balance2.ar(snd[0], snd[1], MouseX.kr(-1, 1), MouseY.kr(0, 1))}.play;
)

// slower freeze-play
(
x.free;
x = {VBPVoc.ar(2, c.bufnum, SinOsc.ar(1/(b.duration), 0, 1, 0).abs / MouseY.kr(30, 1), 2048)}.play;
)


// with sine deviation from pos

(
x.free;
x = {VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0) * SinOsc.ar(MouseY.kr(0, 1), 0, 0.1).abs, 2048*2, 1/2)}.play;
)

// deviation with lfnoise
(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0) * LFNoise2.ar(MouseY.kr(0, 1), 0.1).abs, 2048*2, 1/2)}.play;
)

// same with jpverb

(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0) * LFNoise2.ar(MouseY.kr(0, 1), 0.1).abs, 2048*2, 1/2); snd = JPverb.ar(snd); snd = LPF.ar(snd, 10000)}.play;
)

// with pitchshift

(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 0.2), 2048, 1/2); snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.3), MouseY.kr(0.1, 2), MouseY.kr(0.1, 2), 10, 10, 8, 2);}.play;
)

// with pitchshift on major scale
(
x.free;
x = {
	var snd, scale;
	snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 0.2), 2048, 1/2);
	snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.3), MouseY.kr(0.1, 2), MouseY.kr(0.1, 2), 10, 10, 8, 2)}.play;
)

// with extreme pitchshift effect

(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 0.2), 2048, 1/2); snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0].lag(0.3), 1/10, MouseY.kr(0.1, 10).round(0.5)); snd =  Balance2.ar(snd[0], snd[1], MouseX.kr(-1, 1), MouseY.kr(0, 1))}.play;
)



// with chord

(
x.free;
x = {var snd; snd = VBPVoc.ar(2, c.bufnum, MouseX.kr(0, 1, 0, 1), 2048, MouseY.kr(0, 1)); snd = PitchShiftPA.ar(snd, Pitch.kr(snd)[0], Scale.mixolydian.ratios, Scale.mixolydian.ratios); snd = Splay.ar(snd)}.play;
)