#!/bin/bash
# Homebrew
echo 'Check homebrew'
if ! which brew > /dev/null; then
    echo 'Install homebrew'
    sudo chown -R "$(whoami)":admin '/usr/local'
    /usr/bin/ruby -e "$(curl -fsSL 'https://raw.githubusercontent.com/Homebrew/install/master/install')"
    mkdir -p '/Library/Caches/Homebrew'
    sudo chown -R "$(whoami)":admin '/Library/Caches/Homebrew'
fi
echo 'Update homebrew'
brew update

# rbenv if need
if [[ "$CI" != 'true' ]]; then
    if ! which rbenv > /dev/null; then
        echo 'Install rbenv'
        brew install rbenv
        eval "$(rbenv init -)"
        echo 'which rbenv > /dev/null && eval "$(rbenv init -)"' >> ~/.bashrc
    fi
    brew outdated ruby-build || brew upgrade ruby-build
    echo 'n' | rbenv install || true
    rbenv rehash
fi

echo 'Install bundler'
gem install bundler

# PROJECT DEPENDENCES
echo 'Pod install'
bundle install --path=vendor/bundle --jobs 4 --retry 3

if ! bundle exec pod install; then
    bundle exec pod install --repo-update
fi
