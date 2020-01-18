#!/bin/sh
#
# In case Homebrew isn't installed, just run:
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#

echo "Removing previous installation..."
rm -f -R .build

echo "Trying to update brew..."
if which brew >/dev/null; then
  brew update
else
  echo "warning: Homebrew not installed, please visit https://brew.sh"
fi

function install_current {
  echo "Trying to update $1..."
  # https://docs.travis-ci.com/user/reference/osx/
  # avoids errors
  brew upgrade $1 || brew install $1 || true
  brew link $1
}

if [ -e "Mintfile" ]; then
  install_current mint
  # install linters, formatters, ...
  mint bootstrap --mintfile Mintfile
fi

# install github hooks
swift run komondor install