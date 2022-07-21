#!/bin/bash

reset
Rscript -e "rmarkdown::render_site('.')"
git add docs && git commit -m "Initial docs subtree commit"
git push origin `git subtree split --prefix docs main`:gh-pages --force
git reset --soft HEAD^
git restore --staged .
rm -rf docs
