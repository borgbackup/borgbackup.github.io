#!/bin/bash -xue

# Only build the "source" branch ("master" = built, published pages,
# this can't be changed for organization GitHub Pages)
test $TRAVIS_BRANCH == "source" || exit 0

# Add git metadata
git config user.name "Automated build"
git config user.email "public@enkore.de"

# Build the pages
make clean
make

git add --all .
git commit -m "Automatically built pages at $(git rev-parse --short HEAD)" || exit 0

# travis/github_deploy_key.enc is an encrypted SSH key.
# The keys for this key are stored with Travis and are exposed in the
# $encrypted... environment variables. (These are *not* available in pull request builds!)
# The public key is set up as a deployment key in the GitHub repository.
# The following document explains the process:
# https://github.com/alrra/travis-scripts/blob/master/doc/github-deploy-keys.md
openssl aes-256-cbc -K $encrypted_54b6162b97cf_key -iv $encrypted_54b6162b97cf_iv -in .travis/github_deploy_key.enc -out github_deploy_key -d

# Add the SSH key
chmod 600 github_deploy_key
eval `ssh-agent -s`
ssh-add github_deploy_key

# Push changes to the *master* branch
# Remember, this is building the *source* branch.
git push --force git@github.com:borgbackup/borgbackup.github.io.git HEAD:master

# Kill SSH agent, get rid of the key (Travis does that as well)
kill $SSH_AGENT_PID
shred -u github_deploy_key
