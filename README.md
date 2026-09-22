# YABAOCHEAT (FFXC / Private Edition) — Reconstructed iOS Source Code

Complete, reverse-engineered and decompiled Swift/SwiftUI source code repository for **YABAOCHEAT** (`FFXC / Private Edition` v3.6.9 build 33), recovered from the decrypted ARM64 Mach-O iOS IPA.

---

## ⚡ Overview & Architecture

**YABAOCHEAT** is an iOS runtime hotfix injector specifically designed for **Garena Free Fire** (`com.dts.freefireth`) and **Free Fire MAX** (`com.dts.freefiremax`).

Rather than relying on classic memory manipulation (which is heavily monitored by mobile anti-cheat engines), this tool exploits the game's embedded **Tencent IFix** C# hotfix engine by deploying a high-level bytecode patch directly into the application's data container.

```
┌────────────────────────────────────────────────────────┐
│                   YABAOCHEAT (SwiftUI)                 │
│      LanguageStore • MenuStore • SessionManager        │
└──────────────────────────┬─────────────────────────────┘
                           │
             ContainerBridge (Private MCM)
                           ▼
  /var/mobile/Containers/Data/Application/<Game-UUID>/
     ├── Documents/
     │     ├── Assembly-CSharp-patch.bytes  (IFix Bridge)
     │     └── localConfig.json             (Enabler flag)
     └── Library/Caches/patch/
           └── Assembly-CSharp-patch.bytes
```

---

## 🚀 Key Features

- **Multi-Game Selector:** Instant switching between *Free Fire* and *Free Fire MAX*.
- **Aimbot Smooth:** Real-time crosshair interpolation to nearest entity bounding box.
- **Auto Headshot:** Hitbox calculation redirection directly to the head bone node.
- **Customizable Sliders:**
  - **FOV Radius:** Adjustable 20px – 360px radius.
  - **Headshot Rate:** Fine-grained 0% – 100% targeting chance.
  - **Aim Target:** Head / Neck / Chest selection.
- **ESP & Visuals:** Snaplines, 2D Entity Bounding Boxes.
- **Memory & Weapon Mods:** No Recoil, Fast Switch Scope.
- **Multilingual Support:** 7 languages fully supported (English, Bahasa Indonesia, Tiếng Việt, Português Brasil, Darija المغرب, العربية, 繁體中文 台灣).
- **Clean Neutralization (RESET):** Removes all injected patch files and restores stock game state with a single tap.

---

## 🔓 Zero-Key / Unlocked Operation

The key verification system and remote license check have been **completely bypassed and eliminated**:
- **No Key Required:** Opening the app immediately loads the full cheat menu.
- **Permanent VIP Status:** All features, sliders, and injection routines are permanently activated out of the box.
- **No Remote Server Dependence:** Operates 100% offline without connecting to `crackbomaydi.dev`.

---

## 🛠 Project Structure

```
YABAOCHEAT/
├── Sources/
│   ├── App/
│   │   ├── FFXCApp.swift             # App entry point (@main)
│   │   ├── RootView.swift            # View switcher (Login vs Menu)
│   │   └── AppLog.swift              # In-app diagnostics logger
│   ├── Models/
│   │   ├── FFGame.swift              # Free Fire & Free Fire MAX definitions
│   │   ├── FFLanguage.swift          # 7 supported languages
│   │   ├── Catalog.swift             # Dynamic cheat feature catalog
│   │   ├── GameConfiguration.swift   # Per-game saved configuration
│   │   ├── InjectState.swift         # Injection state machine & errors
│   │   └── Session.swift             # License & device credentials
│   ├── Services/
│   │   ├── LanguageStore.swift       # Full translation tables
│   │   ├── MenuStore.swift           # UI state & persistence
│   │   ├── SessionManager.swift      # API validation + Offline bypass
│   │   ├── ContainerBridge.swift     # Private container discovery
│   │   └── InjectionManager.swift    # IFix patch & localConfig deployment
│   └── UI/
│       ├── Styles/                   # Backdrop, BrandMark, Glass & Toggle styles
│       └── Views/                    # LoginView, MainMenuView, Sliders, Bar
├── Resources/
│   ├── Assembly-CSharp-patch.bytes   # Dumped 322-byte IFix hotfix payload
│   ├── Info.plist                    # App permissions & manifest
│   ├── Entitlements.plist            # TrollStore & MobileContainerManager entitlements
│   └── AppIcons/                     # Extracted retina app icons
├── build_ipa.sh                      # Automated build & packaging script
├── build_ipa.bat                     # Windows packaging script
└── YABAOCHEAT.xcodeproj              # Xcode project
```

---

## 📦 Building & Packaging into IPA

### Option 1: macOS via Xcode / Terminal

```bash
# Clone the repository
git clone https://github.com/your-username/YABAOCHEAT-iOS.git
cd YABAOCHEAT-iOS

# Build and package into IPA
chmod +x build_ipa.sh
./build_ipa.sh
```

Or open `YABAOCHEAT.xcodeproj` directly in Xcode:
1. Set the target to **Any iOS Device (arm64)**.
2. Select **Product > Archive**.
3. Export as an unsigned or development `.ipa`.

### Option 2: Windows Repackaging

If you only need to repackage the original assets and payload on Windows:
```cmd
build_ipa.bat
```

### Option 3: GitHub Actions CI/CD

Push this repository to GitHub and create `.github/workflows/build.yml`:
```yaml
name: Build IPA
on: [push, workflow_dispatch]
jobs:
  build:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - name: Build IPA
        run: |
          chmod +x build_ipa.sh
          ./build_ipa.sh
      - uses: actions/upload-artifact@v4
        with:
          name: YABAOCHEAT_rebuilt.ipa
          path: YABAOCHEAT_rebuilt.ipa
```

---

## 📲 Installation on iOS

Because this tool accesses app containers across sandboxes (`/var/mobile/Containers/Data/Application/`), it requires appropriate entitlements:
- **TrollStore (iOS 14.0 – 17.0):** Recommended. Installs with full root/container permissions.
- **Jailbreak (Dopamine, Palera1n):** Install via Filza or Snail.
- **Sideloading (AltStore / Sideloadly):** Supported on developer accounts with container permissions enabled.

---

## 📜 Credits & Disclaimers

- Recovered and decompiled by **fox 🦊 orange**.
- Original Telegram channel: [t.me/YaPaoCheat](https://t.me/YaPaoCheat).
- For research, binary reversing, and educational security auditing purposes.
