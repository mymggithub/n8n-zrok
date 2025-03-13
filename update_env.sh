#!/bin/bash

# Path to the .env file
ENV_FILE=".env"

# Wait for the zrok container to start producing logs
echo "Waiting for zrok container to produce a valid link..."

# Initialize variables
LINK=""
MAX_ATTEMPTS=60  # Maximum number of attempts (adjust as needed)
ATTEMPT=0

# Loop until a valid link is extracted or max attempts are reached
while [ -z "$LINK" ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  # Extract the URL from the zrok container logs
  LINK=$(docker logs zrok-zrok-1 2>&1 | grep -oP 'https://\S+\.share\.zrok\.io')

  # Check if the link was successfully extracted
  if [ -z "$LINK" ]; then
    echo "Link not found yet. Retrying in 3 seconds... (Attempt $((ATTEMPT + 1))/$MAX_ATTEMPTS)"
    sleep 3
    ATTEMPT=$((ATTEMPT + 1))
  else
    echo "Extracted URL: $LINK"
  fi
done

# Exit if no link was found after max attempts
if [ -z "$LINK" ]; then
  echo "Error: Could not extract the link from zrok logs after $MAX_ATTEMPTS attempts."
  exit 1
fi

# Update the .env file with the extracted URL
if grep -q '^WEBHOOK=' "$ENV_FILE"; then
  # If the variable exists, replace its value
  sed -i "s|^WEBHOOK=.*|WEBHOOK=$LINK|" "$ENV_FILE"
else
  # If the variable does not exist, append it
  echo "WEBHOOK=$LINK" >> "$ENV_FILE"
fi

echo "Updated .env file with WEBHOOK=$LINK"
