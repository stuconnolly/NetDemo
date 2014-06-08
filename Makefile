# $Id$

CONFIG=Development

BUILD_CONFIG?=$(CONFIG)

RM=rm
CP=ditto --rsrc

.PHONY: netdemo clean analyze run

netdemo:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" CFLAGS="$(CFLAGS)" build

clean:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" clean

analyze:
	xcodebuild -project NetDemo.xcodeproj -scheme NetDemo -configuration "$(BUILD_CONFIG)" CFLAGS="$(FLAGS)" analyze

run:
	xcodebuild -project NetDemo.xcodeproj -configuration "$(BUILD_CONFIG)" -target Run

