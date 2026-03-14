#!/bin/bash

# SafeDriver Cloud Functions Deployment Script
set -e

echo "🚀 SafeDriver Cloud Functions Deployment"
echo "=========================================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    exit 1
fi

# Load environment variables (export to subshells)
export $(cat .env | grep -v '^#' | xargs)

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Error: Firebase CLI not installed!"
    exit 1
fi

# Validate required variables
if [ -z "$TEXTLK_API_TOKEN" ]; then
    echo "❌ Error: TEXTLK_API_TOKEN not set!"
    exit 1
fi

echo "✅ Configuration validated"

# Deploy functions with Text.lk config ONLY
echo "🚀 Setting Firebase configuration..."
firebase functions:config:set \
  textlk.apitoken="${TEXTLK_API_TOKEN}" \
  textlk.apiurl="${TEXTLK_API_URL:-https://app.text.lk/api/v3/sms/send}" \
  textlk.senderid="${TEXTLK_SENDER_ID:-SafeDriver}"

echo "🔄 Deploying functions..."
firebase deploy --only functions

echo "✅ Deployment successful!"