#/bin/bash
mkdir ~/Images/unsplash/
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
wget -O ~/Images/unsplash/"$NEW_UUID".jpg https://unsplash.it/2560/1440/?random
gsettings set org.gnome.desktop.background picture-uri ~/Images/unsplash/"$NEW_UUID".jpg
