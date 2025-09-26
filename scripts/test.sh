#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

pass() { echo "[PASS] $1"; }
fail() { echo "[FAIL] $1"; exit 1; }

# Test 1: Dockerfile wine-gui.sh uses VNC_PORT, binds 0.0.0.0, and is nopw
test_dockerfile_gui_flags() {
  local dockerfile="$ROOT_DIR/Dockerfile"
  [[ -f "$dockerfile" ]] || fail "Dockerfile not found"

  grep -q 'x11vnc .* -rfbport \"\$VNC_PORT\"' "$dockerfile" || fail "x11vnc does not use VNC_PORT"
  grep -q 'x11vnc .* -listen 0.0.0.0' "$dockerfile" || fail "x11vnc not bound to 0.0.0.0"
  grep -q 'x11vnc .* -nopw' "$dockerfile" || fail "x11vnc not configured with -nopw"
  pass "Dockerfile GUI script flags are correct"
}

# Test 2: Dockerfile polls for X socket instead of fixed sleep
test_dockerfile_x_socket_poll() {
  local dockerfile="$ROOT_DIR/Dockerfile"
  grep -q '/tmp/.X11-unix/X1' "$dockerfile" || fail "wine-gui.sh does not poll for X socket"
  pass "Dockerfile GUI script polls for X readiness"
}

# Test 3: docker-compose exposes 5901 and GUI service uses wine-gui.sh
test_compose_gui_service() {
  local compose="$ROOT_DIR/docker-compose.yml"
  [[ -f "$compose" ]] || fail "docker-compose.yml not found"

  grep -q 'hangover:' "$compose" || fail "compose missing hangover service"
  grep -q '"5901:5901"' "$compose" || fail "VNC port 5901 not exposed"
  grep -q '/opt/scripts/wine-gui.sh' "$compose" || fail "hangover service not using wine-gui.sh"
  pass "docker-compose GUI service configuration is correct"
}

main() {
  test_dockerfile_gui_flags
  test_dockerfile_x_socket_poll
  test_compose_gui_service
  echo "All tests passed."
}

main "$@"

