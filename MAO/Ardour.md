# Windows VST On Linux

## EWQLSO

Special case for EastWest Quantum Leap Symphonic Orchestra Gold Edition

This one WON'T work with yabridge, it requires Carla

To add Carla, add a midi bus with FLEXIBLE E/S (in Pin Mode) otherwise: No sound.



#Midi

Use one VST for multiple midi tracks:

Create a midi bus

add this VST

create 2 midi track

output to Midi bus

On each midi track, right click in editor, Channel selector, "use a single fixed channel" and choose the channel, this will be the channel used for PLAYBACK. 
Then, when playing the piano, select the right channel on YOUR piano


If you can't change midi channel of your device, QMidiRoute is your friend



