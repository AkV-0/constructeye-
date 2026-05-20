# Flutter Multi-Device Testing Guide

## Quick Start

### **Option 1: Using VS Code Debug Panel (Recommended)**

1. Open VS Code's **Run & Debug** panel (`Ctrl+Shift+D`)
2. Select from the dropdown:
   - **"Flutter: Web + Mobile"** - Runs web and Android simultaneously
   - **"Flutter: Web (Chrome)"** - Web only
   - **"Flutter: Mobile (Android)"** - Mobile only
3. Click the green **Play** button
4. Both instances will start in dedicated terminals

### **Option 2: Using VS Code Tasks**

1. Open Command Palette (`Ctrl+Shift+P`)
2. Type `Tasks: Run Task`
3. Choose:
   - **Flutter: Run Web**
   - **Flutter: Run Mobile (Android)**
   - **Flutter: Run All Devices**

### **Option 3: Manual Terminal Commands**

**Terminal 1 - Web:**
```bash
cd "d:\AATISH FILESS\ConstructionMonitoringApp\mobile_app"
flutter run -d chrome -v
```

**Terminal 2 - Mobile:**
```bash
cd "d:\AATISH FILESS\ConstructionMonitoringApp\mobile_app"
flutter run -d android -v
```

---

## Hot Reload Workflow

After making changes to `LandingPage.dart`:

1. **Save the file** (`Ctrl+S`)
2. **Press `r`** in the terminal running on web
3. **Press `r`** in the terminal running on mobile

Both instances will update instantly!

### Keyboard Shortcuts in Running App:

| Key | Action |
|-----|--------|
| `r` | Hot reload (keeps state) |
| `R` | Hot restart (resets state) |
| `q` | Quit the app |
| `P` | Toggle performance overlay |
| `i` | Toggle widget inspector |

---

## Checking Available Devices

Before running, verify your devices are connected:

```bash
flutter devices
```

Output example:
```
android                          • Android Device (emulator)
chrome                           • Chrome Web Browser
windows                          • Windows Desktop
```

---

## Troubleshooting

### Web won't start
- **Error:** Port 8080 already in use
- **Fix:** Use a different port in `launch.json` or kill the process

### Mobile build fails
- **Error:** Gradle build errors
- **Fix:** Run `flutter clean` then restart

### Hot reload not working
- **Fix:** Press `R` (capital R) for hot restart instead

### Both instances conflict
- **Fix:** Quit one with `q`, fix the issue, restart

---

## Best Practice Setup

Arrange your VS Code workspace:

```
┌─────────────────────────────────────┐
│  Editor (LandingPage.dart)          │
├──────────────────┬──────────────────┤
│  Web Terminal    │ Mobile Terminal  │
│  (Press r here)  │  (Press r here)  │
└──────────────────┴──────────────────┘
```

1. Edit code in the editor
2. Save (`Ctrl+S`)
3. Press `r` in left terminal (web)
4. Press `r` in right terminal (mobile)
5. Compare both layouts instantly

---

## Preset Keyboard Shortcuts

Add to VS Code `keybindings.json` for faster workflow:

```json
{
  "key": "ctrl+shift+w",
  "command": "workbench.action.debug.start",
  "when": "!inDebugMode"
}
```

Then `Ctrl+Shift+W` starts the default configuration.

---

## Need Help?

```bash
# Check Flutter version
flutter --version

# Upgrade Flutter
flutter upgrade

# Get project info
flutter pub get

# Run analysis
flutter analyze
```
