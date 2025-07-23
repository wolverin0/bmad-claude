# 🚀 GitHub Repository Setup Instructions

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `bmad-claude`
3. Description: "Automatically enhance Claude Code prompts with BMAD Method personas"
4. Make it **Public**
5. **DO NOT** initialize with README (we already have one)
6. Click "Create repository"

## Step 2: Push Your Code

After creating the repository, run these commands in your terminal:

```bash
# Navigate to project directory
cd "/mnt/g/_OneDrive/OneDrive/Desktop/Py Apps/bmadmethod"

# Remove the old remote (if it exists)
git remote remove origin

# Add your new repository as remote
# Replace YOUR_USERNAME with your actual GitHub username
git remote add origin https://github.com/YOUR_USERNAME/bmad-claude.git

# Push the code
git push -u origin master

# Create and push tags
git tag -a v1.0.0 -m "Initial release: BMAD Method for Claude Code"
git push origin v1.0.0
```

## Step 3: Update Documentation

After pushing, update the following files with your GitHub username:

1. **README.md**:
   - Replace all instances of `yourusername` with your GitHub username
   - Update the installation URLs

2. **install.sh**:
   - Update `REPO_URL` variable with your repository URL

## Step 4: Enable GitHub Pages (Optional)

1. Go to Settings → Pages
2. Source: Deploy from branch
3. Branch: master, folder: / (root)
4. Save

## Step 5: Create Release

1. Go to your repository → Releases
2. Click "Create a new release"
3. Choose tag: v1.0.0
4. Release title: "BMAD Claude v1.0.0"
5. Description:
   ```
   ## 🎉 Initial Release
   
   Automated BMAD Method integration for Claude Code with:
   - 10 specialized AI personas
   - Automatic prompt enhancement
   - Zero external dependencies
   - One-line installation
   - Comprehensive test suite
   
   ### Installation
   ```bash
   curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/bmad-claude/main/install.sh | bash
   ```
   ```
6. Click "Publish release"

## Step 6: Add Topics

Add these topics to your repository for better discoverability:
- claude-ai
- claude-code
- ai-tools
- developer-tools
- productivity
- prompt-engineering
- bmad-method

## Step 7: Share!

Your repository is now live at:
```
https://github.com/YOUR_USERNAME/bmad-claude
```

Share it on:
- Twitter/X
- Reddit (r/ClaudeAI, r/programming)
- Dev.to
- Hacker News
- Claude Discord/Communities