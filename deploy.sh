#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
cp -r articles favicon.png CNAME docs/
cp -r resources/* docs/resources
git add docs && git commit -m "docs commit"
git push origin main:main

