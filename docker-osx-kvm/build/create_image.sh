#!/bin/bash

hdiutil attach /Applications/Install\ macOS\ High\ Sierra.app/Contents/SharedSupport/InstallESD.dmg -noverify -mountpoint /Volumes/highsierra
hdiutil create -o /tmp/HighSierraBase.cdr -size 7316m -layout SPUD -fs HFS+J
hdiutil attach /tmp/HighSierraBase.cdr.dmg -noverify -mountpoint /Volumes/install_build
asr restore -source /Applications/Install\ macOS\ High\ Sierra.app/Contents/SharedSupport/BaseSystem.dmg -target /Volumes/install_build -noprompt -noverify -erase
rm /Volumes/OS\ X\ Base\ System/System/Installation/Packages
cp -R /Volumes/highsierra/Packages /Volumes/OS\ X\ Base\ System/System/Installation
hdiutil detach /Volumes/OS\ X\ Base\ System/
hdiutil detach /Volumes/highsierra/
mv /tmp/HighSierraBase.cdr.dmg /tmp/BaseSystem.dmg

# Restore the 10.13 Installer's BaseSystem.dmg into file system and place custom BaseSystem.dmg into the root
hdiutil create -o /tmp/HighSierra.cdr -size 8965m -layout SPUD -fs HFS+J
hdiutil attach /tmp/HighSierra.cdr.dmg -noverify -mountpoint /Volumes/install_build
asr restore -source /Applications/Install\ macOS\ High\ Sierra.app/Contents/SharedSupport/BaseSystem.dmg -target /Volumes/install_build -noprompt -noverify -erase
cp /tmp/BaseSystem.dmg /Volumes/OS\ X\ Base\ System

hdiutil detach /Volumes/OS\ X\ Base\ System/
rm /tmp/BaseSystem.dmg

hdiutil convert /tmp/HighSierra.cdr.dmg -format UDTO -o /tmp/HighSierra.iso
mv /tmp/HighSierra.iso.cdr ~/Desktop/HighSierra.iso
rm /tmp/HighSierra.cdr.dmg
