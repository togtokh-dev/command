#!/bin/bash

# Connection details
MONGO_URI=""
USERNAME=""
PASSWORD=""
AUTH_DB=""

# Create output directory if not exists
mkdir -p ./exports

# Get the list of databases
databases=$(mongosh --quiet --eval "db.adminCommand('listDatabases').databases.map(d => d.name).join(' ')" "$MONGO_URI" --username $USERNAME --password $PASSWORD --authenticationDatabase $AUTH_DB)

for database in $databases; do
  echo "Processing database: $database"
  # Create directory for database if not exists
  mkdir -p "./exports/$database"
  # Get the list of collections for the current database
  collections=$(mongosh --quiet --eval "db.getSiblingDB('$database').getCollectionNames().join(' ')" "$MONGO_URI" --username $USERNAME --password $PASSWORD --authenticationDatabase $AUTH_DB)
  # Export each collection in JSON array format
  for collection in $collections; do
    echo "Exporting collection: $collection"
    mongoexport --uri="$MONGO_URI/$database" --collection="$collection" --out="./exports/${database}/${collection}.json" --jsonArray --pretty
  done
done
