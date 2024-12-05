// =====================================================================
// SHARING IS CARING PROJECT
// sharing is crushing
// FOR ESTHER DUONG
// Diego Peralta-Gonzales, December 2024
// Boston, MA
// =====================================================================

// This piece requires a lot of patience from the performer. DO NOT RUSH.

// FIRST INITIALIZE SC AND THE PROXYSPACE:

s.meter; // OPTIONAL
s.boot; // boot the server
p = ProxySpace.push; // create a proxy

// =====================================================================
// SINE WAVES
// =====================================================================

// FREQUENCIES TO TRY: 110, 196, 223, 110

~syn.play; // play the sound
~syn.fadeTime = 8; // seconds between original sound and modified sound

(
~syn = {
	arg freq=110, amp=0.15;
	var snd, reverb;
	snd=Mix.ar(
		Array.fill(4,{arg i; SinOsc.ar(freq:freq*(4**(i/4)), mul:0.2)})
	);
	snd=snd+(0.4*Mix.ar(
		SinOsc.ar(freq:[freq,freq*2.1,freq*2.2,freq*2.3],mul:0.3))
	);

	reverb = GVerb.ar(snd * amp, roomsize: 80, revtime: 4, mul: 0.2);

	snd=Splay.ar(reverb);
	//Out.ar(0,snd);
}
)

// .free acts like a fader

~syn.free(4);

// =====================================================================
// ETHERAL SYNTH
// =====================================================================

// THIS SYNTH PATTERN WILL FINISH, PLAY IT AS MANY TIMES AS DESIRED

~sig.play;
~sig.fadeTime = 8;

(
~sig = {FreeVerb.ar(SinOsc.ar(Duty.ar(1/2,0,Dseq(a=[[2,4.5],[5,6,8,10]];flat(a*.x allTuples(a*.x a)*2).clump(6)++0)),0,0.15)*LFTri.ar(10),29,10)/13
}
)

~sig.free(2);

// =====================================================================
// ETHEREAL NOISE
// =====================================================================

// PARAMETERS YOU CAN EDIT: lfoFreq and lfo

~seq.play;
~seq.fadeTime = 5;

(
~seq = {
	|amp = 0.22, reverbSize = 29, reverbDecay = 10, dutyFreq = 0.2, lfoFreq = 5000|

	var signal, gverbOutput, lfo;

    // Generate the signal using Duty and SinOsc
    signal = SinOsc.ar(
        Duty.ar(
            dutyFreq, // Frequency of the duty cycle
            0,
            Dseq(
                a = [[2, 4.5, 14], [63, 82, 122, 45, 20]],
                inf // Infinite sequence
            )
        )
    );

    // Modulate the signal with an LFO
    lfo = LFClipNoise.ar(lfoFreq) * signal;

    // Add GVerb
    gverbOutput = FreeVerb.ar(
        lfo * amp,           // Input signal
        reverbSize,          // Room size
        reverbDecay,         // Decay time
        0.15,                // Early reflection time
        mul: 1/100           // Output scaling
    );

}
)

~seq.free(2);

// =====================================================================
// CHORDS
// =====================================================================

~cho.play;
~cho.fadeTime = 8; // Set fade-in and fade-out time

// feel free to change the freqArray with any numbers you would like, the more microtonal the better...

(
~cho = { |freqArray = #[130.8128, 195.9977, 311.1270, 587.3295], amp = 0.2, reverbSize = 5, reverbDecay = 1|
    var sig, reverb;

    // Generate the chord sound using triangle waves
    sig = Mix(Pulse.ar(freqArray, 0.2)); // Lower amplitude per oscillator

    // Scale the output to prevent clipping
    sig = sig * 0.1; // Apply a global attenuation factor

    // BitCrusher

	sig = Decimator.ar(sig, 44000, 3); // activate or deactivate this sound freely

	// Apply reverb
    reverb = GVerb.ar(sig * amp, roomsize: reverbSize, revtime: 2, mul: 0.4); // Reverb scaling adjusted

};
)

~cho.free(10); // Free the proxy after fade-out

// =====================================================================
// FM SYNTH
// =====================================================================

~fm.fadeTime_(4).play(vol: 0.04);
~fm2.fadeTime_(4);

// first activate ~fm2, then ~fm
// change the values of the arguments of ~fm2

(
~fm2 = {SinOsc.ar(30 * 4)}
)

(
~fm = {SinOsc.ar([200, 202] +
	(~fm2.ar(2, LFSaw.ar().unipolar(5)) * 10000 // change this number),
	0, 0.2)}
)

(
~fm.free(10);
~fm2.free(10);
)

// =====================================================================
// WHITE NOISE (SIMILAR CODE TO SINE WAVES)
// =====================================================================

~w.quant_(1).fadeTime_(4).play(vol: 0.5);

(
~w = {
	arg freq=196, amp=0.5;
	var snd;
	snd=Mix.ar(
		Array.fill(4,{arg i; LFClipNoise.ar(freq:freq*(4**(i/4)), mul:0.020)})
	);
	snd=snd+(0.4*Mix.ar(
		VarSaw.ar(freq:[freq,freq*1.5,freq*2.2,freq*3.1],mul:0.020))
	);

	snd=Splay.ar(snd);
}
)

~w.free(5);

// =====================================================================
// BASS SYNTH
// =====================================================================

~x.play(vol:0.16);
~x.fadeTime = 2;

(
~x = {
	var snd;

	snd = LFSaw.ar(-30.dbamp!2) * LFPulse.kr(120, 0);

	snd = FreeVerb.ar(snd, 1, 1, 0.9);

	snd = Decimator.ar(snd, rate: 44100.0, bits: 4); // modify the bits and the rate parameter
}
)

~x.free(5);

// =====================================================================
// FADE OUT EVERYTHING!!!

p.free(20);

// =====================================================================



