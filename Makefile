SHELL=bash
WALLPAPERS = $(wildcard ./*.png)
SVG = $(wildcard ./*.svg)

.PHONY: compress svg-image generate-gif $(WALLPAPERS) $(SVG)
generate-all:
	make svg-image "-j$$(nproc)"
	make compress "-j$$(nproc)"
	make generate-gif
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
