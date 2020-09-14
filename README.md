
[<img src="https://preview.redd.it/bnagpyoe2zm51.png?width=1536&format=png&auto=webp&s=50d4190cbb7889962a7efb92b2839ac3c7420d45">](https://youtu.be/2DsOu3cBAS8)
* Click the image for a YouTube Demo! *

# BandMate <br>
BandMate is a jazz accompaniment software made with SuperCollider which allows users to customize, mix, play, and record instrumental backing tracks.  

# Setup and Install
BandMate is made with SuperCollider, a platform for audio synthesis and algorithmic composition. You can download SuperCollider [here](https://supercollider.github.io/). To run BandMate, you need to download and setup the SuperCollider IDE and run the file BandMatev1.0.scd by putting your cursor after the first open parenthesis and using the shortcut control + enter or command + enter to run the script.

## User Interface Guide <br>
- Master Slider: adjusts the overall volume of the instrumental track, ranges from 0 to 100.
- Drums Slider: adjust the volume of the drums in the instrumental track, ranges from 0 to 100
- Comp Slider: adjusts the volume of the comping (short for accompanying), which refers to the chord changes, ranges from 0 to 100
- Drums On/Off Button: On by default. when turned off, drums are cut from the track, and toggling to on brings the drums back.
- Comp On/Off Button: On by default. when turned off, comping is cut from the track, and toggling to on brings the comping back.
- Tempo Number Box: adjusts the tempo of the overall instrumental track, ranges from 20 to 300
- Key Menu: adjusts the tonal center on which the chord changes are being played in
- Comp Rhythm Menu: adjusts the beats upon which the chords are played, where 1, 2, 3, and 4 represent the first, second, third, and fourth quarter note of a measure respectively
- Chord Progression Menu: adjusts the chord progression which governs the chord changes
- ◀️◀️ button: restarts the instrumental track from the beginning
- ▶ / ⏸️ button: starts or stops the instrumental track
- 🔴/⬛ button: starts or stops the recording of the instrumental track
- File Path Box: adjusts the file path upon which an recording will be made when the 🔴 button is clicked, recording file type can be adjustsed to numerous audio file types such as as wav, mp3, and aiff

## Credits <br>
- Developed by Suhel Keswani
- All SynthDefs (instrument models) taken from SCLOrkSynths and from Bruno Ruviaro's SuperCollider Pbind examples
- Special thanks to Bruno Ruviaro for mentorship and guidance with the project
