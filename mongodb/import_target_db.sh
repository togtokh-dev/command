#!/bin/bash

# Connection details
MONGO_URI=""
USERNAME=""
PASSWORD=""
AUTH_DB=""

# Directory containing exported files and custom database name
EXPORTS_DIR="./exports/**"
NAME="**"

# Process the specified directory as a single database
if [ -d "$EXPORTS_DIR" ]; then
  echo "Processing database: $NAME"
  
  # Iterate over each collection file in the specified directory
  for collection_file in "$EXPORTS_DIR"/*.json; do
    if [ -f "$collection_file" ]; then
      # Extract collection name from file name
      collection=$(basename "$collection_file" .json)
      echo "Importing collection: $collection"
      
      # Import the JSON file into MongoDB under the specified database name
      mongoimport --uri="$MONGO_URI/$NAME" --collection="$collection" --file="$collection_file" --jsonArray --drop
    fi
  done
else
  echo "Directory $EXPORTS_DIR does not exist."
fi
