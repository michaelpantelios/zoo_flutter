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
# https://flutter.dev/docs/development/tools/web-renderers
flutter build web --web-renderer html --source-maps
#flutter build web --web-renderer html --release
#flutter build web --web-renderer canvaskit --release

# restore config
rm lib/config/current.dart
if [ -L old_current.dart ]; then
	mv old_current.dart lib/config/current.dart
fi

# copy to dropbox
rm -rf "${DEST_DIR}"
cp -r "${BUILD_DIR}" "${DEST_DIR}"

# upload source maps
printf "\nCalling Rollbar API to upload sourceMaps for production application.\n"
curl https://api.rollbar.com/api/1/sourcemap/ -F access_token='cdaf1f5a8dca4e24a33748b99d1bc65b' -F version='1.0' -F minified_url=https://zappreleases-15b2.kxcdn.com/zoo_flutter/main.dart.js -F source_map=@build/web/main.dart.js.map
printf "\nRollbar completed.\n"
echo build created