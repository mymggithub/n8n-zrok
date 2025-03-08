#!/bin/bash

# Path to the .env file
ENV_FILE=".env"

# Wait for the zrok container to start producing logs
echo "Waiting for zrok container to start..."
sleep 5  # Adjust sleep time if necessary

# Extract the URL from the zrok container logs
LINK=$(docker logs z8 2>&1 | grep -oP 'https://\S+\.share\.zrok\.io')

# Check if the link was successfully extracted
if [ -z "$LINK" ]; then
  echo "Error: Could not extract the link from zrok logs."
  exit 1
fi

echo "Extracted URL: $LINK"

# Update the .env file with the extracted URL
if grep -q '^WEBHOOK=' "$ENV_FILE"; then
  # If the variable exists, replace its value
  sed -i "s|^WEBHOOK=.*|WEBHOOK=$LINK|" "$ENV_FILE"
else
  # If the variable does not exist, append it
  echo "WEBHOOK=$LINK" >> "$ENV_FILE"
fi

echo "Updated .env file with WEBHOOK=$LINK"