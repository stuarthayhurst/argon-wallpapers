SHELL=bash
WALLPAPERS = $(wildcard ./*.png)
SVG = $(wildcard ./*.svg)

.PHONY: compress svg-image generate-gif $(WALLPAPERS) $(SVG)
generate-all:
	make svg-image "-j$$(nproc)"
	make compress "-j$$(nproc)"
	make generate-gif
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
compress:
	read -ra backgrounds <<< "$$(echo *.png)"; \
	"$(MAKE)" "$${backgrounds[@]}"
svg-image:
	read -ra backgrounds <<< "$$(echo *.svg)"; \
	"$(MAKE)" "$${backgrounds[@]}"
generate-gif:
	convert -delay 150 *.png +dither -alpha off -loop 0 docs/Wallpapers.gif
$(SVG):
	echo "Generating $@..."; \
	width="3840"; height="2160"; svgFile="$@"; \
	inkscape "--export-filename=$${svgFile/.svg/.png}" -w "$$width" -h "$$height" "$$svgFile" > /dev/null 2>&1
$(WALLPAPERS): ./%.png: ./Makefile
	echo "Compressing $@..."; \
	  optipng --quiet "$@"
