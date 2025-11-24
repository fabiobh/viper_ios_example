#!/bin/bash

# Script to setup Configuration.plist for TMDB API Key

CONFIG_FILE="ios_viper_example/Configuration.plist"
EXAMPLE_FILE="ios_viper_example/Configuration.plist.example"

echo "🎬 Movie Catalog - VIPER Architecture Setup"
echo "==========================================="
echo ""

# Check if Configuration.plist already exists
if [ -f "$CONFIG_FILE" ]; then
    echo "⚠️  Configuration.plist already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled."
        exit 0
    fi
fi

# Copy example file
if [ ! -f "$EXAMPLE_FILE" ]; then
    echo "❌ Error: Configuration.plist.example not found!"
    exit 1
fi

cp "$EXAMPLE_FILE" "$CONFIG_FILE"
echo "✅ Created Configuration.plist"
echo ""

# Prompt for API key
echo "📝 Please enter your TMDB API Key:"
echo "   (Get it from: https://www.themoviedb.org/settings/api)"
echo ""
read -p "API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo "⚠️  No API key provided. You'll need to edit Configuration.plist manually."
else
    # Replace placeholder with actual API key
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/YOUR_TMDB_API_KEY/$API_KEY/g" "$CONFIG_FILE"
    else
        # Linux
        sed -i "s/YOUR_TMDB_API_KEY/$API_KEY/g" "$CONFIG_FILE"
    fi
    echo "✅ API Key configured successfully!"
fi

echo ""
echo "🚀 Setup complete! You can now run the project in Xcode."
echo ""
echo "⚠️  IMPORTANT: Configuration.plist is in .gitignore and will NOT be committed to Git."
echo ""
