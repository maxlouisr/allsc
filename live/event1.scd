~dfb = Buffer.read(s, "/Users/maxlouisraugel/Documents/ /deeper furniture basses.wav");

x = Synth(\play, [buffer: ~dfb, loop: 1]);
x.free;

Ndef(\sine, {SinOsc.ar(440, 0, 0.01)}).play(fadeTime: 10);

Ndef(\sine)[10] = \filter-> {|in| in * LFPulse.kr(5).lag(0.1)}

Ndef(\sine)[10] = nil;

Ndef(\sine).fadeTime_(0).stop;





