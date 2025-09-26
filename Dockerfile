# Multi-stage Dockerfile for Hangover - Windows application emulation on ARM64
# Supports both CLI and GUI modes with Wine, Box64, and FEX
# Uses pre-built hangover binary from GitHub releases

FROM --platform=linux/arm64 debian:bookworm-slim as base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/wine/.wine
ENV DISPLAY=:1
ENV VNC_PORT=5901

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic tools
    wget \
    curl \
    git \
    unzip \
    ca-certificates \
    gnupg \
    software-properties-common \
    tar \
    # Wine dependencies
    wine \
    wine32 \
    wine64 \
    libwine \
    libwine-dev \
    # X11 and VNC for GUI support
    xvfb \
    x11vnc \
    fluxbox \
    xterm \
    # Additional libraries
    libc6-dev \
    libgcc-s1 \
    libstdc++6 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libxi6 \
    libxinerama1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxpm4 \
    libxmu6 \
    libxft2 \
    libxau6 \
    libxdmcp6 \
    libxss1 \
    libxt6 \
    libxaw7 \
    libxmu6 \
    libxpm4 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libxxf86vm1 \
    # Fonts
    fonts-dejavu-core \
    fonts-liberation \
    # Network tools
    net-tools \
    iputils-ping \
    # Process management
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Create wine user
RUN useradd -m -s /bin/bash wine && \
    echo "wine:wine" | chpasswd && \
    usermod -aG audio wine

# Install Box64
RUN wget https://github.com/ptitSeb/box64/releases/download/v0.2.6/box64_0.2.6_arm64.deb && \
    dpkg -i box64_0.2.6_arm64.deb || apt-get install -f -y && \
    rm box64_0.2.6_arm64.deb

# Install FEX (for x86_64 emulation)
RUN wget https://github.com/FEX-Emu/FEX/releases/download/FEX-2409/FEX-2409-Ubuntu-22.04-aarch64.tar.xz && \
    tar -xf FEX-2409-Ubuntu-22.04-aarch64.tar.xz && \
    cp -r FEX-2409-Ubuntu-22.04-aarch64/* /usr/local/ && \
    rm -rf FEX-2409-Ubuntu-22.04-aarch64*

# Download and install pre-built hangover binary
WORKDIR /opt
RUN wget https://github.com/AndreRH/hangover/releases/download/hangover-10.14/hangover_10.14_debian12_bookworm_arm64.tar && \
    tar -xvf hangover_10.14_debian12_bookworm_arm64.tar && \
    rm hangover_10.14_debian12_bookworm_arm64.tar

# Install hangover wine and emulator DLLs
RUN cd hangover_10.14_debian12_bookworm_arm64 && \
    # Install wine
    cp -r wine/* /usr/local/ && \
    # Install FEX emulator DLLs
    cp fex/*.dll /usr/local/lib/wine/aarch64-windows/ && \
    # Install Box64 emulator DLLs  
    cp box64/*.dll /usr/local/lib/wine/aarch64-windows/ && \
    # Clean up
    cd .. && rm -rf hangover_10.14_debian12_bookworm_arm64

# Create helper scripts directory
RUN mkdir -p /opt/scripts

# Create CLI helper script
RUN cat > /opt/scripts/wine-cli.sh << 'EOF'
#!/bin/bash
# CLI mode helper script for hangover

export WINEDEBUG=-all
export WINEPREFIX=/home/wine/.wine

# Initialize wine prefix if it doesn't exist
if [ ! -d "$WINEPREFIX" ]; then
    echo "Initializing wine prefix..."
    winecfg
fi

# Set emulator DLLs (using pre-built hangover DLLs)
export HODLL64=libarm64ecfex.dll  # For x86_64 emulation (FEX)
export HODLL=wowbox64.dll         # For i386 emulation (Box64)

echo "Hangover CLI mode ready!"
echo "Using pre-built hangover 10.14 with FEX and Box64 emulators"
echo "Available emulators:"
echo "  x86_64: FEX (libarm64ecfex.dll)"
echo "  i386: Box64 (wowbox64.dll)"
echo ""
echo "Usage examples:"
echo "  wine your_app.exe"
echo "  HODLL=libwow64fex.dll wine your_32bit_app.exe  # Use FEX for 32-bit"
echo ""

exec "$@"
EOF

# Create GUI helper script
RUN cat > /opt/scripts/wine-gui.sh << 'EOF'
#!/bin/bash
# GUI mode helper script for hangover

export WINEDEBUG=-all
export WINEPREFIX=/home/wine/.wine
export DISPLAY=:1

# Initialize wine prefix if it doesn't exist
if [ ! -d "$WINEPREFIX" ]; then
    echo "Initializing wine prefix..."
    winecfg
fi

# Set emulator DLLs (using pre-built hangover DLLs)
export HODLL64=libarm64ecfex.dll  # For x86_64 emulation (FEX)
export HODLL=wowbox64.dll         # For i386 emulation (Box64)

# Start Xvfb
echo "Starting X server..."
Xvfb :1 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!

# Wait for X server to start
sleep 2

# Start window manager
echo "Starting window manager..."
fluxbox &
WM_PID=$!

# Start VNC server
echo "Starting VNC server on port $VNC_PORT..."
x11vnc -display :1 -nopw -listen localhost -xkb -rfbport $VNC_PORT -forever &
VNC_PID=$!

# Wait for VNC to start
sleep 2

echo "Hangover GUI mode ready!"
echo "Using pre-built hangover 10.14 with FEX and Box64 emulators"
echo "VNC server running on port $VNC_PORT"
echo "Connect with: vncviewer localhost:$VNC_PORT"
echo ""
echo "Available emulators:"
echo "  x86_64: FEX (libarm64ecfex.dll)"
echo "  i386: Box64 (wowbox64.dll)"
echo ""

# Function to cleanup on exit
cleanup() {
    echo "Shutting down..."
    kill $VNC_PID $WM_PID $XVFB_PID 2>/dev/null
    exit 0
}
trap cleanup SIGTERM SIGINT

# Keep container running
if [ $# -eq 0 ]; then
    echo "Container running in GUI mode. Press Ctrl+C to stop."
    wait
else
    exec "$@"
fi
EOF

# Create supervisor configuration
RUN cat > /etc/supervisor/conf.d/hangover.conf << 'EOF'
[supervisord]
nodaemon=true
user=root

[program:xvfb]
command=Xvfb :1 -screen 0 1024x768x24 -ac +extension GLX +render -noreset
autorestart=true
user=wine

[program:fluxbox]
command=fluxbox
autorestart=true
user=wine
environment=DISPLAY=":1"

[program:x11vnc]
command=x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -rfbport 5901 -forever
autorestart=true
user=wine
environment=DISPLAY=":1"
EOF

# Make scripts executable
RUN chmod +x /opt/scripts/*.sh

# Create wine directory and set permissions
RUN mkdir -p /home/wine/.wine && \
    chown -R wine:wine /home/wine

# Switch to wine user
USER wine
WORKDIR /home/wine

# Expose VNC port
EXPOSE 5901

# Set default command
CMD ["/opt/scripts/wine-gui.sh"]