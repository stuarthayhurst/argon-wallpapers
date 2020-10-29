#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

ls ./*.png
echo "Enter the filename of the wallpaper to use:"
read -r wallpaper
if [[ -f "$wallpaper" ]]; then
  mkdir -p ~/Pictures/Wallpapers
  cp "$wallpaper" ~/Pictures/Wallpapers
  gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/Wallpapers/$wallpaper"
  gsettings set org.gnome.desktop.background picture-options 'zoom'
else
  echo "Invalid filename"
fi
