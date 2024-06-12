#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
git add docs && git commit -m "docs commit"
git push origin main:main

