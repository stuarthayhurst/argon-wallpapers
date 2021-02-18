SHELL=bash
WALLPAPERS = $(wildcard ./*.png)

.PHONY: compress svg-image generate-gif $(WALLPAPERS)
generate-all:
	make svg-image
	make compress "-j$$(nproc)"
	make generate-gif
compress:
	read -ra backgrounds <<< "$$(echo *.png)"; \
	"$(MAKE)" "$${backgrounds[@]}"
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
