#!/bin/sh
IS_SETUP=$(defaults read me.caylan.macconfig IsSetup 2>/dev/null)
USER=$(whoami)

#
# Initial prep
#

# Get password. We'll use it later for the update script
echo "Please enter your password:"
read -s PASSWORD
sudo -S -v <<< "$PASSWORD" 2>/dev/null

# Keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Apps
#

# Homebrew setup
echo "Setting up Homebrew"
[ ! -e /usr/local/bin/brew ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Unbundling things!"
brew bundle # homebrew

#
# Config
#
echo "Configuring system"
setup/setup-config.sh

# Git
git config --global author.name "Caylan Lee"
git config --global author.email "caylanlee@gmail.com"

#
# Dock
#

if [ ! $IS_SETUP ]; then
	# New setup - wipe dock
	defaults write com.apple.dock persistent-apps -array
fi

#
# Cleanup
#

echo "Cleaning up"
defaults write me.caylan.macconfig IsSetup -bool true

# Reset finder
echo "Killing your favourite processes"
killall Finder
killall Dock
killall SystemUIServer

#
# Open relevant installed apps so we can do things with them
#
if [ ! $IS_SETUP ]; then
	echo "Opening apps"
	open "/Applications/Alfred 4.app"
	open /Applications/Dropbox.app
	open /Applications/Docker.app
fi
