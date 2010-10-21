# $Id$

CONFIG=Release

BUILD_CONFIG?=$(CONFIG)

CP=ditto --rsrc
RM=rm

.PHONY: netdemo clean clean-all run latest

sequel-pro:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" CFLAGS="$(CFLAGS)" build

clean:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" -nodependencies clean

clean-all:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" clean

run:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" -target Run

latest:
	svn update
	make sequel-pro
