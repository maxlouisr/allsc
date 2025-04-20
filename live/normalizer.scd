b = "/Users/maxlouisraugel/Documents/ /broken white35.wav".b;
b = "/Users/maxlouisraugel/Documents/son/metallic.wav".b;
b = "/Users/maxlouisraugel/Documents/son/test for voice to midi.wav".b;

{var snd; snd = PlayBuf.ar(2, b, 5 * BufRateScale.kr(b), 1); snd = Normalizer.ar(snd, 0.7); snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(5)/3)}.play;

x.free; x = {var trig, buffer, snd; trig = Dust.kr(5); buffer = rrand(0, 20); snd = PlayBuf.ar(2, buffer, 1 * BufRateScale.kr(buffer), trig).lag(0.1); snd = Normalizer.ar(snd, 0.7); snd = Balance2.ar(snd[0], snd[1], TRand.kr(-1, 1.0, trig))}.play;

{var snd; snd = PlayBuf.ar(2, b, LFSaw.kr(LFNoise2.kr(2).range(5, 10)) + 0.3 * BufRateScale.kr(b), 1); snd = Normalizer.ar(snd, 0.7); snd = Balance2.ar(snd[0], snd[1], LFNoise2.kr(5))}.play;

{var snd; snd = PlayBuf.ar(2, b, 10 * BufRateScale.kr(b), 1); snd = Normalizer.ar(snd, 0.7); snd = LeakDC.ar(snd); snd = Limiter.ar(snd, 1)}.play;