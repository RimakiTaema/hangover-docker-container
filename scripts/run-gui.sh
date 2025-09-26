#!/bin/bash
# Helper script to run hangover in GUI mode

echo "Starting Hangover GUI mode..."
echo "VNC will be available on port 5901"
echo "Connect with: vncviewer localhost:5901"
echo ""

docker compose up hangover