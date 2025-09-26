# Hangover Docker - Quick Start Guide

## 🚀 Quick Start

### 1. Build the Image
```bash
./scripts/build.sh
```

### 2. Run in GUI Mode (VNC)
```bash
./scripts/run-gui.sh
```
Then connect with VNC viewer to `localhost:5901`

### 3. Run in CLI Mode
```bash
./scripts/run-cli.sh
```

## 📁 Project Structure

```
hangover-docker/
├── Dockerfile              # Multi-stage ARM64 Docker image
├── docker-compose.yml      # Docker Compose configuration
├── scripts/                # Helper scripts
│   ├── build.sh           # Build the Docker image
│   ├── run-gui.sh         # Start GUI mode (VNC)
│   ├── run-cli.sh         # Start CLI mode
│   ├── install-app.sh     # Install Windows apps
│   └── wine-config.sh     # Configure Wine
├── examples/               # Test applications
├── apps/                   # Your Windows applications (mounted)
├── README.md              # Full documentation
└── QUICKSTART.md          # This file
```

## 🎯 Key Features

- ✅ **ARM64 Support**: Runs on ARM64 servers and devices
- ✅ **Dual Mode**: CLI and GUI (VNC) modes
- ✅ **Multiple Emulators**: FEX (x86_64) + Box64 (i386) + Wine
- ✅ **VNC GUI**: Access GUI apps via VNC on port 5901
- ✅ **Helper Scripts**: Easy-to-use automation
- ✅ **Wine Integration**: Full Wine support with emulation

## 🔧 Common Commands

```bash
# Build everything
./scripts/build.sh

# GUI mode with VNC
./scripts/run-gui.sh

# CLI mode
./scripts/run-cli.sh

# Install a Windows app
./scripts/install-app.sh /path/to/app.exe

# Configure Wine
./scripts/wine-config.sh

# Run specific app in CLI
./scripts/run-cli.sh wine /path/to/app.exe
```

## 🌐 VNC Connection

- **Host**: localhost
- **Port**: 5901
- **Password**: hangover

## 📋 Requirements

- Docker and Docker Compose
- ARM64 Linux system
- VNC viewer (for GUI mode)

## 🐛 Troubleshooting

1. **Build fails**: Ensure you have enough disk space (5GB+)
2. **VNC won't connect**: Check firewall settings for port 5901
3. **App won't run**: Try different emulator DLLs
4. **Performance issues**: Use FEX for x86_64, Box64 for i386

## 📚 Full Documentation

See `README.md` for complete documentation including:
- Detailed usage examples
- Environment variables
- Advanced configuration
- Troubleshooting guide
- Performance optimization
