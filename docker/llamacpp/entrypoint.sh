#!/bin/bash
set -e

# Display GPU information
echo "=== ROCm GPU Information ==="
/opt/rocm/bin/rocminfo | grep -E "Name|Marketing Name" || echo "rocminfo failed"
echo ""

# Print llama server version
/usr/local/bin/llama-server --version

# Start llama.cpp server
exec /usr/local/bin/llama-server "$@"
