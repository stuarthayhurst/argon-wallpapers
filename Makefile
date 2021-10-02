SHELL=bash
WALLPAPERS = $(wildcard ./*.png) $(wildcard ./old/*.png)
SVG = $(wildcard ./*.svg) $(wildcard ./old/*.svg)

.PHONY: generate-all generate-gif set-wallpaper wallpapers compress prune $(SVG) $(WALLPAPERS)
generate-all:
	$(MAKE) wallpapers
	$(MAKE) compress
	$(MAKE) generate-gif
generate-gif:
	convert -delay 150 *.png +dither -alpha off -loop 0 docs/Wallpapers.gif
set-wallpaper:
	ls ./*.png; \
	echo "Enter the filename of the wallpaper to use:"; \
	read -r wallpaper; \
	if [[ -f "$$wallpaper" ]]; then \
	  mkdir -p ~/Pictures/Wallpapers; \
	  cp "$$wallpaper" ~/Pictures/Wallpapers; \
	  gsettings set org.gnome.desktop.background picture-uri "file:///home/$$USER/Pictures/Wallpapers/$$wallpaper"; \
	  gsettings set org.gnome.desktop.background picture-options 'zoom'; \
	else \
	  echo "Invalid filename"; \
	fi
wallpapers:
	$(MAKE) $(SVG)
compress:
	$(MAKE) $(WALLPAPERS)
prune:
	./clean-svgs.py
$(SVG):
	echo "Generating $@..."; \
	svgFile="$@"; \
	inkscape "--export-filename=$${svgFile/.svg/.png}" -w "3840" -h "2160" "$$svgFile" > /dev/null 2>&1
$(WALLPAPERS):
	echo "Compressing $@..."; \
	  optipng --quiet "$@"
