#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
#主题
git submodule add https://gitee.com/fujiawei/hugo-theme-hello-friend.git themes/hello-friend
# Build the project.
hugo -t hello-friend

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push  origin develop
