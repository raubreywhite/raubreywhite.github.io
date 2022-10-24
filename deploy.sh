#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
cp -r articles favicon.png CNAME docs/
cp -r resources/* docs/resources
sleep 5
git add docs && git commit -m "docs commit"
sleep 5
git push origin main:main
git subtree split --branch gh-pages --prefix _site
git push origin gh-pages:gh-pages
git push origin `git subtree split --prefix _site main`:gh-pages --force
sleep 5
git reset --soft HEAD^
git restore --staged .
rm -rf _site
