#!/bin/bash

# SafeDriver Cloud Functions Deployment Script
# This script deploys Firebase Cloud Functions with environment variables

set -e  # Exit on any error

echo "🚀 SafeDriver Cloud Functions Deployment"
echo "=========================================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file from .env.example and configure your Text.lk API credentials."
    echo "Copy .env.example to .env and update the values:"
    echo "cp .env.example .env"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Error: Firebase CLI not installed!"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if user is logged in to Firebase
if ! firebase projects:list &> /dev/null; then
    echo "❌ Error: Not logged in to Firebase!"
    echo "Login with: firebase login"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install dependencies!"
    exit 1
fi

# Load environment variables for validation
source .env

# Validate required environment variables
echo "🔍 Validating configuration..."

if [ -z "$TEXTLK_API_TOKEN" ]; then
    echo "❌ Error: TEXTLK_API_TOKEN is not set in .env file!"
    exit 1
fi

if [ -z "$TEXTLK_SENDER_ID" ]; then
    echo "❌ Error: TEXTLK_SENDER_ID is not set in .env file!"
    exit 1
fi

echo "✅ Configuration validated"
echo "📡 API Token: ${TEXTLK_API_TOKEN:0:10}..."
echo "📤 Sender ID: $TEXTLK_SENDER_ID"
echo "🌐 API URL: $TEXTLK_API_URL"

# Ask for confirmation
read -p "🤔 Do you want to deploy to Firebase? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Deploy functions
echo "🚀 Deploying Cloud Functions..."
firebase deploy --only functions

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🔗 Your functions are available at:"
    echo "   - sendOTP: https://asia-south1-$(firebase use).cloudfunctions.net/sendOTP"
    echo "   - verifyOTP: https://asia-south1-$(firebase use).cloudfunctions.net/verifyOTP"
    echo "   - healthCheck: https://asia-south1-$(firebase use).cloudfunctions.net/healthCheck"
    echo ""
    echo "📊 Monitor your functions:"
    echo "   firebase functions:log --follow"
    echo ""
    echo "🎉 Ready to test SMS gateway integration!"
else
    echo "❌ Deployment failed!"
    echo "Check the error messages above and try again."
    exit 1
fi