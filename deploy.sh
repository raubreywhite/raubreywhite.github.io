#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
cp -r articles favicon.png CNAME docs/
cp -r resources/* docs/resources
sleep 5
git add docs && git commit -m "docs commit"
sleep 5
git push origin main:main
