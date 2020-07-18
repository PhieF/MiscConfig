#!/bin/bash
sudo pacman -R pamac-gnome-integration
sudo pacman -Syu gnome-software
sudo pacman -Syu gnome-software-packagekit-plugin

#nvidia

sudo mhwd -a pci nonfree 0300
