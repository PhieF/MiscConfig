#Fedora

echo "This script will enable repos for google chrome, nvidia, steam but won't install them, it will  add flathub as flatpak repo, enable finger tap on touchpads, add minimize maximize buttons to windows, install dash to dock, gnome connect, enable H264 video decoding for a better compability with almost all videos you will find on the web. This script hasn't been tested yet."

read -p "Do we proceed? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi


#3rd party repo

sudo dnf install -y fedora-workstation-repositories 

sudo dnf config-manager --set-enabled google-chrome

sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install --user -y flathub com.mattjakeman.ExtensionManager



# touchpad enable finger tap

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

#windows buttons

gsettings set org.gnome.desktop.wm.preferences button-layout 'menu:minimize,maximize,close'


# todo install dash to dock

# gnome-extensions list

# gnome-extensions enable reference-to-extension


sudo dnf install gnome-extensions-app


#gsconnect


#sudo dnf install openssl
#todo: gsconnect extension

#h264

sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

#hardware acceleration for intel
sudo dnf install -y intel-media-driver


#night theme

# install and set https://extensions.gnome.org/extension/2236/night-theme-switcher/

#todo  and set center-new-windows in org.gnome.mutter to true
