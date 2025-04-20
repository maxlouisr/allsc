(
~hurdy = "/Users/maxlouisraugel/Documents/ /hurdy phasor loop.wav".b;
~shortswell = "/Users/maxlouisraugel/Documents/ /short swell 12.wav".b;
~swellreverb = "/Users/maxlouisraugel/Documents/ /swell reverb delay 14.wav".b;
)

~play.set(\buffer, ~hurdy, \loop, 1).play(fadeTime: 30);

~play.copy(\shortswell).set(\buffer, ~shortswell);

Synth(\play, [buffer: ~shortswell, rate: 0.midiratio])

Synth(\play, [buffer: ~shortswell, rate: 2.midiratio])


Synth(\play, [buffer: ~swellreverb, rate: 2.midiratio, amp: 2]);

Synth(\play, [buffer: ~swellreverb, rate: 5.midiratio, amp: 2]);

Synth(\play, [buffer: ~swellreverb, rate: 0.midiratio, amp: 2]);



~play[10] = \filter -> {|in| LPF.ar(in, 1000, 1)}
~play[10] = \filter -> {|in| BPF.ar(in, 700, 5)}
~play[10] = nil;



Synth(\play, [buffer: ~swellreverb, rate: 14.midiratio, amp: 2]);

Synth(\play, [buffer: ~swellreverb, rate: 17.midiratio, amp: 2]);

Synth(\play, [buffer: ~swellreverb, rate: 12.midiratio, amp: 2]);
