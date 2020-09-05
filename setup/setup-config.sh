#!/bin/sh
alias dw="defaults write"
alias dwg="defaults write -g"

#
# Defaults
#

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

# Keyboard
dwg NSAutomaticDashSubstitutionEnabled -bool false
dwg NSAutomaticQuoteSubstitutionEnabled -bool false
dwg NSAutomaticSpellingCorrectionEnabled -bool false
dwg AppleKeyboardUIMode -int 3 # Enable full keyboard access on all controls (not just text boxes)
dwg ApplePressAndHoldEnabled -bool false
dwg InitialKeyRepeat -int 15
dwg KeyRepeat -int 2

# Finder
dw com.apple.finder NewWindowTarget -string "PfHm" # New window default location to ~
dw com.apple.LaunchServices LSQuarantine -bool false # No "Are you sure you want to open?" msg
dw com.apple.finder ShowPathbar -bool true
dw com.apple.finder QLEnableTextSelection -bool true # text selection in quicklook
dw com.apple.finder WarnOnEmptyTrash -bool false
dw com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid creating .DS_Store files on network or USB volumes
dw com.apple.desktopservices DSDontWriteNetworkStores -bool true
dw com.apple.desktopservices DSDontWriteUSBStores -bool true

# default view mode to grid for desktop and list elsewhere
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy list" ~/Library/Preferences/com.apple.finder.plist
chflags nohidden ~/Library # show ~/Library

# Mission Control
dw com.apple.dock mru-spaces -bool false # don't automatically rearrange spaces

# Expand save panel by default
dwg NSNavPanelExpandedStateForSaveMode -bool true
dwg NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
dwg PMPrintingExpandedStateForPrint -bool true
dwg PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
dwg NSDocumentSaveNewDocumentsToCloud -bool false

# MAS
dw com.apple.SoftwareUpdate AutomaticDownload -int 1
dw com.apple.commerce AutoUpdate -bool true
dw com.apple.commerce AutoUpdateRestartRequired -bool true
dw com.apple.SoftwareUpdate ScheduleFrequency -int 1 # daily updates
dw com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
dw com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# TextEdit
dw com.apple.TextEdit RichText -int 0 # default to plain text

# Disable guest user
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false

# Misc
dw com.apple.print.PrintingPrefs "Quit When Finished" -bool true
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window

#
# Prevent app relaunch on restart (https://apple.stackexchange.com/a/253609)
#
if test -n "$(find ~/Library/Preferences/ByHost/ -maxdepth 1 -name 'com.apple.loginwindow*' -print -quit)"; then
    sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow*
    sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow*
fi

#
# Power management
#

sudo pmset autorestart 1
sudo systemsetup -setrestartfreeze on # restart on mac bsod


#
# Enable Safari dev tools
#
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

#
# Terminal
#

echo "Setting Fish as shell"
sudo sh -c "grep -q -F fish /etc/shells || echo /usr/local/bin/fish >> /etc/shells"
sudo chsh -s /usr/local/bin/fish $USER
curl -L https://get.oh-my.fish > /tmp/omf-install
fish /tmp/omf-install --noninteractive || true
