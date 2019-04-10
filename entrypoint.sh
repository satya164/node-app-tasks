#!/bin/bash

set -ex

# Use npm by default
PACKAGE_MANAGER="${PACKAGE_MANAGER-"$npm"}"

NPM_REGISTRY_URL="${NPM_REGISTRY_URL-registry.npmjs.org}"
NPM_STRICT_SSL="${NPM_STRICT_SSL-true}"
NPM_REGISTRY_SCHEME="https"

if ! $NPM_STRICT_SSL
then
  NPM_REGISTRY_SCHEME="http"
fi

# Allow registry.npmjs.org to be overridden with an environment variable
printf "//%s/:_authToken=%s\\nregistry=%s\\nstrict-ssl=%s" "$NPM_REGISTRY_URL" "$NPM_AUTH_TOKEN" "${NPM_REGISTRY_SCHEME}://$NPM_REGISTRY_URL" "${NPM_STRICT_SSL}" > "$HOME/.npmrc"

# Set a dummy email and username so we can commit
git config user.name "GitHub Actions"
git config user.email "github-actions-bot@users.noreply.github.com"

# Configure the remote so we can push code
git remote set-url origin "https://github.com/$GITHUB_REPOSITORY.git"

git config url."https://".insteadOf git://
git config url."https://github.com/".insteadOf git@github.com:

git submodule update --init --recursive
git branch --set-upstream-to "origin/$(basename $GITHUB_REF)"

# Install dependencies and run the specified command
if [ "$PACKAGE_MANAGER" == "yarn" ]; then
  yarn install --frozen-lockfile
  sh -c "yarn $*"
elif [ "$PACKAGE_MANAGER" == "npm" ]; then
  npm ci
  sh -c "npm $*"
else
  echo "Invalid package manager $PACKAGE_MANAGER. Supported options are yarn and npm."
  exit 1
fi
