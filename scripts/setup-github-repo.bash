#!/bin/bash -x
set -e
TARGET=image_common
VERSION=1.6.1
SRC=https://code.ros.org/svn/release/download/stacks/image_common/image_common-1.6.1/image_common-1.6.1.tar.bz2
SRCBASE=image_common-1.6.1.tar.bz2

WORK=/tmp/$TARGET
rm -rf $WORK
mkdir -p $WORK
cd $WORK
wget $SRC -O $SRCBASE
mkdir expand
cd expand
tar xjf ../$SRCBASE
mv * $TARGET
cd $TARGET
git init
git add .
git commit -m "import of $TARGET $VERSION"
pristine-tar commit ../../$SRCBASE master
git remote add origin git@github.com:strawlab/$TARGET.git
git push -u origin master
git push origin pristine-tar

git branch strawlab-electric
git checkout strawlab-electric
git push origin strawlab-electric
