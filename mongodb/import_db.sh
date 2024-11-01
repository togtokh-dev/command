#!/bin/bash

# Connection details
MONGO_URI=""
USERNAME=""
PASSWORD=""
AUTH_DB=""

# Directory containing exported files
EXPORTS_DIR="./exports"

# Iterate over each database directory
for database_dir in "$EXPORTS_DIR"/*; do
  if [ -d "$database_dir" ]; then
    # Extract database name from directory name
    database=$(basename "$database_dir")
    echo "Processing database: $database"
    
    # Iterate over each collection file in the database directory
    for collection_file in "$database_dir"/*.json; do
      if [ -f "$collection_file" ]; then
        # Extract collection name from file name
        collection=$(basename "$collection_file" .json)
        echo "Importing collection: $collection"
        
        # Import the JSON file into MongoDB
        mongoimport --uri="$MONGO_URI/$database" --collection="$collection" --file="$collection_file" --jsonArray --drop
      fi
    done
  fi
done
