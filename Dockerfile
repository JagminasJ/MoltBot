# Multi-stage build for MoltBot Gateway on NorthFlank
FROM node:24-slim

WORKDIR /app

# Install curl and dependencies needed for MoltBot installer
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Try to install MoltBot during build (may fail due to DNS, will retry at runtime)
# This is optional - entrypoint will handle installation if this fails
RUN curl -fsSL https://install.molt.bot 2>/dev/null | sh || \
    echo "MoltBot installer will be attempted at runtime if needed"

# Copy entrypoint script
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

# Create non-root user for security
# Note: Entrypoint will run as root initially to handle setup, then switch to appuser
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app

# Ensure moltbot is accessible in PATH
ENV PATH="/root/.local/bin:/usr/local/bin:/usr/bin:${PATH}"

# Expose port for MoltBot Gateway
# The Gateway serves the Control UI on this port
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD node -e "process.exit(0)" || exit 1

# Use entrypoint to handle setup/onboard and start Gateway
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["gateway"]
