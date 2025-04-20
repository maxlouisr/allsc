
(

Ndef(\gendy3, {
	Pan2.ar(
		Mix.new(
			Gendy3.ar(

				3,5,1.0,1.0,
				(Array.fill(5,{LFNoise2.kr(0.1.rand,1,2)}) * 100),
				// LFNoise2.kr(MouseX.kr(0, 1), 200, 150),
				MouseX.kr(0.01,0.05),
				MouseY.kr(0.001,0.016),
				5,
				mul:0.1

			)
		)
	)

}).play
)

