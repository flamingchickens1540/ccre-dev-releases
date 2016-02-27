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

CCRE_VERSION=$(grep "ccre-version" $1/version.properties | cut -d "=" -f 2)

if [ "${CCRE_VERSION:0:6}" != "ccre-v" -a "${CCRE_VERSION:0:12}" != "devel-after-" ]
then
	echo "Did not successfully compute version!"
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

OUT=dev-builds/$CCRE_VERSION

mkdir -p $OUT

cp $1/CommonChickenRuntimeEngine/CCRE.jar $OUT
cp $1/DeploymentEngine/DepEngine.jar $OUT
cp $1/Emulator/Emulator.jar $OUT
cp $1/PoultryInspector/PoultryInspector.jar $OUT
cp $1/roboRIO/roboRIO.jar $OUT
cp $1/roboRIO/roboRIO-lite.jar $OUT
cp -R $1/ci/junit-output $OUT

HERE=$(pwd)
cd $1
git log -n 1 --pretty=format:%H >$HERE/$OUT/version.txt
cd $HERE

python generate.py $VERSION_HASH

git add $OUT
git add index.html
git config user.email "flamingchickens1540-ccre-upload-bot@users.noreply.github.com"
git config user.name "Travis CI Bot for Team 1540"
git commit -m "Autoadded resources."

git push -f -u origin gh-pages

git checkout master
git branch -d gh-pages
