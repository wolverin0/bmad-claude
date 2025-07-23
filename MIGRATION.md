# Migration Guide

## For Users Updating from v1.0.0

### Security Update - Environment Variables

We've improved security by moving API keys to environment variables. If you were using the Gemini API features:

1. **Create your .env file**:
   ```bash
   cp .env.example .env
   ```

2. **Add your API key**:
   ```bash
   # Edit .env and add your key
   GEMINI_API_KEY=your-actual-api-key-here
   ```

3. **Ensure .env is not tracked**:
   ```bash
   git status  # Should not show .env
   ```

### No Action Required If:
- You're using the simple hook (default) - it doesn't need API keys
- You haven't configured Gemini integration

### What Changed:
- API keys are no longer hardcoded anywhere
- `.env.example` provides a template
- Installer now helps configure environment
- Better security documentation

This change ensures your API keys are never accidentally committed to version control.