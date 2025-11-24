# 🚀 Quick Start - API Key Setup

## TL;DR

```bash
# 1. Run setup script
./setup.sh

# 2. Enter your TMDB API key when prompted
# Get it from: https://www.themoviedb.org/settings/api

# 3. Open and run in Xcode
open ios_viper_example.xcodeproj
```

## Manual Setup

```bash
# Copy template
cp ios_viper_example/Configuration.plist.example ios_viper_example/Configuration.plist

# Edit Configuration.plist and replace YOUR_TMDB_API_KEY with your actual key
```

## Get TMDB API Key

1. Go to: https://www.themoviedb.org/
2. Create free account
3. Go to: Settings → API
4. Request API Key (choose "Developer")
5. Copy your **API Key (v3 auth)**

## Verify Setup

```bash
# Check if Configuration.plist is ignored by Git
git check-ignore ios_viper_example/Configuration.plist
# Should output: ios_viper_example/Configuration.plist

# Check git status
git status
# Configuration.plist should NOT appear in the list
```

## Troubleshooting

### "TMDB API Key not configured!" error
- Make sure Configuration.plist exists
- Make sure you replaced YOUR_TMDB_API_KEY with your actual key
- Make sure the file is in the correct location: `ios_viper_example/Configuration.plist`

### Configuration.plist not found
- Run: `./setup.sh`
- Or manually copy: `cp ios_viper_example/Configuration.plist.example ios_viper_example/Configuration.plist`

### Invalid API Key
- Verify you copied the correct key from TMDB
- Make sure you're using API Key v3 (not v4)
- Check for extra spaces or characters

## Important Notes

⚠️ **NEVER commit Configuration.plist to Git!**

✅ It's already in .gitignore - you're safe

📚 For more details, see:
- **SECURITY.md** - Complete security guide
- **SETUP_INSTRUCTIONS.md** - Detailed setup instructions
- **README.md** - Full project documentation

---

**Need help?** Check SECURITY.md for comprehensive documentation.
