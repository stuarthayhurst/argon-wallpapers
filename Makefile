SHELL=bash
WALLPAPERS = $(wildcard ./*.png)

.PHONY: compress svg-image $(WALLPAPERS)
compress:
	read -ra backgrounds <<< "$$(echo *.png)"; \
	make "$${backgrounds[@]}" "-j$$(nproc)"
svg-image:
	width="3840"; height="2160"; \
	for svgFile in *.svg; do \
	  inkscape "--export-filename=$${svgFile/.svg/.png}" -w "$$width" -h "$$height" "$$svgFile" > /dev/null 2>&1; \
	done
generate-gif:
	convert -delay 150 *.png +dither -alpha off -loop 0 docs/Wallpapers.gif
$(WALLPAPERS): ./%.png: ./Makefile
	echo "Compressing $@..."; \
	  optipng --quiet "$@"
