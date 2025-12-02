#!/bin/bash

# Version Increment Script
# Automatically increments the build number in pubspec.yaml

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PUBSPEC_FILE="pubspec.yaml"

echo "======================================="
echo "  Version Increment Script"
echo "======================================="

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "Error: $PUBSPEC_FILE not found!"
    exit 1
fi

# Read current version from pubspec.yaml
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | awk '{print $2}')

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Could not find version in $PUBSPEC_FILE"
    exit 1
fi

echo -e "${YELLOW}Current version:${NC} $CURRENT_VERSION"

# Split version into name and build number
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# If there's no build number, start with 1
if [ "$BUILD_NUMBER" = "$VERSION_NAME" ]; then
    BUILD_NUMBER=0
fi

# Increment build number
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="${VERSION_NAME}+${NEW_BUILD_NUMBER}"

echo -e "${YELLOW}New version:${NC} $NEW_VERSION"

# Update pubspec.yaml (platform-specific sed)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "$PUBSPEC_FILE"
fi

echo -e "${GREEN}✅ Version updated successfully!${NC}"
echo ""
echo "Don't forget to commit this change:"
echo "  git add $PUBSPEC_FILE"
echo "  git commit -m \"chore: bump version to $NEW_VERSION\""
