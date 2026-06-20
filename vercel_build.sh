#!/usr/bin/env bash
set -e

# Get Flutter (Vercel build machines do not have it).
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Write the .env from Vercel environment variables before building.
cat > .env <<EOF
FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID
FIREBASE_MESSAGING_SENDER_ID=$FIREBASE_MESSAGING_SENDER_ID
FIREBASE_STORAGE_BUCKET=$FIREBASE_STORAGE_BUCKET
FIREBASE_WEB_API_KEY=$FIREBASE_WEB_API_KEY
FIREBASE_WEB_APP_ID=$FIREBASE_WEB_APP_ID
FIREBASE_AUTH_DOMAIN=$FIREBASE_AUTH_DOMAIN
EOF

flutter doctor
flutter config --enable-web
flutter build web --release
