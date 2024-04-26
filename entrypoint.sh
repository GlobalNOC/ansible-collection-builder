#! /bin/sh

EXPECTED_VERSION=$1

CMD="find collections -name galaxy.yml"
GALAXY_FILE_COUNT=$($CMD | wc -l)

if [ $GALAXY_FILE_COUNT -ne 1 ]; then
    echo "Expected 1 galaxy.yml file, but found $GALAXY_FILE_COUNT"
    exit 1
fi

GALAXY_FILE=$($CMD)
GALAXY_DIR=$(dirname $GALAXY_FILE)

COLLECTION_NAMESPACE=$(yq .namespace < $GALAXY_FILE)
COLLECTION_NAME=$(yq .name < $GALAXY_FILE)
COLLECTION_VERSION=$(yq .version < $GALAXY_FILE)

if [ "$EXPECTED_VERSION" != "$COLLECTION_VERSION" ]; then
    echo "Expected version $EXPECTED_VERSION, but found $COLLECTION_VERSION in galaxy.yml"
    exit 1
fi

cd $GALAXY_DIR && ansible-galaxy collection build

echo "COLLECTION_FILE=$GALAXY_DIR/$COLLECTION_NAMESPACE-$COLLECTION_NAME-$COLLECTION_VERSION.tar.gz" >> $GITHUB_OUTPUT
