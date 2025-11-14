#!/bin/bash

# SafeDriver SMS Gateway Quick Setup Script

echo "🚀 SafeDriver SMS Gateway Setup"
echo "=============================="

# Create .env file from example if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📁 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "🔧 Please edit .env file and add your Text.lk API credentials:"
    echo "   TEXTLK_API_TOKEN=your_actual_api_token"
    echo "   TEXTLK_SENDER_ID=your_approved_sender_id"
    echo ""
    echo "📝 You can edit the file with:"
    echo "   nano .env"
    echo "   # or"
    echo "   code .env"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. 📝 Configure your .env file with Text.lk credentials"
echo "2. 🔐 Login to Firebase: firebase login"
echo "3. 🎯 Select your project: firebase use your-project-id"
echo "4. 🚀 Deploy functions: ./deploy.sh"
echo ""
echo "For testing locally:"
echo "   firebase emulators:start"
echo ""
echo "Happy coding! 🚀"