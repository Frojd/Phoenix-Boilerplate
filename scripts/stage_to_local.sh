#!/bin/bash
# Sync db and assets from stage to local
#
# SSH-keys is mandatory
# Example usage `scripts/stage_to_local.sh`

set -e

# Arguments
LOCAL_DOMAIN=example.com.test:4000
SSH_HOST=root@stage.domain.com

ROOTDIR=$(git rev-parse --show-toplevel)
DOCKERDIR=$(cd ${ROOTDIR}/docker/; pwd)


echo "Creating database dump from stage..."
ssh $SSH_HOST "export PGUSER=postgres && pg_dump example_app_db --no-owner > /tmp/db-dump.sql"

echo "Downloading database dump..."
scp $SSH_HOST:/tmp/db-dump.sql $DOCKERDIR/files/db-dumps/db-dump.sql
ssh $SSH_HOST "rm /tmp/db-dump.sql"

cd $ROOTDIR
echo "Rebuilding docker containers."

docker-compose stop
docker-compose rm -f
docker-compose up -d

echo "---"
echo "Done!"
echo "The application is ready at: $LOCAL_DOMAIN"
