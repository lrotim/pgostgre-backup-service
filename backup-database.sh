#!/bin/bash

set -e

GOOGLE_APP_CREDENTIALS_PATH="/credentials"

export PGHOST=${DB_HOST}
export PGPORT=${DB_PORT}
export PGDATABASE=${DB_NAME}
export PGUSER=${DB_USER}
export PGPASSWORD=${DB_PASSWORD}

if [ ! "$GCB_PATH" ]; then
    echo "Missing GCB_PATH variable definition"
    exit 1
fi

/root/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file "$GOOGLE_APP_CREDENTIALS_PATH"
GOOGLE_PROJECT_ID=$(cat "$GOOGLE_APP_CREDENTIALS_PATH" | jq -r ".project_id")
/root/google-cloud-sdk/bin/gcloud config set core/project $GOOGLE_PROJECT_ID

DUMP_FILE_NAME="${DB_NAME}_`date +%Y-%m-%d-%H-%M`"
echo "Creating dump: $DUMP_FILE_NAME"

BUCKET="gs://${GCB_PATH}"

pg_dump > "$DUMP_FILE_NAME.sql"
/bin/tar -cvzf "$DUMP_FILE_NAME.sql" "$DUMP_FILE_NAME.tar.gz"

/root/google-cloud-sdk/bin/gsutil cp "$DUMP_FILE_NAME.tar.gz" "$BUCKET/$DUMP_FILE_NAME.tar.gz"

exit 0