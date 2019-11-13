# Disabling Gnome software background service
```
echo "X-GNOME-Autostart-enabled=false" | sudo tee -a /etc/xdg/autostart/gnome-software-service.desktop
gsettings set org.gnome.software download-updates false
sudo systemctl mask packagekit.service
```


# Disabling Tracker

systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service

# Customize gnome-shell search

open setting, Search, uncheck what you don't need
