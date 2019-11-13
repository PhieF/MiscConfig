# Disabling Gnome software background service
```
echo "X-GNOME-Autostart-enabled=false" | sudo tee -a /etc/xdg/autostart/gnome-software-service.desktop
gsettings set org.gnome.software download-updates false
sudo systemctl mask packagekit.service
```
