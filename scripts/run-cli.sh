#!/bin/bash
# Helper script to run hangover in CLI mode

echo "Starting Hangover CLI mode..."
docker compose run --rm hangover-cli "$@"