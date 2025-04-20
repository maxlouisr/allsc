(
var config = (
	\windowTitle: "rongs",
	\configFileName: "rongs.txt", // Make sure to set as we don't want to overwrite other settings files
	\font: Font.defaultSansFace,
	\fontSize: 16,
	\backgroundColor: [0.0,0.0,0.0],
	\foregroundColor: [1,1,1],
	\activeColor: [0.9,0.9,0.9],
);

// mappings



// RONGS

var actions = (
	\freq: { | val |
		Ndef(\rongs).set(\freq, val);
	},
	\pan: { | val |
		Ndef(\rongs).set(\pan, val);
	},
	\amp: { | val |
		Ndef(\rongs).set(\amp, val);
	},
	\structure: { | val |
		Ndef(\rongs).set(\structure, val);
	},
	\brightness: { | val |
		Ndef(\rongs).set(\brightness, val);
	},
	\damping: { | val |
		Ndef(\rongs).set(\damping, val);
	},
	\density: { | val |
		Ndef(\rongs).set(\density, val);
	},
	\drift: { | val |
		Ndef(\rongs).set(\drift, val);
	},
	\onoff: { | val |
		Ndef(\rongs).set(\onoff, val);
	},
	\lpf: { | val |
		Ndef(\rongs).set(\lpf, val);
	},
	\lpq: { | val |
		Ndef(\rongs).set(\lpq, val);
	},
	\jpverb: { | val |
		Ndef(\rongs).set(\jpverb, val);
	},


	\saveSettings: {
		learnGUI.saveSettings();
	},
	\loadSettings: {
		learnGUI.loadSettings();
	},
);

var learnGUI = LearnGUI(config, actions);

learnGUI.setLayout(
	VLayout(
		HLayout(
			StaticText().string_("RONGS")
			.font_( Font(config[\font], 36))
			.stringColor_(Color(*config[\foregroundColor])),
			nil,
			nil,
			nil,
			HLayout(
				learnGUI.button(["Save"], \saveSettings, 90, 35),
				learnGUI.button(["Load"], \loadSettings, 90, 35),
			),
		),

		// Define sliders

		HLayout(
			learnGUI.slider("Amp", \amp),
			learnGUI.slider("Pan", \pan),
			learnGUI.slider("Freq", \freq),
			learnGUI.slider("onoff", \onoff),
			learnGUI.slider("structure", \structure),
			learnGUI.slider("brightness", \brightness),
			learnGUI.slider("damping", \damping),
			learnGUI.slider("density", \density),
			learnGUI.slider("drift", \drift),
			learnGUI.slider("lpf", \lpf),
			learnGUI.slider("lpq", \lpq),
			learnGUI.slider("jpverb", \jpverb),
		)
	).spacing_(10),

)
)