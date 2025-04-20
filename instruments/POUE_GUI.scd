(
var config = (
	\windowTitle: "poue8",
	\configFileName: "poue8.txt", // Make sure to set as we don't want to overwrite other settings files
	\font: Font.defaultSansFace,
	\fontSize: 16,
	\backgroundColor: [0.0,0.0,0.0],
	\foregroundColor: [1,1,1],
	\activeColor: [0.9,0.9,0.9],
);

// mappings


var actions = (
	\amp: { | val |
		~poue.set(\amp, val);
	},
	\panrnd: { | val |
		~poue.set(\panrnd, val);
	},




	\tempo: { | val |
		~poue.set(\tempo, val);
	},

	\drift: { | val |
		~poue.set(\drift, val);
	},

	\rhythm : { | val |
		~poue.set(\rhythm, val);
	},

	\dur : { | val |
		~poue.set(\dur, val);
	},





	\note1: { | val |
		~poue.set(\note1, val)
	},

	\note2: { | val |
		~poue.set(\note2, val)
	},
	\note3: { | val |
		~poue.set(\note3, val)
	},
	\note4: { | val |
		~poue.set(\note4, val)
	},

	\note5: { | val |
		~poue.set(\note5, val)
	},

	\note6: { | val |
		~poue.set(\note6, val)
	},
	\note7: { | val |
		~poue.set(\note7, val)
	},
	\note8: { | val |
		~poue.set(\note8, val)
	},


	\root: { | val |
		~poue.set(\root, val)
	},

	\scale: { | val |
		~poue.set(\scale, val)
	},

	\lag: { | val |
		~poue.set(\lag, val)
	},
	\stretch: { | val |
		~poue.set(\stretch, val)
	},

	\whitecomb: { | val |
		~poue.set(\whitecomb, val)
	},
	\feedback: { | val |
		~poue.set(\feedback, val)
	},

	\jpverb: { | val |
		~poue.set(\jpverb, val)
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
			StaticText().string_("POUE")
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
			learnGUI.slider("panrand", \panrnd),
			learnGUI.slider("tempo", \tempo),
			learnGUI.slider("drift", \drift),
			learnGUI.slider("rhythm", \rhythm),
			learnGUI.slider("dur", \dur),

			learnGUI.slider("note1", \note1),
			learnGUI.slider("note2", \note2),
			learnGUI.slider("note3", \note3),
			learnGUI.slider("note4", \note4),

			learnGUI.slider("note5", \note5),learnGUI.slider("note6", \note6),learnGUI.slider("note7", \note7),learnGUI.slider("note8", \note8),

			learnGUI.slider("root", \root),
			learnGUI.slider("stretch", \stretch),
			learnGUI.slider("scale", \scale),
			learnGUI.slider("lag", \lag),

			learnGUI.slider("whitecomb", \whitecomb),
			learnGUI.slider("feedback", \feedback),
			learnGUI.slider("jpverb", \jpverb),
		)
	).spacing_(10),

)
)