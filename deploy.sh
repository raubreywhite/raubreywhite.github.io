#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
cp -r articles favicon.png CNAME _site/
git add _site && git commit -m "Initial _site subtree commit"
git push origin `git subtree split --prefix _site main`:gh-pages --force
git reset --soft HEAD^
git restore --staged .
rm -rf _site
