#!/usr/bin/env bash

: <<'DOC'
Builds a distributable RiskGlass app bundle and checksum from the Swift package.
DOC

set -euo pipefail

version="${VERSION:-0.1.0}"
output_dir="${OUTPUT_DIR:-dist}"
signing_identity="${SIGNING_IDENTITY:--}"
app_name="RiskGlass"
bundle_id="com.apurva3509.riskglass"

swift build -c release --product "$app_name"
binary_dir="$(swift build -c release --show-bin-path)"
app_dir="$output_dir/$app_name.app"
contents_dir="$app_dir/Contents"

rm -rf "$app_dir"
mkdir -p "$contents_dir/MacOS" "$contents_dir/Resources"
cp "$binary_dir/$app_name" "$contents_dir/MacOS/$app_name"

cat > "$contents_dir/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$app_name</string>
  <key>CFBundleIdentifier</key>
  <string>$bundle_id</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$app_name</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>$version</string>
  <key>CFBundleVersion</key>
  <string>$version</string>
  <key>LSApplicationCategoryType</key>
  <string>public.app-category.finance</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

plutil -lint "$contents_dir/Info.plist"
codesign --force --options runtime --sign "$signing_identity" "$app_dir"
codesign --verify --deep --strict --verbose=2 "$app_dir"

archive="$output_dir/$app_name-$version-macOS.zip"
rm -f "$archive" "$archive.sha256"
ditto -c -k --sequesterRsrc --keepParent "$app_dir" "$archive"
shasum -a 256 "$archive" > "$archive.sha256"

echo "$archive"
