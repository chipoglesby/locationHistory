#!/bin/bash

unzip *.zip

# Set your cloud storage bucket for storage of your file
cloudStorageBucket="xxx"

# Set your Google BigQuery Dataset and table name
bigQueryDataset="xxx"
bigQueryTable="xxx"

# Use JQ to create a newline delimited version of your file
cat 'Takeout/Location History/LocationHistory.json' | jq -c '.locations[]' > locationHistory.json

# Upload your file to Google Cloud Storage and then upload to Google BigQuery
gsutil -mq cp -r "locationHistory.json" "$cloudStorageBucket/"
bq load --source_format=NEWLINE_DELIMITED_JSON --autodetect $bigQueryDataset.$bigQueryTable "gs://$cloudStorageBucket/locationHistory.json"

rm -rf Takeout
mv locationHistory.json data/
