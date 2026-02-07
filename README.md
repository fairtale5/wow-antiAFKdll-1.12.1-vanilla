# AfkPreventer — Anti-AFK for Vanilla WoW 1.12.1

Prevents AFK kicks in Vanilla WoW 1.12.1. Native C++ DLL, loads via [VanillaFixes](https://github.com/hannesmann/vanillafixes) launcher (dlls.txt).

## Install

1. Download `AfkPreventer.dll` from [Releases](https://github.com/fairtale5/wow-antiAFKdll-1.12.1-vanilla/releases).
2. Copy it to your WoW folder (same folder as `WoW.exe`).
3. Add `AfkPreventer.dll` to `dlls.txt` in that folder (one per line).
4. Launch WoW with the VanillaFixes launcher.

## How it works

The VanillaFixes launcher loads the DLL into WoW's process via `LoadLibrary`. When the DLL attaches:

1. **Entry point** — `DllMain` runs on load (`dllmain.cpp:44`).
2. **On attach** — It calls `DisableThreadLibraryCalls` to avoid unwanted notifications, then spawns a background thread (`dllmain.cpp:49-52`).
3. **Background thread** — The thread loops forever (`dllmain.cpp:23`): sleeps 10 seconds (`dllmain.cpp:25`), then writes `GetTickCount()` into WoW's AFK timer at address `0x00CF0BC8` (`dllmain.cpp:29-30`).
4. **Result** — WoW reads that memory for activity. Fresh values = "user active" = no AFK kick.

Constants: AFK timer address (`dllmain.cpp:16`), interval in ms (`dllmain.cpp:17`).

## Build

WoW 1.12.1 is 32-bit → build for x86/Win32.

### Windows — portable MinGW (no install)

1. Download a 32-bit MinGW, e.g. [WinLibs i686](https://winlibs.com/) (i686 / 32-bit, UCRT or MSVCRT).
2. Extract so you have `tools/mingw32/bin/g++.exe` in this folder:
   ```
   AfkPreventerDll/
   └── tools/
       └── mingw32/
           └── bin/
               └── g++.exe
   ```
3. Run `.\build.ps1` — output: `bin\AfkPreventer.dll`.

The script prefers portable MinGW (`build.ps1:6-13`); if missing, it falls back to Visual Studio MSBuild (`build.ps1:15-20`).

### WSL / Linux (mingw-w64)

```bash
sudo apt install mingw-w64
make
# Output: bin/AfkPreventer.dll
```

### Windows — Visual Studio

Open `AfkPreventer.vcxproj` and build, or run `.\build.ps1` (uses MSBuild if no portable MinGW).

## Technical

- WoW 1.12.1 AFK timer address: `0x00CF0BC8`
- Compatible with Vanilla-based clients (SandWorlds, etc.) that use the same 1.12.1 engine
