(
C.p(\1, 0, 2, seed: rrand(0, 1000), folder: \nov21b, index: Pxrand((0..200), inf), rate: Pxrand([1, 0.5, 1.1], inf), dur: Pwhite(2, 7), sustain: Pkey(\dur) * 2);
C.p(\2, 0, 2, seed: rrand(0, 1000), folder: \nov21b, index: Pxrand((0..200), inf), rate: Pxrand([1, 0.5, 1.1], inf), dur: Pwhite(3, 8), sustain: Pkey(\dur) * 2);
C.p(\3, 0, 2, seed: rrand(0, 1000), folder: \nov21b, index: Pxrand((0..200), inf), rate: Pxrand([1, 0.5, 1.1], inf), dur: Pwhite(5, 12), sustain: Pkey(\dur) * 2);
)

(
C.pp(\1, \bus, ~freezebus1);
C.pp(\2, \bus, ~freezebus2);
C.pp(\3, \bus, ~freezebus3);
)


(
~freezebus1 = ~freezebus1 ?? Bus.audio(s, 2);
~freezebus2 = ~freezebus2 ?? Bus.audio(s, 2);
~freezebus3 = ~freezebus3 ?? Bus.audio(s, 2);
)

(
w = Window.new.front;
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
)

(
SynthDef(\freeze, {
	var snd, buffer;
	snd = In.ar(\in.kr, 2);
	snd = FFT({LocalBuf(2048)}!2, snd);
	snd = PV_Freeze(snd, KeyState.kr(\key.kr, 1, -1, 0));
	snd = IFFT(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

(
Synth(\freeze, [in: ~freezebus1, key: 2], s, 'addToTail');
Synth(\freeze, [in: ~freezebus2, key: 3], s, 'addToTail');
Synth(\freeze, [in: ~freezebus3, key: 5], s, 'addToTail');
)


(
C.pp(\1, \rate, 1);
C.pp(\2, \rate, 1);
C.pp(\3, \rate, 1);
)

(
C.pp(\1, \dur, 3);
C.pp(\2, \dur, 7);
C.pp(\3, \dur, 18);
)





(
SynthDef(\freeze, {
	var snd, buffer;
	buffer = \buffer.kr(0);
	snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.kr(buffer), 1, \pos.kr(0) * BufFrames.kr(buffer), 0, 2);
	snd = FFT(LocalBuf(2048*4, 2), snd);
	snd = PV_Freeze(snd, \freeze.kr(0));
	snd = IFFT(snd);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)


Pbindef(\stop, \instrument, \freeze, \buffer, b, \pos, Pxrand([0.3, 0.5, 0.1], inf), \dur, Pxrand([1, 2, 5], inf), \freeze, 1, \pan, Pwhite(-1, 1.0)).play;