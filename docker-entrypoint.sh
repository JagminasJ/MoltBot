#!/bin/sh
set -e

echo "🚀 MoltBot NorthFlank Deployment - Starting..."

# Ensure we're in the app directory
cd /app

# Verify MoltBot installation
if ! command -v moltbot >/dev/null 2>&1; then
    echo "⚠️  MoltBot not found in PATH, attempting to install..."
    curl -fsSL https://install.molt.bot | sh || {
        echo "❌ Failed to install MoltBot"
        exit 1
    }
fi

# Verify installation
MOLTBOT_PATH=$(which moltbot || echo "")
if [ -z "$MOLTBOT_PATH" ]; then
    echo "❌ MoltBot installation not found"
    echo "💡 Checking common installation locations..."
    find /usr -name "moltbot" 2>/dev/null | head -5 || true
    find /opt -name "moltbot" 2>/dev/null | head -5 || true
    find /root -name "moltbot" 2>/dev/null | head -5 || true
    exit 1
fi

echo "✅ MoltBot found at: $MOLTBOT_PATH"

# Set up port from environment variable (NorthFlank compatibility)
GATEWAY_PORT=${PORT:-${GATEWAY_PORT:-3000}}
export PORT=$GATEWAY_PORT
export GATEWAY_PORT=$GATEWAY_PORT

echo "🌐 Gateway port: $GATEWAY_PORT"

# Run setup if needed (non-interactive mode)
# Check if MoltBot is already configured
if [ ! -f "$HOME/.moltbot/config.json" ] && [ ! -f "/root/.moltbot/config.json" ]; then
    echo "🔧 Running MoltBot setup..."
    moltbot setup --non-interactive || {
        echo "⚠️  Setup may have failed or already completed"
    }
fi

# Run onboard if needed (non-interactive mode)
echo "📋 Running MoltBot onboard..."
moltbot onboard --non-interactive || {
    echo "⚠️  Onboard may have failed or already completed"
}

# Switch to appuser for running the Gateway
# Preserve all environment variables
echo "👤 Switching to appuser and starting Gateway..."

# Execute the command (gateway) as appuser with preserved environment
# Set PORT environment variable for MoltBot Gateway
exec su -m appuser -c "cd /app && PORT=$GATEWAY_PORT GATEWAY_PORT=$GATEWAY_PORT moltbot gateway"
