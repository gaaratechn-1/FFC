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
mkdir -p "${PAYLOAD_DIR}"

echo "=== [2/5] Compiling Swift sources with xcodebuild / swiftc ==="
if command -v xcodebuild &> /dev/null; then
    xcodebuild -project "${APP_NAME}.xcodeproj" \
               -scheme "${APP_NAME}" \
               -configuration Release \
               -destination "generic/platform=iOS" \
               -sdk iphoneos \
               -derivedDataPath "${OUTPUT_DIR}/DerivedData" \
               CODE_SIGNING_ALLOWED=NO \
               CODE_SIGNING_REQUIRED=NO \
               clean build

    BUILT_APP="${OUTPUT_DIR}/DerivedData/Build/Products/Release-iphoneos/${APP_NAME}.app"
    if [ -d "${BUILT_APP}" ]; then
        echo "[+] Copying compiled application bundle..."
        rm -rf "${APP_DIR}"
        cp -R "${BUILT_APP}" "${PAYLOAD_DIR}/"
    else
        echo "[!] Error: Compiled .app bundle not found at ${BUILT_APP}"
        exit 1
    fi
else
    echo "[!] xcodebuild not found. Copying pre-built binary and assets..."
    mkdir -p "${APP_DIR}"
    if [ -f "Resources/${APP_NAME}" ]; then
        cp "Resources/${APP_NAME}" "${APP_DIR}/"
    fi
fi

echo "=== [3/5] Copying resources, icons, and patch payload ==="
if [ -f "Resources/Info.plist" ]; then
    cp Resources/Info.plist "${APP_DIR}/Info.plist"
fi
if [ -f "Resources/Assembly-CSharp-patch.bytes" ]; then
    cp Resources/Assembly-CSharp-patch.bytes "${APP_DIR}/"
fi
if [ -d "Resources/AppIcons" ]; then
    cp Resources/AppIcons/*.png "${APP_DIR}/" 2>/dev/null || true
fi

echo "=== [4/5] Applying entitlements with ldid (if available) ==="
if command -v ldid &> /dev/null; then
    if [ -f "Resources/Entitlements.plist" ] && [ -f "${APP_DIR}/${APP_NAME}" ]; then
        ldid -S"Resources/Entitlements.plist" "${APP_DIR}/${APP_NAME}"
        echo "[+] Signed with ldid and private container entitlements."
    fi
else
    echo "[*] ldid not found, skipping pseudo-codesign (can be signed upon sideloading)."
fi

echo "=== [5/5] Packaging IPA archive ==="
cd "${OUTPUT_DIR}"
zip -qr "${APP_NAME}_rebuilt.ipa" Payload
mv "${APP_NAME}_rebuilt.ipa" ../

echo "=============================================================================="
echo "[+] SUCCESS: ${APP_NAME}_rebuilt.ipa generated successfully!"
echo "    Ready to install via TrollStore, AltStore, Sideloadly, or Scarlet."
echo "=============================================================================="
