
// RHODEY SETUP ===============================================================
fun void funRhode() {
    // set up your array 
    Rhodey r[5];
    NRev rev[2] => dac; 0.05 => rev[0].mix; 0.05 => rev[1].mix;
    Rhodey solo  => LPF lpf_solo => rev;
    0.01 => solo.gain;
    Pan2 p[2]; p[0] => rev[0]; p[1] => rev[1];
    Delay d[2]; rev[0] => d[0] => d[1] => rev[1]; 
    0.7 => d[0].gain => d[1].gain;
    second => d[0].max => d[0].delay => d[1].max => d[1].delay;
    SinOsc panner => blackhole;
    2 => panner.freq;
    r[0] => p[0]; r[1] => p[0]; 
    r[2] => p[1]; r[3] => p[1]; r[4] => p[0]; r[4] => p[1];
    
    for (int i; i < r.cap(); i++) {
        1 => r[i].lfoSpeed;
        0.0 => r[i].lfoDepth;
        r[i].opAM(0,0.4);
        r[i].opAM(2,0.4);
        r[i].opADSR(0, 0.001, 3.50, 0.0, 0.04);
        r[i].opADSR(2, 0.001, 3.00, 0.0, 0.04);
    }
    second/0.05 => dur Q; Q/2 => dur E; E/2 => dur S;
    while( true )
    {
        // set up your note values
        Std.mtof(59) => solo.freq; 0.2 => solo.noteOn; E => now;
        Std.mtof(57) => solo.freq; 0.3 => solo.noteOn; E => now;
        Std.mtof(62) => solo.freq; 0.1 => solo.noteOn; E => now;
        Std.mtof(61) => solo.freq; 0.2 => solo.noteOn; E => now;
        Std.mtof(64) => solo.freq; 0.3 => solo.noteOn; E => now;
        Std.mtof(61) => solo.freq; 0.2 => solo.noteOn; E => now;
        Std.mtof(59) => solo.freq; 0.3 => solo.noteOn; E => now;
        Std.mtof(61) => solo.freq; 0.1 => solo.noteOn; E => now;
        Std.mtof(74) => solo.freq; 0.3 => solo.noteOn; E => now;
        Std.mtof(59) => solo.freq; 0.2 => solo.noteOn; E => now;
         
         // set up the panning for your 
         1.0 - panner.last() => float temp;
         temp => p[0].pan;
         1.0 - temp => p[1].pan;
         ms => now;
    } 
} spork ~ funRhode();

// AUDIO CLIP SETUP ==============================================================
fun void audioClip(){
    // Set your panning
    Pan8 pan => dac;
    
    // set up your panning parameters
    0 => pan.pan;
    pan.pan() + 0.03 => pan.pan;
    10::ms => now;
    
    // connect your audio buffer
    SndBuf mySnd1 => pan => dac;
    SndBuf mySnd2 => pan => dac;
        
    // set the gain of your sound recording
    mySnd1.gain(0.01);
    mySnd2.gain(0.01);
    
    // read your audio files
    "/Users/nancyrico-mineros/Desktop/220A Final /mars1.wav" => mySnd1.read;
    "/Users/nancyrico-mineros/Desktop/220A Final /mars2.wav" => mySnd2.read;
    
    // set to end of each
    mySnd1.samples() => mySnd1.pos;
    mySnd2.samples() => mySnd2.pos;
    
    // sample no.1: moxie air compressor pumping away from mars
    0 => mySnd1.pos;
    75:: second => now;
    mySnd1.samples() => mySnd1.pos;
    
    // sample no.2: first recordings of mars captured by 
    (mySnd2.samples() / 3) => mySnd2.pos;
    20::second => now;
    
    // going back to sample no.1
    3 * 10000 => mySnd1.pos;
    75::second => now;
    mySnd2.samples() => mySnd2.pos;
    15.3::second => now;
                       
} spork ~ audioClip();

// MUSIC SETUP ===================================================================
// set up your reverb chain
NRev reverb => dac;
// set up your reverb mix
.10 => reverb.mix;
// set up your add voice function
fun void addVoice(float midi, dur note_dur, dur loop_dur, dur offset) {
    // set your audio chain
    SinOsc voice => Pan8 pan => LPF lpf => Envelope env => reverb;
    // set your chain gain
    .07 => voice.gain;
    // set up your frequency  
    Std.mtof(midi) => voice.freq; 
    // set your note duration
    note_dur / 2 => env.duration; 
    // wait for initial offset
    offset => now;
    // set your audio loop
    while (true) {
        // set up your panning parameters
        pan.pan() + 0.01 => pan.pan;
        10000::ms => now;
        // open envelope
        env.keyOn(); 
        note_dur / 2 => now;
        // close envelope
        env.keyOff(); 
        note_dur / 2 => now;
        // wait for remainder of loop
        loop_dur - note_dur => now;
    }
}
// VOICES ======================================================================
spork ~ addVoice(57, 2.1::second, 16.2::second, 1::second + 2.9::second); 
spork ~ addVoice(59, 8.5::second, 19.6::second, 1::second + 6.5::second); 
spork ~ addVoice(62, 4.1::second, 24.7::second, 1::second + 4.7::second); 
spork ~ addVoice(61, 2.4::second, 17.8::second, 1::second + 8.2::second); 
spork ~ addVoice(64, 7.9::second, 21.3::second, 1::second + 9.6::second); 
spork ~ addVoice(61, 2.2::second, 31.8::second, 1::second + 15.0::second); 
spork ~ addVoice(59, 5.2::second, 12.8::second, 1::second + 3.4::second); 
spork ~ addVoice(61, 5.1::second, 13.2::second, 1::second + 4.9::second); 
spork ~ addVoice(78, 2.1::second, 1.2::second, 1::second + 2::second);
spork ~ addVoice(74, 2.1::second, 1.2::second, 2::second + 2::second);
spork ~ addVoice(59, 5.5::second, 20.6::second, 4::second + 2.5::second); 
spork ~ addVoice(78, 2.1::second, 4.2::second, 5::second + 2.0::second);
201::second => now;