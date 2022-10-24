#!/bin/bash

reset
Rscript -e "quarto::quarto_render('.')"
cp -r articles favicon.png CNAME _site/
cp -r resources/* _site/resources
sleep 5
git add _site && git commit -m "Initial _site subtree commit"
sleep 5
git subtree split --branch gh-pages --prefix _site
git push origin `git subtree split --prefix _site main`:gh-pages --force
sleep 5
git reset --soft HEAD^
git restore --staged .
rm -rf _site
