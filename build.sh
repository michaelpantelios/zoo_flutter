#!/bin/bash

TARGET=$1
if [ "$TARGET" != "production" ] && [ "$TARGET" != "testing"  ]; then
	echo "usage: build.sh [production | testing]"
	exit
fi

BUILD_DIR="./build/web"
DEST_DIR="$HOME/Dropbox/zapp-releases/$TARGET/zoo_flutter"

set -e	# exit when any command fails

# backup current config and replace with production/testing config
if [ -L lib/config/current.dart ]; then
	mv lib/config/current.dart old_current.dart
fi
ln -s $TARGET.dart lib/config/current.dart

# ensure we get a fresh build
rm -rf .dart_tool/flutter_build
rm -rf "$BUILD_DIR"

# build
# https://flutter.dev/docs/development/tools/web-renderers
case "$TARGET" in
 production) OPTS="--release" ;;
 testing) OPTS="--profile" ;;
esac

flutter build web --web-renderer html --source-maps $OPTS

#flutter build web --web-renderer html --release
#flutter build web --web-renderer canvaskit --release

# restore config
rm lib/config/current.dart
if [ -L old_current.dart ]; then
	mv old_current.dart lib/config/current.dart
fi

# copy to dropbox
rm -rf "$DEST_DIR"
cp -r "$BUILD_DIR" "$DEST_DIR"

# upload source maps
if [ "$TARGET" == "production" ]; then
	printf "\nCalling Rollbar API to upload sourceMaps for production application.\n"
	curl https://api.rollbar.com/api/1/sourcemap/ -F access_token='cdaf1f5a8dca4e24a33748b99d1bc65b' -F version='1.0' -F minified_url=https://zappreleases-15b2.kxcdn.com/zoo_flutter/main.dart.js -F source_map=@build/web/main.dart.js.map
	printf "\nRollbar completed.\n"
fi

echo "$TARGET build created"