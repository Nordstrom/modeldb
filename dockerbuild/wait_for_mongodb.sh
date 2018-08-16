#!/bin/bash
# wait-for-mongodb.sh

# Usage: sh /modeldb/dockerbuild/wait_for_mongodb.sh 0.10.0 mongo

set -e

thrift_version="$1"
host="$2"

export PASSWORD=$(< /mongo/mongodb-password)
# 'foo' doesn't matter here. Just needs something so that $host is interpreted
# as a hostname and not a database name.


until pgrep mongod > /dev/null 2>&1; do
    >&2 echo "MongoDB is unavailable - sleeping"
    sleep 1
done
>&2 echo "MongoDB is up - executing command"


# Substitute the desired MongoDB hostname in the built project's conf file.
before="$PWD"

cd /modeldb/server/codegen
sed -i "s/MONGODB_HOST/$host/" /modeldb/reference.conf
cd "$before"

java -Dconfig.file=/modeldb/reference.conf  -jar /modeldb/modeldb.jar


