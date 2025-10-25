# WineHooks
**Formerly known as Peixoto's Patch**

**Note: readme created by AI. Still needs a human toutch**

A comprehensive compatibility and enhancement framework for classic PC games, featuring resolution fixes, texture replacement, Direct3D/OpenGL hooks, and extensive game-specific patches. Designed to work on both Windows and Linux (via Wine).

[![Patreon](https://img.shields.io/badge/Support-Patreon-orange.svg)](https://www.patreon.com/user/about?u=44312848)
[![License](https://img.shields.io/badge/License-Custom-blue.svg)](#license)

---

## 🎮 Overview

WineHooks is a sophisticated game patching framework that injects custom DLL hooks into games to provide:

* **Resolution Enhancement** - Force games to run at modern resolutions they don't natively support
* **Texture Replacement** - Swap original textures with high-resolution alternatives (up to 4096x4096+)
* **Graphics API Hooks** - DirectX (6-12), OpenGL, DirectDraw, and DDraw support
* **Wine Compatibility** - Full Linux support through Wine, with DXVK integration
* **Audio Enhancements** - DirectSound, WinMM, and MCI audio hooks
* **Input Remapping** - DirectInput and XInput translation capabilities
* **Cheat Engine Integration** - Built-in trainer support for many games
* **Game-Specific Fixes** - 130+ pre-configured game profiles

---

## ✨ Key Features

### Graphics Enhancements
* **Forced Resolution (HD Mode)** - Play games at resolutions they don't natively support
* **Dynamic Super Resolution (DSR)** - Use maximum display resolution
* **SSAA (Super Sampling Anti-Aliasing)** - Software-based anti-aliasing
* **xBRz Scaling** - Pixel art scaler for 2D games
* **Texture Filtering** - Force anisotropic filtering and nearest neighbor options
* **VSync Control** - Triple buffering and frame synchronization
* **Borderless Windowed Mode** - Easy alt-tabbing support

### API Hooks & Support
* **DirectX 6-12** (D3D, DDraw, DirectDraw)
* **OpenGL** with xBRz shader support
* **DirectSound & WinMM** audio
* **DirectInput & XInput**
* **GDI** rendering hooks
* **MCI** multimedia control

### Wine Integration
* **Native Wine Support** - Designed to work seamlessly with Wine on Linux
* **DXVK Compatibility** - Works with DXVK for DX10/11/12 games
* **Wine D3D Selection** - Choose between Wine's D3D or DXVK per game

### Advanced Features
* **Texture Swapping System** - Real-time texture dump and replacement
* **Shader Patching** - Custom shader injection for specific games
* **Process Hooks** - CreateProcess monitoring and injection
* **Virtual Disk System** - File system redirection
* **CheatEngine Integration** - Hotkey-based trainers for supported games
* **HTTP Server** - Embedded server for configuration interface

---

## 📋 Supported Games

WineHooks includes profiles for 130+ games including:

### Legacy of Kain Series
* Blood Omen, Blood Omen 2, Soul Reaver, Soul Reaver 2, Defiance

### Tomb Raider Series
* Tomb Raider 1-5, Legend, Anniversary

### Classic FPS
* Half-Life series, Unreal Gold, Deus Ex, Star Trek Elite Force, Aliens vs Predator

### Adventure Games
* Grim Fandango, Sanitarium, Syberia series, The Longest Journey

### Action Games
* Prince of Persia series, Max Payne 1-2, Oni, Messiah, Die by the Sword

### Modern Games
* Control (D3D11/12), Death Stranding, Ori series, Inside, Unravel

*See `/Profiles` directory for complete game list with individual configuration files*

---

## 🚀 Getting Started

### Prerequisites

**Windows:**
* Windows 7 or later
* DirectX Runtime
* Visual C++ Redistributables

**Linux:**
* Wine 5.0+
* MinGW-w64 cross-compiler (for building)

### Installation

1. Download the latest release from the [releases page](https://github.com/Daniel-Lobo/WineHooks/releases)
2. Extract to your desired location
3. Run `Injector.exe` (Windows) or `Injector.ahk` via AutoHotkey

### Quick Start

1. **Launch the GUI** - Run `Injector.exe`
2. **Select Your Game** - Find your game in the left panel
3. **Configure Options** - Adjust graphics, sound, and input settings
4. **Locate Game** - Click "Start" and browse to your game's executable
5. **Play** - The patch will inject and launch your game

### Creating Shortcuts

Use the "Create Shortcut" button to create desktop shortcuts that automatically launch games with WineHooks applied.

---

## 🔧 Building from Source

### Windows Build

```bash
cd dlls
mkdir build && cd build
cmake .. -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../toolchain-mingw.cmake
make
```

### Linux Build

```bash
cd dlls
mkdir build && cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=/usr/share/mingw/toolchain-mingw32.cmake
make
```

The build system generates:
* `peixoto.dll` (32-bit)
* `peixoto64.dll` (64-bit)

Both DLLs are placed in the `/Ahk` directory.

---

## 📁 Project Structure

```
WineHooks/
├── Ahk/                      # AutoHotkey scripts and compiled executables
│   ├── Injector.exe          # Main launcher
│   ├── *.ahk                 # Hook configuration scripts
│   ├── GUI/                  # Web-based GUI interface
│   └── Lib/                  # AutoHotkey libraries
├── dlls/                     # C++ source code
│   ├── Sources/              # Main DLL implementations
│   ├── Headers/              # Header files
│   ├── LAYERS/               # DirectDraw/DirectSound layer implementations
│   ├── minhook/              # MinHook library
│   └── Simple-HTTP-Server/   # Embedded HTTP server
├── Profiles/                 # Game configuration files (.ini)
├── GameProfiles/             # Additional game profiles and help
├── CheatTables/              # CheatEngine trainer scripts
├── Shaders/                  # Custom shader files
├── Scripts/                  # Game-specific script patches
└── Help/                     # Documentation and help files
```

---

## 🎯 Core Technologies

### DLL Injection
* **MinHook** - x86/x64 API hooking library
* Custom injection framework via AutoHotkey

### Graphics Hooks
* **D3D8-12** - Complete Direct3D pipeline interception
* **OpenGL** - Context and function hooking
* **DirectDraw/DDraw** - Legacy graphics API support
* **xBRz** - CPU-based pixel art scaling

### Audio Hooks
* **DirectSound** - Buffer and stream manipulation
* **WinMM** - Waveform audio and MIDI
* **MCI** - Multimedia Control Interface

### Input Translation
* **DirectInput** - Keyboard and gamepad hooks
* **XInput** - Xbox controller emulation
* **Joystick to Keyboard** - Configurable button mapping

---

## ⚙️ Configuration

Each game profile is an `.ini` file with sections for:

### Basic Settings
```ini
Target=path\to\game.exe       # Game executable
D3D=9                         # DirectX version (6-12)
HD=true                       # Enable forced resolution
SSAA=2                        # Super sampling level
xBR=false                     # xBRz pixel art scaling
SYNC=true                     # VSync/triple buffering
```

### Advanced Options
```ini
WSTL=0                        # Texture swapping level
MHKS=true                     # Mouse hooks
Path=Game\Subfolder           # Relative path
singlecore=false              # Force single CPU core
HDPI=true                     # High DPI aware
```

### Input Mapping
```ini
[J2K]                         # Joystick to Keyboard
a=W,A,S,D,Space               # Map buttons to keys
deadzone=0.25                 # Analog stick deadzone
```

---

## 🖼️ Texture Swapping

WineHooks supports runtime texture replacement for all supported games:

### Workflow
1. Enable "Show/Hide Thumbnail" hotkey in game settings
2. Launch game and press the hotkey to browse loaded textures
3. Use "Next/Previous" hotkeys to find the texture to replace
4. Press "Dump Texture" to save it to the `dumps/` folder
5. Edit the texture (maintain format: DDS, PNG, etc.)
6. Place replacement in `replacements/` folder with same name
7. Restart game - replacement is automatically loaded

### Supported Formats
* **DirectX**: DDS, BMP, PNG (auto-converted)
* **OpenGL**: PNG, TGA, BMP
* **Maximum Size**: Up to 4096x4096 (hardware dependent)

---

## 🐧 Linux/Wine Usage

### Running on Linux

```bash
# Install Wine and dependencies
sudo apt install wine winetricks mingw-w64

# Run WineHooks
wine Ahk/Injector.exe
```

### Wine Configuration
* Enable DXVK for DX10+ games via profile settings
* Use Wine's D3D for DX9 and earlier (better compatibility)
* Configure via `winecfg` for system-wide Wine settings

### Known Linux Issues
* Some games require specific Wine versions
* DXVK compatibility varies by game (see individual profiles)
* Native DirectDraw games work better with Wine's implementation

---

## 🔌 CheatEngine Integration

Many games include built-in trainers:

### Usage
1. Enable CheatEngine support in game profile
2. Launch game through WineHooks
3. Use hotkeys defined in `.CT.ahk` files

### Example Hotkeys
* `H` - Infinite Health
* `K` - Easy Kills
* `E` - Infinite Energy
* `L` - Max Resources

*See individual `.CT.ahk` files in `/CheatTables` for game-specific trainers*

---

## 📚 Documentation

Detailed help files are available in the `/Help` directory:

* **Home.txt** - Getting started guide
* **DX8.txt, DX9.txt, etc.** - DirectX-specific options
* **Gl.txt** - OpenGL configuration
* **Sound.txt** - Audio settings
* **Input.txt** - Controller/keyboard mapping
* **Game-specific** - Individual game guides

---

## 🐛 Known Issues & Limitations

### DirectX 9
* Some games have shadow glitches with DXVK
* Frame limitation not yet implemented
* Reset() not fully implemented for HD mode

### DirectX 8
* Soul Reaver 2 occasional crashes
* Max Payne 2 intro movie resolution detection

### DirectX 7 and Earlier
* xBRz is CPU-only (performance impact)
* Some games have slow transparency rendering
* Execute buffer bugs with Wine (specific games)

### OpenGL
* Rune portal rendering issues
* Some texture upload hooks cause crashes

*See `/Ahk/Todo.txt` for complete issue list*

---

## 🤝 Contributing

Currently not accepting pull requests as this is primarily a portfolio project. However:

* **Bug Reports** - Submit issues on GitHub
* **Game Requests** - Request profiles for specific games
* **Support** - Help other users in discussions

---

## 📜 License

**Custom License - Free for Non-Commercial Use**

### Permissions
✅ Free to use for personal purposes  
✅ Free to modify for personal use  
✅ No warranties - use at your own risk

### Restrictions
❌ Do not redistribute unmodified versions (link to official thread instead)  
❌ Do not use for commercial purposes without permission  
❌ Include proper credits if distributing modifications

### Credits Required
If you distribute modified versions or derived works:
1. Include original credits in README or About section
2. Link to release thread: [Vogons Forum](http://www.vogons.org/viewtopic.php?f=24&t=53121)

### Third-Party Libraries
* **MinHook** - BSD 2-Clause License
* **xBRz** - GPL v3
* **Simple HTTP Server** - MIT License

---

## 💖 Support the Project

Development is supported through donations:

[![PayPal](https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=E68RE3UWG2ZEU&lc=US&item_name=Peixoto&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted)

[![Patreon](https://img.shields.io/badge/Become%20a-Patron-orange.svg)](https://www.patreon.com/user/about?u=44312848)

Donations encourage new features, game support, and continued development!

---

## 🔗 Links

* **Release Thread**: [Vogons Forum](http://www.vogons.org/viewtopic.php?f=24&t=53121)
* **Releases**: [GitHub Releases](https://github.com/Daniel-Lobo/WineHooks/releases)
* **Wine Project**: [WineHQ](https://www.winehq.org/)
* **DXVK**: [GitHub](https://github.com/doitsujin/dxvk/releases)
* **CheatEngine**: [Official Site](https://www.cheatengine.org/)

---

## 📧 Contact

Written by **Peixoto** (Daniel Lobo)

For questions, support, or game requests, please use the GitHub Issues or Discussions.

---

## 🙏 Acknowledgments

* **Shajul** - GUID.ahk library
* **UCyborg** - 4K resolution fix for DirectX 6 and earlier
* **MinHook Contributors** - API hooking library
* **AutoHotkey Community** - Scripting framework
* **Wine Developers** - Linux compatibility layer
* **All Donors and Supporters** - Continued development

---

**Last Updated**: October 2025  
**Version**: 0.10.15+  
**Status**: Active Development
