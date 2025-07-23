# Security Policy

## 🔐 API Key Security

### Best Practices

1. **Never commit API keys to version control**
   - Always use environment variables
   - Keep `.env` files local only
   - Use `.env.example` as a template

2. **Rotate keys regularly**
   - If a key is exposed, revoke it immediately
   - Generate new keys periodically
   - Use separate keys for development/production

3. **Minimal permissions**
   - Only request necessary API scopes
   - Use read-only keys when possible

### Environment Setup

```bash
# Copy example file
cp .env.example .env

# Edit with your editor
nano .env

# Ensure proper permissions
chmod 600 .env
```

### If You Accidentally Commit a Key

1. **Immediately revoke the key** in the provider's console
2. **Remove from history**:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch .env" \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (coordinate with team):
   ```bash
   git push --force --all
   git push --force --tags
   ```
4. **Generate new keys**

## 🛡️ Security Features

- No API keys required for basic functionality
- All keys stored in environment variables
- `.gitignore` configured to exclude sensitive files
- No external API calls in the simple hook version

## 🐛 Reporting Security Issues

Please report security vulnerabilities to:
- Create a private security advisory on GitHub
- Do NOT create public issues for security problems

## 📋 Checklist

- [ ] API keys in `.env` only
- [ ] `.env` added to `.gitignore`
- [ ] No hardcoded secrets
- [ ] Keys have minimal permissions
- [ ] Regular key rotation scheduled