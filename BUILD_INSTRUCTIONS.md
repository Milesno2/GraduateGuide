# Build Instructions for Graduate Assistant Hub

## Netlify Deployment

This project is configured to deploy on Netlify with the following setup:

### Environment Variables Required

Set these in your Netlify dashboard under Site Settings → Environment Variables:

```
SUPABASE_URL = https://zqcykjxwsnlxmtzcmiga.supabase.co
SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpxY3lranh3c25seG10emNtaWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDI4MDgsImV4cCI6MjA3MjQxODgwOH0.dkH258TCMv4q7XXLknfnLNCJu1LVqEGdzabsh-0Oj7s
APP_NAME = Graduate Assistant Hub
APP_VERSION = 1.0.0
```

### Build Process

The build process:
1. Installs Flutter 3.35.2
2. Sets up environment variables
3. Configures Flutter for web
4. Installs dependencies
5. Builds the web app

### Files

- `netlify.toml` - Netlify configuration
- `build.sh` - Build script (alternative)
- `setup_env.sh` - Environment setup script
- `pubspec.yaml` - Flutter dependencies

### Troubleshooting

If the build fails:
1. Check that all environment variables are set
2. Verify Flutter version compatibility
3. Ensure all dependencies are compatible
4. Check the build logs for specific errors