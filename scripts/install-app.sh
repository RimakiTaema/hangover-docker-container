#!/bin/bash
# Helper script to install Windows applications

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_windows_app>"
    echo "Example: $0 /path/to/MyApp.exe"
    exit 1
fi

APP_PATH="$1"
APP_NAME=$(basename "$APP_PATH")

echo "Installing Windows application: $APP_NAME"
echo "Copying to apps directory..."

# Create apps directory if it doesn't exist
mkdir -p ./apps

# Copy the application
cp "$APP_PATH" ./apps/

echo "Application copied to ./apps/$APP_NAME"
echo ""
echo "To run the application:"
echo "  CLI mode: ./scripts/run-cli.sh wine ./apps/$APP_NAME"
echo "  GUI mode: ./scripts/run-gui.sh (then run wine ./apps/$APP_NAME in the VNC session)"