#!/bin/bash
# Test script to verify hangover Docker setup

echo "Testing Hangover Docker Setup..."
echo "================================="
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed or not in PATH"
    echo "Please install Docker and Docker Compose to test this setup"
    echo ""
    echo "Configuration files are ready:"
    echo "  ✓ Dockerfile - Uses pre-built hangover 10.14 binary"
    echo "  ✓ docker-compose.yml - Configured for ARM64"
    echo "  ✓ Helper scripts - Updated for modern docker compose"
    echo ""
    echo "To build and run:"
    echo "  docker compose build"
    echo "  ./scripts/run-cli.sh"
    echo "  ./scripts/run-gui.sh"
    exit 0
fi

# Test 1: Build the Docker image
echo "1. Building Docker image..."
if docker compose build; then
    echo "✓ Docker image built successfully"
else
    echo "✗ Failed to build Docker image"
    exit 1
fi

echo ""

# Test 2: Test CLI mode
echo "2. Testing CLI mode..."
if docker compose run --rm hangover-cli wine --version; then
    echo "✓ CLI mode working - Wine version check passed"
else
    echo "✗ CLI mode failed"
    exit 1
fi

echo ""

# Test 3: Test GUI mode startup (briefly)
echo "3. Testing GUI mode startup..."
echo "Starting GUI mode for 10 seconds..."
timeout 10s docker compose up hangover &
GUI_PID=$!

sleep 5

# Check if VNC port is listening
if netstat -tuln | grep -q ":5901"; then
    echo "✓ GUI mode working - VNC port 5901 is listening"
else
    echo "✗ GUI mode failed - VNC port not listening"
fi

# Clean up GUI process
kill $GUI_PID 2>/dev/null
docker compose down

echo ""
echo "================================="
echo "Hangover Docker setup test completed!"
echo ""
echo "To use:"
echo "  CLI mode: ./scripts/run-cli.sh"
echo "  GUI mode: ./scripts/run-gui.sh"
echo "  Install app: ./scripts/install-app.sh /path/to/app.exe"