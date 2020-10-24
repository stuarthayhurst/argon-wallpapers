#!/bin/bash
for background in *.png; do
  echo -n "Compressing $background..."
  optipng --quiet "$background"
  echo " Done"
done
