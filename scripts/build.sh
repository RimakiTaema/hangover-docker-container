#!/bin/bash
# Build script for hangover Docker image

echo "Building Hangover Docker image..."
echo "This may take 10-15 minutes on ARM64 systems..."

# Build the image
docker-compose build

echo ""
echo "Build complete!"
echo ""
echo "Usage:"
echo "  GUI mode: ./scripts/run-gui.sh"
echo "  CLI mode: ./scripts/run-cli.sh"
echo "  Install app: ./scripts/install-app.sh /path/to/app.exe"