#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t slim

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# # Push source and build repos.
# git push -f origin master
# git subtree push --prefix=public git@github.com:seanBE/seanBE.github.io.git gh-pages
