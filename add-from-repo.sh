#!/bin/bash

set -e

if [ ! -e "$1/version.properties" ]
then
	echo "Not a CCRE repo!"
	exit 1
fi
if [ "$0" != "./add-from-repo.sh" -o ! -e "$0" -o ! -e "./.git" ]
then
	echo "Must be invoked from its own directory!"
	exit 1
fi

CCRE_VERSION = $(grep "ccre-version" ../common-chicken-runtime-engine/version.properties | cut -d "=" -f 2)

if [ "${CCRE_VERSION:0:6}" != "ccre-v" ]
then
	echo "Did not successfully compute version!
	exit 1
fi

git reset --hard
git checkout master
git pull
git checkout -b gh-pages

if [ -e "dev-builds" ]
then
	echo "Oh no! We already have builds!"
	exit 1
fi
mkdir -p dev-builds/$CCRE_VERSION
OUT=dev-builds/$CCRE_VERSION

cp $1/CommonChickenRuntimeEngine/CCRE.jar $OUT
cp $1/DeploymentEngine/DepEngine.jar $OUT
cp $1/Emulator/Emulator.jar $OUT
cp $1/PoultryInspector/PoultryInspector.jar $OUT
cp $1/roboRIO/roboRIO.jar $OUT
cp $1/roboRIO/roboRIO-lite.jar $OUT

python generate.py

git push -f
