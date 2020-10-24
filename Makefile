SHELL=bash
WALLPAPERS = $(wildcard ./*.png)

.PHONY: compress
compress:
	read -ra backgrounds <<< "$$(echo *.png)"; \
	make "$${backgrounds[@]}" "-j$$(nproc)"
$(WALLPAPERS): ./%.png: ./Makefile
	echo "Compressing $@..."; \
	  optipng --quiet "$@"
