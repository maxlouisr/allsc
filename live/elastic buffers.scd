b = "/Users/maxlouisraugel/Documents/ /decl.wav".b;

(
e = Ndef(\elastic,
	{var snd, env, trig, buffer, lfo;
		trig = Dust.kr(\density.kr(10));
		buffer = \buffer.kr(b);
		lfo = LFNoise2.kr(\lfo.kr(5));
		snd = PlayBuf.ar(2, b, lfo.range(1/3, 3) * BufRateScale.kr(b), trig, \pos.kr(0.3) * BufFrames.kr(b));
		snd * Env.linen(0.1, 1, 0.1).kr(0, trig);
		snd = BPF.ar(snd, Array.fib(10, 1.2, 100), 0.1, 10); snd = Splay.ar(snd); HPF.ar(snd, 140);
		snd = Balance2.ar(snd[0], snd[1], lfo + LFNoise2.kr(0.3));
	}
).play;
)

e.clear;



// take out fibonacci bpfs + startPos at 0

b = "/Users/maxlouisraugel/Documents/ /tom 239823.wav".b;

e.set(\pos, 0);


b = "/Users/maxlouisraugel/Documents/son/crrrrr.WAV".b;

e.set(\density, 1);

b = "/Users/maxlouisraugel/Documents/ /chambacu.wav".b;
