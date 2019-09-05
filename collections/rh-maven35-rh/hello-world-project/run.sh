#!/bin/bash

# Example app taken from https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

rm -rf my-app

set -xe

scl enable $INSTALL_SCLS -- mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false

cd my-app

scl enable $INSTALL_SCLS -- mvn package

java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App | tee output

grep -q 'Hello World!' output && echo 'Project built successfully.' && exit 0

echo 'Program did not print the expected greeting, which is considered a FAILURE.'

exit 1
