# Disabling Gnome software background service

these might be redondant

be aware that it might disable update notifications
```
echo "X-GNOME-Autostart-enabled=false" | sudo tee -a /etc/xdg/autostart/gnome-software-service.desktop
gsettings set org.gnome.software download-updates false
sudo systemctl mask packagekit.service
```


# Disabling Tracker

tracker index your files, could be useless for some of us including me

```
systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
```

# Customize gnome-shell search

open setting, Search, uncheck what you don't need
