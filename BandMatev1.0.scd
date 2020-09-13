/*BandMate, version 1.0
by Suhel Keswani
Thanks for checking out my code! Feel free to modify it how you please.
I've done my best too annotate my code with comments.
For questions or iniquiry, you can reach me at suhelkeswani@gmail.com
*/

(
s.waitForBoot{

/*
=========== RHODES SYNTHDEF ==========
*/

SynthDef(\FMRhodes1, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1, lfoSpeed = 4.8, inputLevel = 0.2,
    // all of these range from 0 to 1
    modIndex = 0.2, mix = 0.2, lfoDepth = 0.1;

    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * 30) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
  	snd = snd * (SinOsc.ar(lfoSpeed).range((1 - lfoDepth), 1));

    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
},
metadata: (
	credit: "Nathan Ho",
	category: \keyboards,
	tags: [\pitched, \piano, \fm]
)
).add;

postln("Rhodes Synth intialized.");


/*
=========== CHORDS, TEMPO, VOLUME ==========
*/


~metronome = TempoClock.new(120/60).permanent_(true);

~c1maj7 = [48, 52, 55, 59]; // Cmaj7 by default
~c6min7 = [45, 48, 52, 55];// Amin7 by default
~c2min7 = [50, 53, 57, 60];// Dmin7 by defauly
~c5dom7 = [55, 59, 62, 65]; // Gdom7 by default

~c2min7b5 = [50, 53, 56, 60]; //Dmin7b5 by default
~c1min7 = [48, 51, 55, 58]; // Cmin7 by default
~c6min7b5 = [45, 48, 51, 55]; //Amin7b5 by default

~c1sharpdim7 = [49, 52, 55, 58]; //C#dim7 by default

~masterVol = 0.75;
~drumsVol = 0.5;
~compVol = 0.5;

postln("Chords + tempo + volume variables intialized.");

/*
=========== DEFINING THE COMP PBIND ==========
*/

Pbindef(\comp,
	\instrument, \FMRhodes1,
	\dur, Pseq([1/4 * 4, Rest(1/4 *4), 1/4 * 4, Rest(1/4 * 4)], inf),
	\midinote, Pseq([
		~c1maj7, ~c1maj7, ~c1maj7, ~c1maj7,
		~c6min7, ~c6min7, ~c6min7, ~c6min7,
		~c2min7, ~c2min7, ~c2min7, ~c2min7,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7

	], inf),
	\rel, 0.4,
	\mix, 0.2,
    \modIndex, 0.2,
    \lfoSpeed, 0.5,
    \lfoDepth, 0.4,
    \inputLevel, Pgauss(0.8, 0.1, inf),
    \amp, 0.2 * ~masterVol * ~compVol,
	\legato, 1/2,
	\strum, Pwhite(0, 0.02),
	\ctranspose, 0,
	\pan, 0.1
);

postln("Comp Pbind initialized.");

/*
=========== HAT SYNTH ==========
*/

SynthDef("hihat", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

postln("Hat Synth initialized.");

/*
=========== BASS DRUM SYNTH ==========
*/

SynthDef("bass_drum", {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var env, snd, ramp;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

postln("Bass Drum Synth initialized.");

/*
=========== HI-HAT PBIND ==========
*/


Pbindef(\hihat,
	\instrument, "hihat",
	\dur, Pseq([1/12*4, Rest(1/6*4), 1/12*4, Rest(1/12*4), 1/12*4], inf),
	\att, 0.01,
	\rel, -0.1*~metronome.tempo + 0.8,
	\ffreq, 11500,
	\pan, 0.2,
	\amp, 0.2 * ~masterVol * ~drumsVol
);

postln("Hi-Hat Pbind initialized.");

/*
=========== CLOSED-HAT PBIND ==========
*/


Pbindef(\closed_hat,
	\instrument, "hihat",
	\dur, Pseq([Rest(1), 1], inf),
	\pan, -0.1,
	\amp, 0.2 *~masterVol * ~drumsVol
);

postln("Closed-Hat Pbind initialized.");


/*
=========== BASS DRUM PBIND ==========
*/

Pbindef(\bass_drum,
	\instrument, "bass_drum",
	\dur, 1,
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 0.6 * ~masterVol * ~drumsVol,
	\pan, 0.1
);

postln("Bass Drum Pbind initialized.");

/*
=========== QUANTIZE PBIND ==========
*/


Pbindef(\closed_hat).quant_(~metronome.tempo * 4);
Pbindef(\hihat).quant_(~metronome.tempo * 4);
Pbindef(\bass_drum).quant_(~metronome.tempo * 4);
Pbindef(\comp).quant_(~metronome.tempo * 4);

postln("Pbinds quantized.");


/*
=========== DEFINING THE COMP PBIND ==========
*/

// GUI Symbols (copy + paste when needed) ♭ ♯ ⏯ ⏸️ ♩ ◼️

~chordSequencer = Window.new("BandMate", Rect.new(Window.screenBounds.width/2 - 400, Window.screenBounds.height/2 - 225, 760, 420), false)
.alwaysOnTop_(true)
//.background_("white")
.onClose_({
	postln("window closed");
	if (~record.value == 1, {
			s.stopRecording;
		});
	Pbindef(\hihat).stop;
	Pbindef(\closed_hat).stop;
	Pbindef(\bass_drum).stop;
	Pbindef(\comp).stop;
	s.freeAll;
	})
.front();

postln("Window initialized.");

~tempoBox = EZNumber(~chordSequencer, label: "Tempo: ",
	bounds: Rect(300, 20, 70, 75),
	controlSpec: ControlSpec.new(minval: 20, maxval: 300, warp: 'lin', step: 1),
	labelHeight:40,
	initVal: 120,
	layout: \line2
	)
	// .setColors(Color.gray)
.font_(Font("Monaco", 20))
.action_({ |newTempo|
		~metronome.tempo_(newTempo.value/60);

		Pbindef(\hihat,
		\rel, -0.1*~metronome.tempo + 0.8,
		);

	});

postln("Tempo Box initialized.");

~key = EZPopUpMenu.new(parentView: ~chordSequencer,
		bounds: Rect.new(430, 20, 85, 75),
		label: "Key: ",
		labelHeight: 40,
		layout: \vert,)
.font_(Font("Monaco", 20))
	// .setColors(Color.gray)
.addItem("A", {
	Pbindef(\comp,
	\ctranspose, -3,
); })
.addItem("A♯/B♭", {
	Pbindef(\comp,
	\ctranspose, -2,
);})
.addItem("B", {
	Pbindef(\comp,
	\ctranspose, -1,
);})
.addItem("C", {
	Pbindef(\comp,
	\ctranspose, 0,
);})
.addItem("C♯/D♭", {
	Pbindef(\comp,
	\ctranspose, 1,
);})
.addItem("D", {
	Pbindef(\comp,
	\ctranspose, 2,
);})
.addItem("D♯/E♭", {
	Pbindef(\comp,
	\ctranspose, 3,
);})
.addItem("E", {
	Pbindef(\comp,
	\ctranspose, 4,
);})
.addItem("F", {
	Pbindef(\comp,
	\ctranspose, 5,
);})
.addItem("F♯/G♭", {
	Pbindef(\comp,
	\ctranspose, 6,
);})
.addItem("G", {
	Pbindef(\comp,
	\ctranspose, 7,
);})
.addItem("G♯/A♭", {
	Pbindef(\comp,
	\ctranspose, 8,
);})
.value = 3;

postln("Key menu initialized.");

~rhythmMenu = EZPopUpMenu.new(~chordSequencer,
	Rect.new(300, 125, 150, 75),
	"Comp Rhythm:",
	layout: \vert,
	labelHeight: 40)
.font_(Font("Monaco", 20))
	// .setColors(Color.gray)
	.addItem("1|3", {
	Pbindef(\comp,
	\dur, Pseq([1/4 * 4, Rest(1/4 * 4), 1/4 * 4, Rest(1/4 * 4)], inf),);
	})
.addItem("2|4", {
	Pbindef(\comp,
	\dur, Pseq([Rest(1/4 * 4), 1/4 * 4, Rest(1/4 * 4), 1/4 *4 ], inf),);
	})
.addItem("1|2|3|4", {
	Pbindef(\comp,
	\dur, Pseq([1/4 * 4, 1/4 * 4, 1/4 * 4, 1/4 * 4], inf),)
	});

postln("Rhythm menu initialized.");

~chordProgMenu = EZPopUpMenu.new(~chordSequencer,
	Rect.new(300, 230, 220, 75),
	"Chord Progression:",
	layout: \vert,
	labelHeight: 40)
.font_(Font("Monaco", 20))
	// .setColors(Color.gray)
.addItem("I-vi-ii-V7", {
	Pbindef(\comp,
	\midinote, Pseq([
		~c1maj7, ~c1maj7, ~c1maj7, ~c1maj7,
		~c6min7, ~c6min7, ~c6min7, ~c6min7,
		~c2min7, ~c2min7, ~c2min7, ~c2min7,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7

		], inf),)
})
.addItem("i-viø7-iiø7-V7", {
	Pbindef(\comp,
	\midinote, Pseq([
		~c1min7, ~c1min7, ~c1min7, ~c1min7,
		~c6min7b5, ~c6min7b5, ~c6min7b5, ~c6min7b5,
		~c2min7b5, ~c2min7b5, ~c2min7b5, ~c2min7b5,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7,
		], inf),)
})
.addItem("I-ii-V7-I", {
	Pbindef(\comp,
	\midinote, Pseq([
		~c1maj7, ~c1maj7, ~c1maj7, ~c1maj7,
		~c2min7, ~c2min7, ~c2min7, ~c2min7,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7,
		~c1maj7, ~c1maj7, ~c1maj7, ~c1maj7,
		], inf),)
})
.addItem("i-iiø7-V7-i", {
	Pbindef(\comp,
	\midinote, Pseq([
		~c1min7, ~c1min7, ~c1min7, ~c1min7,
		~c2min7b5, ~c2min7b5, ~c2min7b5, ~c2min7b5,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7,
		~c1min7, ~c1min7, ~c1min7, ~c1min7,
		], inf),)
})
.addItem("I-i#o7-ii-V7", {
	Pbindef(\comp,
	\midinote, Pseq([
		~c1maj7, ~c1maj7, ~c1maj7, ~c1maj7,
		~c1sharpdim7, ~c1sharpdim7, ~c1sharpdim7, ~c1sharpdim7,
		~c2min7, ~c2min7, ~c2min7, ~c2min7,
		~c5dom7, ~c5dom7, ~c5dom7, ~c5dom7,
		], inf),)
});

postln("Rhythm menu initialized.");

~masterVolSlider = EZSlider( parent: ~chordSequencer,
	bounds: Rect(30, 20, 55, 250),
	label: "Master",
	controlSpec: ControlSpec.new(minval: 0, maxval: 100, warp: 'lin', step: 0.01),
	labelWidth: 80,
	layout: \vert
)
	// .setColors(Color.gray)
.font_(Font("Monaco", 15))
.action_({
	arg vol;
	~masterVol = vol.value()/100;
	postln(vol.value/100);

	Pbindef(\hihat,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);

	Pbindef(\comp,
    \amp, 0.2 * ~masterVol * ~compVol,
	);

	Pbindef(\closed_hat,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);

	Pbindef(\bass_drum,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);
})
.value_(75);

postln("Master vol slider initialized.");

~drumsOnOff = Button(~chordSequencer, Rect.new(105, 280, 55, 40))
.font_(Font("Monaco", 20))
.states_([["OFF", Color.grey], ["ON", Color.blue]])
.action_({
		arg obj;
		if (
			obj.value == 0,
			{
				Pbindef(\hihat).stop;
				Pbindef(\closed_hat).stop;
				Pbindef(\bass_drum).stop;
			},

			{
				if (~play_pause.value == 1, {
					Pbindef(\hihat).play(~metronome);
					Pbindef(\closed_hat).play(~metronome);
					Pbindef(\bass_drum).play(~metronome);
				});
			}
		);

})
.value_(1);

postln("Drums On/Off initialized.");

~drumsVolSlider = EZSlider( parent: ~chordSequencer,
	bounds: Rect(105, 20, 55, 250),
	label: "Drums",
	controlSpec: ControlSpec.new(minval: 0, maxval: 100, warp: 'lin', step: 0.01),
	labelWidth: 80,
	layout: \vert
)
	// .setColors(Color.gray)
.font_(Font("Monaco", 15))
.action_({
	arg vol;
	~drumsVol = vol.value()/100;
	postln(vol.value/100);

	Pbindef(\hihat,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);

	Pbindef(\closed_hat,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);

	Pbindef(\bass_drum,
	\amp, 0.2 * ~masterVol * ~drumsVol,
	);
})
.value_(50);

postln("Drums vol slider initialized.");

~compOnOff = Button(~chordSequencer, Rect.new(180, 280, 55, 40))
.font_(Font("Monaco", 20))
.states_([["OFF", Color.grey], ["ON", Color.blue]])
.action_({
		arg obj;
		if (
			obj.value == 0,
			{
				Pbindef(\comp).stop;
			},

			{
				if (~play_pause.value == 1, {
					Pbindef(\comp).play(~metronome)
				});
			}
		);

})
.value_(1);

postln("Comp On/Off initialized.");

~compVolSlider = EZSlider( parent: ~chordSequencer,
	bounds: Rect(180, 20, 55, 250),
	label: "Comp",
	controlSpec: ControlSpec.new(minval: 0, maxval: 100, warp: 'lin', step: 0.01),
	labelWidth: 80,
	layout: \vert
)
	// .setColors(Color.gray)
.font_(Font("Monaco", 15))
.action_({
	arg vol;
	~compVol = vol.value()/100;
	postln(vol.value/100);

	Pbindef(\comp,
    \amp, 0.2 * ~masterVol * ~compVol,
	);
})
.value_(50);

postln("Comp vol slider initialized.");

~play_pause = Button(~chordSequencer, Rect.new(630, 30, 50, 50))
.font_(Font("Monaco", 20))
.states_([["▶"], ["▮▮"]])
.action_({
		arg obj;

		if (obj.value == 0, {

			// stop all sound when pause button is hit

			Pbindef(\hihat).stop;
			Pbindef(\closed_hat).stop;
			Pbindef(\bass_drum).stop;
			Pbindef(\comp).stop;
		},

		{

			// if drums enabled, play them

			if (~drumsOnOff.value == 1, {
				Pbindef(\hihat).play(~metronome);
				Pbindef(\closed_hat).play(~metronome);
				Pbindef(\bass_drum).play(~metronome);
			});

			// if comp enabled, play it

			if (~compOnOff.value == 1, {
				Pbindef(\comp).play(~metronome);
			});

		});
})
.value_(0);

postln("Play/pause button initialized.");

~rewind = Button(~chordSequencer, Rect.new(580, 30, 50, 50))
.font_(Font("Monaco", 20))
.string_("◀️◀️")
.action_({
		Pbindef(\hihat).stop(~metronome);
		Pbindef(\closed_hat).stop(~metronome);
		Pbindef(\bass_drum).stop(~metronome);
		Pbindef(\comp).stop(~metronome);
		Pbindef(\closed_hat).play(~metronome);
		Pbindef(\hihat).play(~metronome);
		Pbindef(\bass_drum).play(~metronome);
		Pbindef(\comp).play(~metronome);
	});

postln("Rewind button initialized.");

~record = Button(~chordSequencer, Rect.new(680, 30, 50, 50))
.font_(Font("Monaco", 15))
.states_([["🔴"], ["⬛"]])
.action_({
		arg obj;
		if (obj.value == 1, {
			s.record(path: ~pathBox.value);
			~pathBox.enabled_(false);
		}, {
			s.stopRecording();
			~pathBox.enabled_(true);
		})

});

postln("Record Button initialized.");

~pathBoxLabel = StaticText(~chordSequencer, Rect.new(30, 375, 700, 25))
.font_(Font("Monaco", 15))
.align_(\left)
.string_("Audio Recording File Path")
	// .background_(Color.gray)
;

postln("Path label initialized.");

~pathBox = TextField(~chordSequencer, bounds: Rect.new(30, 350, 700, 25))
.font_(Font("Monaco", 15))
.value_(thisProcess.platform.recordingsDir.value ++ "/file-name-goes-here.wav");

postln("Path Box initialized.");

};
)