
// for midi mapping see 'Modality Tutorial' in helpfiles - specifically Using actions
// Server.killAll;
// Quarks.all.do{|quark| quark.update() };
MKtl.find;

(
Routine.run({


	ServerOptions.devices;

	Server.default.options.outDevice_("Soundcraft Signature 22 MTK");
	// Server.default.options.inDevice_("Soundcraft Signature 22 MTK");

	// Server.default.options.outDevice_("Scarlett Solo USB");
	// Server.default.options.inDevice_("Scarlett Solo USB");

	// Server.default.options.outDevice_("Built-in Output");
	// Server.default.options.outDevice_("BlackHole 2ch");


	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples

	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages

	s.options.numWireBufs = 64 * 10; // increase this if you get "exceeded number of interconnect buffers" messages

	s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"

	s.options.numOutputBusChannels = 4;

	s.options.numInputBusChannels = 2;



	// SUPERDIRT

	s.waitForBoot {
		~dirt.stop;
		~dirt = SuperDirt(4, s);
		~dirt.doNotReadYet = true;
		~dirt.loadSoundFiles("/Users/maxlouisraugel/Documents/son/tidalsamples/*");
		s.sync;
		~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0

		// optional, needed for convenient access from sclang:
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);


		s.sync; 5.wait;


		"/Users/maxlouisraugel/Documents/sc/instruments/tidal FX ++.scd".load;

		s.sync;

		// "/Users/maxlouisraugel/Documents/sc/instruments/tidal synths ++.scd".load;

		s.sync;

		"/Users/maxlouisraugel/Documents/sc/instruments/tidal global effects.scd".load;

		s.sync;


		// RECORDING

		thisProcess.platform.recordingsDir = "/Users/maxlouisraugel/Documents/son/";

	s.recHeaderFormat_("wav");


		// AUDIO BUFFERS

		// "/Users/maxlouisraugel/Documents/sc/instruments/buffers.scd".load;

		s.sync;

		// "/Users/maxlouisraugel/Documents/sc/instruments/convolutions.scd".load;


	s.sync;

		// C.crawl("/Users/maxlouisraugel/Documents/son/drums/", 1);
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/thanks/");
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/Ott-Orgel_1.02 ORGAN (ok to use)/Gedackt8/");
		s.sync;
		// C.crawl("/Users/maxlouisraugel/Documents/son/small instruments/", 1);


		// INSTRUMENTS



		// "/Users/maxlouisraugel/Documents/sc/instruments/synthdefs.scd".load;

		"/Users/maxlouisraugel/Documents/sc/instruments/quadraphony.scd".load;

		s.sync;

		// "/Users/maxlouisraugel/Documents/sc/instruments/ndefs.scd".load;


		s.sync; CmdPeriod.run;


	};

	s.latency = 0.2; // increase this if you get "late" messages

})

)





// (
// ~postPatFor = {|synthDef=\gongFM|
// 	var controls = SynthDescLib.global.synthDescs.at(synthDef).controls;
// 	"(
// 	Pdef(0,
// 	Pbind(
// 	%instrument, %%,".format("\\", "\\", synthDef.asSymbol).postln;
// 	controls.do{|control|
// 		var name = control.name;
// 		var val = control.defaultValue;
//
// 		// Check that synth doesn't have a duration of 0 by default (making sc explode)
// 		val = if(name == \dur && val == 0.0, { 1.0 }, { val });
// 		"\t%%, %,".format("\\", name, val).postln
// 	};
// 	")
// 	).play;
// 	)".postln;
// };
// ~postPatFor.value(\gongFM)
// )