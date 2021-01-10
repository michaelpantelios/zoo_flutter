#!/bin/bash

BUILD_DIR="./build/web"
DEST_DIR="$HOME/Dropbox/zapp-releases/production/zoo_flutter"

set -e	# exit when any command fails

# backup current config and replace with production config
if [ -L lib/config/current.dart ]; then
	mv lib/config/current.dart old_current.dart
fi
ln -s production.dart lib/config/current.dart

# ensure we get a fresh build
rm -rf .dart_tool/flutter_build
rm -rf "${BUILD_DIR}"

# build
flutter build web --web-renderer html --release

# restore config
rm lib/config/current.dart
if [ -L old_current.dart ]; then
	mv old_current.dart lib/config/current.dart
fi

# copy to dropbox
rm -rf "${DEST_DIR}"
cp -r "${BUILD_DIR}" "${DEST_DIR}"

echo build created