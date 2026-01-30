# MoltBot Gateway - NorthFlank Deployment

MoltBot Gateway deployment configured for NorthFlank with Gemini AI integration.

## Features

- 🎛️ **Gateway Control UI** - Web-based interface for managing MoltBot
- 🧠 **Gemini AI** - Powered by Google's Gemini API
- 🐳 **Docker Ready** - Optimized for NorthFlank deployment
- 🔒 **Secure** - Non-root user execution where possible
- ⚙️ **Auto Setup** - Runs setup/onboard commands during startup

## Prerequisites

- NorthFlank account
- Google Gemini API Key
- GitHub repository (for deployment)

## Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd moltbot-telegram
   ```

2. **Build the Docker image**
   ```bash
   docker build -t moltbot-gateway .
   ```

3. **Run locally**
   ```bash
   docker run -p 3000:3000 \
     -e GEMINI_API_KEY=your_key_here \
     -e PORT=3000 \
     moltbot-gateway
   ```

4. **Access the Control UI**
   - Open http://localhost:3000 in your browser
   - The Gateway serves the MoltBot Control UI

## Environment Variables

### Required

- `GEMINI_API_KEY` - Your Google Gemini API key

### Optional

- `PORT` - Port for the Gateway (default: 3000)
- `GATEWAY_PORT` - Gateway port override (defaults to PORT)
- `NODE_ENV` - Environment (default: production)

## NorthFlank Deployment

### 1. Connect GitHub Repository

1. Go to your NorthFlank project
2. Navigate to **Services** → **Add Service** → **Git**
3. Connect your GitHub repository
4. Select the repository and branch (typically `main`)

### 2. Configure Build Settings

- **Build Context**: `.` (root directory)
- **Dockerfile Path**: `Dockerfile`
- **Build Command**: (auto-detected from Dockerfile)

### 3. Set Environment Variables

In NorthFlank dashboard, go to **Environment Variables** and add:

```
GEMINI_API_KEY=your_gemini_api_key
PORT=3000
NODE_ENV=production
```

**Important**: These are **runtime** environment variables, not build arguments.

### 4. Configure Networking

1. Go to **Networking** tab
2. The service should auto-detect port 3000
3. Enable **Public Port** to access the Control UI
4. The Control UI will be available at your NorthFlank public URL

### 5. Recommended Resource Settings

- **CPU**: 0.25-0.5 vCPU
- **Memory**: 512MB-1GB RAM
- **Port**: 3000 (auto-detected)

### 6. Deploy

Click **Deploy** and wait for the build to complete. The deployment will:

1. Install MoltBot using the official installer
2. Run `moltbot setup` (if not already configured)
3. Run `moltbot onboard` (if needed)
4. Start the Gateway on the configured port

Once running:
- Access the Control UI at: `https://your-service-name.northflank.app`
- The Gateway serves the MoltBot Control UI for managing your bot

## Gateway Control UI

The MoltBot Gateway provides a web-based Control UI for:

- Managing bot connections
- Configuring AI models (Gemini)
- Adding channels (Telegram, Discord, etc.)
- Monitoring bot activity
- Viewing logs and metrics

The Control UI is automatically served at the root path (`/`) on the configured port.

**Documentation**: https://docs.molt.bot/web

## Setup Process

The entrypoint script automatically:

1. **Installs MoltBot** - Uses official installer if not found
2. **Runs Setup** - Executes `moltbot setup` in non-interactive mode
3. **Runs Onboard** - Executes `moltbot onboard` in non-interactive mode
4. **Starts Gateway** - Launches `moltbot gateway` with proper port configuration

## Troubleshooting

### Gateway not starting

- Check logs for MoltBot installation errors
- Verify environment variables are set correctly
- Ensure `GEMINI_API_KEY` is valid
- Check that port 3000 is not conflicting

### Control UI not accessible

- Ensure public port is enabled in NorthFlank
- Verify PORT environment variable matches NorthFlank configuration
- Check that the Gateway is running (check logs)

### Setup/Onboard failures

- These commands may fail if already configured - this is normal
- Check logs for specific error messages
- You can configure manually via the Control UI if needed

## Support

- [MoltBot Documentation](https://docs.molt.bot)
- [MoltBot Gateway Documentation](https://docs.molt.bot/web)
- [NorthFlank Documentation](https://docs.northflank.com)

## License

MIT
