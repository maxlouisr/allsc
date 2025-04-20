// Evaluate the block below to start the mapping MIDI -> OSC.
(
var on, off, cc, midichan;
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
// MIDIIn.connectAll;
MIDIIn.connect(0, -71678389);

on = MIDIFunc.noteOn({ |val, num, chan, src|
    osc.sendMsg("/ctrl", num.asString, val/127);
}).fix;

off = MIDIFunc.noteOff({ |val, num, chan, src|
    osc.sendMsg("/ctrl", num.asString, 0);
}).fix;

cc = MIDIFunc.cc({ |val, num, chan, src|
	osc.sendMsg("/ctrl", (num + 1).asString, val/127);
	}).fix;

/*cc = MIDIFunc.cc({ |val, num, chan, src|
osc.sendMsg("/ctrl", num.asString ++ "-" ++ chan.asString, val/127);
}).fix;*/

if (~stopMidiToOsc != nil, {
    ~stopMidiToOsc.value;
});

~stopMidiToOsc = {
    on.free;
    off.free;
    cc.free;
	// midichan.free;
};
)

// Evaluate the line below to stop it.
// ~stopMidiToOsc.value;