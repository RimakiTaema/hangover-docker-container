# Hangover Docker Image

A Docker image for running Windows applications on ARM64 Linux using the [Hangover project](https://github.com/AndreRH/hangover). This image uses pre-built binaries from GitHub releases and supports both CLI and GUI modes with Wine, Box64, and FEX emulation.

## Features

- **Pre-built Binary**: Uses hangover 10.14 pre-built for Debian 12 Bookworm ARM64
- **ARM64 Support**: Runs on ARM64 servers and devices
- **Dual Mode**: Both CLI and GUI (VNC) modes
- **Multiple Emulators**: 
  - FEX for x86_64 emulation (default)
  - Box64 for i386 emulation (default)
  - Wine for native ARM64 applications
- **VNC GUI**: Access GUI applications via VNC on port 5901
- **Helper Scripts**: Easy-to-use scripts for common tasks
- **Fast Setup**: Quick 2-3 minute build time using pre-built binaries

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- ARM64 Linux system (or ARM64 emulation)

### Building the Image

```bash
docker compose build
```

### Testing the Setup

```bash
# Run the test script to verify everything works
./scripts/test-setup.sh
```

### Running in GUI Mode (Default)

```bash
# Start the container with VNC GUI
./scripts/run-gui.sh

# Or manually
docker compose up hangover
```

Connect to the GUI using any VNC client:
- Host: `localhost`
- Port: `5901`
- No password required

### Running in CLI Mode

```bash
# Start interactive CLI session
./scripts/run-cli.sh

# Run a specific Windows application
./scripts/run-cli.sh wine /path/to/app.exe

# Or manually
docker compose run --rm hangover-cli wine /path/to/app.exe
```

## Usage Examples

### Installing Windows Applications

```bash
# Copy a Windows application to the container
./scripts/install-app.sh /path/to/MyApp.exe

# The app will be available in ./apps/ directory
```

### Running Different Emulators

The container supports multiple emulators. You can specify which one to use:

```bash
# For x86_64 applications (default: FEX)
./scripts/run-cli.sh wine app64.exe

# For i386 applications (default: Box64)
./scripts/run-cli.sh wine app32.exe

# Use FEX for 32-bit applications
./scripts/run-cli.sh bash -c "HODLL=libwow64fex.dll wine app32.exe"

# Use different 64-bit emulator
./scripts/run-cli.sh bash -c "HODLL64=xtajit64.dll wine app64.exe"
```

### Wine Configuration

```bash
# Open Wine configuration GUI
./scripts/wine-config.sh
```

### Available Emulators

- **x86_64 emulation**:
  - `libarm64ecfex.dll` (FEX) - Default, best performance
  - `xtajit64.dll` (Wine stub)

- **i386 emulation**:
  - `wowbox64.dll` (Box64) - Default
  - `libwow64fex.dll` (FEX)

## Environment Variables

- `VNC_PORT`: VNC server port (default: 5901)
- `DISPLAY`: X11 display (default: :1)
- `WINEDEBUG`: Wine debug level (default: -all)
- `WINEPREFIX`: Wine prefix directory (default: /home/wine/.wine)
- `HODLL64`: 64-bit emulator DLL
- `HODLL`: 32-bit emulator DLL

## Directory Structure

```
.
├── Dockerfile              # Main Docker image
├── docker-compose.yml      # Docker Compose configuration
├── scripts/                # Helper scripts
│   ├── run-cli.sh         # Start CLI mode
│   ├── run-gui.sh         # Start GUI mode
│   ├── install-app.sh     # Install Windows apps
│   └── wine-config.sh     # Configure Wine
├── apps/                   # Windows applications (mounted)
└── README.md              # This file
```

## Advanced Usage

### Custom Wine Prefix

```bash
# Use a custom wine prefix
docker compose run --rm -e WINEPREFIX=/custom/path hangover-cli wine app.exe
```

### DXVK Support

For better graphics performance with DirectX applications:

1. Download DXVK from [GitHub](https://github.com/doitsujin/dxvk)
2. Copy the appropriate binaries:
   - x32 binaries → `$WINEPREFIX/drive_c/windows/syswow64`
   - arm64ec/aarch64/x64 binaries → `$WINEPREFIX/drive_c/windows/system32`
3. Configure DLL overrides in `winecfg`:
   - `d3d8`, `d3d9`, `d3d10core`, `d3d11`, `dxgi` → `native`

### Wayland Support

```bash
# Enable Wayland instead of X11
./scripts/run-cli.sh bash -c "wine reg.exe add HKCU\\Software\\Wine\\Drivers /v Graphics /d wayland,x11"
```

## Troubleshooting

### Common Issues

1. **VNC connection refused**: Ensure port 5901 is not blocked by firewall
2. **Application won't start**: Try different emulator DLLs
3. **Graphics issues**: Install DXVK or try different Wine drivers
4. **Performance issues**: Check if you're using the optimal emulator for your application

### Debug Mode

```bash
# Enable Wine debug output
docker compose run --rm -e WINEDEBUG=+all hangover-cli wine app.exe
```

### Logs

```bash
# View container logs
docker compose logs hangover
```

## Pre-built Binary Installation

The Docker image uses the pre-built hangover binary from GitHub releases:

- Downloads hangover 10.14 for Debian 12 Bookworm ARM64
- Includes Wine with ARM64EC, AArch64, and i386 support
- Pre-compiled FEX emulator for x86_64 applications
- Pre-compiled Box64 emulator for i386 applications

Build process takes approximately 2-3 minutes on a modern ARM64 system.

## Contributing

This Docker setup is based on the official [Hangover project](https://github.com/AndreRH/hangover). For issues related to:

- Wine emulation: Report to the Hangover project
- Docker setup: Report to this repository
- FEX emulator: Report to the [FEX project](https://github.com/FEX-Emu/FEX)
- Box64 emulator: Report to the [Box64 project](https://github.com/ptitSeb/box64)

## License

This Docker setup follows the same license as the Hangover project. See the [Hangover LICENSE](https://github.com/AndreRH/hangover/blob/master/LICENSE) for details.