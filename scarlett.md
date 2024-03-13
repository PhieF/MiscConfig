To get All input

On gnome config, select input 5.1 otherwise won't appear in jackctrl (pipewire)

or in pavu control, configuration, scarlett, select ProAudio

I would recommand using scarlett gui to configure the soundcard https://github.com/geoffreybennett/alsa-scarlett-gui

edit
`/etc/modprobe.d/scarlett.conf`

add options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1

if not sure, this line is displayed in

`sudo dmesg | grep Scarlett`

