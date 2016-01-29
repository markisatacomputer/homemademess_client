#!/bin/bash
gulp clean
gulp build
git checkout gh-pages
rm -r index.html styles scripts maps
mv dist/index.html index.html
mv dist/styles styles
mv dist/scripts scripts
mv dist/maps maps
git add -u
git add .
# this step will need commit message
display notification "Time to write a commit message" with title "Hey!"
git commit
git push origin gh-pages
git checkout master