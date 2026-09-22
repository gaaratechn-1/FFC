#!/bin/bash
# ==============================================================================
#  YABAOCHEAT (FFXC Private Edition) - Automated IPA Build & Packaging Script
# ==============================================================================
set -e

APP_NAME="YABAOCHEAT"
BUNDLE_ID="com.apple.mobile.MobileHouseArrest"
OUTPUT_DIR="BuildOutput"
PAYLOAD_DIR="${OUTPUT_DIR}/Payload"
APP_DIR="${PAYLOAD_DIR}/${APP_NAME}.app"

echo "=== [1/5] Preparing build workspace ==="
rm -rf "${OUTPUT_DIR}"
mkdir -p "${APP_DIR}"

echo "=== [2/5] Compiling Swift sources with xcodebuild / swiftc ==="
if command -v xcodebuild &> /dev/null; then
    xcodebuild -project "${APP_NAME}.xcodeproj" \
               -scheme "${APP_NAME}" \
               -configuration Release \
               -destination "generic/platform=iOS" \
               -sdk iphoneos \
               -derivedDataPath "${OUTPUT_DIR}/DerivedData" \
               CODE_SIGNING_ALLOWED=NO \
               CODE_SIGNING_REQUIRED=NO

    cp -R "${OUTPUT_DIR}/DerivedData/Build/Products/Release-iphoneos/${APP_NAME}.app/"* "${APP_DIR}/"
else
    echo "[!] xcodebuild not found. Copying pre-built binary and assets..."
    if [ -f "Resources/${APP_NAME}" ]; then
        cp "Resources/${APP_NAME}" "${APP_DIR}/"
    fi
fi

echo "=== [3/5] Copying resources, icons, and patch payload ==="
cp Resources/Info.plist "${APP_DIR}/Info.plist"
cp Resources/Assembly-CSharp-patch.bytes "${APP_DIR}/"
cp Resources/AppIcons/*.png "${APP_DIR}/" 2>/dev/null || true

echo "=== [4/5] Applying entitlements with ldid (if available) ==="
if command -v ldid &> /dev/null; then
    ldid -S"Resources/Entitlements.plist" "${APP_DIR}/${APP_NAME}"
    echo "[+] Signed with ldid and private container entitlements."
fi

echo "=== [5/5] Packaging IPA archive ==="
cd "${OUTPUT_DIR}"
zip -qr "${APP_NAME}_rebuilt.ipa" Payload
mv "${APP_NAME}_rebuilt.ipa" ../

echo "=============================================================================="
echo "[+] SUCCESS: ${APP_NAME}_rebuilt.ipa generated successfully!"
echo "    Ready to install via TrollStore, AltStore, Sideloadly, or Scarlet."
echo "=============================================================================="
