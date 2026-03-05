#!/bin/bash

# SkyCards User Data Export Script
# Prompts for email/password, calls the API, and outputs a filtered JSON file
# Upload your JSON file at https://skystats.win/ for a nice pretty dashboard

# Prompt for credentials
read -p "Email: " EMAIL
read -s -p "Password: " PASSWORD
echo ""

if [[ -z "$EMAIL" || -z "$PASSWORD" ]]; then
  echo "Error: Email and password are required." >&2
  exit 1
fi

echo "Logging in..."

RESPONSE=$(curl -s -X POST "https://api.skycards.oldapes.com/users/" \
  -H "accept: application/json" \
  -H "Accept-Encoding: gzip" \
  -H "Connection: Keep-Alive" \
  -H "Content-Type: application/json" \
  -H "Host: api.skycards.oldapes.com" \
  -H "User-Agent: okhttp/4.12.0" \
  -H "x-client-version: 2.0.27" \
  --compressed \
  -d "{\"email\": \"$EMAIL\", \"password\": \"$PASSWORD\"}")

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to connect to the API." >&2
  exit 1
fi

if echo "$RESPONSE" | jq -e '.error // .message' > /dev/null 2>&1; then
  ERR=$(echo "$RESPONSE" | jq -r '.error // .message')
  echo "API Error: $ERR" >&2
  exit 1
fi

# Extract fields from userData and write to output file
OUTPUT_FILE="skycards_user.json"
echo "$RESPONSE" | jq '{
  id:                .userData.id,
  name:              .userData.name,
  xp:                .userData.xp,
  cards:             .userData.cards,
  numAircraftModels: .userData.numAircraftModels,
  numDestinations:   .userData.numDestinations,
  numBattleWins:     .userData.numBattleWins,
  numAchievements:   .userData.numAchievements,
  unlockedAirportIds:.userData.unlockedAirportIds,
  uniqueRegs:        .userData.uniqueRegs
}' > "$OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
  echo "Success! User data saved to: $OUTPUT_FILE"
  echo "Upload your JSON file at https://skystats.win/ for a nice pretty dashboard."
else
  echo "Error: Failed to parse API response." >&2
  echo "Raw response:" >&2
  echo "$RESPONSE" >&2
  exit 1
fi
